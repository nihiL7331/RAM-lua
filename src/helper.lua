local Helper = {}
Helper.__index = Helper

local codetable = nil 
local interpreter = nil

function Helper:load(ct,i)
    codetable = ct
    interpreter = i
end 

function runCode()
    local c = codetable:getCode()
    interpreter:runCode(c)
end

function createLine(y)
    codetable:createLine(y)
end

function setMode(mode)
    currentMode = MODE[mode]
    if mode == "INSERT" then 
        setPointer(1,1)
    end
end

function movePointer(dx,dy)
    local pos = codetable:getPointer()
    pos.x = pos.x + dx
    pos.y = pos.y + dy 
    setPointer(pos.x,pos.y)
end

function setPointer(x,y)
    codetable:setPointer(x,y)
end

function getPointer()
    return codetable:getPointer()
end

function moveDown()
    local s = codetable:getSize()
    local pos = codetable:getPointer()
    if s == pos.y then 
        createLine(pos.y+1)
    end
    movePointer(0,1)
end

function deleteChar()
    codetable:deleteChar()
end

function writeChar(key)
    local pos = codetable:getPointer()
    if key == "space" then 
        local len = codetable:getTextLength(pos.x,pos.y)
        if len == 0 then return end
        key = " " 
    end
    if #key > 1 then return end
    codetable:writeChar(key)
end

return Helper