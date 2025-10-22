local Core = {}
Core.__index = Core

MODE = {
    INSERT = 0,
    CONTROL = 1,
    OUTPUT = 2
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
local canvas = require "src.canvas"
local codetable = require "src.codetable"
local interpreter = require "src.interpreter"
local helper = require "src.helper"

canvases = {
    ["INSERT"] = canvas:new(-windowWidth/2,0,0,0,{ offPos = { x = -windowWidth/2, y = 0 }, onPos = { x = 0, y = 0 }},{}),
    ["CONTROL"] = canvas:new(-windowWidth/2,0,0,0,{ offPos = { x = -windowWidth/2, y = 0 }, onPos = { x = 0, y = 0 }},{}),
    ["OUTPUT"] = canvas:new(-windowWidth/2,0,0,0,{ offPos = { x = -windowWidth/2, y = 0 }, onPos = { x = 0, y = 0 }},{})
}

currentCanvas = nil

function Core:onMouseClick()
    for _, btn in ipairs(buttons) do 
        btn:onMouseClick()
    end
end

function Core:load()
    helper:load(codetable,interpreter)
    canvases["CONTROL"].children = {
        button:new(0,0,{index = "CONTROL", variation = "start"},{onClick = runCode}),
        button:new(0,windowHeight/4,{index = "CONTROL", variation = "new"},{onClick = createLine}),
        button:new(0,windowHeight/2,{index = "CONTROL", variation = "speed"},{}),
        button:new(0,windowHeight*3/4,{index = "CONTROL", variation = "stop"},{})
    }
    canvases["INSERT"].children = {
        button:new(0,windowHeight*7/8,{index = "INSERT", variation = "add"},{})
    }
    canvases["OUTPUT"].children = {
        button:new(0,windowHeight*7/8,{index = "OUTPUT", variation = "speed"},{})
    }
    canvases["CONTROL"].targetPosX = 0
    setCanvas("CONTROL")
end

function Core:update(dt, clicked)
    local mx, my = love.mouse.getPosition()
    for _, canvae in pairs(canvases) do 
        canvae:update(dt,mx,my,clicked)
    end
end

function Core:draw()
    for _, canvae in pairs(canvases) do 
        if canvae ~= currentCanvas then
            canvae:draw()
        end
    end
    currentCanvas:draw()
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