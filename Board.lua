Board = {}
local grassImg = love.graphics.newImage('GreenGrass.png')

Board.__index = Board
setmetatable(Board, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

local cell = {SKY=0,GROUND=1}
local TILE_WIDTH = 25
local TILE_HEIGHT = 25
local TILES_PER_ROW = 40
local TILES_PER_COL = 40
local exists = false
-- TODO: SINGLETONE IT!
-- function setBoard()
--   if not exists then
--     -- TODO TEMP!
--     exists = true
--     return Board(40,40)
--   end
-- end

function Board:init(boardWidth,boardHeight)
  map = {}
  for i=1,TILES_PER_ROW do
    map[i] = {}
    for j=1,TILES_PER_COL do
      -- map[i][j] = cell.GROUND
      if j>TILES_PER_COL*5/10 then
        map[i][j] = cell.GROUND
      elseif j==TILES_PER_COL*3/10-4 and i>14 and i<16 then
          map[i][j] = cell.GROUND
      elseif i>5 and i<17 and j==TILES_PER_COL*5/10 then
        map[i][j] = cell.GROUND
      elseif i>19 and i<30 and j>TILES_PER_COL*5/10-4 then
        map[i][j] = cell.GROUND
      else
        map[i][j] = cell.SKY
      end
    end
  end
  -- map[1][1] = cell.GROUND
  self.map = map
end
function Board:hasCollisionRange(posX,posY,sizeX,sizeY)
  firstRow = math.ceil(posX/TILE_WIDTH)
  lastRow = math.ceil((posX+sizeX)/TILE_WIDTH)
  firstCol = math.ceil(posY/TILE_HEIGHT)
  lastCol = math.ceil((posY+sizeY)/TILE_HEIGHT)
  for i=firstRow,lastRow do
    for j=firstCol,lastCol do
      if self.map[i][j] == cell.GROUND then
        return true
      end
    end
  end
  return false
    -- return true
  -- else

  -- end
end
function Board:hasCollision(posX,posY)
  if self.map[math.ceil(posX/TILE_WIDTH)][math.ceil(posY/TILE_HEIGHT)] == cell.GROUND then
    return true
  else
    return false
  end
end
function Board:render()
  scale_x = TILE_WIDTH/grassImg:getWidth()
  scale_y = TILE_HEIGHT/grassImg:getHeight()
  for i=1,TILES_PER_ROW do
    for j=1,TILES_PER_COL do
      if map[i][j] == cell.GROUND then
        -- love.graphics.draw(grassImg, (i-1)*TILE_WIDTH, (j-1)*TILE_HEIGHT,0, 0.1,0.1)
        love.graphics.draw(grassImg, ((i-1)*TILE_WIDTH)-screenScroll, (j-1)*TILE_HEIGHT,0, scale_x, scale_y)
      end
    end
  end
end
