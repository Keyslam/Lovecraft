local Concord = require("lib.concord")
local Cpml    = require("lib.cpml")

local Transform = Concord.component(function(e, position, rotation)
   e.position = position or Cpml.vec3(0, 0, 0)
   e.rotation = rotation or Cpml.vec3(0, 0, 0)
end)

local GetProperties, SetProperties = {}, {}
function GetProperties:forward()
   return Cpml.vec3(
      math.cos(self.rotation.y) * math.sin(self.rotation.x),
      math.sin(self.rotation.y),
      math.cos(self.rotation.y) * math.cos(self.rotation.x)
   )
end

function GetProperties:right()
   return Cpml.vec3(
      math.sin(self.rotation.x - math.pi/2),
      0,
      math.cos(self.rotation.x - math.pi/2)
   )
end

function GetProperties:up()
   return Cpml.vec3.cross(self.right, self.forward)
end


-- function SetProperties:forward(normal)
--    self.rotation = Cpml.quat.from_direction(normal)
-- end

Transform.__mt.__index = function(e, key)
   return GetProperties[key] and GetProperties[key](e) or Transform[key]
end

Transform.__mt.__newindex = function(e, key, value)
   if SetProperties[key] then 
      SetProperties[key](e, value)
   else
      rawset(e, key, value)
   end
end


return Transform