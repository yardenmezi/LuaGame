require "Figure"
-- Worm = Class{}
local wormImg = love.graphics.newImage('worm.png')
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
function Worm:init(x, y,g)
    Figure.init(self,x,y,g,wormImg,30,30)
end

function Worm:getAction()
  return math.random(3, 5)
end
