Coin = Class{}
local coinImg = love.graphics.newImage('coin.png')
local coinScroll = 0
local radiusX = 0.1
local radiusY = 0.1
function Coin:init()
  -- self.x = 0
  -- self.y = 0
  self.x = math.random(0,width)
  self.y = math.random(height/3, height/2)
end
-- function Coin:init(x,y)
--   self.x = x
--   self.y = y
-- end


function Coin:collides(player)

  left = math.min(player.x, self.x)
  sizeX =  (coinImg:getWidth()* radiusX)
  sizeY = (coinImg:getHeight() * radiusY)
  right = math.max(player.x + player.sizeX, self.x + sizeX)
  up = math.min(player.y-player.sizeY, self.y)
  down = math.max(self.y + sizeY, player.y)
  if ((math.abs(right - left )<= sizeX + player.sizeX) and (down - up <= sizeY + player.sizeY)) then
    print(self.x)
    return true
  else
    return false
  end
--   if ((self.x <= player.x and player.x <= self.x + (coinImg:getWidth() * radiusX))
--   and (self.y <= player.y and player.y <= self.y+(coinImg:getHeight() * radiusY))) then
--     return true
--   else if ((self.))
--     return false
--   end
end


function Coin:update(dt)
  coinScroll = (screenScroll)
  -- self.x = self.x - coinScroll
end


function Coin:render()
  -- love.graphics.draw(coinImg, self.x, self.y,0.1,0.1)
  -- love.graphics.draw(puddleImg, self.x - coinScroll, self.y, 0, 0.03, 0.03)
  love.graphics.draw(coinImg, self.x - (coinScroll), self.y,0.1,0.1)
end
