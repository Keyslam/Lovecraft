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
   -- Front
   {-1, -1, 1, 0, 1, 1,    1,    1,    1},
   { 1, -1, 1, 1, 1, 1,    1,    1,    1},
   {-1,  1, 1, 0, 0, 1,    1,    1,    1},
   { 1,  1, 1, 1, 0, 1,    1,    1,    1},

   -- Back
   { 1, -1, -1, 0, 1, 1,    1,    1,    1},
   {-1, -1, -1, 1, 1, 1,    1,    1,    1},
   { 1,  1, -1, 0, 0, 1,    1,    1,    1},
   {-1,  1, -1, 1, 0, 1,    1,    1,    1},

   -- Left
   {-1, -1, -1, 0, 1, 1,    1,    1,    1},
   {-1, -1,  1, 1, 1, 1,    1,    1,    1},
   {-1,  1, -1, 0, 0, 1,    1,    1,    1},
   {-1,  1, 1,  1, 0, 1,    1,    1,    1},
   
   -- Right
   { 1, -1,  1,  0, 1, 1,    1,    1,    1},
   { 1, -1, -1,  1, 1, 1,    1,    1,    1},
   { 1,  1,  1,  0, 0, 1,    1,    1,    1},
   { 1,  1, -1,  1, 0, 1,    1,    1,    1},

   -- Top
   {-1, -1, -1,  0, 1, 1,    1,    1,    1},
   { 1, -1, -1,  1, 1, 1,    1,    1,    1},
   {-1, -1,  1,  0, 0, 1,    1,    1,    1},
   { 1, -1,  1,  1, 0, 1,    1,    1,    1},

   -- Bottom
   { 1, 1, -1, 0, 1, 1,    1,    1,    1},
   {-1, 1, -1, 1, 1, 1,    1,    1,    1},
   { 1, 1,  1, 0, 0, 1,    1,    1,    1},
   {-1, 1,  1, 1, 0, 1,    1,    1,    1},
}, "triangles")
Mesh:setVertexMap({
    1,  3,  2,  2,  3,  4,
    5,  7,  6,  6,  7,  8,
    9, 11, 10, 10, 11, 12,
   13, 15, 14, 14, 15, 16,
   17, 19, 18, 18, 19, 20,
   21, 23, 22, 22, 23, 24,
})
Mesh:setTexture(love.graphics.newImage("stone.png"))

local Camera = {
   position = Cpml.vec3(0, 0, -10),
   rotation = Cpml.vec2(0, 0),

   direction = nil,
   right     = nil,
   up        = nil,
}

local PerspectiveMatrix = Cpml.mat4.from_perspective(
   75, 
   love.graphics.getWidth() / love.graphics.getHeight(), 
   0.1, 
   1000
)
local ViewMatrix = Cpml.mat4()

local ModelMatrix_1 = Cpml.mat4.identity()
--ModelMatrix_1:translate(ModelMatrix_1, Cpml.vec3(5, 0, 0))

local ModelMatrix_2 = Cpml.mat4.identity()
ModelMatrix_2:translate(ModelMatrix_2, Cpml.vec3(5, 0, 2))

function love.update(dt)
   Camera.direction = Cpml.vec3(
      math.cos(Camera.rotation.y) * math.sin(Camera.rotation.x),
      math.sin(Camera.rotation.y),
      math.cos(Camera.rotation.y) * math.cos(Camera.rotation.x)
   )

   Camera.right = Cpml.vec3(
      math.sin(Camera.rotation.x - math.pi/2),
      0,
      math.cos(Camera.rotation.x - math.pi/2)
   )

   Camera.forward = Cpml.vec3(
      math.sin(Camera.rotation.x + math.pi),
      0,
      math.cos(Camera.rotation.x + math.pi)
   )

   Camera.up = Cpml.vec3.cross(Camera.right, Camera.direction)


   local movementVector = Cpml.vec3()

   if love.keyboard.isDown("w") then movementVector = movementVector + Camera.forward end
   if love.keyboard.isDown("s") then movementVector = movementVector - Camera.forward end

   if love.keyboard.isDown("a") then movementVector = movementVector + Camera.right end
   if love.keyboard.isDown("d") then movementVector = movementVector - Camera.right end

   if love.keyboard.isDown("space")  then movementVector.y = movementVector.y + 1 end
   if love.keyboard.isDown("lshift") then movementVector.y = movementVector.y - 1 end


   Camera.position = Camera.position + movementVector * 10 * dt

   

   
end

function love.draw()
   local ViewMatrix = ViewMatrix:identity()

   ViewMatrix:look_at(ViewMatrix, Camera.position, Camera.position + Camera.direction, Camera.up)
	ViewMatrix:translate(ViewMatrix, Camera.position)
	--ViewMatrix:rotate   (ViewMatrix, Camera.rotation.y, Cpml.vec3.unit_x)
   --ViewMatrix:rotate   (ViewMatrix, Camera.rotation.x, Cpml.vec3.unit_y)

   Shader:send("view_matrix",       "column", ViewMatrix)
   Shader:send("projection_matrix", "column", PerspectiveMatrix)
   
   love.graphics.setShader(Shader)
   love.graphics.setColor(1, 1, 1)
   love.graphics.setDepthMode("lequal", true)
   love.graphics.setCanvas(DepthBuffer.canvas)
   love.graphics.clear(0, 0, 0, 0, true, 1)
   love.graphics.setMeshCullMode("back")

	Shader:send("model_matrix", "column", ModelMatrix_1)
   love.graphics.draw(Mesh)

   Shader:send("model_matrix", "column", ModelMatrix_2)
   love.graphics.draw(Mesh)

   love.graphics.setMeshCullMode("none")
   love.graphics.setShader()
   love.graphics.setDepthMode()
   love.graphics.setCanvas()

   love.graphics.draw(DepthBuffer.color)
end

function love.keypressed(key)
   if key == "q" then
      love.event.quit()
   elseif key == "t" then
      love.mouse.setRelativeMode(not love.mouse.getRelativeMode())
   end
end

function love.mousemoved(x, y, dx, dy)
   if love.mouse.getRelativeMode() then
      local rotationVector = Cpml.vec2(-dx, dy)
      Camera.rotation = Camera.rotation + rotationVector / 80
   end
end

