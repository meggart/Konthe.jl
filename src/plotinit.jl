type LineColl
	coord_s::Array{Coord,1}
	coord_e::Array{Coord,1}
	color_s::Array{RGB}
	color_e::Array{RGB}
end

typealias XYZVecTuple (Array{Float64,1},Array{Float64,1},Array{Float64,1})
typealias XYZTuple (Float64,Float64,Float64)
typealias SurfArray (Array{Float64,2},Array{Float64,1},Array{Float64,1})
typealias ParametricSurface (Function, Vector{Float64}, Vector{Float64})
immutable VertexContainer{T1,T2,T3}
	coords::T1
	normals::T2
	colors::T3
	norminc::Int64
	colinc::Int64
	predefs::Array{Expr,1}
end


# FUnctions to retrieve coordinates and normals
VertexContainer(coords,normals,colors,norminc,colinc)=VertexContainer(coords,normals,colors,norminc,colinc,Array(Expr,0))
getCoord{T1<:XYZVecTuple,T2,T3}(v::VertexContainer{T1,T2,T3},i::Integer)=(v.coords[1][i],v.coords[2][i],v.coords[3][i])
getNormal{T1,T2<:XYZVecTuple,T3}(v::VertexContainer{T1,T2,T3},i::Integer)=(v.normals[1][i],v.normals[2][i],v.normals[3][i])
getColor{T1,T2,T3<:Array{RGB,1}}(v::VertexContainer{T1,T2,T3},i::Integer)=v.colors[i]
getNCoord{T1<:XYZVecTuple,T2,T3}(v::VertexContainer{T1,T2,T3})=length(v.coords[1])
getNNormal{T1,T2<:XYZVecTuple,T3}(v::VertexContainer{T1,T2,T3})=length(v.normals[1])
getNColor{T1,T2,T3<:Array{RGB,1}}(v::VertexContainer{T1,T2,T3})=length(v.colors)
getNCoord{T1<:SurfArray,T2,T3}(v::VertexContainer{T1,T2,T3})=4*(length(v.coords[2])-1)*(length(v.coords[3])-1)
getNColor{T1,T2,T3<:Function}(v::VertexContainer{T1,T2,T3})=getNCoord(v)
getNNormal{T1,T2<:Function,T3}(v::VertexContainer{T1,T2,T3})=getNCoord(v)
getColor{T1,T2,T3<:Function}(v::VertexContainer{T1,T2,T3},i::Integer)=v.colors(v,i)
getNormal{T1,T2<:Function,T3}(v::VertexContainer{T1,T2,T3},i::Integer)=v.normals(v,i)
getNCoord{T1<:ParametricSurface,T2,T3}(v::VertexContainer{T1,T2,T3})=4*(length(v.coords[2])-1)*(length(v.coords[3])-1)


# Function to get the i-th coordinate for surface plotting
function getCoord{T1<:SurfArray,T2,T3}(v::VertexContainer{T1,T2,T3},i::Integer)
    i > getNCoord(v) ? error("Index not in Surface Array") : nothing
	#In an Ni*Nj mesh we have (Ni-1)*(Nj-1) quads
    Nx=length(v.coords[2])-1
    Ny=length(v.coords[3])-1
	iQuad=div(i-1,4)+1
	iCorn=mod(i-1,4)+1
    #println("$iQuad $iCorn")
	x = iCorn>2 ? 1 : 0
	y = (iCorn==2 || iCorn==3) ? 1 : 0
    #println("$x $y")
    x = x + div(iQuad-1,Nx) + 1
    y = y + mod(iQuad-1,Nx) + 1
    return(v.coords[2][x],v.coords[3][y],v.coords[1][x,y])
end

function getCoord{T1<:ParametricSurface,T2,T3}(v::VertexContainer{T1,T2,T3},i::Integer)
    i > getNCoord(v) ? error("Index not in Surface Array") : nothing
	#In an Ni*Nj mesh we have (Ni-1)*(Nj-1) quads
    Nx=length(v.coords[2])-1
    Ny=length(v.coords[3])-1
	iQuad=div(i-1,4)+1
	iCorn=mod(i-1,4)+1
    #println("$iQuad $iCorn")
	x = iCorn>2 ? 1 : 0
	y = (iCorn==2 || iCorn==3) ? 1 : 0
    #println("$x $y")
    x = x + div(iQuad-1,Nx) + 1
    y = y + mod(iQuad-1,Nx) + 1
    return(v.coords[1](v.coords[2][x],v.coords[3][y]))
end

immutable SphereContainer
	coords::(Float64,Float64,Float64)
	colors::RGB
	r::Float64
	slices::Int64
	stacks::Int64
	predefs::Array{Expr,1}
end

immutable CylinderContainer
	coords::(Float64,Float64,Float64)
	colors::RGB
	r1::Float64
	r2::Float64
	h::Float64
	slices::Int64
	stacks::Int64
	predefs::Array{Expr,1}
end

function setRotate(a1,a2,a3) 
  global xrot=a1
  global yrot=a2
  global zrot=a3
end

