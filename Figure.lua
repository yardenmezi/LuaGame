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
function Figure:init(x, y, g, img, sizeX,sizeY)
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
  self.y = newY
  self.onGround = false
end

function Figure:move()
  action = self:getAction()
  if action == ACTION.UP then
    self.dy = -self.speed*10
  elseif action == ACTION.DOWN then
    self.dy = self.speed
  elseif action == ACTION.LEFT then
    self.dx = -self.speed
  elseif action == ACTION.RIGHT then
    self.dx = self.speed
  end
  self:handleGravity()
  self:setHeight(self.y + self.dy)
  self.x = self.x + self.dx
  self.dx = 0
  self.dy = 0
end


function Figure:handleBlockCollision(solidObj)
  --  if it's above.
  if self.y + self.sizeY - SPEED -self.gravityForce  <= solidObj.y then
    self:setHeight( solidObj.y - self.sizeY)
    self.onGround = true
    -- self.y = solidObj.y - self.sizeY

  -- elseif self.x + self.sizeX + SPEED <= solidObj.x then
  --   self.x = solidObj.x - self.sizeX
  -- elseif self.x - SPEED >= solidObj.x + solidObj.sizeX then
  --   self.x = solidObj.x + solidObj.sizeX
  end
end

function Figure:handleGravity()
  -- self.y = self.y + self.gravityForce
  self:setHeight(self.y + self.gravityForce)
end

function Figure:update(dt)
  self:move()
end


function Figure:render()
  love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, self.scaleY)
  -- love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
    -- love.graphics.rectangle('fill', self.x, self.y, 5, 20)
end
