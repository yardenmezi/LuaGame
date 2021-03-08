Collidable = {}
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
end

function Collidable:checkCollisionX(solidObj)
  maxVal = math.max(self.x + self.sizeX, solidObj.x + solidObj.sizeX)
  minVal = math.min(self.x, solidObj.x)
  -- print(maxVal)
  -- return true
  return solidObj.sizeX + self.sizeX <= maxVal - minVal
end

function Collidable:checkCollisionY(solidObj)
  -- max = math.max(self.y + self.sizeY, solidObj.y + solidObj.sizeY) <= solidObj.sizeY
  max = math.max(self.y + self.sizeY, solidObj.y + solidObj.sizeY)
  min = math.min(self.y, solidObj.y)
  -- return true
  return (solidObj.sizeY + self.sizeY <= max-min)
end

function Collidable:handleCollision(solidObj)
  if(self:checkCollisionX(solidObj)) then
    self.x = solidObj.x
  end
  if(self:checkCollisionY(solidObj)) then
    self.y = solidObj.y
  end
end
