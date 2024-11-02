require 'States/Game/ObjectAttributes/Collidable'
require 'States/Game/ObjectAttributes/Animation'
require "utils.ClassInit"

ACTION = {DOWN=1, UP=2, LEFT=3, RIGHT=4, NO_MOVE=5}

Figure = declareClass(Collidable, Figure)

function Figure:init(board,x, y, g,imageProperties,speed)
  Collidable.init(self, x, y, imageProperties.sizeX,imageProperties.sizeY,{x=20,y=0},{x=-20,y=-20})
  self.board = board
  self.img = imageProperties.img
  self.scaleY = imageProperties.sizeY / imageProperties.fsizeY
  self.scaleX = imageProperties.sizeX / imageProperties.fsizeX
  self.dx = 0
  self.dy = 0
  self.gravityForce = g
  self.scrolling = 0
  self.speed = speed or SPEED
  self.onGround = false
  self.inMotion = false
  self.mothionAnim = Animation(imageProperties.frames, 0.05)
  self.isJumping= false
end


function Figure:getAction()
  return math.random(1, 5)
end

function Figure:setHeight(newY)
  if self.board:hasCollisionRange(self.x, newY,self.sizeX,self.sizeY)[1] == CELL_TYPE.GROUND  then
    self.onGround = true
  else
    self.y = newY
    self.onGround = false
  end
end

function Figure:flipImgUpdate(sign)
  self.inMotion = true
  if sign * self.scaleX > 0 then
    self.scaleX = -self.scaleX
  else
    self.dx = sign * self.speed
  end
end

function Figure:move()
  local action = self:getAction()
  if (action == ACTION.UP and self.onGround ==true) or isJumping then
    self.dy = -self.speed
    self.inMotion = true
  end
  if action == ACTION.DOWN then
    self.dy = self.speed
    self.inMotion = false
  elseif action == ACTION.LEFT then
    self:flipImgUpdate(-1)
  elseif action == ACTION.RIGHT then
    self:flipImgUpdate(1)
    inMotion =true
  else
    self.inMotion = false
  end
  self:setHeight(self.y + self.dy)
  self:handleGravity()
  tmpX = self.x + self.dx
  if self.board:hasCollisionRange(tmpX,self.y,self.sizeX,self.sizeY)[1] ~= CELL_TYPE.GROUND then
    self.x = self.x + self.dx
  end
  self.dx = 0
  self.dy = 0
end


function Figure:handleBlockCollision(solidObj)
  Collidable.handleBlockCollision(self,solidObj)
  self.onGround = true
end


function Figure:handleRegCollision(solidObj)
  isFigureAboveObject = self.y + self.sizeY - self.speed -self.gravityForce  <= solidObj.y

  if isFigureAboveObject then
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
    self:setHeight(self.y + self.gravityForce*5)
end


function Figure:update(dt)
  self:move()
  if self.inMotion then
    self.mothionAnim:update(dt)
  end
end


function Figure:render()

  if self.scaleX<0 then
    love.graphics.draw(self.img, self.mothionAnim:getFrame(), self.x+self.sizeX, self.y, 0, self.scaleX, self.scaleY)
  else
    love.graphics.draw(self.img, self.mothionAnim:getFrame(), self.x,  self.y, 0, self.scaleX, self.scaleY)
  end
end
