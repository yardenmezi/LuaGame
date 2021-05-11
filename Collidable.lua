Collidable = {}
collisionType = {BLOCK=1, HARM=3, REGULAR=4, PRIZE=5, PLAYER = 6}

Collidable.__index = Collidable
setmetatable(Collidable, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Collidable:init(x,y,sizeX,sizeY)
  self.x = x
  self.y = y
  self.sizeX = sizeX
  self.sizeY = sizeY
  self.collisionType = collisionType.BLOCK
end

function Collidable:update(dt)
end


function Collidable:handlePrizeCollision(solidObj)
  -- if solidObj.collisionType == collisionType.PLAYER then
  --   print("logging")
  --   return true
  -- end
  -- return false
end
function Collidable:setHeight(newY)
  self.y = newY
end
function Collidable:handleBlockCollision(solidObj)
  self:setHeight(solidObj.y - self.sizeY)
  --  if it's above.
  -- if self.y + self.sizeY  < solidObj.y then
    -- self.y =
  -- else
    -- self.x = solidObj.x - self.sizeX
  -- end
end

function Collidable:handleRegCollision(solidObj)
  self.x = self.x- 60
  -- self.y = self.y- 60
  self:setHeight(self.y- 60)
end

function Collidable:handleHarmCollision(solidObj)
  self.x = self.x- 60
  -- self.y = self.y- 60
  self:setHeight(self.y + 20)
end

function Collidable:checkCollision(solidObj)
  if solidObj.sizeX + self.sizeX > math.max(self.sizeX+self.x, solidObj.sizeX + solidObj.x) - math.min(self.x,solidObj.x) then
    return solidObj.sizeY + self.sizeY > math.max(self.sizeY + self.y, solidObj.sizeY + solidObj.y) - math.min(self.y, solidObj.y)
  else
    return false
  end
end

function Collidable:handleCollision(solidObj)

  if self:checkCollision(solidObj) then
    if solidObj.collisionType == collisionType.BLOCK then
      return self:handleBlockCollision(solidObj)
    elseif solidObj.collisionType == collisionType.HARM then
      return self:handleHarmCollision(solidObj)
    elseif solidObj.collisionType == collisionType.REGULAR then
      return self:handleRegCollision(solidObj)
    elseif solidObj.collisionType == collisionType.PRIZE then
      -- TODO FOR SOME RESON, WHEN IT'S "FALSE, THE COINS HANDLES LIKE REGULAR COLLISION"
      return self:handlePrizeCollision(solidObj)
      -- self:handleRegCollision(solidObj)
    end
  end
  -- TODO: false for needed to delete object
  return false
end
