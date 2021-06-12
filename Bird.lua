require "Enemy"
-- Bird = Class{}

local birdPic = love.graphics.newImage('images/flyingBird.png')
top_left = love.graphics.newQuad(0, 0,2000, 1500, birdPic:getDimensions())
--
-- -- And here is bottom left:
bottom_left = love.graphics.newQuad(0, 1500,2000,1500, birdPic:getDimensions())
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

--




-- img = love.graphics.newImage("mushroom-64x64.png")
--
-- -- Let's say we want to display only the top-left
-- -- 32x32 quadrant of the Image:
-- top_left = love.graphics.newQuad(0, 0, 32, 32, img:getDimensions())
--
-- -- And here is bottom left:
-- bottom_left = love.graphics.newQuad(0, 32, 32, 32, img:getDimensions())

--
function Bird:init(board,x, y,g)
    Enemy.init(self,board,x,y,g,birdPic)
    self.gravityForce = 0
    self.speed = SPEED/8
    self.numSteps = 10
    self.stepsToStop = 10
    self.firstQuad = true
end

function Bird:handleCollision(solidObj)
  if solidObj.collisionType == collisionType.PLAYER then
    -- print("logging")
    isCloseX = solidObj.x < self.x + self.sizeX + (2 * self.speed) and solidObj.x > self.x
    -- print(isCloseX)
    isCloseX = isCloseX or  solidObj.x + self.sizeX > self.x - (4* self.speed) and solidObj.x < self.x
    isCloseY = solidObj.y < self.y + self.sizeY + (4 * self.speed) and solidObj.y > self.y
    if isCloseX and isCloseY  then
      solidObj:makeNoise()
      solidObj:handleHarmCollision(self)
    end
  end
end

function Bird:getAction()
  -- TODO: CHECK WHY CAN'T DO SELF.
  if self.firstQuad then
    self.img = top_left
  else
    self.img = bottom_left
  end
  self.firstQuad = not  self.firstQuad
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

function Bird:render()
  -- love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, self.scaleY)
  love.graphics.draw(birdPic,self.img, self.x, self.y,0, self.scaleX,self.scaleY)
  -- love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
    -- love.graphics.rectangle('fill', self.x, self.y, 5, 20)
end
