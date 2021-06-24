--[[
Desctription:
The file represents the Game class.

]]--
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
require 'Avatar'
require 'Still'
require 'Bird'
require 'Board'
require 'Coin'
require 'Butterfly'
require 'Worm'
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
coinsTaken = 0
local sky = love.graphics.newImage('images/clouds.png')
sounds = {['music'] = love.audio.newSource('sounds/backround_music.mp3', 'static')}




function Game:graphicsSetting()
  screenScroll = 0
  love.graphics.setNewFont(12)
  love.graphics.setColor(255, 255, 255)
  love.graphics.setBackgroundColor(0, 0, 0)
  font = love.graphics.setNewFont(40)
  height = love.graphics.getHeight()
  width = love.graphics.getWidth()
  -- coloredText = love.graphics.newText(font, {{0, 0, 1}, coinsTaken, {0, 0, 1}, " world"})
end

function Game:setButterflies()
  startX = 40
  x = 40
  y=height/2
  for i=1,20 do
    while board:hasCollisionRange(x,y,SPEED*10,400) do
      x = x+SPEED
    end
    x = math.random(x ,x+SPEED*10)
    y = math.random(3*height/4,2*height/3)
    self.collidableObjects[#self.collidableObjects + 1] = Butterfly(x,y,g,player)
    x= x + SPEED * 10
  end

  for j=1,10 do
    x = math.random(1 ,width*20)
    y = math.random(1,3*height/4)
    self.collidableObjects[#self.collidableObjects + 1] = Butterfly(x,y,g,player)
  end
end

function Game:init()
  self.collidableObjects = {}
  self:graphicsSetting()
  self:setObjects()
  self.coinsTaken = 0

  sounds['music']:play()
end

function Game:setObjects()
  board = Board(width,height)
  player = Avatar(board,START_POS_X, START_POS_Y, g)
  self.collidableObjects[#self.collidableObjects + 1] = Bird(board,700,100,g)
    -- collidableObjects[#collidableObjects + 1] = Worm(board,700,100,g)
  self:setButterflies()
  coins = {}
  for i=1,NUM_COINS do
    coins[i] = Coin()
  end
end


-- function love.keypressed( key )
--    if key == "escape" then
--       love.event.quit()
--    end
--    keypressed = key
-- end

function Game:update(dt)
  -- Updating all collidable objects --
  player:update(dt)
  screenScroll = player:getScrolling()
  board:update(dt)
  for i=1,#self.collidableObjects do
    self.collidableObjects[i]:update(dt)
  end
  for i=1,NUM_COINS do
    coins[i]:update(dt)

  end
  skyScroll = (skyScroll + 0.1) % BACKGROUND_LOOPING_POINT
  for i=1,#self.collidableObjects do
    player:handleCollision(self.collidableObjects[i])
    self.collidableObjects[i]:handleCollision(player)
  end

  for i=1,NUM_COINS do
    player:handleCollision(coins[i])
    gotCoin = coins[i]:handleCollision(player)
    self.coinsTaken = self.coinsTaken + gotCoin
  end

  if not player.isAlive then
    -- love.event.clear()
    love.event.quit()
  end
end
function Game:stop()
  sounds['music']:stop()
end

function Game:render()
  -- TODO: change to love.graphics.translate(-math.floor(screenScroll), 0)
  love.graphics.draw(sky, -skyScroll, 0,0,0.255)
  -- Render all objects
  board:render()
  for i=1,#self.collidableObjects do
    self.collidableObjects[i]:render()
  end
  for i,coin in pairs(coins) do
    coin: render()
  end
  player: render()
  coloredText = love.graphics.newText(font, {{0, 0, 1}, coinsTaken})
  love.graphics.draw(coloredText,0,height-40)
end
