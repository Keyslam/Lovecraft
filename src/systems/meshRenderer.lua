local Concord = require("lib.concord")
local Cpml    = require("lib.cpml")

local C = require("src.components")

local MeshRenderer = Concord.system({C.transform, C.mesh})

function MeshRenderer:draw()
   for _, e in ipairs(self.pool.objects) do
      local transform = e:get(C.transform)
      local mesh      = e:get(C.mesh)
   
      local shader = love.graphics.getShader()
      shader:send("model_matrix", "column", Cpml.mat4.from_transform(
         transform.position,
         Cpml.quat.from_direction(Cpml.vec3(1, 0, 0)),
         transform.scale
      ))

      love.graphics.draw(mesh.mesh)
   end
end

return MeshRenderer