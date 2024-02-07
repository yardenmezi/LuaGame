Coin = {}
inherit(Coin, Still)

function GetRandomPosition(width, height)
  local x = math.random(0, width * 6)
  local y = math.random(0, height / 2)
  return {x,y}
end

function Coin:init()
  {x,y} = GetRandomPosition()
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
