require "States/Game/Figures/Figure"
require "Settings"

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
frames ={love.graphics.newQuad(0, 0,500,images['worm']:getHeight(), images['worm']:getDimensions())}

function Worm:init(board,x, y,g)
    Figure.init(self,board,x,y,g,images['worm'],70,70,frames,444,images['worm']:getHeight(),0)
    self.collisionType = collisionType.REGULAR
end


function Worm:getAction()
  return math.random(3, 5)
end
