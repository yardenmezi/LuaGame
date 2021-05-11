
require "Figure"
Avatar = Class{}
local giraffe = love.graphics.newImage('giraffe.png')
local sounds = {['bark'] = love.audio.newSource('sounds/wall_hit.wav', 'static')}
onGround  = false

Avatar = {}
Avatar.__index = Avatar
setmetatable(Avatar, {
  __index = Figure,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

function Avatar:init(board,x, y,g)

    -- self.x = x
    -- self.y = y
    -- self.sizeY = giraffe:getHeight() * scaleY
    -- self.sizeX = giraffe:getWidth() * scaleX
    -- self.img =giraffe
    Figure.init(self,board,x,y,g,giraffe,100,100)
    self.dx = 0
    self.dy = 0
    self.gravityForce = 0.1 * g
    self.scrolling = 0
    self.collisionType = collisionType.PLAYER

end

function Avatar:makeNoise()
  sounds['bark']:play()
end

-- function Avatar:collides(wall)
--   if self.y < wall.y then
--     onGround = false
--     return false
--   end
--   onGround = true
--   return true
-- end


function Avatar:getScrolling()
  return self.scrolling
end

function Avatar:getAction()
  -- TODO: handle the case of off ground (variable onGround)
  if keypressed == "space" then
    return ACTION.UP
  elseif love.keyboard.isDown("right") then
    return ACTION.RIGHT
  elseif love.keyboard.isDown("left") then
    return ACTION.LEFT
  elseif love.keyboard.isDown("down") then
    return ACTION.DOWN
  end
  -- if love.keyboard.isDown("w") then
  --   makeNoise()
  -- end
end
function Avatar:handleScrolling()
  -- TODO: MOVE TO MAIN Class
  rightLim =  width*6/8
  leftLim = width/8
  if self.x > rightLim then
    self.scrolling = self.x- rightLim
    self.x = rightLim
  elseif self.x <leftLim then
      self.scrolling =  self.x-leftLim
      self.x = leftLim
  else
    self.scrolling = 0
  end
end


function Avatar:update(dt)
  self:move()
  self:handleScrolling()
  -- TODO: HANDLE other actions
end


-- function Avatar:render()
--   love.graphics.draw(giraffe, self.x, self.y - self.sizeY, 0, scaleX,scaleY)
--   -- love.graphics.draw(giraffe, 0, 0, 0, scaleX,scaleY)
--   -- love.graphics.draw(giraffe, self.x, self.y - self.sizeY, 0, scaleX,scaleY)
--
--   -- love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
--     -- love.graphics.rectangle('fill', self.x, self.y, 5, 20)
-- end
