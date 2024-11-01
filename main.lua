require 'States/Game/Game'
require 'States/StartState'
require 'States.StateMachine'
love.window.setTitle('Grass And Sun')

function love.load()
  keypressed = {}
  stateMachine = StateMachine {
      ['first'] = function() return StartState() end,
      ['game'] = function() return Game() end
  }
  stateMachine:change('first')
end

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   end
   keypressed = key
end

function love.update(dt)
  stateMachine:update(dt)
end

function love.draw()
  stateMachine:render()
end
