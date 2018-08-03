local Concord = require("lib.concord")
local Cpml    = require("lib.cpml")

local Camera = Concord.component(function(e)
   e.shader = love.graphics.newShader("shader.glsl")
   e.depthBuffer = {
      color = love.graphics.newCanvas(w, h, {format = "rgba8"}),
      depth = love.graphics.newCanvas(w, h, {format = "depth24"}),
   }
   

   e.depthBuffer.canvas = {
      e.depthBuffer.color, 
      depthstencil = e.depthBuffer.depth
   }

   e.viewMatrix        = Cpml.mat4.identity()
   e.perspectiveMatrix = Cpml.mat4.from_perspective(
      75, 
      love.graphics.getWidth() / love.graphics.getHeight(), 
      0.1, 
      1000
   )
end)

return Camera