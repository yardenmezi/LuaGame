Game = {}
Game.__index = Game
setmetatable(Game, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})
------ Imports ------
Class = require 'class'
require 'States/Game/Figures/Avatar'
require 'States/Game/Figures/Bird'
require 'States/Game/Figures/Butterfly'
require 'States/Game/Figures/Worm'
require "States/Game/ObjectAttributes/Still"
require 'Board'

require "States/GameOver"
require "Settings"
------ Consts ------
SPEED = 20
g = 9.8
local BACKGROUND_LOOPING_POINT = 300
local skyScroll = 0
local NUM_COINS = 20
local NUM_PUDDLES = 20
local START_POS_X = 200
local START_POS_Y = 20

------ Game Definitions ------
local height = love.graphics.getHeight()
local width = love.graphics.getWidth()

function Game:graphicsSetting()
  screenScroll = 0
  font = love.graphics.setNewFont(40)
end

function Game:setObjects()
  board = Board(width,height)
  self.player = Avatar(board,START_POS_X, START_POS_Y, g)
  self.collidableObjects[#self.collidableObjects + 1] = Bird(board,700,100,g)
  self.collidableObjects[#self.collidableObjects + 1] = Bird(board,1500,200,g)
  self.collidableObjects[#self.collidableObjects + 1] = Bird(board,2500,150,g)
  self:setButterflies()
end

function Game:setButterflies()
  startX = 40
  x = 40
  y=height/2
  for i=1,20 do
    x = math.random(x ,x+SPEED*10)
    y = math.random(3*height/4,2*height/3-200)
    self.collidableObjects[#self.collidableObjects + 1] = Butterfly(x,y,g,self.player)
    x= x + SPEED * 10
  end

  for j=1,10 do
    x = math.random(1 ,width*20)
    y = math.random(1,3*height/4-200)
    self.collidableObjects[#self.collidableObjects + 1] = Butterfly(x,y,g,self.player)
  end
end


function Game:init()
  self.collidableObjects = {}
  self.player = nil
  self:graphicsSetting()
  self:setObjects()
  self.gameOverState = nil
  sounds['gameMusic']:play()
  love.graphics.setColor(1,1,1)
end


function Game:update(dt)
  -- Updating all collidable objects --
  if not self.player:checkAlive() then
    if self.gameOverState == nil then
      self:stop()
      self.gameOverState = GameOver()
    end
    self.gameOverState:update(dt)
    -- love.event.clear()
    -- love.event.quit()
  else
    self.player:update(dt)
    board:update(dt)
    screenScroll = self.player:getScrolling()
    for i=1,#self.collidableObjects do
      self.collidableObjects[i]:update(dt)
    end

    skyScroll = (skyScroll + 0.1) % BACKGROUND_LOOPING_POINT
    for i=1,#self.collidableObjects do
      self.player:handleCollision(self.collidableObjects[i])
      self.collidableObjects[i]:handleCollision(self.player)
    end
  end
end


function Game:stop()
  sounds['gameMusic']:stop()
end



function Game:render()
  -- TODO: check how to change it to love.graphics.translate(-math.floor(screenScroll), 0)
  love.graphics.draw(images['backround'], -skyScroll, 0,0,0.255)
  board:render()
  for i=1,#self.collidableObjects do
    self.collidableObjects[i]:render()
  end
  self.player: render()
  coloredText = love.graphics.newText(font, {{0, 0, 1}, self.player.score})
  love.graphics.draw(coloredText,0,height-40)
  if self.gameOverState then
     self.gameOverState:render()
  end
end
