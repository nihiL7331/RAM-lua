local Interpreter = {}
Interpreter.__index = Interpreter 

local input = {4,5,20}
output = {}
memTable = {}
memTable[0] = 0
local tempCode = {}
local jumpTable = {}

local functions = {
    read = function(arg) Interpreter:read(arg) end,
    load = function(arg) Interpreter:load(arg) end,
    write = function(arg) Interpreter:write(arg) end,
    add = function(arg) Interpreter:add(arg) end,
    sub = function(arg) Interpreter:sub(arg) end,
    store = function(arg) Interpreter:store(arg) end,
    div = function(arg) Interpreter:div(arg) end,
    mult = function(arg) Interpreter:mult(arg) end,
    jump  = function(arg) return Interpreter:jump(arg) end,
    jzero = function(arg) return Interpreter:jzero(arg) end,
    jgtz = function(arg) return Interpreter:jgtz(arg) end,
    halt = function() return Interpreter:halt() end,
}

function Interpreter:read(arg)
    local s = string.sub(arg,1,1)
    if s == "^" then 
        local ind1 = tonumber(string.sub(arg,2,#arg))
        local ind2 = memTable[ind1]
        memTable[ind2] = input[1]
        table.remove(input,1)
    else
        local ind = tonumber(arg)
        memTable[ind] = input[1]
        table.remove(input,1)
    end
end

function Interpreter:load(arg)
    local s = string.sub(arg,1,1)
    if s == "=" then 
        local num = tonumber(string.sub(arg,2,#arg))
        memTable[0] = num
    elseif s == "^" then 
        local ind1 = tonumber(string.sub(arg,2,#arg))
        local ind2 = memTable[ind1]
        local num = memTable[ind2]
        memTable[0] = num
    else
        local ind = tonumber(arg)
        local num = memTable[ind]
        memTable[0] = num
    end
end

function Interpreter:write(arg)
    local s = string.sub(arg,1,1)
    if s == "=" then
        local num = tonumber(string.sub(arg,2,#arg))
        table.insert(output,num)
    elseif s == "^" then
        local ind1 = tonumber(string.sub(arg,2,#arg))
        local ind2 = memTable[ind1]
        local num = memTable[ind2]
        table.insert(output,num)
    else
        local ind = tonumber(arg)
        local num = memTable[ind]
        table.insert(output,num)
    end
end

function Interpreter:add(arg)
    local s = string.sub(arg,1,1)
    if s == "=" then 
        local num = tonumber(string.sub(arg,2,#arg))
        memTable[0] = memTable[0] + num
    elseif s == "^" then 
        local ind1 = tonumber(string.sub(arg,2,#arg))
        local ind2 = memTable[ind1]
        local num = memTable[ind2]
        memTable[0] = memTable[0] + num
    else
        local ind = tonumber(arg)
        local num = memTable[ind]
        memTable[0] = memTable[0] + num
    end
end

function Interpreter:sub(arg)
    local s = string.sub(arg,1,1)
    if s == "=" then 
        local num = tonumber(string.sub(arg,2,#arg))
        memTable[0] = memTable[0] - num
    elseif s == "^" then 
        local ind1 = tonumber(string.sub(arg,2,#arg))
        local ind2 = memTable[ind1]
        local num = memTable[ind2]
        memTable[0] = memTable[0] - num
    else
        local ind = tonumber(arg)
        local num = memTable[ind]
        memTable[0] = memTable[0] - num
    end
end

function Interpreter:store(arg)
    local s = string.sub(arg,1,1)
    if s == "^" then 
        local ind1 = tonumber(string.sub(arg,2,#arg))
        local ind2 = memTable[ind1]
        memTable[ind2] = memTable[0]
    else
        local ind = tonumber(arg)
        memTable[ind] = memTable[0]
    end
end

function Interpreter:div(arg)
    local s = string.sub(arg,1,1)
    if s == "=" then 
        local num = tonumber(string.sub(arg,2,#arg))
        memTable[0] = math.floor(memTable[0]/num)
    elseif s == "^" then 
        local ind1 = tonumber(string.sub(arg,2,#arg))
        local ind2 = memTable[ind1]
        local num = memTable[ind2]
        memTable[0] = math.floor(memTable[0]/num)
    else
        local ind = tonumber(arg)
        local num = memTable[ind]
        memTable[0] = math.floor(memTable[0]/num)
    end
end

function Interpreter:mult(arg)
    local s = string.sub(arg,1,1)
    if s == "=" then 
        local num = tonumber(string.sub(arg,2,#arg))
        memTable[0] = memTable[0] * num
    elseif s == "^" then 
        local ind1 = tonumber(string.sub(arg,2,#arg))
        local ind2 = memTable[ind1]
        local num = memTable[ind2]
        memTable[0] = memTable[0] * num
    else
        local ind = tonumber(arg)
        local num = memTable[ind]
        memTable[0] = memTable[0] * num
    end
end

function Interpreter:jump(arg)
    return jumpTable[arg]
end

function Interpreter:jzero(arg)
    if memTable[0] == 0 then 
        return jumpTable[arg]
    end
    return nil
end

function Interpreter:jgtz(arg)
    if memTable[0] > 0 then 
        return jumpTable[arg]
    end
    return nil
end

function Interpreter:halt()
    return #tempCode + 1
end

function Interpreter:runCode(code)
    memTable = {}
    memTable[0] = 0
    jumpTable = {}
    for i, v in ipairs(code) do 
        if #v[1] ~= 0 and not jumpTable[v[1]] then 
            jumpTable[v[1]] = i 
        end
    end

    tempCode = code

    local it = 1
    while it <= #code and it >= 1 do 
        local fun = code[it][2]
        local arg = code[it][3]
        if #fun ~= 0 then
            local j = functions[fun](arg)
            if j then 
                it = j
            else
                it = it + 1
            end
        else
            it = it + 1
        end
    end
end

return Interpreter