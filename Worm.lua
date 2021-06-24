require "Figure"
-- Worm = Class{}
local wormImg = love.graphics.newImage('images/wormFrames.png')
local sounds = {['bark'] = love.audio.newSource('sounds/wall_hit.wav', 'static')}
onGround  = false

Worm = {}
Worm.__index = Worm
setmetatable(Worm, {
  __index = Figure,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

local frames = {}
frames ={love.graphics.newQuad(0, 0,500,wormImg:getHeight(), wormImg:getDimensions())}
-- for i=1 do
--   frames ={love.graphics.newQuad(500*(i-1), 0,500,wormImg:getHeight(), wormImg:getDimensions())}
-- end

function Worm:init(board,x, y,g)
  -- (board,x, y, g, img, sizeX,sizeY,frames,frameSizeX,frameSizeY,speed)
    Figure.init(self,board,x,y,g,wormImg,70,70,frames,444,wormImg:getHeight(),0)
    self.collisionType = collisionType.REGULAR
end

-- function Worm:handleCollision(board,x, y,g)
--   -- (board,x, y, g, img, sizeX,sizeY,frames,frameSizeX,frameSizeY,speed)
-- end
function Worm:getAction()
  return math.random(3, 5)
end
