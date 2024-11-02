function declareClass(base, derived)
  derived = {}
  derived.__index = derived
  setmetatable(derived, {
    __index = base or derived,
    __call = function (cls, ...)
      local self = setmetatable({}, cls)
      self:init(...)
      return self
    end,
  })
  return derived
end
