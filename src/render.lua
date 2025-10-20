local Render = {}
Render.__index = Render

love.window.setMode(640, 640, { vsync = 0 })
windowWidth, windowHeight = love.graphics.getDimensions()
screenScale = 4

function Render:load()

end

return Render