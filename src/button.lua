local Button = {}
Button.__index = Button

local STATE = {
    IDLE = 0,
    HOVER = 1,
    CLICK = 2,
    HOLD = 3
}

local TEMPLATE = {
    ["SIDE"] = {
        spriteIndex = 1,
        size = { x = windowWidth/10, y = windowHeight/4 }
    }
}

local function getTemplate(index,variation)
    local toReturn = TEMPLATE[index]
    toReturn.sprite = love.graphics.newImage('assets/button'..tostring(toReturn.spriteIndex)..tostring(variation)..".png")
    return toReturn
end

function Button:new(x,y,template,callbacks)
    local self = setmetatable({}, Button)

    self.x = x
    self.y = y 

    local templateData = getTemplate(template.index,template.variation or '')
    self.size = templateData.size
    self.sprite = templateData.sprite

    self.state = STATE.IDLE
    self.callbacks = {
        onIdle = callbacks.onIdle or nil,
        offIdle = callbacks.offIdle or nil,
        onHover = callbacks.onHover or nil,
        offHover = callbacks.offHover or nil,
        onClick = callbacks.onClick or nil,
        offClick = callbacks.offClick or nil,
        onHold = callbacks.onHold or nil,
        offHold = callbacks.offHold or nil
    }

    table.insert(buttons, self)
    return self
end

function Button:update(dt, mx, my)
    self:updateState(dt, mx, my)
end

function Button:setState(state)
    if self.state == STATE.IDLE and self.callbacks.offIdle then 
        self.callbacks.offIdle()
    elseif self.state == STATE.HOVER and self.callbacks.offHover then
        self.callbacks.offHover()
    elseif self.state == STATE.CLICK and self.callbacks.offClick then 
        self.callbacks.offClick()
    elseif self.state == STATE.HOLD and self.callbacks.offHold then 
        self.callbacks.offHold()
    end
    self.state = STATE[state]
    if self.state == STATE.IDLE and self.callbacks.onIdle then 
        self.callbacks.onIdle()
    elseif self.state == STATE.HOVER and self.callbacks.onHover then
        self.callbacks.onHover()
    elseif self.state == STATE.CLICK and self.callbacks.onClick then
        self.callbacks.onClick()
    elseif self.state == STATE.HOLD and self.callbacks.onHold then 
        self.callbacks.onHold()
    end
end

function Button:onMouseClick()
    if self.state == STATE.HOVER then 
        self:setState("CLICK")
    end
end

function Button:updateState(dt, mx, my, clicked)
    if self.state == STATE.IDLE then
        --do an AABB check
        local isAABB = self:checkAABB(mx, my)
        if isAABB then 
            self:setState("HOVER")
            return
        end
    elseif self.state == STATE.HOVER then
        local isAABB = self:checkAABB(mx, my)
        if not isAABB then 
            self:setState("IDLE")
            return
        end
        if clicked then 
            self:setState("CLICK")
        end
    elseif self.state == STATE.CLICK then 
        self:setState("HELD")
    elseif self.state == STATE.HELD then
        local isAABB = self:checkAABB(mx, my)
        if not clicked or not isAABB then
            self:setState("IDLE")
        end
    end
end

function Button:checkAABB(mx, my)
    return (
        mx > self.x and 
        mx < self.x + self.size.x and 
        my > self.y and 
        my < self.y + self.size.y
    )
end

function Button:draw()
    if self.state == STATE.HOVER then 
        love.graphics.setColor(0.8,0.8,0.8,1)
    else 
        love.graphics.setColor(1,1,1,1)
    end
    love.graphics.draw(
        self.sprite,
        self.x,
        self.y,
        nil,
        screenScale,
        screenScale
    )
    -- debug
    love.graphics.setColor(1, 1, 1, 1)
    if not debugDraw then return end
    love.graphics.print(
        tostring(self.state),
        self.x + 8,
        self.y + 8
    )
    love.graphics.setColor(1,1,1,1)
end


return Button