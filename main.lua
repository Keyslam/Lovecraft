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

Game:addSystem(cameraController, "draw", "attach")
Game:addSystem(S.meshRenderer(), "draw")
Game:addSystem(cameraController, "draw", "detach")
Game:addSystem(cameraController, "draw")

local CameraEntity = Concord.entity()
CameraEntity:give(C.transform)
CameraEntity:give(C.camera)
CameraEntity:give(C.controllable)

Game:addEntity(CameraEntity)

for x = 1, 4 do
   for z = 1, 4 do
      local cube = Concord.entity()
      cube:give(C.transform, Cpml.vec3(x * 2, (x + z) * 2, z * 2))
      cube:give(C.mesh, CubeMesh)

      Game:addEntity(cube)
   end
end

Concord.addInstance(Game)