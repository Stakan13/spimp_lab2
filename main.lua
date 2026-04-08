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

