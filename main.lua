
------ Imports ------
Class = require 'class'
require 'Avatar'
require 'Wall'
require 'Still'
require 'Bird'
require 'Enemy'
require 'Coin'
require 'Butterfly'
require 'Figure'
require 'Worm'
------ Consts ------
SPEED = 5
g = 9.8
local BACKGROUND_LOOPING_POINT = 300
local skyScroll = 0
local NUM_COINS = 20
local NUM_PUDDLES = 20
keypressed = {}
------ Game Definitions ------
local sky = love.graphics.newImage('Sky.png')
-- local ground = love.graphics.newImage('grass.png')
love.window.setTitle('Grass And Sun ☼')
sounds = {['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')}
screenScroll = 0

function graphicsSetting()
  height = love.graphics.getHeight()
  width = love.graphics.getWidth()
  love.graphics.setNewFont(12)
  love.graphics.setColor(255, 255, 255)
  love.graphics.setBackgroundColor(0, 0, 0)
end

function puddlesPlacement(collidableObjects)
  local startX = width*(1/5)
  for i=1,NUM_PUDDLES do
    x = math.random(startX + (width/30) , startX + width/2)
    sizeX = math.random(width/7, width/2)
    sizeY = math.random(height/7, height/2)
    collidableObjects[#collidableObjects+1] = Still(x,450-sizeY,sizeX,sizeY)
    startX = x + sizeX
  end
end
function setObjects()
  collidableObjects = {}
  print(#collidableObjects)
  collidableObjects[#collidableObjects + 1] = Wall(0, height*(3/4), floorImg:getWidth(), 400)
  collidableObjects[#collidableObjects + 1] = Worm(500,400,g)
  collidableObjects[#collidableObjects + 1] = Bird(400,100,g)
  collidableObjects[#collidableObjects + 1] = Butterfly(40,350,g)
  puddlesPlacement(collidableObjects)
  player = Avatar(200, 20, g)
  coins = {}
  for i=1,NUM_COINS do
    coins[i] = Coin()
  end
end

function love.load()
  graphicsSetting()
  setObjects()
  sounds['wall_hit']:play()
end

function love.keypressed( key )
   if key == "escape" then
      love.event.quit()
   end
   keypressed = key
end

function love.update(dt)
  player:update(dt)
  for i=1,#collidableObjects do
    collidableObjects[i]:update(dt)
  end
  for i=1,NUM_COINS do
    coins[i]:update(dt)
  end
  skyScroll = (skyScroll + 0.1) % BACKGROUND_LOOPING_POINT
  -- screenScroll = screenScroll + player:getScrolling()
  screenScroll = player:getScrolling()
  for i=1,#collidableObjects do
    player:handleCollision(collidableObjects[i])
    collidableObjects[i]:handleCollision(player)
  end
  -- TODO: SHOULD HANDLE ALL Collidable OBJECTS COLLISIONS WITH EACH OTHER.
  -- TODO: problem is- the wall and the paddle are always colliding and etc, and paddles with each others..
  for k=1,#collidableObjects do
    for j=1,#collidableObjects do
      if j ~= k  then
        collidableObjects[k]:handleCollision(collidableObjects[j])
        -- collidableObjects[j]:handleCollision(collidableObjects[k])
      end
    end
  end

-- since during an iteration you can win only one coin, we can break the loop
-- gotCoin = false
  for i=1,NUM_COINS do
    player:handleCollision(coins[i])
    gotCoin = coins[i]:handleCollision(player)
  end


  -- for j=1,NUM_COINS do
  --   coins[j]:update(dt)
  --   -- if coins[j]:collides(player) then
  --   -- if coins[j].x == player.x then
  --     -- print(coins[j])
  --     -- table.remove(coins,j)
  --   -- end
  -- end

  -- for j,coin in pairs(coins) do
  -- for j=1,NUM_COINS do
    -- coins[j]:update(dt)
    -- print(coins[j])
    -- if coins[j]:collides(player) then
      -- print(coins[j])
      -- table.remove(coins,j)
    -- end
  -- end
  keypressed = {}
end


function love.draw()
  love.graphics.draw(sky, -skyScroll, 0)
  for i=1,#collidableObjects do
    collidableObjects[i]:render()
  end
  for i,coin in pairs(coins) do
    coin: render()
  end
  player: render()
end
