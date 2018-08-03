local Cpml = require("lib.cpml")

local Camera = {
   position = Cpml.vec3(0, 0, 0),
   rotation = Cpml.vec2(0, 0),

   direction = nil,
   right     = nil,
   up        = nil,
}

return Camera