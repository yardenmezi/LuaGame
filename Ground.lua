require "Still"
local grassImg = love.graphics.newImage('GreenGrass.png')

Ground = {}
Ground.__index = Ground
setmetatable(Ground, {
  __index = Still,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

function Ground:init(x, y,sizeX,sizeY)
  Still.init(self,x,y,sizeX,sizeY,grassImg)
  self.collisionType = collisionType.REGULAR
end
