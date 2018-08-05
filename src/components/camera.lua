local Concord = require("lib.concord")
local Cpml    = require("lib.cpml")

local Camera = Concord.component(function(e, color)
   e.shader = love.graphics.newShader("shader.glsl")
   
   e.convergenceDist = 10

   e.eyes = {
      -- Normal
      {
         offset = 0, 
         color  = {1, 1, 1, 1},
         canvas = {
            love.graphics.newCanvas(w, h, {format = "rgba8", msaa = 4}),
            depthstencil = love.graphics.newCanvas(w, h, {format = "depth24", msaa = 4}),
         },
      },
      
      -- Anaglyph
      --[[
      {
         offset = 0.1, 
         color  = {0, 0.2, 0.2, 1},
         canvas = {
            love.graphics.newCanvas(w, h, {format = "rgba8", msaa = 4}),
            depthstencil = love.graphics.newCanvas(w, h, {format = "depth24", msaa = 4}),
         },
      },
      {
         offset = -0.1, 
         color  = {0.2, 0, 0, 1},
         canvas = {
            love.graphics.newCanvas(w, h, {format = "rgba8", msaa = 4}),
            depthstencil = love.graphics.newCanvas(w, h, {format = "depth24", msaa = 4}),
         },
      }
      ]]
   }

   e.viewMatrix        = Cpml.mat4.identity()
   e.perspectiveMatrix = Cpml.mat4.from_perspective(
      60, 
      love.graphics.getWidth() / love.graphics.getHeight(), 
      0.1, 
      1000
   )
end)

return Camera