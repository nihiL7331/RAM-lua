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
-- down arrow/enter (if lowest)/ctrl+n: new line
-- up arrow: go up
-- CONTROL MODE:
-- space: start/pause
-- s: change mode (insta/animated)
-- d/i: halt
local crtShader = love.graphics.newShader('src/shaders/crtShader.glsl')

function love.load()
    love.math.setRandomSeed(love.math.getRandomSeed())

    mainFont = love.graphics.newFont('assets/PressStart2P-Regular.ttf', 16)
    love.graphics.setFont(mainFont)

    Core:load()
    Render:load()
end

function love.mousepressed(x,y,button)
    if button == 1 then 
        Core:onMouseClick()
    end
end

function love.keypressed(key) 
    local m = getMode()
    if key == "i" then 
        --insert mode, if currently running then halt
        if m == MODE.CONTROL then 
            setMode("INSERT")
            return
        else

        end
    elseif key == "escape" then
        --control mode
        if m == MODE.INSERT then 
            setMode("CONTROL")
            return
        end
    elseif key == "space" then 
        --go right if in INSERT, start/pause if in control
        if m == MODE.INSERT then 
            movePointer(1,0)
            return
        else
            
        end
    elseif key == "right" or key == "tab" then 
        --go right if in insert
        if m == MODE.INSERT then 
            movePointer(1,0)
            return
        end
    elseif key == "down" then 
        --go down if in insert, if in lowest cell then add new cell
        if m == MODE.INSERT then 
            moveDown()
            return
        end
    elseif key == "return" then 
        if m == MODE.INSERT then 
            moveDown()
            local pos = getPointer()
            setPointer(0,pos.y)
            return
        end
    elseif key == "backspace" then 
        --if insert: if empty: go left, if empty and in leftmost cell: go up and wrap around, else: delete character
        if m == MODE.INSERT then 
            deleteChar()
            return
        end
    elseif key == "left" then 
        if m == MODE.INSERT then 
            movePointer(-1,0)
            return
        end
    elseif key == "up" then 
        if m == MODE.INSERT then 
            movePointer(0,-1)
            return
        end
    elseif key == "n" then 
        --if insert: if holds ctrl, make new line
    elseif key == "s" then
        --if control: change mode (instant, animated)
    elseif key == "d" then 
        --if control: halt
    end
    if m == MODE.INSERT then 
        writeChar(key)
    end
end

function love.update(dt)
    local clicked = love.mouse.isDown(0)
    Core:update(dt, clicked)
    crtShader:send("curvature",0.015)
    crtShader:send("scanlineIntensity",0.05)
    crtShader:send("scanlineCount",200.0)
    crtShader:send("vignetteIntensity",0.45)
end

function love.draw()
    love.graphics.setShader(crtShader)
    Core:draw()
end
