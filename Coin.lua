Coin = Class{}
local coinImg = love.graphics.newImage('images/leaf.png')
-- local coinScroll = 0


Coin = {}
Coin.__index = Coin
setmetatable(Coin, {
  __index = Still,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

function Coin:init()
  -- self.x = 0
  -- self.y = 0
  x = math.random(-width,width)
  y = math.random(0, height/2)
  Still.init(self,x,y,60,60,coinImg)
  self.collisionType = collisionType.PRIZE
  -- self.img = coinImg
end

function Coin:handleCollision(solidObj)
  if self:checkCollision(solidObj) then
    if solidObj.collisionType == collisionType.PLAYER then
      self.img = nil
      self.isVisible = false
    end
    -- return false
    end
  end

--
-- function Coin:collides(player)
--
--   left = math.min(player.x, self.x)
--   sizeX =  (coinImg:getWidth()* radiusX)
--   sizeY = (coinImg:getHeight() * radiusY)
--   right = math.max(player.x + player.sizeX, self.x + sizeX)
--   up = math.min(player.y-player.sizeY, self.y)
--   down = math.max(self.y + sizeY, player.y)
--   if ((math.abs(right - left )<= sizeX + player.sizeX) and (down - up <= sizeY + player.sizeY)) then
--     print(self.x)
--     return true
--   else
--     return false
--   end
--   if ((self.x <= player.x and player.x <= self.x + (coinImg:getWidth() * radiusX))
--   and (self.y <= player.y and player.y <= self.y+(coinImg:getHeight() * radiusY))) then
--     return true
--   else if ((self.))
--     return false
--   end
-- end
