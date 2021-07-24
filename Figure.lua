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
-- lala = Collidable
-- print(lala.xyz)
-- $$$$$$TODO: TODO : get the number of actions!!

-- TODO: check if when I update the x it update also the Collidable

--[[
  Description: Defines initial fefinitions for an instance of a Figure.
  Params:
    - board: (Board instance) the board in which the Figure moves.
    -
]]--
-- function Figure:init(board,x, y, g, img, sizeX,sizeY,frames,frameSizeX,frameSizeY,speed)
 -- img, sizeX,sizeY,frames,frameSizeX,frameSizeY
function Figure:init(board,x, y, g,imageProperties,speed)
  Collidable.init(self, x, y, imageProperties.sizeX,imageProperties.sizeY)
  self.board = board
  self.img = imageProperties.img
  self.scaleY = imageProperties.sizeY / imageProperties.fsizeY
  self.scaleX = imageProperties.sizeX / imageProperties.fsizeX
  self.dx = 0
  self.dy = 0
  self.gravityForce = 0
  self.scrolling = 0
  self.speed = speed or SPEED
  self.onGround = false
  self.inMotion = false
  self.mothionAnim = Animation(imageProperties.frames, 0.1)
end


--[[
  Description: Defult action of a general figure.
]]--
function Figure:getAction()
  return math.random(1, 5)
end

function Figure:setHeight(newY)
  -- TODO: RANGE

  if self.board:hasCollisionRange(self.x, newY,self.sizeX,self.sizeY)[1] == cell.GROUND  then
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
  action = self:getAction()
  if action == ACTION.UP and self.onGround ==true then
    self.dy = -self.speed * 6
    self.inMotion = true
  elseif action == ACTION.DOWN then
    -- TODO: FIX DOWN!
    self.dy = self.speed
    self.inMotion = false
  elseif action == ACTION.LEFT then
    self:flipImgUpdate(-1)
  elseif action == ACTION.RIGHT then
    self:flipImgUpdate(1)
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
  -- if scaleX<0 then
  --   tempX= tempX-self.sizeX
  -- end
  if self.board:hasCollisionRange(tmpX,self.y,self.sizeX,self.sizeY)[1] ~= cell.GROUND then
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


function Figure:handleRegCollision(solidObj)
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



--[[
  Description: Changing the place of the figure, according to the gravity.
]]--
function Figure:handleGravity()
    self:setHeight(self.y + self.gravityForce*5)
end


--[[
  Description: updates the place and state of the figure during the game.
]]--
function Figure:update(dt)
  self:move()
  if self.inMotion then
    self.mothionAnim:update(dt)
  end
end

--[[
  Description: Drawing figure.
]]--
function Figure:render()
  love.graphics.rectangle("fill", self.x,self.y, 20, 10)
  love.graphics.rectangle("fill", self.x + self.sizeX, self.y + self.sizeY, 20, 10 )
  if self.scaleX<0 then
    love.graphics.draw(self.img, self.mothionAnim:getFrame(), self.x+self.sizeX, self.y, 0, self.scaleX, self.scaleY)
  else
      -- love.graphics.draw(birdPic,self.flyingAnim:getFrame(), self.x,               self.y,0, self.scaleX,self.scaleY)
    love.graphics.draw(self.img, self.mothionAnim:getFrame(), self.x,  self.y, 0, self.scaleX, self.scaleY)
  end
end
