lightAmbient = float32([0.2, 0.2, 0.2, 1.0])
lightDiffuse = float32([0.5, 0.5, 0.5, 1.0])
lightSpecular= float32([1.0, 1.0, 1.0, 1.0])
lightPosition= float32([1.0, 0.0, 1.0, 0.0])
shininess    = float32(5.0)


function setLights()
	if lighted
		glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient)
		glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse)
		glLightfv(GL_LIGHT0, GL_SPECULAR, lightSpecular)
		glLightfv(GL_LIGHT0, GL_POSITION, lightPosition)
		
		glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, lightSpecular);
		glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 50.0);
		
		glEnable(GL_LIGHT0)
		glEnable(GL_LIGHTING)
	else
		glDisable(GL_LIGHTING)
		glDisable(GL_LIGHT0)
	end
	
end

function setLightDirection(x,y,z)
	lightPosition[1]=float32(x)
	lightPosition[2]=float32(y)
	lightPosition[3]=float32(z)
end
export setLightDirection