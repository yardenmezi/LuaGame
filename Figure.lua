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
scaleX = 0.1
scaleY = 0.1
ACTION = {DOWN=1, UP=2, LEFT=3, RIGHT=4, NO_MOVE=5}
img = love.graphics.newImage('img.png')

-- ACTION = {[DOWN]='S',UP='W',LEFT='A',RIGHT='D',NO_MOVE=' '}

-- $$$$$$TODO: TODO : get the number of actions!!
-- print(#ACTION)
-- print(ACTION.UP)

-- TODO: check if when I update the x it update also the Collidable
function Figure:init(x, y)
  sizeY = img:getHeight() * scaleY
  sizeX = img:getWidth() * scaleX
  Collidable.init(self, x,y,sizeX,sizeY)
  self.img = img
  self.dx = 0
  self.dy = 0
  self.mass = 6
  self.scrolling = 0
end


function Figure:getAction()
  return math.random(1, 5)
end

function Figure:move()
  action = self.getAction()
  if action == ACTION.UP then
    self.dy = -SPEED
  elseif action == ACTION.DOWN then
    self.dy = SPEED
  elseif action == ACTION.LEFT then
    self.dx = -SPEED
  elseif action == ACTION.RIGHT then
    self.dx = SPEED
  end
  self.y = self.y + self.dy
  self.x = self.x + self.dx
  self.dx = 0
  self.dy = 0
end


function Figure:update(dt)
  self:move()
end


function Figure:render()
  love.graphics.draw(self.img, self.x, self.y, 0, scaleX, scaleY)
  -- love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
    -- love.graphics.rectangle('fill', self.x, self.y, 5, 20)
end
