Grid = {}
Grid.__index = Grid
setmetatable(Grid, {
  __call = function(cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

function Grid:init(board, scaleBoardX, scaleBoardY, img)
  self.scaleX = scaleBoardX
  self.scaleY = scaleBoardY
  self.renderScaleX = (board:getTileSize()[1] * scaleBoardX) / img:getWidth()
  self.renderScaleY = (board:getTileSize()[2] * scaleBoardY) / img:getHeight()
  self.sprite = sprite
  local map = {}
  local sizeBoard = board:getBoardSize()
  for i = 1, sizeBoard[1] do
    map[i] = {}
    for j = 1, sizeBoard[2] do
      map[i][j] = 0
    end
  end
  self.map = map
  self.img = img
end

function Grid:insert(boardCellX, boardCellY)
  for i = boardCellX, boardCellX + self.scaleX do
    for j = boardCellY, boardCellY + self.scaleY do
      self.map[boardCellX][boardCellY] = 2
    end
  end
  self.map[boardCellX][boardCellY] = 1
end

function Grid:remove(boardCellX, boardCellY)
  -- should find the first cells. returns num of objects that removed
  local cells = {}
  for i = math.max(0, boardCellX - self.scaleX), math.min(boardCellX + self.scaleX, #self.map) do
    for j = math.max(boardCellY - self.scaleY), math.min(boardCellY + self.scaleY, #self.map[1]) do
      if self.map[i][j] == 1 then
        cells[#cells + 1] = { i, j }
        -- TODO:FROM SOME RESON,IT DOSNT WORK WHEN TOUCHING THE 2
      end
    end
  end
  for idx = 1, (#cells) do
    for i = cells[idx][1], cells[idx][1] + self.scaleX do
      for j = cells[idx][2], cells[idx][2] + self.scaleY do
        self.map[i][j] = 0
      end
    end
  end

  return #cells
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
