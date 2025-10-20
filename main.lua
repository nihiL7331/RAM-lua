love.graphics.setDefaultFilter("nearest","nearest")

local Render = require "src.render"
local Core = require "src.core"

-- SHORTCUTS
-- i: go to insert mode
-- esc: go to control mode
-- INSERT MODE:
-- space/right arrow: go right
-- enter/down arrow: go down
-- backspace (if empty)/left arrow: go left
-- backspace (if empty and left)/up arrow: go up
-- down arrow (if lowest)/ctrl+n: new line
-- CONTROL MODE:
-- space: start/pause
-- s: change mode (insta/animated)
-- d/i: halt


function love.load()
    love.math.setRandomSeed(love.math.getRandomSeed())
    Core:load()
    Render:load()
end

function love.mousepressed(x,y,button)
    if button == 1 then 
        Core:onMouseClick()
    end
end

function love.update(dt)
    local clicked = love.mouse.isDown(0)
    Core:update(dt, clicked)
end

function love.draw()
    Core:draw()
end
