--[[
Desctription:
The file represents the Game class.
]]--

---------------- Class requirements ----------------
require "Still"
require "Animation"

local butterflyImg = love.graphics.newImage('images/butterflySprite.png')
frames = {}
for i=1,3 do
  frames[i] = love.graphics.newQuad(99*(i-1),0,99,200, butterflyImg:getDimensions())
end

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
  self.scaleX = 60/99
  self.player = player
  self.numOfSteps = -15
  self.flyingAnim = Animation(frames,0.4)
end

function Butterfly:update(dt)
  self.flyingAnim:update(dt)
  if self:checkCollision(player) then
    if self.player:hasMadeNoise() then
      self.numOfSteps = 15
    end
  end
  if self.numOfSteps > -15 then
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
    love.graphics.draw(self.img,self.flyingAnim:getFrame(), self.x, self.y-40,0, self.scaleX,self.scaleY)
    -- love.graphics.draw(self.img, self.x, self.y - 40, 0, self.scaleX, self.scaleY)
  end
end
