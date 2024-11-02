Animation = declareClass(nil, Animation)

function Animation:init(frames, timePerFrame)
  self.frames = frames
  self.timePerFrame = timePerFrame
  self.frameDuration = 0
  self.curFrameNum = 0
end

function getFramesFromImage(image, framesNumber)
  local frameSize = { width = image:getWidth(), height = image:getHeight() }
  local Frames = {}
  for i = 1, framesNumber do
    Frames[i] = love.graphics.newQuad(image:getWidth() / framesNumber * (i - 1), 0, frameSize.width / 3, frameSize
    .height, image:getHeight(), image:getDimensions())
  end
  return Frames
end

function Animation:getFrame()
  return self.frames[self.curFrameNum + 1]
end

function Animation:update(dt)
  self.frameDuration = self.frameDuration + dt
  if self.timePerFrame <= self.frameDuration then
    self.curFrameNum = ((self.curFrameNum + 1) % #self.frames)
    self.frameDuration = 0
  end
end
