Avatar = Class{}
local giraffe = love.graphics.newImage('giraffe.png')
local scaleX = 0.1
local scaleY = 0.1
local sounds = {['bark'] = love.audio.newSource('sounds/wall_hit.wav', 'static')}
onGround  = false

function Avatar:init(x, y)
    self.x = x
    self.y = y
    self.sizeY = giraffe:getHeight() * scaleY
    self.sizeX = giraffe:getWidth() * scaleX
    self.dx = 0
    self.dy = 0
    self.mass = 6
    self.scrolling = 0
end

function makeNoise()
  sounds['bark']:play()
end

function Avatar:collides(wall)
  if self.y < wall.y then
    onGround = false
    return false
  end
  onGround = true
  return true
end


function Avatar:getScrolling()
  return scrolling
end

function Avatar:update(dt)
  if keypressed == "space" and onGround == true then
    self.dy = -20 * SPEED
  end
  if love.keyboard.isDown("w") then
    makeNoise()
  end
   if love.keyboard.isDown("down") then
     self.dy = SPEED
   end
  if love.keyboard.isDown("left") then
    self.dx = -SPEED
  end
  if love.keyboard.isDown("right") then
    self.dx = SPEED
  end
  if (self.x < width/4 and self.dx>0) or (self.x > width/10 and self.dx<0) then
    self.x = self.x + self.dx
  else
    scrolling = self.dx
  end
  self.dy = self.dy + GRAVITY * dt * 10
  self.y = self.y + self.dy
  -- self.y = self.y + self.dy
  -- self.y = self.y - (giraffe:getHeight() * scaleY)
  self.dx = 0
  self.dy = 0
  -- print(x)
end


function Avatar:render()
  love.graphics.draw(giraffe, self.x, self.y - self.sizeY, 0, scaleX,scaleY)
  -- love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
    -- love.graphics.rectangle('fill', self.x, self.y, 5, 20)
end
