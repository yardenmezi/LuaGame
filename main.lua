
------ Imports ------
Class = require 'class'
require 'Avatar'
require 'Wall'
require 'Puddle'
require 'Coin'
require 'Figure'
------ Consts ------
SPEED = 5
GRAVITY = 9.8
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
  local startX = width*(1/5)
  fig = Figure(100,100)
  wall = Wall(0, height*(3/4),width)
  player = Avatar(200, 20)
  puddles = {}
  for i=1,NUM_PUDDLES do
    if i>1 then
      startX  = puddles[i-1]:getPuddleEnd()
    end
    puddles[i] = Puddle(startX)
  end
  coins = {}
  for i=1,NUM_COINS do
    coins[i] = Coin()
  end
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
  skyScroll = (skyScroll + 0.1) % BACKGROUND_LOOPING_POINT

  -- player.dy = player.dy + (player.mass * G)
  player:handleCollision(wall)
  -- if(player:collides(wall)) then
    -- player.y = wall.y
    -- sounds['wall_hit']:play()
  -- end

  player:update(dt)
  screenScroll = screenScroll + player:getScrolling()
  fig:update()
  for i=1, NUM_PUDDLES do
    puddles[i]:update(dt)
  end

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

  wall: render()
  for i=1,NUM_PUDDLES do
    puddles[i]: render()
  end
  -- for i,coin in pairs(coins) do
  --   coin: render()
  -- end
  player: render()
  fig:render()
end
