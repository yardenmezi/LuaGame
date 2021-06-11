Board = {}
local grassImg = love.graphics.newImage('images/GreenGrass.png')
local coinImg = love.graphics.newImage('images/leaf.png')

Board.__index = Board
setmetatable(Board, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

local cell = {SKY=0,GROUND=1,LEAF=2}
local TILE_WIDTH = 20
local TILE_HEIGHT = 20
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
  TILES_PER_COL = boardHeight/TILE_HEIGHT
  randomPairs = {}
  xbegin = 1
  xend = math.ceil(SPEED*3/TILE_WIDTH)
  for i=1,100 do
    randomPairs[i] = {}
    randomPairs[i]['x'] = math.random(xbegin, xend)
    randomPairs[i]['sizex'] = math.random(5,15)
    randomPairs[i]['y'] = math.random(TILES_PER_COL*4/5,TILES_PER_COL)
    randomPairs[i]['sizey'] = math.random(1,3)
    xbegin = xend+randomPairs[i]['sizex']
    xend = math.min(xbegin+math.ceil(SPEED*15/TILE_WIDTH), TILES_PER_ROW-20)
  end
  for i=1,TILES_PER_ROW do
    map[i] = {}
    for j=1,TILES_PER_COL do
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

  -- map[10][10] = cell.LEAF
  self.map = map
  self.tilesGap = 0
end

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


function Board:inBoardLimit(scrolling)
  if self.tilesGap == 0 and scrolling<0 then
    return true
  end
  return false
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
      elseif map[i][j] == cell.LEAF then
        love.graphics.draw(coinImg, ((i-1-self.tilesGap) * TILE_WIDTH), (j-1)*TILE_HEIGHT,0, scale_x, scale_y)
      end
    end
  end
end
