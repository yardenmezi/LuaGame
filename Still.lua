require "Collidable"
-- Puddle = Class{}
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

local puddleImg = love.graphics.newImage('images/tree.png')

-- -- TODO:THAT SHOULD BE A FACTORY.
-- function Still:init(x_init)
--   self.x = math.random(x_init + (width/30) , x_init + width/2)
--   -- TODO:change value!
--   self.y = 420
--   self.size = math.random(width/20, width/10)
--   self.img = puddleImg
--   Collidable.init(self, self.x,self.y,self.size,10)
-- end

function Still:init(x,y,sizeX,sizeY,img,width)

  self.img = img or puddleImg
  -- TODO: MAGIC NUMBER
  -- y = y or 420
  -- width = width or self.img:getWidth()
  self.scaleX = sizeX / width
  self.scaleY = sizeY / self.img:getHeight()
  -- TODO: HAVE COLLIDE X DIFFERS THEN THE REAL X AND Y.
  Collidable.init(self, x,y, sizeX, sizeY,{{0,0},{0,0}})

  self.isVisible = true
end
--
-- function Still:getPuddleEnd()
--   return self.x + self.size
-- end

function Still:update(dt)
    self.x = self.x - screenScroll
end

-- function Still:handleCollision(solidObj)
-- end


function Still:render()
  if self.isVisible then
    love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, self.scaleY)
  end
  -- self.x = self.x - puddleScroll
  -- love.graphics.draw(puddleImg,self.x , self.y, 0, 0.03, 0.03)
  -- love.graphics.rectangle('fill', self.x - puddleScroll, self.y, self.size, 20)
end