zlim(z1,z2)=begin _zlim[1]=z1;_zlim[2]=z2;return nothing; end
ylim(y1,y2)=begin _ylim[1]=y1;_ylim[2]=y2;return nothing; end
xlim(x1,x2)=begin _xlim[1]=x1;_xlim[2]=x2;return nothing; end
export xlim,ylim,zlim

pointsList=Array(VertexContainer,0)
linesList=Array(VertexContainer,0)
quadsList=Array(VertexContainer,0)
sphereList=Array(SphereContainer,0)
cylinderList=Array(CylinderContainer,0)
qobj = gluNewQuadric()
gluQuadricDrawStyle(qobj, GLU_FILL)
gluQuadricNormals(qobj, GLU_SMOOTH)

ccur=RGB(1.0,1.0,1.0)
bgcur=RGB(0.0,0.0,0.0)
zrot=45.0
yrot=0.0
xrot=45.0
_xlim=[-1.0,1.0]
_ylim=[-1.0,1.0]
_zlim=[-1.0,1.0]


width=800
height=600

lighted=true;
include("light.jl")

# Some color functions
cbarcur(x::Number)= return(x < 0.5 ? RGB(2.0*x,2.0*x,1.0-2.0*x) : RGB(1,2.0*(1.0-x),0))
zvalcol(v::VertexContainer,i::Integer)=cbarcur((getCoord(v,i)[3]-_zlim[1])/(_zlim[2]-_zlim[1]))
lightsON()=global lighted=true;
lightsOFF()=global lighted=false;
export lightsON, lightsOFF



#Functions for Normal determination
function nnMeanNormal{T1<:SurfArray,T2,T3}(v::VertexContainer{T1,T2,T3},i::Integer)
    i > getNCoord(v) ? error("Index not in Surface Array") : nothing
	#In an Ni*Nj mesh we have (Ni-1)*(Nj-1) quads
    Nx=length(v.coords[2])-1
    Ny=length(v.coords[3])-1
	iQuad=div(i-1,4)+1
	iCorn=mod(i-1,4)+1
	x = iCorn>2 ? 1 : 0
	y = (iCorn==2 || iCorn==3) ? 1 : 0
    x = x + div(iQuad-1,Nx) + 1
    y = y + mod(iQuad-1,Nx) + 1
	if x==1
		dx = v.coords[2][x+1] - v.coords[2][x]
		dzx= v.coords[1][x+1,y]-v.coords[1][x,y]
	elseif x==(Nx+1)
		dx = v.coords[2][x] - v.coords[2][x-1]
		dzx= v.coords[1][x,y]-v.coords[1][x-1,y]
	else
		dx = v.coords[2][x+1] - v.coords[2][x-1]
		dzx= v.coords[1][x+1,y]-v.coords[1][x-1,y]
	end
	if y==1
		dy = v.coords[3][y+1] - v.coords[3][y]
		dzy= v.coords[1][x,y+1]-v.coords[1][x,y]
	elseif y==(Ny+1)
		dy = v.coords[3][y] - v.coords[3][y-1]
		dzy= v.coords[1][x,y]-v.coords[1][x,y-1]
	else
		dy = v.coords[3][y+1] - v.coords[3][y-1]
		dzy= v.coords[1][x,y+1]-v.coords[1][x,y-1]
	end
	no = sqrt(dy*dy*dzx*dzx + dx*dx*dzy*dzy + dx*dx*dy*dy)
	return (dy*dzx/no,dx*dzy/no,-dx*dy/no)
end

function nnMeanNormal{T1<:ParametricSurface,T2,T3}(v::VertexContainer{T1,T2,T3},i::Integer)
    i > getNCoord(v) ? error("Index not in Surface Array") : nothing
	#In an Ni*Nj mesh we have (Ni-1)*(Nj-1) quads
    Nx=length(v.coords[2])-1
    Ny=length(v.coords[3])-1
	iQuad=div(i-1,4)+1
	iCorn=mod(i-1,4)+1
	x = iCorn>2 ? 1 : 0
	y = (iCorn==2 || iCorn==3) ? 1 : 0
    x = x + div(iQuad-1,Nx) + 1
    y = y + mod(iQuad-1,Nx) + 1
	dp = 100.0*eps(v.coords[2][x])
	dt = 100.0*eps(v.coords[3][y])
	p = v.coords[1](v.coords[2][x],v.coords[3][y])
	px = v.coords[1](v.coords[2][x]+dp,v.coords[3][y])
	py = v.coords[1](v.coords[2][x],v.coords[3][y]+dt)
	dx1,dy1,dz1 = px[1]-p[1],px[2]-p[2],px[3]-p[3]
	dx2,dy2,dz2 = py[1]-p[1],py[2]-p[2],py[3]-p[3]
	no = sqrt((dy1*dz2-dy2*dz1)^2 + (dz1*dx2-dz2*dx1)^2 + (dx1*dy2-dx2*dy1)^2)
	return ((dy1*dz2-dy2*dz1)/no, (dz1*dx2-dz2*dx1)/no, (dx1*dy2-dx2*dy1)/no)
end


