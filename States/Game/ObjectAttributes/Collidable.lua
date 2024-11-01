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

function Collidable:init(x,y,sizeX,sizeY,virtPosDiff,virtSizeDiff)
  self.x = x
  self.y = y
  self.sizeX = sizeX
  self.sizeY = sizeY
  self.virtSizeDiff = virtSizeDiff or {x=0, y=0}
  self.virtPosDiff = virtPosDiff or {x=0, y=0}
  self.collisionType = collisionType.BLOCK
end


function Collidable:getVirtSize()
  -- // if the size diff is minus, it means the size decreases.
  --  in addition, we have to dectrease/increase the size according to the position of virtual x
  --  that is, if x is minus, we have to increase size. else, we should dectrease.
  return {self.sizeX + self.virtSizeDiff.x - self.virtPosDiff.x, self.sizeY + self.virtSizeDiff.y - self.virtPosDiff.y}
end

function Collidable:getVirtPt()
  return {self.x + self.virtPosDiff.x, self.y + self.virtPosDiff.y}
end


function Collidable:setHeight(newY)
  self.y = newY
end

function Collidable:handleBlockCollision(obj)
  local Y=2
  objpt = obj:getVirtPt()
  size = self:getVirtSize()
  pt = self:getVirtPt()
  if pt[Y] + size[Y]-SPEED  < objPt[Y]  then
    self:setHeight(objpt[Y]-size[Y])
  end
end
-- TODO: SHOULD CHANGE THE COLLISION OF THE AVATAR WHEN SWITCH SIDES.(SIZE TO PT AND PT TO SIZE)


function Collidable:handleHarmCollision(solidObj)
  self.x =self.x- 60
  self:setHeight(self.y + 20)
end

function Collidable:checkCollision(obj)
  local X=1
  local Y=2

  pt = self:getVirtPt()
  size = self:getVirtSize()
  objPt = obj:getVirtPt()
  objSize = obj:getVirtSize()

  rightBound = math.max(size[X] + pt[X], objSize[X] + objPt[X])
  leftBound = math.min(pt[X], objPt[X])
  upperBound = math.min(pt[Y], objPt[Y])
  lowerBound = math.max(size[Y] + pt[Y], objSize[Y] + objPt[Y])
  if objSize[X] + size[X] > rightBound-leftBound and objSize[Y] + size[Y] > lowerBound - upperBound then
    return  true
  end
  return false
end

function Collidable:handleCollision(solidObj)
  if self:checkCollision(solidObj) then
    if solidObj.collisionType == collisionType.BLOCK then
      return self:handleBlockCollision(solidObj)
    elseif solidObj.collisionType == collisionType.HARM then
      return self:handleHarmCollision(solidObj)
    elseif solidObj.collisionType == collisionType.REGULAR then
      return self:handleRegCollision(solidObj)
    end
  end
  return false
end
