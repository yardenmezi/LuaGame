
require "Figure"
Avatar = Class{}
local giraffe = love.graphics.newImage('images/gifisprite.png')
local sounds = {['bark'] = love.audio.newSource('sounds/bark.wav', 'static'),
['jump'] = love.audio.newSource('sounds/woop.wav', 'static'), ['eat'] = love.audio.newSource('sounds/leaf.wav', 'static')}
onGround  = false

Avatar = {}
Avatar.__index = Avatar
setmetatable(Avatar, {
  __index = Figure,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})


local frames = {}
for i=1,3 do
  frames[i] = love.graphics.newQuad(444*(i-1), 0,444,giraffe:getHeight(), giraffe:getDimensions())
end

function Avatar:init(board,x, y,g)
    Figure.init(self,board,x,y,g,giraffe,200,80,frames,444,giraffe:getHeight())
    self.dx = 0
    self.dy = 0
    self.gravityForce = 0.1 * g
    self.scrolling = 0
    self.collisionType = collisionType.PLAYER
    self.madeNoise = false
    self.isAlive = true
    self.score = 0

    -- self.walking = Animation(frames,0.2)

end

function Avatar:makeNoise()
  if self.score >0 then
    -- self.board:takePower()
    sounds['bark']:play()
    self.madeNoise = true
    self.score = self.score -1
  end
end

function Avatar:hasMadeNoise()
  output = self.madeNoise
  self.madeNoise = false
  return output
end

function Avatar:getScrolling()
  return self.scrolling
end

function Avatar:getAction()
  -- TODO: handle the case of off ground (variable onGround)
  self.madeNoise = false
  if keypressed == "w" then
    sounds['jump']:play()
    return ACTION.UP
  elseif love.keyboard.isDown("right") then
    return ACTION.RIGHT
  elseif love.keyboard.isDown("left") then
    return ACTION.LEFT
  elseif love.keyboard.isDown("down") then
    return ACTION.DOWN
  end
  if keypressed == "q" then
    self:makeNoise()
  end
end

function Avatar:handleScrolling()
  -- TODO: MOVE TO MAIN Class?
  rightLim =  width/3
  leftLim = width/8
  if self.x > rightLim then
    self.scrolling = self.x- rightLim
    self.x = rightLim
  elseif self.x <leftLim then
    self.scrolling =  self.x-leftLim
    self.x = leftLim
    -- if not board:inBoardLimit(self.x-leftLim) then
    -- end
  else
    self.scrolling = 0
  end
  if board:inBoardLimit(self.scrolling) then
    self.scrolling = 0
  end
end

function Avatar:update(dt)
  -- self:move()
  -- self.walking:update(dt)
  -- super:
  Figure.update(self,dt)
  self:handleScrolling()
  -- TODO: HANDLE other actions
  -- TODO: CHANGE TO changeble val
  if self.y > 515 then
    self.isAlive = false
  else
    colType = board:hasCollisionRange(self.x,self.y,self.sizeX,self.sizeY)
    if colType[1] == cell.WORM then
      -- TODO: CHANGE TO WON STATE/GAME OVER STATE
      stateMachine:change('first')
    elseif colType[1] == cell.LEAF then
      self.score = self.score + self.board:remove(colType)
      sounds['eat']:play()
    end

    -- stateMachine.change('game')
  end
end


function Avatar:isAlive()
  return self.isAlive
end

-- function Avatar:render()
--   -- love.graphics.draw(birdPic,self.flyingAnim:getFrame(), self.x, self.y,0, self.scaleX,self.scaleY)
--   love.graphics.draw(self.img,self.walking:getFrame(), self.x, self.y, 0, 1, 1)
--   -- love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
--     -- love.graphics.rectangle('fill', self.x, self.y, 5, 20)
-- end


-- function Avatar:render()
--   love.graphics.draw(giraffe, self.x, self.y - self.sizeY, 0, scaleX,scaleY)
--   -- love.graphics.draw(giraffe, 0, 0, 0, scaleX,scaleY)
--   -- love.graphics.draw(giraffe, self.x, self.y - self.sizeY, 0, scaleX,scaleY)
--
--   -- love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)
--     -- love.graphics.rectangle('fill', self.x, self.y, 5, 20)
-- end
