
require "Animation"
StartState ={}
StartState.__index = StartState
setmetatable(StartState, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})
start = nil
local startSound = love.audio.newSource('sounds/birdTutorial.mp3', 'static')
local titleFont = love.graphics.setNewFont(50)
local font = love.graphics.setNewFont(20)
-- title
local coloredText = love.graphics.newText(titleFont, {{0, 1, 0.9}, "Welcome!"})
local instruction1 = love.graphics.newText(font, {{1, 1, 1}, "Press arrows to move"})
local instruction2 = love.graphics.newText(font, {{1, 1, 1}, "Press 'w' to jump"})
local instruction3 = love.graphics.newText(font, {{1, 1, 1}, "Press 'q' to move butterfly when your'e on it (action takes a leaf)"})
local instruction4= love.graphics.newText(font, {{1, 1, 1}, "Beware of birds!"})
local instruction5 = love.graphics.newText(font, {{1, 1, 1}, "Press ENTER to start game!"})

--
-- function StartState.begin()
--   if start==nil then
--     return start()
--   end
--   return start
-- end
local gifi = love.graphics.newImage('images/tmpGiff.png')
-- local gifi = love.graphics.newImage('images/gifisprite.png')

local frames = {}
for i=1,4 do
  frames[i-1] = love.graphics.newQuad(gifi:getWidth()/4*(i-1), 0,gifi:getWidth()/4,gifi:getHeight(), gifi:getDimensions())
end

-- TODO: INTO A SINGLETONE
function StartState:init()
    startSound:play()
    self.anim = Animation(frames,0.3)
  -- print("logging")
end

function StartState:update(dt)
  -- print("lalaa")
  -- love.keyboard.isDown("right")
  if  keypressed == "return" then
      stateMachine:change('game')
  end
  self.anim:update(dt)
end

function StartState:stop()
  startSound:stop()
  keypressed = {}
end

function StartState:render()
love.graphics.setBackgroundColor( 0.1, 0.2, 0.2)
  love.graphics.draw(coloredText,50,50)
  love.graphics.draw(instruction1,50,120)
  love.graphics.draw(instruction2,50,150)
  love.graphics.draw(instruction3,50,180)
  love.graphics.draw(instruction4,50,210)
  love.graphics.draw(instruction5,50,250)
  love.graphics.draw(gifi, self.anim:getFrame(), 200,300, 0, 0.5,0.5)
    -- love.graphics.printf('Press Enter', 0,100,100)
end
