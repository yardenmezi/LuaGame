StateMachine = {}
StateMachine.__index = StateMachine
setmetatable(StateMachine, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:init(...)
    return self
  end,
})

function StateMachine:init(states)
  self.empty = {
		render = function() end,
    stop = function() end,
		update = function() end
	}
	self.states = states or {}
	self.curState = self.empty
end

function StateMachine:change(stateName)
  self.curState:stop()
  self.curState = self.states[stateName]()
end

function StateMachine:update(dt)
  self.curState:update(dt)
end

function StateMachine:render()
  self.curState:render()
end
