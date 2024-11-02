require "States/Game/Figures/Figure"
require "Settings"
require "utils.ClassInit"


Avatar = declareClass(Figure, Avatar)

local frames = {}
for i = 1, 4 do
  image = Images['giraffe']
  frames[i] = love.graphics.newQuad(image:getWidth() / 4 * (i - 1), 0, image:getWidth() / 4, image:getHeight(),
    image:getDimensions())
end
local imageProperties = { img = image, sizeX = 100, sizeY = 150, frames = frames, fsizeX = image:getWidth() / 4, fsizeY =
image:getHeight() }

function Avatar:init(board, x, y, g)
  Figure.init(self, board, x, y, g, imageProperties, 15)
  self.dx = 0
  self.dy = 0
  self.gravityForce = 0.1 * g
  self.scrolling = 0
  self.collisionType = collisionType.PLAYER
  self.madeNoise = false
  self.isAlive = true
  self.timeOnAir = 0.2
  self.isJumping = true
end

function Avatar:makeNoise()
    Sounds['bark']:play()
end

function Avatar:checkAlive()
  return self.isAlive
end

function Avatar:hasMadeNoise()
  output = self.madeNoise
  self.madeNoise = false
  return output
end

function Avatar:getScrolling()
  return self.scrolling
end

function Avatar:getAction()
  -- TODO: handle the case of off ground (variable onGround)
  self.madeNoise = false
  if keypressed == "w" and self.onGround == true then
    if self.timeOnAir == 0.2 then
      Sounds['jump']:play()
      isJumping = true
    end
    return ACTION.UP
  end
  if love.keyboard.isDown("right") then
    return ACTION.RIGHT
  elseif love.keyboard.isDown("left") then
    return ACTION.LEFT
  elseif love.keyboard.isDown("down") then
    return ACTION.DOWN
  end
end

function Avatar:getLeftLim()
  return boardSize[1] / 3
end

function Avatar:handleScrolling()
  boardSize = board:getBoardSize()
  local rightLim = boardSize[1] / 3
  local leftLim = boardSize[1] / 8  
  if board:isOutOfLimits(self) then
    self.scrolling = 0
  else
    if self.x > rightLim then
      self.scrolling = self.x - rightLim
      self.x = rightLim
    elseif self.x < leftLim then
      self.scrolling = self.x - leftLim
      self.x = leftLim
    else
      self.scrolling = 0
    end
  end
end


function Avatar:update(dt)
  Figure.update(self, dt)
  self:handleScrolling()
  -- TODO: HANDLE other actions
  if self.y > 430 then
    self.isAlive = false
  end
    local collision = board:hasCollisionRange(self.x, self.y, self.sizeX, self.sizeY)
    if self.timeOnAir <= 0 then
      self.timeOnAir = 0.2
      keypressed = {}
      isJumping = false
    end
    if isJumping then
      self.timeOnAir = self.timeOnAir - dt
    end
    return collision
  end
