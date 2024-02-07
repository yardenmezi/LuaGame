Size = {}
-- Size.__index = Size
-- setmetatable(Size, {
--   __index = Size,
--   __call = function (cls, ...)
--     local self = setmetatable({}, cls)
--     self:init(...)
--     return self
--   end,
-- })

function Size:init(width, height)
  self.width = width
  self.height = height
end
