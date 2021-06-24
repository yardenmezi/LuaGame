
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
local font = love.graphics.setNewFont(50)
local coloredText = love.graphics.newText(font, {{0.5, 1, 1}, "Press Enter to start"})
--
-- function StartState.begin()
--   if start==nil then
--     return start()
--   end
--   return start
-- end
-- TODO: INTO A SINGLETONE
function StartState:init()
  -- print("logging")
end

function StartState:update(dt)
  -- print("lalaa")
  -- love.keyboard.isDown("right")
  if love.keyboard.isDown("return") then
      stateMachine:change('play')
  end
end
function StartState:stop()

end

function StartState:render()
  love.graphics.draw(coloredText,50,50)
    -- love.graphics.printf('Press Enter', 0,100,100)
end
