------ Imports ------
require "States/Game/Figures/Enemy"
require 'States/Game/ObjectAttributes/Animation'
require "utils.ClassInit"
require "Settings"

Bird = declareClass(Enemy, Bird)

-- TODO: CHANGE animation frames.
local birdSize = { width = 444, height = 444 }
local top_left = love.graphics.newQuad(0, 0, birdSize.width, birdSize.height, Images['bird']:getDimensions())
local bottom_left = love.graphics.newQuad(birdSize.width, 0, birdSize.width, birdSize.height,
  Images['bird']:getDimensions())
local imageProperties = { img = Images['bird'], sizeX = 70, sizeY = 70, frames = { bottom_left, top_left }, fsizeX = 444, fsizeY = 444 }


function Bird:init(board, x, y)
  Enemy.init(self, board, x, y, 0, imageProperties, GameParameters.playerSpeed / 8)
  self.flyingAnim = Animation({ top_left, bottom_left }, 0.2)
end

function Bird:handleCollision(solidObj)
  if solidObj.collisionType == CollisionType.PLAYER then
    if self:checkCollision(solidObj) then
      solidObj:handleHarmCollision(self)
      Sounds['scaryNoise']:play()
    end
  end
end

function Bird:getAction()
  return ACTION.LEFT
end
