require "States/Game/ObjectAttributes/Still"
require 'States/Game/ObjectAttributes/Animation'

Butterfly = declareClass(Still, Butterfly)
TIME_TO_MOVE = 0.4


function Butterfly:init(x, y, g, player)
  local frames = getFramesFromImage(Images.butterfly, 3)
  local imageProperties = {
    img = Images.butterfly,
    sizeX = 60,
    sizeY = 60,
    frames = frames,
    fsizeX = image:getWidth() / 3,
    fsizeY =
        image:getHeight()
  }
  Still.init(self, x, y, imageProperties)
  self.player = player
  self.numOfSteps = -15
  self.collisionGap = 30
  self.flyingAnim = Animation(frames, 0.35)
  self.movingTime = 0
end

function Butterfly:handleFlightRequest()
  if self:checkCollision(self.player) then
    Sounds['bark']:play()
    -- if self.player:hasMadeNoise() then
    self.movingTime = TIME_TO_MOVE
    -- end
  end
end

function Butterfly:update(dt, request)
  local requestCompleted = false
  if self:checkCollision(self.player) and request then
    Sounds['bark']:play()
    requestCompleted = true    
    self.movingTime = TIME_TO_MOVE
  end
  self.flyingAnim:update(dt)
  self.movingTime = self.movingTime - dt
  if self.movingTime > 0 then
    if self.movingTime > TIME_TO_MOVE / 2 then
      self.y = self.y - 15
    else
      self.y = self.y + 15
    end
  elseif self.movingTime <= 0 then
    self.movingTime = 0
  end
  self.x = self.x - screenScroll
  return requestCompleted
end

function Butterfly:render()
  love.graphics.draw(self.img, self.flyingAnim:getFrame(), self.x, self.y, 0, self.scaleX, self.scaleY)
end
