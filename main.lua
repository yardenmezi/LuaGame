
------ Imports ------
Class = require 'class'
require 'Avatar'
require 'Wall'
require 'Puddle'
require 'Coin'
require 'Figure'
------ Consts ------
SPEED = 5
g = 9.8
local BACKGROUND_LOOPING_POINT = 300
local skyScroll = 0
local NUM_COINS = 4
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

function setObjects()
  collidableObjects = {}
  print(#collidableObjects)
  collidableObjects[#collidableObjects + 1] = Wall(0, height*(3/4), floorImg:getWidth(), 20)
  collidableObjects[#collidableObjects + 1] = Figure(100,100,g)
  -- TODO: INSERT PADDLES
  local startX = width*(1/5)
  for i=1,NUM_PUDDLES do
    if i>1 then
      startX  = collidableObjects[#collidableObjects]:getPuddleEnd()
    end
     collidableObjects[#collidableObjects+1] = Puddle(startX)
  end
  player = Avatar(200, 20, g)
  -- coins = {}
  -- for i=1,NUM_COINS do
  --   coins[i] = Coin()
  -- end
end

function love.load()
  graphicsSetting()
  setObjects()
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
  skyScroll = (skyScroll + 0.1) % BACKGROUND_LOOPING_POINT
  screenScroll = screenScroll + player:getScrolling()
  for i=1,#collidableObjects do
    player:handleCollision(collidableObjects[i])
    collidableObjects[i]:handleCollision(player)
  end
  -- TODO: SHOULD HANDLE ALL Collidable OBJECTS COLLISIONS WITH EACH OTHER.
  -- TODO: problem is- the wall and the paddle are always colliding and etc, and paddles with each others..
  -- for k=1,#collidableObjects do
  --   for j=1,#collidableObjects do
  --     collidableObjects[k]:handleCollision(collidableObjects[j])
  --     collidableObjects[j]:handleCollision(collidableObjects[k])
  --   end
  -- end

-- issue: NUM_COINS is smaller after delete
  -- for i=NUM_COINS,1,-1 do
  --   coins[i]:update(dt)
  --   if coins[i]:collides(player) then
  --       table.remove(coins, i)
  --   end
  -- end


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
  -- for i,coin in pairs(coins) do
  --   coin: render()
  -- end
  player: render()
end
