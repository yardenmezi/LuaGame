require 'States/Game/ObjectAttributes/Animation'
require "Settings"

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
-- local startSound = love.audio.newSource('sounds/birdTutorial.mp3', 'static')
local titleFont = love.graphics.setNewFont(50)
local font = love.graphics.setNewFont(20)
-- title
local title = love.graphics.newText(titleFont, {{0, 1, 0.9}, "Welcome!"})

local instructions = {
  "Press arrows to move", "Press 'w' to jump", "Press 'q' to move butterfly when your'e on it (action takes a leaf)", "Beware of birds!", "Press ENTER to start game!"
}

local gifi = love.graphics.newImage('images/tmpGiff.png')

local frames = {}
for i=1,4 do
  frames[i-1] = love.graphics.newQuad(gifi:getWidth()/4*(i-1), 0, gifi:getWidth()/4,gifi:getHeight(), gifi:getDimensions())
end

-- TODO: INTO A SINGLETONE?
function StartState:init()
    startSound:play()
    self.anim = Animation(frames,0.3)
end

function StartState:update(dt)
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
  love.graphics.draw(title,50,50)
  for i=1,#instructions do
    instruction = love.graphics.newText(font, {{1, 1, 1}, instructions[i]})
    love.graphics.draw(instruction,50,100+(i*20))
  end
  love.graphics.draw(gifi, self.anim:getFrame(), 200,300, 0, 0.5,0.5)
end
