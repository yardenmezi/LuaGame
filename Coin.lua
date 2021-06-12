Coin = Class{}
local coinImg = love.graphics.newImage('images/leaf.png')
local sounds = {['coinTaking'] = love.audio.newSource('sounds/leaf.wav', 'static')}
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
  x = math.random(0,width*6)
  y = math.random(0, height/2)
  Still.init(self,x,y,60,60,coinImg)
  self.collisionType = collisionType.PRIZE
end

function Coin:handleCollision(solidObj)
  if self.isVisible  then
    if self:checkCollision(solidObj) then
      if solidObj.collisionType == collisionType.PLAYER then
        sounds['coinTaking']:play()
        self.img = nil
        self.isVisible = false
        return 1
      end
    end
  end
  return 0
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
