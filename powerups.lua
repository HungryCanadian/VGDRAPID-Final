local Object = require "classic"
local PowerUps = Object:extend()

local powerUpIcons = {
    spread = love.graphics.newImage("Assets/spread.png"),
    shield = love.graphics.newImage("Assets/shield.png"),
    bomb = love.graphics.newImage("Assets/bomb.png")
}

local activePowerUps = {}

local iconSize = 32

function PowerUps:spawn(type, x, y)
    table.insert(activePowerUps, {
        type = type,
        x = x,
        y = y,
        width = iconSize,
        height = iconSize,
        timer = 5,
        flashing = false
    })
end

function PowerUps:getIcon(type)
    return powerUpIcons[type]
end

function PowerUps:update(dt)

end

function PowerUps:draw()
    for _, powerUp in ipairs(activePowerUps) do
        local icon = powerUpIcons[powerUp.type]
        if icon then
                love.graphics.draw(icon, powerUp.x, powerUp.y, 0, 0.5, 0.5)
            end
        end
end

function PowerUps:checkCollision(player)
    for i = #activePowerUps, 1, -1 do
        local powerUp = activePowerUps[i]
        if player.x < powerUp.x + powerUp.width and
           player.x + player.w > powerUp.x and
           player.y < powerUp.y + powerUp.height and
           player.y + player.h > powerUp.y then
            -- Trigger player power-up logic
            sidebar:addPowerUp(powerUp.type)
            player:togglePowerUp(powerUp.type)
            table.remove(activePowerUps, i)
        end
    end
end

return PowerUps
