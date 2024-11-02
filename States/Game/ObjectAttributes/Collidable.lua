require "utils.ClassInit"

collisionType = {BLOCK=1, HARM=3, REGULAR=4, PRIZE=5, PLAYER = 6}

Collidable =declareClass(nil, Collidable)

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
  local objPt = obj:getVirtPt()
  local size = self:getVirtSize()
  local pt = self:getVirtPt()
  if pt[Y] + size[Y]-SPEED  < objPt[Y]  then
    self:setHeight(objPt[Y]-size[Y])
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

  local pt = self:getVirtPt()
  local size = self:getVirtSize()
  local objPt = obj:getVirtPt()
  local objSize = obj:getVirtSize()

  local rightBound = math.max(size[X] + pt[X], objSize[X] + objPt[X])
  local leftBound = math.min(pt[X], objPt[X])
  local hasWidthOverlap = objSize[X] + size[X] > rightBound-leftBound 
  local upperBound = math.min(pt[Y], objPt[Y])
  local lowerBound = math.max(size[Y] + pt[Y], objSize[Y] + objPt[Y])
  local hasHeightOverlap = objSize[Y] + size[Y] > lowerBound - upperBound
  return  hasWidthOverlap and hasHeightOverlap
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
