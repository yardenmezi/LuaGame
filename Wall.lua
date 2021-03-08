-- Wall = Class{}
require 'Collidable'
-- Figure = Class{}
-- TODO: HANDLE THE LOCAL!!!! IN Figure = {}
Wall  = {}
Wall.__index = Wall
setmetatable(Wall , {
  __index = Collidable,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

function Wall:init(x,y,size)
  Collidable.init(self,x,y,size,size)
  -- self.x = x
  -- self.y = y
  self.size = size
end
function Wall:update(dt)
end

function Wall:render()
  -- love.graphics.draw(ground, 0, self.y + 30)
    -- love.graphics.draw(ground, -player.scrolling, 0)
  love.graphics.line(self.x, self.y, self.x + self.size, self.y)
end
