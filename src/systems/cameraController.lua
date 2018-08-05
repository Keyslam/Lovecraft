local Concord = require("lib.concord")
local Cpml    = require("lib.cpml")

local C = require("src.components")

local CameraController = Concord.system({C.transform, C.camera})

function CameraController:draw()
   local e = self.pool.objects[1]

   if e then
      local transform = e:get(C.transform)
      local camera    = e:get(C.camera)

      camera.shader:send("projection_matrix", "column", camera.perspectiveMatrix)

      for _, eye in ipairs(camera.eyes) do
         local position = transform.position + Cpml.vec3(eye.offset, 0, eye.offset) * transform.right

         camera.viewMatrix:identity()
         camera.viewMatrix:look_at  (camera.viewMatrix, position, transform.position + (transform.forward * camera.convergenceDist), transform.up)
         camera.viewMatrix:translate(camera.viewMatrix, position)

         camera.shader:send("view_matrix", "column", camera.viewMatrix)
         
         love.graphics.setShader(camera.shader)
         camera.shader:send("dColor", eye.color)
         love.graphics.setDepthMode("lequal", true)
         love.graphics.setCanvas(eye.canvas)
         love.graphics.clear(0, 0, 0, 0, true, 1)
         love.graphics.setMeshCullMode("back")

         self:getInstance():emit("renderscene")
      end

      love.graphics.setMeshCullMode("none")
      love.graphics.setShader()
      love.graphics.setDepthMode()
      love.graphics.setCanvas()

      love.graphics.setBlendMode("add", "premultiplied")
      for _, eye in ipairs(camera.eyes) do
         love.graphics.draw(eye.canvas[1])
      end
      love.graphics.setBlendMode("alpha")
   end
end

return CameraController