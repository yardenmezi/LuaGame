Collidble = Class{}

function Collidble:new(x,y,sizeX,sizeY):
  self.x = x
  self.y = y
  self.sizeX = sizeX
  self.sizeY = sizeY
end
function Collidble:init(x,y,sizeX,sizeY):
  self.x = x
  self.y = y
  self.sizeX = sizeX
  self.sizeY = sizeY
end

function Collidble:checkCollisionX(solidObj):
  max = math.max(self.x + self.sizeX, solidObj.x + solidObj.sizeX) <= solidObj.sizeX
  min = math.min(self.x, solidObj.x)
  return solidObj.sizeX + self.sizeX <= max-min
end

function Collidble:checkCollisionY(solidObj):
  max = math.max(self.y + self.sizeY, solidObj.y + solidObj.sizeY) <= solidObj.sizeY
  min = math.min(self.y, solidObj.y)
  return solidObj.sizeY + self.sizeY <= max-min
end

function Collidble:responseCollision(solidObj):
  if(self:checkCollisionX(solidObj)) then
    self.x = solidObj.x
  end
  if(self:checkCollisionY(solidObj)) then
    self.y = solidObj.y
  end
end
