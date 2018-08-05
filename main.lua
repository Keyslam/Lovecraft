love.graphics.setDefaultFilter("nearest", "nearest")

local Cpml = require("lib.cpml")
local Concord = require("lib.concord").init({
   useEvents = true,
})

local C = require("src.components")
local S = require("src.systems")

local CubeMesh = require("cubeMesh")

local Game = Concord.instance()

local controller       = S.controller()
local cameraController = S.cameraController()

Game:addSystem(controller, "update")
Game:addSystem(controller, "keypressed")
Game:addSystem(controller, "mousemoved")

Game:addSystem(cameraController, "draw")
Game:addSystem(S.meshRenderer(), "renderscene", "draw")

local Camera = Concord.entity()
Camera:give(C.transform)
Camera:give(C.camera)
Camera:give(C.controllable)

Game:addEntity(Camera)

for x = 1, 20 do
   for z = 1, 20 do
      --for z = 1, 16 do
         if love.math.random() < 0.7 then
            local cube = Concord.entity()
            cube:give(C.transform, Cpml.vec3(x - 10, x + z, 10 + z))
            cube:give(C.mesh, CubeMesh)

            Game:addEntity(cube)
         end
      --end
   end
end

Concord.addInstance(Game)