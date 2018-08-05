local Concord = require("lib.concord")
local Cpml    = require("lib.cpml")

local Controllable = Concord.component(function(e)
   e.velocity     = Cpml.vec3(0, 0, 0)
   e.turnVelocity = Cpml.vec3(0, 0, 0)

   e.friction = 10
   e.turnFriction = 50
end)

return Controllable