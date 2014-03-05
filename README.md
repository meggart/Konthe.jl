# Konthe

[![Build Status](https://travis-ci.org/meggart/glPlot.jl.png)](https://travis-ci.org/meggart/glPlot.jl)

Collection of convenience function for plotting using the OpenGL package. Here is a list of exported functions:

    newPlot3D(width=800, height=600)

deletes all previous plots from the cache and creates an empty new plot. 

    plot3D()

draws the current plot and returns an Image object containing the plot. This will automatically show up in an iPython notebook. 
You might want to use the ImageView package in other environments. 

    points3D(x::Vector, y::Vector, z::Vector; ps=2.0, color::Array{RGB}=RGB(1,1,1))

Draws a set of points with pointsize ps. color is an array of color values, if it is shorter than the number of points, colors will be repeated. 

    lines3D(x::Vector, y::Vector, z::Vector; lw=2.0, color::Array{RGB}=RGB(1,1,1))

Draws a connected set of lines with linewidth lw. color is an array of color values, if it is shorter than the number of points, colors will be repeated. 

    surf3D(s::Matrix;x::Vector=linspace(0,1,size(s,1)),y::Vector=linspace(0,1,size(s,2)),
	filled::Bool=true,color=zvalcol,normals=nnMeanNormal,lw=2)

Draws a surface defined by the Matrix s. x and y values can be defined. If filled is true, a filled surface is drawn, otherwise a connected grid is drawn. If no color is specified, colors are determined by the z value using the current colorbar. Normals are determined by automtaic gradient calculation. 

    surf3D(f::Function,r1::Vector,r2::Vector;
    filled::Bool=true,color=zvalcol,normals=nnMeanNormal,lw=2)

Draws a surface defined by the parametric function f that should have 2 arguments and return a tuple of (Float64, Float64, Float64). r1 and r2 are arrays that give the parameter values at which f should be calculated. If filled is true, a filled surface is drawn, otherwise a connected grid is drawn. If no color is specified, colors are determined by the z value using the current colorbar. Normals are determined by automtaic gradient calculation. 

    sphere3D(x,y,z,r;
	filled=true,color=ccur,slices=20,stacks=20)

Draws a spere with center at (x,y,z) and radius r. Draws a filled surface if filled=true otherwise a grid is drawn. Color can be given by a RGB object. slices and stacks define the number of rendering points (the higher the prettier does the spehere look)

    lightsON()

enables lighting.

    lightsOFF()

disbales lighting. 

	setLightDirection(x,y,z)

sets the direction of the light source. 

Examples:

![Fig1](https://github.com/meggart/Konthe/blob/master/examples/fig1.png?raw=true)

![Fig2](https://github.com/meggart/Konthe/blob/master/examples/fig2.png?raw=true)

![Fig3](https://github.com/meggart/Konthe/blob/master/examples/fig3.png?raw=true)

![Fig4](https://github.com/meggart/Konthe/blob/master/examples/fig4.png?raw=true)

![Fig5](https://github.com/meggart/Konthe/blob/master/examples/fig5.png?raw=true)
