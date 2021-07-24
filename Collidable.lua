Collidable = {}
collisionType = {BLOCK=1, HARM=3, REGULAR=4, PRIZE=5, PLAYER = 6}
-- Collidable.xyz = 1
Collidable.__index = Collidable
setmetatable(Collidable, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function Collidable:init(x,y,sizeX,sizeY,collChanges)
  self.x = x
  self.y = y
  self.sizeX = sizeX
  self.sizeY = sizeY
  -- self.startPt = {x,y}
  -- self.sizes = {sizeX,sizeY}
  -- collChanges = collChanges or {['l']=0,['r']=0,['u']=0,['b']=0}
  collChanges = {['l']=0,['r']=0,['u']=0,['b']=0}
  self.collPt = {['x'] = x+collChanges['l'], ['y']=y+collChanges['u']}
  self.collsizes = {sizeX-collChanges['l']-collChanges['r'],sizeY-collChanges['u']-sizeY-collChanges['b']}
  -- self.collGaps = {['upperL'] = {x,y}, ['bottomR'] = {x+sizeX,y+sizeY}}
  -- self.collPts = colSizes or  {['upperL'] = {x,y}, ['bottomR'] = {x+sizeX,y+sizeY}}
  self.collisionType = collisionType.BLOCK
end

function Collidable:update(dt)
end


function Collidable:setHeight(newY)
  self.y = newY
end
function Collidable:handleBlockCollision(solidObj)
  -- self:setHeight(solidObj.y - self.sizeY)
  self:setHeight(solidObj.collPts['upperL'][2] - self.sizeY)
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

function Collidable:checkCollision(obj)
  -- objCoords = {''}
  -- local objR = self.collPt['x']
  local selfU,selfL ,selfR ,selfB,objU,objL,objR,objB
  selfU = self.collPt['y']
  selfL = self.collPt['x']
  selfR = self.collPt['x']+ self.collsizes[1]
  selfB = self.collPt['y']+ self.collsizes[2]
  objU = obj.collPt['y']
  objL = obj.collPt['x']
  objR = obj.collPt['x']+ obj.collsizes[1]
  objB = obj.collPt['y']+ obj.collsizes[2]
  -- Checking left collision

  -- Checking collision from right

  -- Checking collision from up

  -- Checking collision from down
  -- print("logging")
  -- TODO: THINK OF A BETTER WAY TO REPRESENT IT.
  -- if obj.collsizes[1] + self.collsizes[1] > math.max(objR,selfR)-math.min(objL,selfL) then
  if obj.sizeX + self.sizeX > math.max(self.sizeX + self.x, obj.sizeX + obj.x) - math.min(self.x, obj.x) then
    -- return obj.collsizes[2] + self.collsizes[2] > math.max(objB,selfB) - math.min(selfU, objU)
    return obj.sizeY + self.sizeY > math.max(self.sizeY + self.y, obj.sizeY + obj.y) - math.min(self.y, obj.y)
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
    end
  end
  -- TODO: false for needed to delete object
  return false
end
