local Concord = require("lib.concord")
local Cpml    = require("lib.cpml")

local Mesh = Concord.component(function(e, mesh)
   e.mesh = mesh
end)

local GetProperties, SetProperties = {}, {}

Mesh.__mt.__index = function(e, key)
   return GetProperties[key] and GetProperties[key](e) or Mesh[key]
end

Mesh.__mt.__newindex = function(e, key, value)
   if SetProperties[key] then 
      SetProperties[key](e, value)
   else
      rawset(e, key, value)
   end
end

return Mesh