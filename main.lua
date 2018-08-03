--CPML is the magic that makes the transforms work
local Cpml = require("cpml")
local Shader = love.graphics.newShader("shader.glsl")

local DepthBuffer = {
   color = love.graphics.newCanvas(w, h, {format = "rgba8"}),
   depth = love.graphics.newCanvas(w, h, {format = "depth24"}),
}
DepthBuffer.canvas = {DepthBuffer.color, depthstencil = DepthBuffer.depth}


local VertexFormat = {
	{"VertexPosition", "float", 3},
   {"VertexTexCoord","float", 2},
   {"VertexColor", "byte", 4},
}

local Mesh = love.graphics.newMesh(VertexFormat, {
   {-1, -1, 0, 0, 1, 255, 255, 255, 255},
   { 1, -1, 0, 1, 1, 255, 255, 255, 255},
   {-1,  1, 0, 0, 0, 255, 255, 255, 255},
   { 1,  1, 0, 1, 0, 255, 255, 255, 255},
}, "triangles")
Mesh:setVertexMap({1, 2, 3, 2, 3, 4})
Mesh:setTexture(love.graphics.newImage("stone.png"))

local Camera = {
   position = Cpml.vec3(0, 0, -10),
   rotation = Cpml.vec2(0, 0),
}

local PerspectiveMatrix = Cpml.mat4.from_perspective(
   75, 
   love.graphics.getWidth() / love.graphics.getHeight(), 
   0.1, 
   1000
)
local ViewMatrix = Cpml.mat4()

local ModelMatrix_1 = Cpml.mat4.identity()
ModelMatrix_1:translate(ModelMatrix_1, Cpml.vec3(1, 0, 0))

local ModelMatrix_2 = Cpml.mat4.identity()
ModelMatrix_2:translate(ModelMatrix_2, Cpml.vec3(5, 0, 2))

function love.draw()
   local ViewMatrix = ViewMatrix:identity()

	ViewMatrix:translate(ViewMatrix, Camera.position)
	ViewMatrix:rotate   (ViewMatrix, Camera.rotation.y, Cpml.vec3.unit_x)
   ViewMatrix:rotate   (ViewMatrix, Camera.rotation.x, Cpml.vec3.unit_y)

   Shader:send("view_matrix",       "column", ViewMatrix)
   Shader:send("projection_matrix", "column", PerspectiveMatrix)
   
   love.graphics.setShader(Shader)
   love.graphics.setColor(1, 1, 1)
   love.graphics.setDepthMode("lequal", true)
   love.graphics.setCanvas(DepthBuffer.canvas)
   love.graphics.clear(1, 1, 1, 1, true, 1)

	Shader:send("model_matrix", "column", ModelMatrix_1)
   love.graphics.draw(Mesh)
   
   Shader:send("model_matrix", "column", ModelMatrix_2)
   love.graphics.draw(Mesh)

   love.graphics.setShader()
   love.graphics.setDepthMode()
   love.graphics.setCanvas()

   love.graphics.draw(DepthBuffer.color)
end

function love.update(dt)
   local movementVector = Cpml.vec3()

   if love.keyboard.isDown("w") then movementVector.z = movementVector.z + 1 end
   if love.keyboard.isDown("s") then movementVector.z = movementVector.z - 1 end

   if love.keyboard.isDown("a") then movementVector.x = movementVector.x + 1 end
   if love.keyboard.isDown("d") then movementVector.x = movementVector.x - 1 end

   if love.keyboard.isDown("r") then movementVector.y = movementVector.y - 1 end
   if love.keyboard.isDown("f") then movementVector.y = movementVector.y + 1 end

   Camera.position = Camera.position + movementVector * 5 * dt
end

function love.mousepressed(x, y, button)
	if button == 1 then
		dragging = true
		love.mouse.setRelativeMode(true)
	end
end

function love.mousereleased(x, y, button)
	if button == 1 then
		dragging = false
		love.mouse.setRelativeMode(false)
	end
end

function love.mousemoved(x, y, dx, dy)
   if dragging then
      local rotationVector = Cpml.vec2(dx, dy)

		Camera.rotation = Camera.rotation + rotationVector / 100
	end
end

