require 'States/Game/ObjectAttributes/Animation'
require "Settings"

StartState = {}
StartState.__index = StartState

setmetatable(StartState, {
  __call = function(cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

start = nil
local animationSpeed = 0.3
local titleColor = { 0, 1, 0.9 }
local backroundColor = { 0.1, 0.2, 0.2 }
local instructionColor = { 1, 1, 1 }
local titlePos = { 50, 50 }
local title = love.graphics.newText(Fonts.title, { titleColor, Messages.startStateTitle })
local runningAvatarImage = Images.giraffe
local instructionsPos = { titlePos[1], titlePos[2] + 50 }
local spaceSize = 20
local imgPos = {200, 300}
local imgScale = {0.5,0.5}

-- TODO: INTO A SINGLETONE?
function StartState:init()
  StartSound:play()
  local animationFrames = {}
  local framesNum = 4
  for i = 1, framesNum do
    local imgWidth = runningAvatarImage:getWidth() / framesNum
    animationFrames[i - 1] = love.graphics.newQuad(imgWidth * (i - 1), 0, imgWidth, runningAvatarImage:getHeight(),
      runningAvatarImage:getDimensions())
  end
  self.anim = Animation(animationFrames, animationSpeed)
end

function StartState:update(dt)
  if keypressed == "return" then
    stateMachine:change('game')
  end
  self.anim:update(dt)
end

function StartState:stop()
  StartSound:stop()
end

function StartState:render()
  love.graphics.setBackgroundColor(backroundColor)
  love.graphics.draw(title, titlePos[1], titlePos[2])
  for i = 1, #Messages.gameInstructions do
    local instruction = love.graphics.newText(Fonts.instruction, { instructionColor, Messages.gameInstructions[i] })
    love.graphics.draw(instruction, instructionsPos[1], instructionsPos[2] + (i * spaceSize))
  end
  love.graphics.draw(runningAvatarImage, self.anim:getFrame(), imgPos[1],imgPos[2], 0, imgScale[1], imgScale[2])
end
