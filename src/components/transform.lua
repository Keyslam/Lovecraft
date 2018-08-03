local Concord = require("lib.concord")
local Cpml    = require("lib.cpml")

local Transform = Concord.component(function(e, position, rotation, scale)
   e.position = position or Cpml.vec3(0, 0, 0)
   e.rotation = rotation or Cpml.vec2(0, 0) -- TODO make this a quaternion please
   e.scale    = scale    or Cpml.vec3(0, 0, 0)

   e.hasChanged = true
end)

local GetProperties, SetProperties = {}, {}
function GetProperties:direction()
   return Cpml.vec3(
      math.cos(self.rotation.y) * math.sin(self.rotation.x),
      math.sin(self.rotation.y),
      math.cos(self.rotation.y) * math.cos(self.rotation.x)
   )
end

function GetProperties:forward() 
   return Cpml.vec3(
      math.sin(self.rotation.x + math.pi),
      math.sin(self.rotation.y),
      math.cos(self.rotation.x + math.pi)
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
   return Cpml.vec3.cross(self.right, self.direction)
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