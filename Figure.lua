--[[------------------------------------------

----------------------------------------------]]
require 'Collidable'
require 'Animation'
-- Figure = Class{}
-- TODO: HANDLE THE LOCAL!!!! IN Figure = {}
ACTION = {DOWN=1, UP=2, LEFT=3, RIGHT=4, NO_MOVE=5}
defImg = love.graphics.newImage('img.png')

Figure = {}
Figure.__index = Figure
setmetatable(Figure, {
  __index = Collidable,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

-- $$$$$$TODO: TODO : get the number of actions!!

-- TODO: check if when I update the x it update also the Collidable
function Figure:init(board,x, y, g, img, sizeX,sizeY,frames,frameSizeX,frameSizeY,speed)
  self.board = board
  self.img = img or defImg
  -- TODO FIX!! MAYBE NOT ALLOW NOT HAVING FRAMES.
  local frames = frames or {self.img}
  local sizeX = sizeX or 70
  local sizeY = sizeY or 70
  local frameSizeY =  frameSizeY or self.img:getHeight()
  local frameSizeX =  frameSizeX or self.img:getWidth()
  self.scaleY = sizeY/frameSizeY
  self.scaleX = sizeX/frameSizeX
  Collidable.init(self, x, y, sizeX,sizeY)
  self.dx = 0
  self.dy = 0
  self.gravityForce = 0
  self.scrolling = 0
  self.speed = speed or SPEED
  self.onGround = false
  self.inMotion = false
  self.mothionAnim = Animation(frames, 0.05)
end


function Figure:getAction()
  return math.random(1, 5)
end

function Figure:setHeight(newY)
  -- TODO: RANGE
  if self.board:hasCollisionRange(self.x, newY,self.sizeX,self.sizeY)  then
    self.onGround = true
  else
    self.y = newY
    self.onGround = false
  end
end

function Figure:move()
  action = self:getAction()
  if action == ACTION.UP and self.onGround ==true then
    self.dy = -self.speed * 6
    self.inMotion = false
    -- TODO: FIX DOWN!
  elseif action == ACTION.DOWN then
    self.dy = self.speed
    self.inMotion = false
  elseif action == ACTION.LEFT then
    if self.scaleX < 0 then
      self.scaleX = -self.scaleX
      -- offset.
      -- self.x = self.x - self.sizeX
    else
      self.dx = -self.speed

    end
    self.inMotion = true
  elseif action == ACTION.RIGHT then
    self.inMotion = true

    if self.scaleX > 0 then
      self.scaleX = -self.scaleX
      -- offset (can't be done in drawing because of collision checking.)
      -- self.x = self.x + self.sizeX
    else
      self.dx = self.speed
    end
  else
    self.inMotion = false
  end
  self:setHeight(self.y + self.dy)
  self:handleGravity()
  -- print(self.board)
  -- if self.board:hasCollision(self.x + self.dx, self.y + self.dy) then
    -- self.onGround = true
  -- else

  -- end
  tmpX = self.x + self.dx
  -- if action == ACTION.RIGHT then
  --   tmpX = tmpX + self.sizeX
  -- end
  -- if not self.board:hasCollision(tmpX, self.y) and not self.board:hasCollision(tmpX, self.y+self.sizeY)  then
  if not self.board:hasCollisionRange(tmpX,self.y,self.sizeX,self.sizeY) then
    self.x = self.x + self.dx
  end
  self.dx = 0
  self.dy = 0
end


function Figure:handleBlockCollision(solidObj)
  --  if it's above.
  if self.y + self.sizeY - self.speed -self.gravityForce  <= solidObj.y then
    self:setHeight(solidObj.y - self.sizeY)
    self.onGround = true
  end
end

function Collidable:handleRegCollision(solidObj)
  -- handle the case if Figure is above ovject
  if self.y + self.sizeY - self.speed -self.gravityForce  <= solidObj.y then
    self:setHeight(solidObj.y - self.sizeY)
    self.onGround = true
  -- handle the case if Figure is below object
  elseif self.y  > solidObj.y + solidObj.sizeY then
    -- self:setHeight(solidObj.y + solidObj.sizeY)
  elseif self.x + self.sizeX  > solidObj.x + solidObj.sizeX then
    self.x = solidObj.x + solidObj.sizeX
  else
    self.x = solidObj.x - self.sizeX
  end
end

function Figure:handleGravity()
  -- self.y = self.y + self.gravityForce
  -- if not self.board:hasCollision(self.x, self.y+self.gravityForce) then
    self:setHeight(self.y + self.gravityForce*5)
  -- end

end

function Figure:update(dt)
  self:move()
  if self.inMotion then
    self.mothionAnim:update(dt)
  end

end


function Figure:render()
  -- love.graphics.draw(self.img, self.mothionAnim:getFrame(), self.x, self.y, 0, self.scaleX, self.scaleY,self.sizeX,0)
  -- love.graphics.draw(self.img, self.mothionAnim:getFrame(), self.x, self.y, 0, -self.scaleX, self.scaleY)
  if self.scaleX<0 then
    love.graphics.draw(self.img, self.mothionAnim:getFrame(), self.x+self.sizeX, self.y, 0, self.scaleX, self.scaleY)
    -- love.graphics.draw(self.img, self.mothionAnim:getFrame(), self.x, self.y, 0, -self.scaleX, self.scaleY)
  else
    love.graphics.draw(self.img, self.mothionAnim:getFrame(), self.x, self.y, 0, self.scaleX, self.scaleY)
  end

  -- love.graphics.draw(self.img, self.mothionAnim:getFrame(), self.x, self.y)

  -- if self.inMotion == false then
  --   love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, self.scaleY)
  -- else
  --   love.graphics.draw(self.img, self.mothionAnim:getFrame(), self.x, self.y, 0, self.scaleX, self.scaleY)
  -- end
  -- love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
    -- love.graphics.rectangle('fill', self.x, self.y, 5, 20)
end
