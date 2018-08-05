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
      local controllable = e:get(C.controllable)

      local movementVector = Cpml.vec3()

      if love.keyboard.isDown("w") then movementVector = movementVector - transform.forward end
      if love.keyboard.isDown("s") then movementVector = movementVector + transform.forward end

      if love.keyboard.isDown("a") then movementVector = movementVector + transform.right end
      if love.keyboard.isDown("d") then movementVector = movementVector - transform.right end

      if love.keyboard.isDown("space")  then movementVector.y = movementVector.y + 1 end
      if love.keyboard.isDown("lshift") then movementVector.y = movementVector.y - 1 end

      controllable.velocity = controllable.velocity + movementVector * 250 * dt
      transform.position = transform.position + controllable.velocity * dt
      controllable.velocity = controllable.velocity - (controllable.velocity * controllable.friction * dt)

      transform.rotation = transform.rotation + controllable.turnVelocity * dt
      controllable.turnVelocity = controllable.turnVelocity - (controllable.turnVelocity * controllable.turnFriction * dt)
      transform.rotation.y = math.min(math.pi/2, math.max(-math.pi/2, transform.rotation.y))
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
         local controllable = e:get(C.controllable)

         local rotationVector = Cpml.vec3(-dx, dy, 0)

         controllable.turnVelocity = controllable.turnVelocity + rotationVector / 10
      end
   end
end

return Controller