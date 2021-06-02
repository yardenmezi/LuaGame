Board = {}
local grassImg = love.graphics.newImage('images/GreenGrass.png')

Board.__index = Board
setmetatable(Board, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

local cell = {SKY=0,GROUND=1}
local TILE_WIDTH = 20
local TILE_HEIGHT = 40
local TILES_PER_ROW = 1050
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
  print(boardHeight)
  TILES_PER_COL = boardHeight/TILE_HEIGHT
  print(TILES_PER_COL)
  for i=1,TILES_PER_ROW do
    map[i] = {}
    for j=1,TILES_PER_COL do
      -- map[i][j] = cell.GROUND
      if j==TILES_PER_COL then
        map[i][j] = cell.GROUND
    elseif i>5 and i<10 and j>TILES_PER_COL-8 then
        map[i][j] = cell.GROUND
    elseif i>9 and i<15 and j ==TILES_PER_COL-2 then
        map[i][j] = cell.GROUND
    elseif i>25 and i<30 and j==TILES_PER_COL-3 then
      map[i][j] = cell.GROUND
    elseif i>35 and i<50 and j==TILES_PER_COL-4 then
      map[i][j] = cell.GROUND
    elseif i>15 and i<25 and j==TILES_PER_COL-9 then
      map[i][j] = cell.GROUND
    -- elseif i>55 and i<70 and j==TILES_PER_COL-2 then
      -- map[i][j] = cell.GROUND
    else
        map[i][j] = cell.SKY
      end
    end
  end
  -- map[1][1] = cell.GROUND
  self.map = map
  self.tilesGap = 0
end

function Board:update(dt)
  -- self.stillScroll = screenScroll
  -- self.x = self.x - self.stillScroll
  -- print("---")
  -- print(screenScroll)
  -- print(TILE_WIDTH)
  -- print(screenScroll%TILE_WIDTH)
  if screenScroll%TILE_WIDTH==0 then
    if screenScroll<0 then
      self.tilesGap = self.tilesGap + math.floor(screenScroll/TILE_WIDTH)
    elseif screenScroll>0 then
      self.tilesGap = self.tilesGap + math.ceil(screenScroll/TILE_WIDTH)
    end
  end
  -- print(self.tilesGap)
end

function Board:hasCollisionRange(posX,posY,sizeX,sizeY)
  if posX<=0 or posY<=0 then
    return false
  end
  firstRow = math.ceil(posX/TILE_WIDTH)
  lastRow = math.ceil((posX+sizeX)/TILE_WIDTH)
  firstCol = math.ceil(posY/TILE_HEIGHT)
  lastCol = math.ceil((posY+sizeY)/TILE_HEIGHT)
  for i=firstRow,lastRow do
    for j=firstCol,lastCol do
      if self.map[i+self.tilesGap][j] == cell.GROUND then
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

  if self.map[math.ceil(posX/TILE_WIDTH) + self.tilesGap][math.ceil(posY/TILE_HEIGHT)] == cell.GROUND then
    return true
  else
    return false
  end
end

function Board:render()
  scale_x = TILE_WIDTH/grassImg:getWidth()
  scale_y = TILE_HEIGHT/grassImg:getHeight()
  tilesPerScreen = math.ceil(love.graphics.getWidth()/TILE_WIDTH)
  -- screenTilesmath.ceil(screenScroll/TILE_WIDTH)
  -- k = 1
  for i=1+self.tilesGap,tilesPerScreen+self.tilesGap do
    for j=1,TILES_PER_COL do
      if map[i][j] == cell.GROUND then
        -- love.graphics.draw(grassImg, (i-1)*TILE_WIDTH, (j-1)*TILE_HEIGHT,0, 0.1,0.1)
        love.graphics.draw(grassImg, ((i-1-self.tilesGap) * TILE_WIDTH), (j-1)*TILE_HEIGHT,0, scale_x, scale_y)
      end
    end
  end
end
