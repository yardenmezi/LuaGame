Animation  = {}
Animation.__index = Animation
setmetatable(Animation, {
  __index = Animation,
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})


function Animation:init(frames,timePerFrame)
  self.frames = frames
  self.timePerFrame = timePerFrame
  self.frameDuration = 0
  self.curFrameNum = 0
end

function Animation:getFrame()
  return self.frames[self.curFrameNum+1]
end

function Animation:update(dt)
  self.frameDuration = self.frameDuration + dt
  if self.timePerFrame <= self.frameDuration  then
    self.curFrameNum = ((self.curFrameNum +1) % #self.frames)
    self.frameDuration = 0
  end
end
