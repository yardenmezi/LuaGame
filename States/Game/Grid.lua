Grid = {}
Grid.__index = Grid
setmetatable(Grid, {
  __call = function(cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

function Grid:init_matrix(board)
  local matrix = {}
  local sizeBoard = board:getBoardSize()
  for i = 1, sizeBoard[1] do
    matrix[i] = {}
    for j = 1, sizeBoard[2] do
      matrix[i][j] = 0
    end
  end
  return matrix
end

function Grid:init(board, cellSpanX, cellSpanY, img)
  self.cellSpanX = cellSpanX
  self.cellSpanY = cellSpanY
  self.renderScaleX = (board:getTileSize()[1] * cellSpanX) / img:getWidth()
  self.renderScaleY = (board:getTileSize()[2] * cellSpanY) / img:getHeight()
  self.sprite = sprite
  self.map = self:init_matrix(board)
  self.img = img
end

function Grid:insert(boardPosX, boardPosY)
  for i = boardPosX, boardPosX + self.cellSpanX do
    for j = boardPosY, boardPosY + self.cellSpanY do
      self.map[boardPosX][boardPosY] = 2
    end
  end
  self.map[boardPosX][boardPosY] = 1
end

function Grid:getNonEmptyCells(boardCellX,boardCellY)
  local cells = {}
  for i = math.max(1, boardCellX - self.cellSpanX), math.min(boardCellX + self.cellSpanX, #self.map) do
    for j = math.max(1,boardCellY - self.cellSpanY), math.min(boardCellY + self.cellSpanY, #self.map[1]) do      
      if self.map[i][j] == 1 then
        cells[#cells + 1] = { i, j }
        -- TODO:FROM SOME RESON,IT DOSNT WORK WHEN TOUCHING THE 2
      end
    end
  end
  return cells
end

function Grid:remove(boardCellX, boardCellY)
  -- should find the first cells. returns num of objects that removed
  local nonEmptyCells = self:getNonEmptyCells(boardCellX,boardCellY)
  for idx = 1, (#nonEmptyCells) do

    for i = nonEmptyCells[idx][1], nonEmptyCells[idx][1] + self.cellSpanX do
      for j = nonEmptyCells[idx][2], nonEmptyCells[idx][2] + self.cellSpanY do
        self.map[i][j] = 0
      end
    end
  end

  return #nonEmptyCells
end

function Grid:checkColInCell(boardCellX, boardCellY)
  if self.map[boardCellX][boardCellY] > 0 then
    return true
  end
  return false
end

function Grid:renderGridCell(boardCellX, boardCellY)
  if boardCellX < 1 or boardCellY < 1 then
    return false
  end
  if self.map[boardCellX][boardCellY] == 1 then
    pt = board:getXYFromBoard(boardCellX, boardCellY)
    -- TODO: USE FRAMES.
    love.graphics.draw(self.img, pt[1], pt[2], 0, self.renderScaleX, self.renderScaleY)
    return true
  end
  return false
end
