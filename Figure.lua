--[[------------------------------------------

----------------------------------------------]]

require 'Collidable'
-- Figure = Class{}
-- TODO: HANDLE THE LOCAL!!!! IN Figure = {}
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
-- scaleX = 0.1
-- scaleY = 0.1
ACTION = {DOWN=1, UP=2, LEFT=3, RIGHT=4, NO_MOVE=5}
defImg = love.graphics.newImage('img.png')

-- ACTION = {[DOWN]='S',UP='W',LEFT='A',RIGHT='D',NO_MOVE=' '}

-- $$$$$$TODO: TODO : get the number of actions!!
-- print(#ACTION)
-- print(ACTION.UP)

-- TODO: check if when I update the x it update also the Collidable
function Figure:init(board,x, y, g, img, sizeX,sizeY)
  self.board = board
  self.img = img or defImg
  sizeX = sizeX or 70
  sizeY = sizeY or 70
  self.scaleY = sizeY / self.img:getHeight()
  self.scaleX = sizeX / self.img:getWidth()
  Collidable.init(self, x,y,sizeX,sizeY)
  self.dx = 0
  self.dy = 0
  self.gravityForce = 0
  self.scrolling = 0
  self.speed = SPEED
  self.onGround = false
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
    self.dy = -self.speed * 20
  elseif action == ACTION.DOWN then
    self.dy = self.speed
  elseif action == ACTION.LEFT then
      self.dx = -self.speed
  elseif action == ACTION.RIGHT then
      self.dx = self.speed
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
  if self.y + self.sizeY - SPEED -self.gravityForce  <= solidObj.y then
    self:setHeight( solidObj.y - self.sizeY)
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
    self:setHeight(solidObj.y + solidObj.sizeY)
  elseif self.x + self.sizeX  > solidObj.x + solidObj.sizeX then
    self.x = solidObj.x + solidObj.sizeX
  else
    self.x = solidObj.x - self.sizeX
  end
end

function Figure:handleGravity()
  -- self.y = self.y + self.gravityForce
  -- if not self.board:hasCollision(self.x, self.y+self.gravityForce) then
    self:setHeight(self.y + self.gravityForce)
  -- end

end

function Figure:update(dt)
  self:move()
end


function Figure:render()
  love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, self.scaleY)
  -- love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
    -- love.graphics.rectangle('fill', self.x, self.y, 5, 20)
end
