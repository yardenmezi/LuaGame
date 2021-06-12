
------ Imports ------
Class = require 'class'
require 'Avatar'
-- require 'Wall'
require 'Still'
require 'Bird'
-- require 'Ground'
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
keypressed = {}
------ Game Definitions ------
-- local coinsTaken = 0
coinsTaken = 0
local sky = love.graphics.newImage('images/clouds.png')
-- local ground = love.graphics.newImage('grass.png')
love.window.setTitle('Grass And Sun ☼')
sounds = {['music'] = love.audio.newSource('sounds/backround_music.mp3', 'static')}
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
    x = math.random(startX + (width/3) , startX + width*3)
    sizeX = math.random(width/7, width/2)
    sizeY = math.random(height/3, height/2)
    collidableObjects[#collidableObjects+1] = Still(x,560-sizeY,sizeX,sizeY)
    startX = x + sizeX
  end
end

function setObjects()
  board = Board(40,height)
  collidableObjects = {}
  print(#collidableObjects)
  -- collidableObjects[#collidableObjects + 1] = Worm(board,700,100,g)
  collidableObjects[#collidableObjects + 1] = Bird(board,700,100,g)
  startX = 40
  -- puddlesPlacement(collidableObjects)
  player = Avatar(board,200, 20, g)
  x =40
  y=height/2
  for i=1,20 do
    -- // half of the butterflies only randomize places in which there
    while board:hasCollisionRange(x,y,SPEED*10,400) do
      x = x+SPEED
    end
    x = math.random(x ,x+SPEED*10)
    -- y = math.random(height/2,2*height/3)
    y = math.random(3*height/4,2*height/3)
    collidableObjects[#collidableObjects + 1] = Butterfly(x,y,g,player)
    x= x+SPEED*10
  end

  for j=1,10 do
    x = math.random(1 ,width*20)
    y = math.random(1,3*height/4)
    collidableObjects[#collidableObjects + 1] = Butterfly(x,y,g,player)
  end
  coins = {}
  for i=1,NUM_COINS do
    coins[i] = Coin()
  end
end


function run()
  graphicsSetting()
  setObjects()
  coinsTaken = 0
  sounds['music']:play()
end


function love.keypressed( key )
   if key == "escape" then
      love.event.quit()
   end
   keypressed = key
end

function love.update(dt)
  player:update(dt)
  screenScroll = player:getScrolling()
  board:update(dt)
  for i=1,#collidableObjects do
    collidableObjects[i]:update(dt)
  end
  for i=1,NUM_COINS do
    coins[i]:update(dt)

  end
  skyScroll = (skyScroll + 0.1) % BACKGROUND_LOOPING_POINT
  -- screenScroll = screenScroll + player:getScrolling()

  for i=1,#collidableObjects do
    player:handleCollision(collidableObjects[i])
    collidableObjects[i]:handleCollision(player)
  end
  -- -- TODO: SHOULD HANDLE ALL Collidable OBJECTS COLLISIONS WITH EACH OTHER.
  -- -- TODO: problem is- the wall and the paddle are always colliding and etc, and paddles with each others..
  -- for k=1,#collidableObjects do
  --   for j=1,#collidableObjects do
  --     if j ~= k  then
  --       collidableObjects[k]:handleCollision(collidableObjects[j])
  --       -- collidableObjects[j]:handleCollision(collidableObjects[k])
  --     end
  --   end
  -- end

-- since during an iteration you can win only one coin, we can break the loop
-- gotCoin = false


  for i=1,NUM_COINS do
    player:handleCollision(coins[i])
    gotCoin = coins[i]:handleCollision(player)
    coinsTaken = coinsTaken + gotCoin
  end
  keypressed = {}
  if not player.isAlive then
    love.event.quit()
  end
end


function love.draw()
  love.graphics.draw(sky, -skyScroll, 0,0,0.255)
  -- TODO: change
  -- love.graphics.translate(-math.floor(screenScroll), 0)
  board:render()
  for i=1,#collidableObjects do
    collidableObjects[i]:render()
  end
  for i,coin in pairs(coins) do
    coin: render()
  end
  player: render()

end
