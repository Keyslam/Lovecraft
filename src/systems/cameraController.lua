local Concord = require("lib.concord")
local Cpml    = require("lib.cpml")

local C = require("src.components")

local CameraController = Concord.system({C.transform, C.camera})

function CameraController:attach()
   local e = self.pool:get(1)

   if e then
      local transform = e:get(C.transform)
      local camera    = e:get(C.camera)

      camera.viewMatrix:identity()
      camera.viewMatrix:look_at  (camera.viewMatrix, transform.position, transform.position + transform.direction, transform.up)
      camera.viewMatrix:translate(camera.viewMatrix, transform.position)

      camera.shader:send("view_matrix",       "column", camera.viewMatrix)
      camera.shader:send("projection_matrix", "column", camera.perspectiveMatrix)
      
      love.graphics.setShader(camera.shader)
      love.graphics.setColor(1, 1, 1)
      love.graphics.setDepthMode("lequal", true)
      love.graphics.setCanvas(camera.depthBuffer.canvas)
      love.graphics.clear(0, 0, 0, 0, true, 1)
      love.graphics.setMeshCullMode("back")
   end
end

function CameraController:detach()
   love.graphics.setMeshCullMode("none")
   love.graphics.setShader()
   love.graphics.setDepthMode()
   love.graphics.setCanvas()
end

function CameraController:draw()
   local e = self.pool:get(1)

   if e then
      local camera = e:get(C.camera)

      love.graphics.draw(camera.depthBuffer.color)
   end
end

return CameraController