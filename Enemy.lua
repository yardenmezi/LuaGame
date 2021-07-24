
require "Figure"
Enemy = Class{}

local enemyPic = love.graphics.newImage('images/goast.png')
local sounds = {['bark'] = love.audio.newSource('sounds/wall_hit.wav', 'static')}
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

function Enemy:init(board,x, y,g,img,imageProperties,speed)
  Figure.init(self,board,x, y, g,img,imageProperties,speed)
  self.gravityForce = 0.1 * g
  self.collisionType = collisionType.HARM
end

function Enemy:update(dt)
  Figure.update(self,dt)
  self.x = self.x - screenScroll

end
function Enemy:getAction()
  return ACTION.NO_MOVE
end
