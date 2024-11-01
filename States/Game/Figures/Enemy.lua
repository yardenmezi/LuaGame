require "States/Game/Figures/Figure"

onGround  = false
Enemy  = {}

Enemy.__index = Enemy
setmetatable(Enemy, {
  __index = Figure,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

function Enemy:init(board,x, y,g,imageProperties,speed)
  Figure.init(self,board,x, y, g,imageProperties, speed)
  self.collisionType = collisionType.HARM
end

function Enemy:update(dt)
  Figure.update(self,dt)
  self.x = self.x - screenScroll
end

function Enemy:getAction()
  return ACTION.NO_MOVE
end
