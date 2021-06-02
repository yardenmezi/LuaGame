require "Still"
local butterflyImg = love.graphics.newImage('images/butterfly.png')

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


function Butterfly:render()
  if self.isVisible then
    love.graphics.draw(self.img, self.x, self.y - 40, 0, self.scaleX, self.scaleY)
  end
end
