Puddle = Class{}
local puddleScroll = 0
local puddleImg = love.graphics.newImage('puddle.png')
function Puddle:init(x_init)
  self.x = math.random(x_init + (width/30) , x_init + width/2)
  self.y = wall.y
  self.size = math.random(width/20, width/10)
end

function Puddle:getPuddleEnd()
  return self.x + self.size
end

function Puddle:update(dt)
  -- if puddleScroll != screenScroll then

  -- end
  puddleScroll = (screenScroll)

  -- self.x = self.x - puddleScroll
end

function Puddle:render()
  love.graphics.draw(puddleImg, self.x - puddleScroll, self.y, 0, 0.02, 0.02)
  -- self.x = self.x - puddleScroll
  -- love.graphics.draw(puddleImg,self.x , self.y, 0, 0.03, 0.03)
  -- love.graphics.rectangle('fill', self.x - puddleScroll, self.y, self.size, 20)
end
