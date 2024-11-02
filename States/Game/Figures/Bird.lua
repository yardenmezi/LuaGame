------ Imports ------
require "States/Game/Figures/Enemy"
require 'States/Game/ObjectAttributes/Animation'
require "utils.ClassInit"
require "Settings"

Bird  = {}
Bird.__index = Bird
setmetatable(Bird, {
  __index = Enemy,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})
-- TODO: CHANGE animation frames.
birdSize = {width = 444,height = 444}
top_left = love.graphics.newQuad(0, 0,birdSize.width,birdSize.height, images['bird']:getDimensions())
bottom_left = love.graphics.newQuad(birdSize.width,0,birdSize.width,birdSize.height, images['bird']:getDimensions())
local imageProperties={img=images['bird'],sizeX=70,sizeY=70,frames={bottom_left,top_left},fsizeX=444,fsizeY=444}


function Bird:init(board, x, y)
    Enemy.init(self,board,x, y, 0, imageProperties, gameParameters.playerSpeed/8)
    self.flyingAnim = Animation({top_left,bottom_left},0.2)
end

function Bird:handleCollision(solidObj)
  if solidObj.collisionType == collisionType.PLAYER then
    if self:checkCollision(solidObj) then
      solidObj:handleHarmCollision(self)
      sounds['scaryNoise']:play()
    end
  end
end

function Bird:getAction()
  return ACTION.LEFT
end
