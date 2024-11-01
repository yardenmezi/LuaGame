-- TODO: delete requirement and change the place of changing state (to avatar)
require 'States.StateMachine'
require "States.Game.Grid"
require "Settings"
Board = {}


Board.__index = Board
setmetatable(Board, {
  __call = function(cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

cell = { SKY = 0, GROUND = 1, WORM = 2, LEAF = 3 }
local TILE_WIDTH = 15
local TILE_HEIGHT = 20
local TILES_PER_ROW = 1050

function Board:init(boardWidth, boardHeight)
  self.tilesPerCol = boardHeight / TILE_HEIGHT
  -- TILES_PER_ROW = boardWidth/TILE_WIDTH
  self.map = self:createLvl()
  self.tilesGap = 0
  self.leavesGrid = Grid(self, 3, 3, images['coin'])
  self:addRewards()
end

function Board:createLvl()
  randomPairs = {}
  xbegin = 1
  xend = math.ceil(SPEED * 3 / TILE_WIDTH)
  -- build the game board.
  for i = 1, 100 do
    randomPairs[i] = {}
    randomPairs[i]['x'] = math.random(xbegin, xend)
    randomPairs[i]['sizex'] = math.random(5, 15)
    randomPairs[i]['y'] = math.random(self.tilesPerCol * 4 / 5, self.tilesPerCol)
    randomPairs[i]['sizey'] = math.random(1, 3)
    xbegin = xend + randomPairs[i]['sizex']
    xend = math.min(xbegin + math.ceil(SPEED * 15 / TILE_WIDTH), TILES_PER_ROW - 20)
  end
  map = {}
  for i = 1, TILES_PER_ROW do
    map[i] = {}
    for j = 1, self.tilesPerCol do
      map[i][j] = cell.SKY
      for pairNum = 1, 100 do
        if i >= randomPairs[pairNum]['x'] and i <= randomPairs[pairNum]['x'] + randomPairs[pairNum]['sizex'] then
          if j >= randomPairs[pairNum]['y'] and j <= randomPairs[pairNum]['y'] + randomPairs[pairNum]['sizey'] then
            map[i][j] = cell.GROUND
          end
        end
      end
    end
  end
  map[995][22] = cell.WORM
  return map
end

function Board:addRewards()
  for i = 1, 100 do
    local x = math.random(1, TILES_PER_ROW)
    local y = math.random(1, self.tilesPerCol / 2)
    self.leavesGrid:insert(x, y)
  end
end

function Board:getTileSize()
  return { TILE_WIDTH, TILE_HEIGHT }
end

function Board:getBoardSize()
  return { TILES_PER_ROW, self.tilesPerCol }
end

function Board:update(dt)
  if screenScroll % TILE_WIDTH == 0 then
    if screenScroll < 0 then
      self.tilesGap = self.tilesGap + math.floor(screenScroll / TILE_WIDTH)
    elseif screenScroll > 0 then
      self.tilesGap = self.tilesGap + math.ceil(screenScroll / TILE_WIDTH)
    end
    if self.tilesGap < 0 then
      self.tilesGap = 0
    end
  end
end

function Board:hasCollisionRange(posX, posY, sizeX, sizeY)
  -- Check for invalid positions
  if posX <= 0 or posY <= 0 then
    return { 0 } -- Return an indication of no valid collision
  end

  -- Calculate the grid cell range based on position and size
  local firstRow = math.ceil(posX / TILE_WIDTH) + self.tilesGap
  local lastRow = math.ceil((posX + sizeX) / TILE_WIDTH) + self.tilesGap
  local firstCol = math.ceil(posY / TILE_HEIGHT)
  local lastCol = math.ceil((posY + sizeY) / TILE_HEIGHT)

  local collisionType = { cell.SKY } -- Default collision type

  -- Check for collisions within the specified grid range
  for row = firstRow, lastRow do
    for col = firstCol, lastCol do
      if self.leavesGrid:checkColInCell(row, col) then
        collisionType = { cell.LEAF, { row, col } }   -- Collision with leaves
        break                                         -- Exit the inner loop on collision
      end

      if self.map[row] and self.map[row][col] > 0 then
        collisionType = { self.map[row][col], { row, col } }   -- Collision with a tile
      end
    end

    -- Break the outer loop if a collision was found
    if collisionType[1] ~= cell.SKY then
      break
    end
  end

  return collisionType -- Return the collision type and position
end

function Board:isOutOfLimits(avatar)
  if self.tilesGap == 0 and avatar.x <= avatar:getLeftLim() then
    return true
  end
  return false
end

function Board:getXYFromBoard(cellX, cellY)
  return { (cellX - 1 - self.tilesGap) * TILE_WIDTH, (cellY - 1) * TILE_HEIGHT }
end

function Board:remove(cellType)
  if cellType[1] == cell.LEAF then
    return self.leavesGrid:remove(cellType[2][1], cellType[2][2])
  else
    return 0
  end
end

function Board:render()
  scale_x = TILE_WIDTH / images['grass']:getWidth()
  scale_y = TILE_HEIGHT / images['grass']:getHeight()
  tilesPerScreen = math.ceil(love.graphics.getWidth() / TILE_WIDTH)
  for i = 1 + self.tilesGap, tilesPerScreen + self.tilesGap do
    for j = 1, self.tilesPerCol do
      place = self:getXYFromBoard(i, j)
      self.leavesGrid:renderGridCell(i, j)
      if map[i][j] == cell.GROUND then
        love.graphics.draw(images['grass'], place[1], place[2], 0, scale_x, scale_y)
      elseif map[i][j] == cell.WORM then
        love.graphics.draw(images['worm'], ((i - 1 - self.tilesGap) * TILE_WIDTH), (j - 1) * TILE_HEIGHT, 0, scale_x * 5,
          scale_y / 2)
      end
    end
  end
end
