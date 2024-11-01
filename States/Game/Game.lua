Game = {}
Game.__index = Game
setmetatable(Game, {
  __call = function(cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})
------ Imports ------
require 'States/Game/Figures/Avatar'
require 'States/Game/Figures/Bird'
require 'States/Game/Figures/Worm'
require 'States.Game.Elements.Butterfly'
require "States/Game/ObjectAttributes/Still"
require 'States.Game.Board'

require "States/GameOver"
require "Settings"
------ Consts ------
SPEED = 20
g = 9.8
local BACKGROUND_LOOPING_POINT = 300
local skyScroll = 0
local STARTING_PT = { X = 200, Y = 20 }

------ Game Definitions ------
local height = love.graphics.getHeight()
local width = love.graphics.getWidth()
local heightThreshold = 3 * height / 4
local objectRange = (SPEED * 10)
local butterflyBoundaries = {
  xMin = 40,
  xMax = objectRange,
  yMin = heightThreshold - 200,
  yMax = heightThreshold
}
function Game:setGraphicsSetting()
  screenScroll = 0
  love.graphics.setColor(1, 1, 1)
end

function Game:setObjects()
  self.player = nil
  board = Board(width, height)
  self.player = Avatar(board, STARTING_PT.X, STARTING_PT.Y, g)
  local birdPositions = { { x = 700, y = 100 }, { x = 1500, y = 200 }, { x = 2500, y = 150 } }
  for i = 1, #birdPositions do
    self.collidableObjects[i] = Bird(board, birdPositions[i].x, birdPositions[i].y, g)
  end
  self:setButterflies()
end

function Game:getRandomPosition(boundaries)
  local x = math.random(boundaries.xMin, boundaries.xMax)
  local y = math.random(boundaries.yMin, boundaries.yMax)
  return { x, y }
end

function Game:setButterflies()
  local numLowButterflies = 50
  local numHighButterflies = 100
  for i = 1, numLowButterflies do
    local pos = self:getRandomPosition(butterflyBoundaries)
    self.collidableObjects[#self.collidableObjects + 1] = Butterfly(pos[1], pos[2], g, self.player)
    butterflyBoundaries.xMin = butterflyBoundaries.xMax
    butterflyBoundaries.xMax = butterflyBoundaries.xMax + objectRange
  end
  for j = 1, numHighButterflies do
    local pos = self:getRandomPosition({ xMin = 1, xMax = width * 20, yMin = 1, yMax = heightThreshold - 200 })
    self.collidableObjects[#self.collidableObjects + 1] = Butterfly(pos[1], pos[2], g, self.player)
  end
end

function Game:init()
  self.collidableObjects = {}
  self:setGraphicsSetting()
  self:setObjects()
  self.gameOverState = nil
  sounds.gameMusic:play()
end

function Game:handlePlayerLost(dt)
  if self.gameOverState == nil then
    self:stop()
    self.gameOverState = GameOver()
  end
  self.gameOverState:update(dt)
end

function Game:updateObjects(dt)
  self.player:update(dt)
  board:update(dt)

  for i = 1, #self.collidableObjects do
    self.collidableObjects[i]:update(dt)
  end

  for i = 1, #self.collidableObjects do
    self.player:handleCollision(self.collidableObjects[i])
    self.collidableObjects[i]:handleCollision(self.player)
  end
end

function Game:update(dt)
  -- Updating all collidable objects --
  if not self.player:checkAlive() then
    self:handlePlayerLost(dt)
  else
    self:updateObjects(dt)
    screenScroll = self.player:getScrolling()
    skyScroll = (skyScroll + 0.1) % BACKGROUND_LOOPING_POINT
  end
end

function Game:stop()
  sounds.gameMusic:stop()
end

function Game:render()
  -- TODO: check how to change it to love.graphics.translate(-math.floor(screenScroll), 0)
  love.graphics.draw(images.backround, -skyScroll, 0, 0, 0.255)
  board:render()

  for i = 1, #self.collidableObjects do
    self.collidableObjects[i]:render()
  end
  self.player:render()
  local coloredText = love.graphics.newText(fonts['game'], { { 0, 0, 1 }, self.player.score })
  love.graphics.draw(coloredText, 0, height - 40)
  if self.gameOverState then
    self.gameOverState:render()
  end
end
