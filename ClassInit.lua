-- function inherit(class,fatherClass)
--   class.__index = class
--   setmetatable(fatherClass, {
--     __index = fatherClass,
--     __call = function (cls, ...)
--       local self = setmetatable({}, cls)
--       fatherClass:init(...)
--       self:init(...)
--       return self
--     end,
--   })
-- end

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
