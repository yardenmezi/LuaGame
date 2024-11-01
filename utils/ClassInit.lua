function inherit(base, derived)
  derived = {}
  derived.__index = derived
  setmetatable(derived, {
    __index = base,
    __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:init(...)
      return self
    end,
  })
end
