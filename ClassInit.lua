




function inherit(class,fatherClass)
  -- Bird  = {}
  class.__index = class
  setmetatable(fatherClass, {
    __index = fatherClass,
    __call = function (cls, ...)
      local self = setmetatable({}, cls)
      fatherClass:init(...)
      self:init(...)
      return self
    end,
  })
end
