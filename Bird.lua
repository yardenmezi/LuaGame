require "Enemy"
require "Animation"
require "ClassInit"
-- Bird = Class{}

local birdPic = love.graphics.newImage('images/bird.png')
local sounds = {['scaryNoise'] = love.audio.newSource('sounds/toodoom.wav', 'static')}
top_left = love.graphics.newQuad(0, 0,444,444, birdPic:getDimensions())
--
-- -- And here is bottom left:
bottom_left = love.graphics.newQuad(444,0,444,444, birdPic:getDimensions())
-- frames = {}
-- -- for i=1,3 do
-- --   frames[i] = love.graphics.newQuad(444*(i-1), 0,444,444, birdPic:getDimensions())
-- -- end
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

local imageProperties={img=birdPic,sizeX=70,sizeY=70,frames={bottom_left,top_left},fsizeX=444,fsizeY=444}


--[[
  Description: Bird constructor.
  Parms:
    - board: the board in which the instance placed.
    - x: the x position.
    - y: the y position
]]--
function Bird:init(board, x, y)
    Enemy.init(self,board,x, y, 0,imageProperties, SPEED/8)
    self.flyingAnim = Animation({top_left,bottom_left},0.2)
end


--[[
  Description: Bird constructor.
  Parms:
    - solidObj: a collidable object.
]]--
function Bird:handleCollision(solidObj)
  if solidObj.collisionType == collisionType.PLAYER then
    if self:checkCollision(solidObj) then
      solidObj:handleHarmCollision(self)
      sounds['scaryNoise']:play()
    end
  end
end


--[[
  Description: Handles the action of the instance.
  Returns: an action.
]]--
function Bird:getAction()
  return ACTION.LEFT
end
