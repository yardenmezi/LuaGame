require "Enemy"
-- Bird = Class{}

local birdPic = love.graphics.newImage('bird.jpeg')
Bird  = {}
Bird.__index = Bird
setmetatable(Bird, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})
function Bird:init(x, y,g)
    Enemy.init(self,x,y,g,birdPic)
    self.gravityForce = 0
    self.speed = SPEED/8
    self.numSteps = 10
    self.stepsToStop = 10
end

function Bird:handleCollision(solidObj)
  if solidObj.collisionType == collisionType.PLAYER then
    -- print("logging")
    isCloseX = solidObj.x < self.x + self.sizeX + (2 * self.speed) and solidObj.x > self.x
    -- print(isCloseX)
    isCloseX = isCloseX or  solidObj.x + sizeX > self.x - (4* self.speed) and solidObj.x < self.x
    isCloseY = solidObj.y < self.y + self.sizeY + (4 * self.speed) and solidObj.y > self.y
    if isCloseX and isCloseY  then
      solidObj:makeNoise()
      solidObj:handleHarmCollision(self)
    end
  end
end

function Bird:getAction()
  -- TODO: CHECK WHY CAN'T DO SELF.
  return ACTION.LEFT
  -- self.numSteps = self.numSteps - 1
  -- if self.numSteps > 0 and self.numSteps < self.stepsToStop then
  --   return ACTION.LEFT
  -- else
  --   if self.numSteps == -self.stepsToStop then
  --     self.numSteps = self.stepsToStop
  --   end
  --   return ACTION.RIGHT
  -- end
end
