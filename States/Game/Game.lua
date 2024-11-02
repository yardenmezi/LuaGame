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
local STARTING_PT = { X = 20, Y = 1 }
local scoreColor = { 0, 0, 1 }

------ Game Definitions ------
local height = love.graphics.getHeight()
local width = love.graphics.getWidth()
local heightThreshold = (3 * height) / 4
local objectRange = (GameParameters.playerSpeed * 10)
local scorePosition = { 0, 1}

function Game:setGraphicsSetting()
  screenScroll = 0
  love.graphics.setColor(1, 1, 1)
end

function Game:setObjects()
  self.player = nil
  board = Board(width, height)
  self.player = Avatar(board, STARTING_PT.X, STARTING_PT.Y, g)
  for i=1, GameParameters.numBirds do
    self.collidableObjects[i] = Bird(board, width * i, (height*i/4), g)
  end
  self:setButterflies()
end

function Game:getRandomPosition(boundaries)
  local x = math.random(boundaries.xMin, boundaries.xMax)
  local y = math.random(boundaries.yMin, boundaries.yMax)
  return { x, y }
end

function Game:setButterflies()
  local butterflyBoundaries = {
    xMin = 200,
    xMax = objectRange,
    yMin = heightThreshold - 200,
    yMax = heightThreshold
  }
  local numLowButterflies = 20
  local numHighButterflies = 10
  for i = 1, numLowButterflies do
    local pos = self:getRandomPosition(butterflyBoundaries)
    self.collidableObjects[#self.collidableObjects + 1] = Butterfly(pos[1], pos[2], g, self.player)
    butterflyBoundaries.xMin = butterflyBoundaries.xMax
    butterflyBoundaries.xMax = butterflyBoundaries.xMax + objectRange
  end
  for j = 1, numHighButterflies do
    local pos = self:getRandomPosition({ xMin = 1, xMax = width * 30, yMin = 1, yMax = heightThreshold })
    self.collidableObjects[#self.collidableObjects + 1] = Butterfly(pos[1], pos[2], g, self.player)
  end
end

function Game:init()
  self.collidableObjects = {}
  self:setGraphicsSetting()
  self:setObjects()
  self.gameOverState = nil
  self.score = 0
  Sounds.gameMusic:play()
end

function Game:handlePlayerLost(dt)
  if self.gameOverState == nil then
    self:stop()
    self.gameOverState = GameOver()
  end
  self.gameOverState:update(dt)
end

function Game:updateObjects(dt,requestedFlight)
  local collisionType = self.player:update(dt)
  if collisionType[1] == CELL_TYPE.LEAF then
    Sounds['eat']:play()
    self.score = self.score + board:remove(collisionType)
  end
  board:update(dt)
  if requestedFlight then
    requestedFlight =  self.score>0
  end
  for i = 1, #self.collidableObjects do
    if self.collidableObjects[i]:update(dt,requestedFlight) then
      self.score = self.score-1
      keypressed = {}
    end
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
    local requestedFlight = false
    if keypressed == "q" then
      requestedFlight = true
      
    end
    self:updateObjects(dt, requestedFlight)
    screenScroll = self.player:getScrolling()

    skyScroll = (skyScroll + GameParameters.skyScrollSpeed) % BACKGROUND_LOOPING_POINT
  end
  
end

function Game:stop()
  Sounds.gameMusic:stop()
end

function Game:render()
  -- TODO: check how to change it to love.graphics.translate(-math.floor(screenScroll), 0)
  local cloudsScale = 0.3
  love.graphics.draw(Images.backround, -skyScroll, 0, 0, cloudsScale)
  board:render()

  for i = 1, #self.collidableObjects do
    self.collidableObjects[i]:render()
  end
  self.player:render()
  local scoreTxt = love.graphics.newText(Fonts['game'], {scoreColor, self.score })  
  love.graphics.draw(scoreTxt, scorePosition[1],scorePosition[1])
  if self.gameOverState then
    self.gameOverState:render()
  end
end
