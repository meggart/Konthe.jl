push!(DL_LOAD_PATH,"/opt/ImageMagick/lib")
push!(DL_LOAD_PATH,"/opt/local/lib");
global OpenGLver="1.0"
module Konthe
using Images

using OpenGL
using OpenGLStd
using GLUT
using GLU
using Color
include("extfuns.jl")

function initGL()
	
	glutInit()
	glutInitDisplayMode(GLUT_RGBA)
	glutInitWindowSize(1, 1)
	glutInitWindowPosition(0, 0)
	
	window = glutCreateWindow("Konthe dummy window")
	glutHideWindow();
		
end
export initGL

type glFrameBuffer
	FrameBufferID::Array{Uint32}
	RenderBufferID::Array{Uint32}
	DepthBufferId::Array{Uint32}
	width::Integer
	height::Integer
end


immutable Coord
	x::Float64
	y::Float64
	z::Float64
end
include("plotinit.jl")
include("plotfuns.jl")


function makeFrameBuffer(width::Integer, height::Integer)
	fbid=Array(Uint32,1)
	rbid=Array(Uint32,1)
	dbid=Array(Uint32,1)
	glGenFramebuffersEXT(1, fbid)
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbid[1]);
	glGenRenderbuffersEXT(1, rbid);
	glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, rbid[1]);
	glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_RGB, width, height);
	glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_RENDERBUFFER_EXT, rbid[1]);
	
	glGenRenderbuffersEXT(1, dbid);   
	glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, dbid[1]);
	glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT, width, height);
	glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, dbid[1])

	status = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT)
	println(uint32(status))
	return(glFrameBuffer(fbid,rbid,dbid,width,height))
end
export makeFrameBuffer

function plot3D(y::Image,fb::glFrameBuffer)

	glClearColor(float32(bgcur[1].r), float32(bgcur[1].g), float32(bgcur[1].b), float32(1.0))
	glShadeModel(GL_SMOOTH);
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LEQUAL);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
	
	glViewport(0, 0, fb.width, fb.height);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	glOrtho(-fb.width/fb.height,fb.width/fb.height,-1.0,1.0,-1.0,1.0)
	
	glRotate(xrot,1.0,0.0,0.0)
	glRotate(yrot,0.0,1.0,0.0)
	glRotate(zrot,0.0,0.0,1.0)
	
	glOrtho(_xlim[1],_xlim[2],_ylim[1],_ylim[2],_zlim[2],_zlim[1])
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	setLights();
	
	renderVertexList(pointsList,(:GL_POINTS))
	renderVertexList(linesList,(:GL_LINE_STRIP))
	renderVertexList(quadsList,(:GL_QUADS))
	
	renderSpheres(sphereList)
	renderCylinders(cylinderList)
	
	glReadBuffer(GL_COLOR_ATTACHMENT0_EXT)
	glReadPixels(0, 0, fb.width, fb.height, GL_RGB, GL_UNSIGNED_BYTE, y.data);
	return(y)
end

function plot3D() 
	global gfb
	global gy
	gfb == nothing ? newPlot3D(width,height) : nothing 
	if gy==nothing
		gy = Image(zeros(Uint8,3,width,height),["limits"=>(0x00,0xff),"colordim"=>1,"spatialorder"=>["x","y"],"colorspace"=>"RGB"])
	end
	plot3D(gy,gfb)
end

export plot3D

function newPlot3D(w::Integer=800,h::Integer=600)

	global gfb 
	global width
	global height
	
	empty!(pointsList)
	empty!(linesList)
	empty!(quadsList)
	empty!(sphereList)
	empty!(cylinderList)

	ccur[1]=RGB(1.0,1.0,1.0)
	bgcur[1]=RGB(0.0,0.0,0.0)
	
	if gfb!=nothing
		if (gfb.width==w) && (gfb.height==h)
			return nothing
		else
			glDeleteRenderbuffersEXT(1, gfb.RenderBufferID);
			glDeleteRenderbuffersEXT(1, gfb.DepthBufferID);
			glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
			glDeleteFramebuffersEXT(1, gfb.FrameBufferID);
		end
	end
	
	gfb = makeFrameBuffer(width,height)
	width = w
	height = h
	return nothing
end
export newPlot3D

initGL()
gfb = makeFrameBuffer(800, 600)
gy  = nothing
end
