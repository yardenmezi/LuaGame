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

CELL_TYPE = { SKY = 0, GROUND = 1, WORM = 2, LEAF = 3 }
local TILE_WIDTH = 15
local TILE_HEIGHT = 20
local TILES_PER_ROW = 1050

function Board:init(boardWidth, boardHeight)
  self.tilesPerCol = boardHeight / TILE_HEIGHT
  -- TILES_PER_ROW = boardWidth/TILE_WIDTH
  self.map = self:createLvl()
  self.tilesGap = 0
  self.leavesGrid = Grid(self, 3, 3, Images.coin)
  self:addRewards()
end

function Board:getTileSize()
  return { TILE_WIDTH, TILE_HEIGHT }
end

function Board:getBoardSize()
  return { TILES_PER_ROW, self.tilesPerCol }
end

function Board:generateGroundSurfaces()
  local groundSurfaces = {}
  local xbegin = 1
  local xend = math.ceil(SPEED * 3 / TILE_WIDTH)
  for i = 1, GameParameters.numSurfaces do
    groundSurfaces[i] = {
      x = math.random(xbegin, xend),
      y = math.random(self.tilesPerCol * 4 / 5, self.tilesPerCol),
      width = math.random(5, 15),
      height = math.random(1, 3)
    }
    xbegin = xend + groundSurfaces[i]['width']
    xend = math.min(xbegin + math.ceil(SPEED * 15 / TILE_WIDTH), TILES_PER_ROW - 20)
  end
  return groundSurfaces
end

function Board:fill_ground_tiles(map)
  local groundSurfaces = self:generateGroundSurfaces()
  for surfaceNum = 1, #groundSurfaces do
    local xEnd = groundSurfaces[surfaceNum].x + groundSurfaces[surfaceNum].width
    local yEnd = groundSurfaces[surfaceNum]['y'] + groundSurfaces[surfaceNum]['height']
    for i = groundSurfaces[surfaceNum].x, xEnd do
      for j = groundSurfaces[surfaceNum].y, yEnd do
        if #map > i and #map[i] > j then
          map[i][j] = CELL_TYPE.GROUND
        end
      end
    end
  end
end

function Board:createLvl()
  local map = {}
  for i = 1, TILES_PER_ROW do
    map[i] = {}
    for j = 1, self.tilesPerCol do
      map[i][j] = CELL_TYPE.SKY
    end
  end
  self:fill_ground_tiles(map)

  map[995][22] = CELL_TYPE.WORM
  return map
end

function Board:addRewards()
  for i = 1, 100 do
    local x = math.random(1, TILES_PER_ROW)
    local y = math.random(1, self.tilesPerCol / 2)
    self.leavesGrid:insert(x, y)
  end
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

function Board:getTileIndex(posX, posY)
  return { math.ceil(posX / TILE_WIDTH) + self.tilesGap, math.ceil(posY / TILE_HEIGHT) }
end

function Board:hasCollisionRange(posX, posY, sizeX, sizeY)
  -- Check for invalid positions
  if posX <= 0 or posY <= 0 then
    return { 0 } -- Return an indication of no valid collision
  end

  local upperRightPt = self:getTileIndex(posX, posY)
  local lowerLeftPt = self:getTileIndex(posX + sizeX, posY + sizeY)
  
  local collisionType = { CELL_TYPE.SKY } -- Default collision type
  -- Check for collisions within the specified grid range
  for row = upperRightPt[1], lowerLeftPt[1] do
    for col = upperRightPt[2], lowerLeftPt[2] do
      if self.leavesGrid:checkColInCell(row, col) then
        collisionType = { CELL_TYPE.LEAF, { row, col } } -- Collision with leaves
        break                                            -- Exit the inner loop on collision
      end
      if self.map[row] and self.map[row][col] > 0 then
        collisionType = { self.map[row][col], { row, col } } -- Collision with a tile
      end
    end
    -- Break the outer loop if a collision was found
    if collisionType[1] ~= CELL_TYPE.SKY then
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
  if cellType[1] == CELL_TYPE.LEAF then
    return self.leavesGrid:remove(cellType[2][1], cellType[2][2])
  else
    return 0
  end
end

function Board:render()
  local scale_x = TILE_WIDTH / Images['grass']:getWidth()
  local scale_y = TILE_HEIGHT / Images['grass']:getHeight()
  local tilesPerScreen = math.ceil(love.graphics.getWidth() / TILE_WIDTH)
  for i = 1 + self.tilesGap, tilesPerScreen + self.tilesGap do
    for j = 1, self.tilesPerCol do
      local place = self:getXYFromBoard(i, j)
      self.leavesGrid:renderGridCell(i, j)
      if self.map[i][j] == CELL_TYPE.GROUND then
        love.graphics.draw(Images['grass'], place[1], place[2], 0, scale_x, scale_y)
      elseif self.map[i][j] == CELL_TYPE.WORM then
        love.graphics.draw(Images['worm'], ((i - 1 - self.tilesGap) * TILE_WIDTH), (j - 1) * TILE_HEIGHT, 0, scale_x * 5,
          scale_y / 2)
      end
    end
  end
end
