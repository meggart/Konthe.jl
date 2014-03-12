OpenGL.glColor(c::RGB)=glColor(c.r,c.g,c.b)
OpenGL.glVertex(c::Coord)=glVertex(c.x,c.y,c.z)

function points3D{T}(x::Array{T,1}, y::Array{T,1}, z::Array{T,1};
	ps=2.0,
	color::Array{RGB,1}=ccur, xn::Array{T,1}=Array(Float64,0), yn::Array{T,1}=Array(Float64,0), zn::Array{T,1}=Array(Float64,0))
	length(x)==length(y)==length(z) ? nothing : error("Number of Coordinates must match")
	colinc  = length(color) == 1 ? length(x)+1 : 1
	norminc = length(x)+1
	predef=[:(glPointSize($ps))]
	push!(pointsList,VertexContainer((x,y,z),(xn,yn,zn),color,int64(norminc),int64(colinc),predef))
	return(nothing)
end
export points3D

function lines3D{T}(x::Array{T,1},y::Array{T,1},z::Array{T,1};
	lw=2.0,
	color::Array{RGB,1}=ccur,xn::Array{T,1}=Array(Float64,0),yn::Array{T,1}=Array(Float64,0),zn::Array{T,1}=Array(Float64,0))
	length(x)==length(y)==length(z) ? nothing : error("Number of Coordinates must match")
	colinc  = length(color) == 1 ? length(x)+1 : 1
	norminc = length(x)+1
	predef=[:(glLineWidth($lw))]
	push!(linesList,VertexContainer((x,y,z),(xn,yn,zn),color,int64(norminc),int64(colinc),predef))
	return(nothing)
end
export lines3D

function quads3D{T}(x::Array{T,1},y::Array{T,1},z::Array{T,1};
	filled::Bool=true,
	color=ccur,xn::Array{T,1}=Array(Float64,0),yn::Array{T,1}=Array(Float64,0),zn::Array{T,1}=Array(Float64,0),
	colinc::Int64=-1,norminc::Int64=-1)
	length(x)==length(y)==length(z) ? nothing : error("Number of Coordinates must match")
	length(xn)==length(yn)==length(zn) ? nothing : error("Number of Normals must match")
	mod(length(x),4)==0 ? nothing : error("Number of Coordinates must be multiple of 4")
	
	colinc  = 	colinc > 0 ? colinc : length(color) == 1 ? length(x)+1 : 1
			
	norminc =   norminc > 0 ? norminc : length(xn) == 1 ? length(x)+1 : 1
	
	predef = filled ? [:(glPolygonMode(GL_FRONT_AND_BACK, GL_FILL))] : [:(glPolygonMode(GL_FRONT_AND_BACK, GL_LINE))]
	push!(quadsList,VertexContainer((x,y,z),(xn,yn,zn),color,int64(norminc),int64(colinc),predef))
	return(nothing)
end
export quads3D

function surf3D{T<:Number}(s::Matrix{T};
	x::Vector{T}=linspace(0,1,size(s,1)),y::Vector{T}=linspace(0,1,size(s,2)),
	filled::Bool=true,
	color=zvalcol,normals=nnMeanNormal,lw=2)
	size(s,1)==length(x) ? nothing : error("Length of x array must match first matrix dimension")
	size(s,2)==length(y) ? nothing : error("Length of y array must match first matrix dimension")
	predef = filled ? [:(glPolygonMode(GL_FRONT_AND_BACK, GL_FILL))] : [:(glPolygonMode(GL_FRONT_AND_BACK, GL_LINE))]
	push!(predef,:(glLineWidth($lw)))
	push!(quadsList,VertexContainer((s,x,y),normals,color,1,1,predef))
	return(nothing)
end
export surf3D

function surf3D{T<:Number}(f::Function,r1::Vector{T},r2::Vector{T};
	filled::Bool=true,
	color=zvalcol,normals=nnMeanNormal,lw=2)
	predef = filled ? [:(glPolygonMode(GL_FRONT_AND_BACK, GL_FILL))] : [:(glPolygonMode(GL_FRONT_AND_BACK, GL_LINE))]
	push!(predef,:(glLineWidth($lw)))
	push!(quadsList,VertexContainer((f,r1,r2),normals,color,1,1,predef))
	return(nothing)
end
export surf3D

function sphere3D(x,y,z,r;
	filled=true,
	color=ccur[1],slices=30,stacks=30)
	predef = filled ? [:(glPolygonMode(GL_FRONT_AND_BACK, GL_FILL))] : [:(glPolygonMode(GL_FRONT_AND_BACK, GL_LINE))]
	push!(sphereList,SphereContainer((x,y,z),color,r,slices,stacks,predef))
	return(nothing)
end	
export sphere3D

