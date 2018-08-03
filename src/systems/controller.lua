local Concord = require("lib.concord")
local Cpml    = require("lib.cpml")

local C = require("src.components")

local Controller = Concord.system({C.transform, C.controllable})

function Controller:init()
   self.isRelative = false
end

function Controller:update(dt)
   for _, e in ipairs(self.pool.objects) do
      local transform = e:get(C.transform)

      local movementVector = Cpml.vec3()

      if love.keyboard.isDown("w") then movementVector = movementVector + transform.forward end
      if love.keyboard.isDown("s") then movementVector = movementVector - transform.forward end

      if love.keyboard.isDown("a") then movementVector = movementVector + transform.right end
      if love.keyboard.isDown("d") then movementVector = movementVector - transform.right end

      if love.keyboard.isDown("space")  then movementVector.y = movementVector.y + 1 end
      if love.keyboard.isDown("lshift") then movementVector.y = movementVector.y - 1 end

      transform.position = transform.position + movementVector * 10 * dt
   end

   love.window.setTitle(love.timer.getFPS())
end

function Controller:keypressed(key)
   if key == "q" then -- Should this be in here? Probably not
      love.event.quit()
   end

   if key == "t" then
      self.isRelative = not self.isRelative
      love.mouse.setRelativeMode(self.isRelative)
   end
end

function Controller:mousemoved(x, y, dx, dy)
   if self.isRelative then
      for _, e in ipairs(self.pool.objects) do
         local transform = e:get(C.transform)

         local rotationVector = Cpml.vec2(-dx, dy)
         transform.rotation = transform.rotation + rotationVector / 80
      end
   end
end

return Controller