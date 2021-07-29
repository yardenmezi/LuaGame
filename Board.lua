-- TODO: delete requirement and change the place of changing state (to avatar)
require 'StateMachine'
require "Grid"
Board = {}
local grassImg = love.graphics.newImage('images/GreenGrass.png')
local wormImg = love.graphics.newImage('images/worm.png')
local coinImg = love.graphics.newImage('images/leaf.png')

Board.__index = Board
setmetatable(Board, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})
-- TODO: BUG: THE LIMIT WHEN GOING INTO A WALL (THERE IS A GAP THAT USER CANT REACH)
cell = {SKY=0,GROUND=1,WORM=2,LEAF=3}
local TILE_WIDTH = 15
local TILE_HEIGHT = 20
local TILES_PER_ROW = 1050
-- local TILES_PER_COL = 40
local exists = false
-- TODO: SINGLETONE IT!
-- function setBoard()
--   if not exists then
--     -- TODO TEMP!
--     exists = true
--     return Board(40,40)
--   end
-- end


--[[
  Description: Board constructor.
  Parms:
    - boardWidth: the width of the board (in tiles). must be an int
    - boardHeight: the height of the board (in tiles). must be an int
]]--
function Board:init(boardWidth,boardHeight)
  self.tilesPerCol = boardHeight/TILE_HEIGHT
  -- TILES_PER_ROW = boardWidth/TILE_WIDTH
  self.map = self:createLvl()
  self.tilesGap = 0
  self.leavesGrid = Grid(self,3,3,coinImg)
  self:addRewards()
end

--[[
  Description: Builds the positions in the scene of level 1.
]]--
function Board:createLvl()
  randomPairs = {}
  xbegin = 1
  xend = math.ceil(SPEED*3/TILE_WIDTH)
  -- build the game board.
  for i=1,100 do
    randomPairs[i] = {}
    randomPairs[i]['x'] = math.random(xbegin, xend)
    randomPairs[i]['sizex'] = math.random(5,15)
    randomPairs[i]['y'] = math.random(self.tilesPerCol*4/5,self.tilesPerCol)
    randomPairs[i]['sizey'] = math.random(1,3)
    xbegin = xend+randomPairs[i]['sizex']
    xend = math.min(xbegin+math.ceil(SPEED*15/TILE_WIDTH), TILES_PER_ROW-20)
  end
  map = {}
  for i=1,TILES_PER_ROW do
    map[i] = {}
    for j=1,self.tilesPerCol do
        map[i][j] = cell.SKY
      for pairNum=1,100 do
        if i>=randomPairs[pairNum]['x'] and i<=randomPairs[pairNum]['x']+randomPairs[pairNum]['sizex'] then
          if j>=randomPairs[pairNum]['y'] and j<=randomPairs[pairNum]['y']+randomPairs[pairNum]['sizey'] then
            map[i][j] = cell.GROUND
          end
        end
      end
    end
  end
  map[995][22] = cell.WORM
  return map
end

--[[
  Description: Place the rewards in the board
]]--
function Board:addRewards()
  for i=1,100 do
    local x = math.random(1,TILES_PER_ROW)
    local y = math.random(1,self.tilesPerCol/2)
    self.leavesGrid:insert(x,y)
  end
end


--[[
  Description: Tile size getter
  Returns: A table with the width and height of a tile (pixels).
]]--
function Board:getTileSize()
  return {TILE_WIDTH,TILE_HEIGHT}
end


--[[
  Description: Board size getter
  Returns: A table with the width and height of the board (in tiles).
]]--
function Board:getBoardSize()
  return {TILES_PER_ROW,self.tilesPerCol}
end


--[[
  Description: Updates the board states and the viewed part of it in the game.
]]--
function Board:update(dt)
  if screenScroll%TILE_WIDTH==0 then
    if screenScroll<0 then
      self.tilesGap = self.tilesGap + math.floor(screenScroll/TILE_WIDTH)
    elseif screenScroll>0 then
      self.tilesGap = self.tilesGap + math.ceil(screenScroll/TILE_WIDTH)
    end
  end
end

function Board:hasCollisionRange(posX,posY,sizeX,sizeY)
  if posX<=0 or posY<=0 then
    -- TODO: SOMETHING MORE COMMUNICATING
    return {0}
  end

  local firstRow = math.ceil(posX/TILE_WIDTH) + self.tilesGap
  local lastRow = math.ceil((posX+sizeX)/TILE_WIDTH)+self.tilesGap
  local firstCol = math.ceil(posY/TILE_HEIGHT)
  local lastCol = math.ceil((posY+sizeY)/TILE_HEIGHT)
  type = {cell.SKY}
  for i=firstRow,lastRow do
    for j=firstCol,lastCol do
      if self.leavesGrid:checkColInCell(i,j) then
        type = {cell.LEAF,{i,j}}
        break
        -- return cell.LEAF
      end
      if self.map[i][j] > 0 then
        type = {self.map[i][j],{i,j}}
      -- elseif  then
      --   return cell.
      -- elseif self.map[i+self.tilesGap][j] == cell.GROUND then
      --   return cell.GROUND
        -- print(cell.WORM)
        -- TODO: CHANGE IT. BOARD JOB IS TO GIVE INFORMATION. NOT CHANGE STATES FOR COLLISIONS
        -- stateMachine:change('first')
      end
    end
  end
  return type
  -- return false
end


function Board:inBoardLimit(scrolling)
  if self.tilesGap == 0 and scrolling<0 then
    return true
  end
  return false
end


-- function Board:hasCollision(posX,posY)
--
--   if self.map[math.ceil(posX/TILE_WIDTH) + self.tilesGap][math.ceil(posY/TILE_HEIGHT)] == cell.GROUND then
--     return true
--   else
--     return false
--   end
-- end


-- function Board:takePower()
--   if coinsTaken > 0 then
--     coinsTaken = coinsTaken - 1
--     return true
--   end
--   return false
--
-- end

function Board:getXYFromBoard(cellX,cellY)
  return {(cellX-1-self.tilesGap)* TILE_WIDTH, (cellY - 1) * TILE_HEIGHT}
end

function Board:remove(cellType)
  if cellType[1] == cell.LEAF then
    -- should get the cellNumber
    return self.leavesGrid:remove(cellType[2][1],cellType[2][2])
    -- return self.leavesGrid:remove(self.tilesGap + math.ceil(x/TILE_WIDTH), math.ceil(y/TILE_HEIGHT))
  else
    return 0
  end
end
function Board:render()
  scale_x = TILE_WIDTH/grassImg:getWidth()
  scale_y = TILE_HEIGHT/grassImg:getHeight()
  tilesPerScreen = math.ceil(love.graphics.getWidth()/TILE_WIDTH)
  -- screenTilesmath.ceil(screenScroll/TILE_WIDTH)
  -- k = 1
  for i=1+self.tilesGap,tilesPerScreen+self.tilesGap do
    for j=1,self.tilesPerCol do
      place = self:getXYFromBoard(i,j)
      self.leavesGrid:renderGridCell(i,j)
      if map[i][j] == cell.GROUND then
        -- love.graphics.draw(grassImg, (i-1)*TILE_WIDTH, (j-1)*TILE_HEIGHT,0, 0.1,0.1)
        love.graphics.draw(grassImg, place[1], place[2],0, scale_x, scale_y)
      elseif map[i][j] == cell.WORM then
        -- self.boardx
        love.graphics.draw(wormImg, ((i-1-self.tilesGap) * TILE_WIDTH), (j-1)*TILE_HEIGHT,0, scale_x*5, scale_y/2)
      end
    end
  end
end
