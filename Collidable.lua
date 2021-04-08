Collidable = {}
Collidable.__index = Collidable
collisionType = {BLOCK=1, HARM=3, REGULAR=4}

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
  self.collisionType = collisionType.REGULAR
end

function Collidable:update(dt)
end

function Collidable:handleBlockCollision(solidObj)
  self.y = solidObj.y - self.sizeY - solidObj.sizeY
  -- solidObj.y = self.y - solidObj.sizeY - solidObj.sizeY
end

function Collidable:handleRegCollision(solidObj)
  self.x = self.x- 60
  self.y = self.y- 60
end

function Collidable:handleHarmCollision(solidObj)
  self:handleRegCollision()
end

function Collidable:checkCollision(solidObj)
  if solidObj.sizeX + self.sizeX > math.max(self.sizeX+self.x, solidObj.sizeX + solidObj.x) - math.min(self.x,solidObj.x) then
    -- TODO: TEMP
    return solidObj.sizeY + self.sizeY > math.max(self.sizeY + self.y, solidObj.sizeY + solidObj.y) - math.min(self.y, solidObj.y)
    -- return solidObj.sizeY + self.sizeY > math.max(self.sizeY + self.y, solidObj.sizeY + solidObj.y) - math.min(self.y, solidObj.y)
  else
    return false
  end
end

function Collidable:handleCollision(solidObj)
  if self:checkCollision(solidObj) then
    if solidObj.collisionType == collisionType.BLOCK then
      self:handleBlockCollision(solidObj)
    elseif solidObj.collisionType == collisionType.HARM then
      self:handleHarmCollision(solidObj)
    elseif solidObj.collisionType == collisionType.REGULAR then
      self:handleRegCollision(solidObj)
    end
  end
  -- if self:checkCollision(solidObj) then
  --   solidObj.y = self.y - solidObj.sizeY - solidObj.sizeY
  --   -- solidObj.y = self.y - solidObj.sizeY - solidObj.sizeY
  -- end
end
