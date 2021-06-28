
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
local coloredText = love.graphics.newText(titleFont, {{0.5, 1, 1}, "Giraffe Game"})
local instruction1 = love.graphics.newText(font, {{1, 1, 1}, "press arrows to move"})
local instruction2 = love.graphics.newText(font, {{1, 1, 1}, "press 'w' to jump"})
local instruction3 = love.graphics.newText(font, {{1, 1, 1}, "press 'q' to move butterfly (action takes coins)"})
local instruction4 = love.graphics.newText(font, {{1, 1, 1}, "press ENTER to start game!"})

--
-- function StartState.begin()
--   if start==nil then
--     return start()
--   end
--   return start
-- end
-- TODO: INTO A SINGLETONE
function StartState:init()
    startSound:play()
  -- print("logging")
end

function StartState:update(dt)
  -- print("lalaa")
  -- love.keyboard.isDown("right")
  if  keypressed == "return" then
      stateMachine:change('game')
  end
end

function StartState:stop()
  startSound:stop()

end

function StartState:render()
  love.graphics.draw(coloredText,50,50)
  love.graphics.draw(instruction1,50,120)
  love.graphics.draw(instruction2,50,150)
  love.graphics.draw(instruction3,50,180)
  love.graphics.draw(instruction4,50,250)
    -- love.graphics.printf('Press Enter', 0,100,100)
end
