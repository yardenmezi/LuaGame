-- Wall = Class{}
require 'Collidable'
floorImg = love.graphics.newImage('images/GreenGrass.png')
local scaleX = 0.1
local scaleX = 0.2
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

function Wall:init(x,y,sizeX,sizeY)
  -- TODO: Currently the size means nothing. the real size of the picture is defined by the image size.
  -- TODO: NEED FUNCTION WHO DEFINES THE RIGHT SIZE
  self.scaleY = sizeY/floorImg:getHeight()
  Collidable.init(self, x, y ,sizeX, sizeY)
  self.collisionType = collisionType.BLOCK
end

function Wall:handleCollision(solidObj)

end

function Wall:render()
  -- love.graphics.draw(ground, 0, self.y + 30)
    -- love.graphics.draw(ground, -player.scrolling, 0)
    -- love.graphics.draw(giraffe, self.x, self.y - self.sizeY, 0, scaleX,scaleY)
    love.graphics.draw(floorImg, self.x, self.y,0,1,self.scaleY)
    -- love.graphics.draw(floorImg, self.x, self.y,0, scaleX,scaleY)
  -- love.graphics.line(self.x, self.y, self.x + self.size, self.y)
end
