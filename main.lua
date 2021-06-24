require 'Game'
require 'StartState'
require 'StateMachine'
love.window.setTitle('Grass And Sun ☼')
function love.load()
  keypressed = {}
  stateMachine = StateMachine{
      ['start'] = function() return StartState() end,
      ['play'] = function() return Game() end
      -- ['gameOver'] = function() return Game() end
  }
  stateMachine:change('start')
-- state:render()
  -- run()
  -- love.graphics.circle('fill',20,20,20)
  -- TODO: make state machine class
--   gStateMachine = {
--     ['start'] = function() return StartState() end,
--     ['play'] = function() return Game() end
-- }
end

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   end
   keypressed = key
end

function love.update(dt)
  stateMachine:update(dt)
  keypressed = {}
end

function love.draw()
  stateMachine:render()
end
