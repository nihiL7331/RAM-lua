local Core = {}
Core.__index = Core

MODE = {
    INSERT = 0,
    CONTROL = 1
}
MAXLEN = 6 -- max text length

function getMode()
    return currentMode
end

buttons = {}
currentInput = -1
currentMode = MODE.CONTROL


debugDraw = false


local button = require "src.button"
local codetable = require "src.codetable"
local helper = require "src.helper"

function Core:onMouseClick()
    for _, btn in ipairs(buttons) do 
        btn:onMouseClick()
    end
end

function Core:load()
    helper:load(codetable)

    button:new(0,0,{index = "SIDE", variation = "start"},{})
    button:new(0,windowHeight/4,{index = "SIDE", variation = "new"},{onClick = createLine})
    button:new(0,windowHeight/2,{index = "SIDE", variation = "speed"},{})
    button:new(0,windowHeight*3/4,{index = "SIDE", variation = "stop"},{})
end

function Core:update(dt, clicked)
    local mx, my = love.mouse.getPosition()
    for _, btn in ipairs(buttons) do 
        btn:update(dt,mx,my,clicked)
    end
end

function Core:draw()
    for _, btn in ipairs(buttons) do 
        btn:draw()
    end
    codetable:draw()
    love.graphics.setColor(1,1,1,0.25)
    local modeText = "."
    for i, v in pairs(MODE) do 
        if currentMode == v then 
            modeText = tostring(i)
        end
    end
    local padding = 4*screenScale
    local size = { x = mainFont:getWidth(modeText) + padding, y = mainFont:getHeight(modeText) + padding}
    love.graphics.rectangle("fill", windowWidth - size.x, windowHeight - size.y, size.x, size.y)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(modeText, windowWidth - size.x + padding/2, windowHeight - size.y + padding/2)
end

return Core