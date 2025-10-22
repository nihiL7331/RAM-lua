local Codetable = {}
Codetable.__index = Codetable 

local code = {
    {
        [1] = "LABEL",
        [2] = "INSTR",
        [3] = "ARG",
        [4] = "COMMENT"
    },
    {
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = "",
    }
}

pointer = { x = 1, y = 2 }

function Codetable:createLine(y)
    local line = {
        [1] = "",
        [2] = "",
        [3] = "",
        [4] = ""
    }
    table.insert(code,y or (#code+1),line)
end

function Codetable:getSize()
    return #code
end

function Codetable:getCode()
    local newCode = {}
    for i = 2, #code do 
        table.insert(newCode, code[i])
    end
    return newCode
end

function Codetable:load()

end

function Codetable:update(dt)

end

function Codetable:setPointer(x,y)
    pointer.x = math.max(1,math.min(4,x)) or pointer.x
    pointer.y = math.max(2,math.min(#code,y)) or pointer.y
end

function Codetable:getPointer()
    return pointer
end

function Codetable:deleteChar(rm)
    local len = #code[pointer.y][pointer.x]
    if len == 0 then 
        --go left
        if(pointer.x == 1 and pointer.y ~= 2) then 
            if rm then 
                table.remove(code,pointer.y)
            end
            setPointer(4,pointer.y-1)
        else
            setPointer(pointer.x-1,pointer.y)
        end
    else
        --delete the char
        code[pointer.y][pointer.x] = string.sub(code[pointer.y][pointer.x],1,len-1)
    end
end

function Codetable:writeChar(key)
    local len = #code[pointer.y][pointer.x]
    if pointer.x ~= 4 and len == MAXLEN then return
    elseif pointer.x == 4 and len+2 == MAXLEN*2 then return end
    code[pointer.y][pointer.x] = code[pointer.y][pointer.x]..key
end

function Codetable:getTextLength(x,y)
    return #code[y][x]
end

function Codetable:draw()
    for i, l in ipairs(code) do 
        local c = 1
        local offset = windowWidth/10 + 4
        if i ~= 1 then
            if pointer.y == i and getMode() == MODE.INSERT then love.graphics.setColor(1,0,0,1) end
            love.graphics.print(tostring(i-1), offset, i*16)
        end
        love.graphics.setColor(1,1,1,1)
        for _, data in ipairs(l) do
            local isPointer = false
            if pointer.x == c and pointer.y == i and getMode() == MODE.INSERT then 
                love.graphics.setColor(1,0,0,1) 
                isPointer = true
            end
            local text = data
            if isPointer then text = text.."|"
            elseif #text == 0 then text = "." end
            love.graphics.print(text, c * offset * 1.7, i*16)
            c = c + 1
            love.graphics.setColor(1,1,1,1)
        end
    end
    if not debugDraw then return end
    local oV = 0
    if #output > 0 then oV = output[1] end
    love.graphics.print("O1: "..oV.." AC: "..memTable[0], windowWidth/2, windowHeight - 16)
end

return Codetable