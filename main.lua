local cpml = require("cpml")

local ModelMatrix = cpml.mat4.identity()
local ViewMatrix  = cpml.mat4.identity()
ViewMatrix:translate(ViewMatrix, cpml.vec3(4, 4, 3))
ViewMatrix:look_at(ViewMatrix,  cpml.vec3(4, 4, 3), cpml.vec3(0, 0, 0), cpml.vec3(0, 1, 0))

local PerspectiveMatrix = cpml.mat4.from_perspective (
   90, 
   16 / 9,
   0.1,
   10000.0
)

local Shader = love.graphics.newShader("shader.glsl")

local Mesh = love.graphics.newMesh({
   {"VertexPosition", "float", 3},
   {"VertexTexCoord", "float", 2},
   {"VertexColor",    "byte",  4},
}, {
   { 0,  1, 0, 0, 0, 1, 1, 1, 1},
   {-1, -1, 0, 0, 0, 1, 1, 1, 1},
   { 1, -1, 0, 0, 0, 1, 1, 1, 1},
}, "triangles", "dynamic")

function love.update(dt)
   local delta = cpml.vec3(0, 0, 0)
   local rdelta = 0

   if love.keyboard.isDown("a") then delta.x = delta.x + 1 end
   if love.keyboard.isDown("d") then delta.x = delta.x - 1 end

   if love.keyboard.isDown("w") then delta.z = delta.z + 1 end
   if love.keyboard.isDown("s") then delta.z = delta.z - 1 end

   if love.keyboard.isDown("r") then delta.y = delta.y - 1 end
   if love.keyboard.isDown("f") then delta.y = delta.y + 1 end

   if love.keyboard.isDown("q") then rdelta = rdelta - 3 end
   if love.keyboard.isDown("e") then rdelta = rdelta + 3 end

   ViewMatrix:translate(ViewMatrix, delta * dt)
   ViewMatrix:rotate(ViewMatrix, 5 * dt, cpml.vec3(0, 1, 0))
end


function love.draw()
   --ViewMatrix:invert(ViewMatrix)

   Shader:send("ModelMatrix", "row", ModelMatrix)
   Shader:send("ViewMatrix", ViewMatrix)
   Shader:send("PerspectiveMatrix", "row", PerspectiveMatrix)

   love.graphics.setShader(Shader)
		love.graphics.draw(Mesh)
	love.graphics.setShader()
end 