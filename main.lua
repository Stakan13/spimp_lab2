local WIDTH, HEIGHT = 900, 600
local MAX_ITER = 150

local image
local zoom = 1.0
local offsetX = -0.5
local offsetY = 0.0

local function getColor(iter)
    if iter == MAX_ITER then
        return 0, 0, 0, 1
    end
    local t = iter / MAX_ITER
    local r = 0.5 + 0.5 * math.sin(6.28 * t + 0.0)
    local g = 0.5 + 0.5 * math.sin(6.28 * t + 2.1)
    local b = 0.5 + 0.5 * math.sin(6.28 * t + 4.2)
    return r, g, b, 1
end

local function render()
    local data = love.image.newImageData(WIDTH, HEIGHT)
    local scale = 3.0 / (zoom * WIDTH)

    for px = 0, WIDTH - 1 do
        for py = 0, HEIGHT - 1 do
            local cx = (px - WIDTH / 2) * scale + offsetX
            local cy = (py - HEIGHT / 2) * scale + offsetY

            local x, y = 0, 0
            local iter = 0

            while x * x + y * y <= 4 and iter < MAX_ITER do
                local xn = x * x - y * y + cx
                y = 2 * x * y + cy
                x = xn
                iter = iter + 1
            end

            data:setPixel(px, py, getColor(iter))
        end
    end

    image = love.graphics.newImage(data)
end

function love.load()
    love.window.setMode(WIDTH, HEIGHT)
    love.window.setTitle("Mandelbrot Set  |  scroll = zoom  |  drag = pan  |  R = reset")
    render()
end

function love.draw()
    if image then
        love.graphics.draw(image, 0, 0)
    end

    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.print(
        string.format("zoom: %.2fx   center: (%.4f, %.4f)", zoom, offsetX, offsetY),
        10, 10
    )
    love.graphics.setColor(1, 1, 1, 1)
end

function love.wheelmoved(_, dy)
    if dy > 0 then
        zoom = zoom * 1.3
    else
        zoom = zoom / 1.3
    end
    render()
end

local dragging = false
local dragStartX, dragStartY
local dragOffsetX, dragOffsetY

function love.mousepressed(x, y, btn)
    if btn == 1 then
        dragging = true
        dragStartX, dragStartY = x, y
        dragOffsetX, dragOffsetY = offsetX, offsetY
    end
end

function love.mousereleased(_, _, btn)
    if btn == 1 then
        dragging = false
    end
end

function love.mousemoved(x, y)
    if dragging then
        local scale = 3.0 / (zoom * WIDTH)
        offsetX = dragOffsetX - (x - dragStartX) * scale
        offsetY = dragOffsetY - (y - dragStartY) * scale
        render()
    end
end

function love.keypressed(key)
    if key == "r" then
        zoom = 1.0
        offsetX = -0.5
        offsetY = 0.0
        render()
    elseif key == "escape" then
        love.event.quit()
    end
end