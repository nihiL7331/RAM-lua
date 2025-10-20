local Core = {}
Core.__index = Core

buttons = {}

code = {
    {
        label = "lloop",
        instruction = "write",
        argument = "=1",
        comment = "no comment"
    }
}
currentInput = -1


local button = require "src.button"

function createLine()
    local line = {
        label = "empty",
        instruction = "empty",
        argument = "empty",
        comment = "empty"
    }
    table.insert(code,line)
end

function Core:onMouseClick()
    for i = 1, #buttons do 
        buttons[i]:onMouseClick()
    end
end

function Core:load()
    button:new(0,0,{index = "SIDE", variation = "start"},{})
    button:new(0,windowHeight/4,{index = "SIDE", variation = "new"},{onClick = createLine})
    button:new(0,windowHeight/2,{index = "SIDE", variation = "speed"},{})
    button:new(0,windowHeight*3/4,{index = "SIDE", variation = "stop"},{})
    for x = 1, 4 do 
        for y = 1, 8 do 
            -- button:new()
        end
    end
end

function Core:update(dt, clicked)
    local mx, my = love.mouse.getPosition()
    for i = 1, #buttons do 
        buttons[i]:update(dt,mx,my,clicked)
    end
end

function Core:draw()
    for i = 1, #buttons do 
        buttons[i]:draw()
    end
    for i = 1, #code do 
        love.graphics.print(i.." "..code[i].label.." "..code[i].instruction.." "..code[i].argument.." "..code[i].comment, windowWidth/14, (i-1)*16)
    end
end

return Core