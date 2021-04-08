require "Collidable"
-- Puddle = Class{}
Puddle = {}
Puddle.__index = Puddle
setmetatable(Puddle, {
  __index = Collidable,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

local puddleScroll = 0
local puddleImg = love.graphics.newImage('puddle.png')
function Puddle:init(x_init)
  self.x = math.random(x_init + (width/30) , x_init + width/2)
  -- TODO:change value!
  self.y = 420

  self.size = math.random(width/20, width/10)
  Collidable.init(self, self.x,self.y,self.size,10)
end

function Puddle:getPuddleEnd()
  return self.x + self.size
end

function Puddle:update(dt)
  -- if puddleScroll != screenScroll then

  -- end
  puddleScroll = (screenScroll)

  -- self.x = self.x - puddleScroll
end

function Puddle:render()
  love.graphics.draw(puddleImg, self.x - puddleScroll, self.y, 0, 0.02, 0.02)
  -- self.x = self.x - puddleScroll
  -- love.graphics.draw(puddleImg,self.x , self.y, 0, 0.03, 0.03)
  -- love.graphics.rectangle('fill', self.x - puddleScroll, self.y, self.size, 20)
end
