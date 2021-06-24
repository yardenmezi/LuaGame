StateMachine = {}
StateMachine.__index = StateMachine
setmetatable(StateMachine, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})
-- TODO: CREATE INTERFACE OF STATE
function StateMachine:init(states)
  self.empty = {
		render = function() end,
    stop = function() end,
		update = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.curState = self.empty
end

function StateMachine:change(stateName)

  self.curState:stop()
  self.curState = self.states[stateName]()
  -- print(self.curState)
end

function StateMachine:update(dt)
  -- print(self.curState)
  self.curState:update(dt)
    -- if love.keyboard.wasPressed('enter') then
    --     gStateMachine:change('play')
    -- end
end

function StateMachine:render()
  self.curState:render()
end