function cylinder3D(x1,y1,z1,r1,x2,y2,z2,r2;
	filled=true,
	color=ccur[1],slices=30,stacks=30)
	#Determine height
	h = sqrt((x1-x2)^2+(y1-y2)^2+(z1-z2)^2)
	predef = filled ? [:(glPolygonMode(GL_FRONT_AND_BACK, GL_FILL))] : [:(glPolygonMode(GL_FRONT_AND_BACK, GL_LINE))]
	#Check if rotation is necessary
	dxy=sqrt((y1-y2)^2+(x1-x2)^2)
	if dxy > 0
		n = ((y1-y2)/dxy,(x2-x1)/dxy,0.0)
		phi = acosd((z2-z1)/h)
		push!(predef,:(glRotate($phi,$(n[1]),$(n[2]),0.0)))
	end	
	push!(cylinderList,CylinderContainer((x1,y1,z1),color,r1,r2,h,slices,stacks,predef))
	return(nothing)
end
export cylinder3D

function coordSys3D(xlim,ylim,zlim)
	lines3D([xlim[1],xlim[end]],[    0.0,      0.0],[    0.0,      0.0],color=[RGB(1.0,1.0,1.0)])
	lines3D([    0.0,      0.0],[ylim[1],ylim[end]],[    0.0,      0.0],color=[RGB(1.0,1.0,1.0)])
	lines3D([    0.0,      0.0],[    0.0,      0.0],[zlim[1],zlim[end]],color=[RGB(1.0,1.0,1.0)])
	cylinder3D(0.0,0.0,zlim[1]+0.92*(zlim[end]-zlim[1]),0.04,0.0,0.0,zlim[1]+1.1*(zlim[end]-zlim[1]),0.0,color=RGB(1.0,1.0,1.0))
	cylinder3D(0.0,ylim[1]+0.92*(ylim[end]-ylim[1]),0.0,0.04,0.0,ylim[1]+1.1*(ylim[end]-ylim[1]),0.0,0.0,color=RGB(1.0,1.0,1.0))
	cylinder3D(xlim[1]+0.92*(xlim[end]-xlim[1]),0.0,0.0,0.04,xlim[1]+1.1*(xlim[end]-xlim[1]),0.0,0.0,0.0,color=RGB(1.0,1.0,1.0))
	return(nothing)
end
coordSys3D()=coordSys3D([0.0,_xlim[2]],[0.0,_ylim[2]],[0.0,_zlim[2]])
export coordSys3D


function renderVertexList(l::Array{VertexContainer,1},ex::Symbol)
  na=length(l)
  if na > 0
	for i=1:na
		for e in l[i].predefs
			eval(e)
		end
		glBegin(eval(ex))
		_plotVertices(l[i])
    	glEnd()
	end
  end
end

function _plotVertices(v::VertexContainer)
	ncoord = getNCoord(v)
	nnorm  = getNNormal(v)
	ncol   = getNColor(v)
	colinc = v.colinc
	norminc= v.norminc
	
	icolind = 1 # Count of color index
	inormind= 1 # Count of normal index

	icol   = ncol > 0 ? colinc : colinc+1 # when is the color changed again
	inorm  = nnorm> 0 ? norminc : norminc+1 # when is the normal changed again
	icoord = 1
	
	
	while icoord <= ncoord
		
		if icol == colinc  
			
			c=getColor(v,icolind)
			lighted ? glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE,float32([c.r, c.g, c.b, 1.0])) : glColor(c)
			icolind = icolind + 1
			if icolind > ncol
				icolind = 1
			end
			icol = 1
		else
			icol = icol + 1
		end
		
		if inorm == norminc
			glNormal(getNormal(v,inormind)...)
			inorm = 1
			inormind = inormind + 1
		else
			inorm = inorm + 1
		end 
		
		glVertex(getCoord(v,icoord)...)
		
		icoord = icoord + 1
		
	end
	
end

function renderSpheres(l::Array{SphereContainer,1})
    na=length(l)
    if na > 0
  	for i=1:na
  		for e in l[i].predefs
  			eval(e)
  		end
		if lighted
			glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE,float32([l[i].colors.r,l[i].colors.g,l[i].colors.b,1.0]))
		else
			glColor(l[i].colors)
		end
		
		glTranslate(l[i].coords[1],l[i].coords[2],l[i].coords[3])
  		gluSphere(qobj,l[i].r,l[i].slices,l[i].stacks)
		glTranslate(-l[i].coords[1],-l[i].coords[2],-l[i].coords[3])
  	end
    end
end

function renderCylinders(l::Array{CylinderContainer,1})
    na=length(l)
    if na > 0
  	for i=1:na
		if lighted
			glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE,float32([l[i].colors.r,l[i].colors.g,l[i].colors.b,1.0]))
		else
			glColor(l[i].colors)
		end
		glPushMatrix()
		glTranslate(l[i].coords[1],l[i].coords[2],l[i].coords[3])
  		for e in l[i].predefs
  			eval(e)
  		end
		gluCylinder(qobj,l[i].r1,l[i].r2,l[i].h,l[i].slices,l[i].stacks)
		glPopMatrix()
  	end
    end
end