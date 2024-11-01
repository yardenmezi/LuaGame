require 'States/Game/ObjectAttributes/Collidable'

Still = {}
Still.__index = Still
setmetatable(Still, {
  __index = Collidable,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

function Still:init(x, y, imageProperties)
  self.img = imageProperties.img
  self.scaleX = imageProperties.sizeX / imageProperties.fsizeX
  self.scaleY = imageProperties.sizeY / imageProperties.fsizeY
  -- TODO: HAVE COLLIDE X DIFFERS THEN THE REAL X AND Y.
  Collidable.init(self, x,y, imageProperties.sizeX, imageProperties.sizeY,{x=5,y=14},{x=-4,y=0})
end

function Still:update(dt)
    self.x = self.x - screenScroll
end


function Still:render()
  love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, self.scaleY)
end
