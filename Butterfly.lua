require "Still"
local butterflyImg = love.graphics.newImage('images/butterfly.png')

Butterfly = {}
Butterfly.__index = Butterfly
setmetatable(Butterfly, {
  __index = Still,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

function Butterfly:init(x, y,g,player)
  Still.init(self,x,y,60,60,butterflyImg)
  self.player = player
  self.numOfSteps = -3
end

function Butterfly:update(dt)
  if self:checkCollision(player) then
    if self.player:hasMadeNoise() then
      self.numOfSteps = 3
    end
  end
  if self.numOfSteps > -3 then
    if self.numOfSteps > 0 then
      self.y = self.y - 15
    else
      self.y = self.y + 15
    end
    self.numOfSteps = self.numOfSteps - 1
  end
  self.x = self.x - screenScroll
end

function Butterfly:render()
  if self.isVisible then
    love.graphics.draw(self.img, self.x, self.y - 40, 0, self.scaleX, self.scaleY)
  end
end
