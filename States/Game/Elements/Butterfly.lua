require "States/Game/ObjectAttributes/Still"
require 'States/Game/ObjectAttributes/Animation'
-- Butterfly = {}
-- inherit(Butterfly, Still)
Butterfly = {}
Butterfly.__index = Butterfly
setmetatable(Butterfly, {
  __index = Still,
  __call = function(cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

frames = {}
for i = 1, 3 do
  image = images['butterfly']
  frames[i] = love.graphics.newQuad(image:getWidth() / 3 * (i - 1), 0, image:getWidth() / 3, image:getHeight(),
    image:getDimensions())
end
local imageProperties = { img = image, sizeX = 60, sizeY = 60, frames = frames, fsizeX = image:getWidth() / 3, fsizeY =
image:getHeight() }

TIME_TO_MOVE = 0.4


function Butterfly:init(x, y, g, player)
  Still.init(self, x, y, imageProperties)
  self.player = player
  self.numOfSteps = -15
  self.collisionGap = 30
  self.flyingAnim = Animation(frames, 0.35)
  self.movingTime = 0
end

function Butterfly:update(dt)
  self.flyingAnim:update(dt)
  if self:checkCollision(self.player) then
    if self.player:hasMadeNoise() then
      self.movingTime = TIME_TO_MOVE
    end
  end
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
end

function Butterfly:render()
  love.graphics.draw(self.img, self.flyingAnim:getFrame(), self.x, self.y, 0, self.scaleX, self.scaleY)
end
