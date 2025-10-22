local Canvas = {}
Canvas.__index = Canvas

SORT = {
    VERTICAL_LEFT = 0,
    VERTICAL_MIDDLE = 1,
    VERTICAL_RIGHT = 2,
    HORIZONTAL_DOWN = 3,
    HORIZONTAL_MIDDLE = 4,
    HORIZONTAL_UP = 5
}

--Canvas is used as a "parent" to buttons allowing to move them, disable them, and space them
function Canvas:new(x,y,sx,sy,positions,children)
    local self = setmetatable({}, Canvas)
    self.x, self.y = x, y
    self.targetPosX, self.targetPosY = self.x, self.y
    self.onPos = positions.onPos 
    self.offPos = positions.offPos
    self.size = { x = sx, y = sy }
    self.sortType = sortType
    self.children = children
    return self 
end

function Canvas:update(dt,mx,my,clicked)
    local speed = 3
    local vel = { 
        x = (self.targetPosX - self.x) * dt * speed,
        y = (self.targetPosY - self.y) * dt * speed
    }
    if vel.x*vel.x < 0.000001 then vel.x = 0 end 
    if vel.y*vel.y < 0.000001 then vel.y = 0 end 
    self.x = self.x + vel.x  
    self.y = self.y + vel.y  
    for i, child in ipairs(self.children) do 
        if vel.x ~= 0 or vel.y ~= 0 then 
            child.enabled = false
        else
            child.enabled = true 
        end
        child.relativePos = { x = self.x, y = self.y }
        child:update(dt,mx,my,clicked)
    end
end

function Canvas:draw()
    for _, child in ipairs(self.children) do 
        child:draw()
    end
end

return Canvas