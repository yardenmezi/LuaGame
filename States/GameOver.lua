GameOver ={}
GameOver.__index = GameOver
setmetatable(GameOver, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

local endSound = love.audio.newSource('sounds/lookAtMeNow.wav', 'static')
local titleFont = love.graphics.setNewFont(50)
local font = love.graphics.setNewFont(30)
local coloredText = love.graphics.newText(titleFont, {{1, 1, 1}, "GAME OVER"})
local wonText = love.graphics.newText(titleFont, {{1, 1, 0}, "You won the game!"})
local lostText = love.graphics.newText(titleFont, {{1, 1, 0}, "You won the game!"})
local instruction = love.graphics.newText(font, {{1, 1, 0}, "Press enter to play again"})

function GameOver:init(hasWon)
  self.hasWon = hasWon
  endSound:play()
end

function GameOver:update(hasWon)
  if  keypressed == "return" then
    endSound:stop()
    stateMachine:change('game')
  end
end

function GameOver:stop(hasWon)
    keypressed = {}
end

function GameOver:render(hasWon)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("fill", 100, 100, 500, 200 )
  love.graphics.setColor(1,0.5,1)
  love.graphics.draw(coloredText,200,130)
  love.graphics.draw(instruction,170,200)
end
