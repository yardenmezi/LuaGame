require "Still"
local butterflyImg = love.graphics.newImage('butterfly.png')

Butterfly = {}
Butterfly.__index = Butterfly
setmetatable(Butterfly, {
  __index = Still,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

function Butterfly:init(x, y,g)
  -- fakeX = x-
  Still.init(self,x,y,60,60,butterflyImg)
end
