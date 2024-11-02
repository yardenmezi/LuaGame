Coin = declareClass(Still, Coin)
COIN_VALUE = 1

function GetRandomPosition(width, height)
  local x = math.random(0, width * 6)
  local y = math.random(0, height / 2)
  return { x, y }
end

function Coin:init()
  x, y = GetRandomPosition()
  Still.init(self, x, y, 60, 60, Images.coin)
  self.collisionType = collisionType.PRIZE
end

function Coin:handleCollision(solidObj)
  if self.isVisible and self:checkCollision(solidObj) and solidObj.collisionType == collisionType.PLAYER then
    self.img = nil
    self.isVisible = false
    return COIN_VALUE
  end
  return 0
end
