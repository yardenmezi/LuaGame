--[[
Desctription:
The file represents the Game class.
]]--

---------------- Class requirements ----------------
require "Still"
require "Animation"

local butterflyImg = love.graphics.newImage('images/spriteButterfly.png')
frames = {}
for i=1,3 do
  frames[i] = love.graphics.newQuad(butterflyImg:getWidth()/3*(i-1),0,butterflyImg:getWidth()/3,butterflyImg:getHeight(), butterflyImg:getDimensions())
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

--[[
  Description:
]]--
function Butterfly:init(x, y,g,player)
  Still.init(self,x,y,60,60,butterflyImg,butterflyImg:getWidth()/3)
  -- self.scaleX = 60/99
  self.player = player
  self.numOfSteps = -15
  self.collisionGap =30
  self.flyingAnim = Animation(frames,0.35)
end

function Butterfly:update(dt)
  self.flyingAnim:update(dt)
  if self:checkCollision(self.player) then
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
-- function Butterfly:checkCollision(object)
--   self.y = self.y - self.collisionGap
--   self.sizeY = self.sizeY - self.collisionGap
--   Collidable.checkCollision(self,object)
--   self.y = self.y + self.collisionGap
--   self.sizeY = self.sizeY + self.collisionGap
-- end

function Butterfly:render()
  -- if self.isVisible then

  love.graphics.rectangle("fill", self.x,self.y,10, 10 )
  love.graphics.rectangle("fill", self.x+self.sizeX,self.y+self.sizeY,10, 10 )
  -- todo: change to a better solution
  love.graphics.draw(self.img,self.flyingAnim:getFrame(), self.x, self.y,0, self.scaleX,self.scaleY)
    -- love.graphics.draw(self.img, self.x, self.y - 40, 0, self.scaleX, self.scaleY)
  -- end
end
