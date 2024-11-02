require "States/Game/Figures/Figure"

onGround  = false
Enemy = declareClass(Figure, Enemy)

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
