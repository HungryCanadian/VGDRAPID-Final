local Object = require "classic"
local PowerUps = require "powerups"
local Sidebar = Object:extend()

-- Sidebar dimensions
local background = love.graphics.newImage("Assets/sidebartest.png")

local sidebarWidth = 200
local screenHeight = love.graphics.getHeight()
local margin = 10
local iconSize = 32
local fontSize = 20

-- Load assets
local lifeIcon = love.graphics.newImage("Assets/life.png")

-- Initialize player stats
Sidebar.playerStats = {
    lives = 3,
    highscore = 1337,
    score = 0,
    powerUps = {} 
}

-- Create an instance of PowerUps
local powerUps = PowerUps()

function Sidebar:new()

end

function Sidebar:update(dt)
    powerUps:update(dt)
    powerUps:checkCollision(player)

    if self.playerStats.score >= self.playerStats.highscore then
        self.playerStats.highscore = self.playerStats.score
    end

    -- Update sidebar power-ups
    for i = #Sidebar.playerStats.powerUps, 1, -1 do
        local powerUp = Sidebar.playerStats.powerUps[i]

        -- Decrease the timer
        powerUp.timer = powerUp.timer - dt

        -- Start flashing when there's 1 second left
        if powerUp.timer <= 1 then
            powerUp.flashing = true
        end

        -- Remove the power-up if the timer reaches 0
        if powerUp.timer <= 0 then
            table.remove(Sidebar.playerStats.powerUps, i)
        end
    end
end

function Sidebar:updateLives(lives)
    if type(lives) == "number" and lives >= 0 then
        Sidebar.playerStats.lives = lives
    end
end

function Sidebar:addScore(score)
    Sidebar.playerStats.score = Sidebar.playerStats.score + score

    print("Score: " .. Sidebar.playerStats.score)

    if Sidebar.playerStats.score % 1000 == 0 then
        self:updateLives(Sidebar.playerStats.lives + 1)
    end
end

function Sidebar:addPowerUp(powerUpType)
    table.insert(Sidebar.playerStats.powerUps, {
        type = powerUpType,
        timer = 5, -- Timer for sidebar display
        flashing = false
    })
end

function Sidebar:removePowerUp(powerUpType)
    for i, powerUp in ipairs(Sidebar.playerStats.powerUps) do
        if powerUp.type == powerUpType then
            table.remove(Sidebar.playerStats.powerUps, i)
            break
        end
    end
end

function Sidebar:draw()
    love.graphics.draw(background, love.graphics.getWidth() - sidebarWidth, 0, 0, 0.51, 0.72)

    -- Draw lives
    love.graphics.setFont(love.graphics.newFont(fontSize))
    for i = 0, Sidebar.playerStats.lives - 1 do
        love.graphics.draw(lifeIcon, love.graphics.getWidth() - 175 + (i * (iconSize + 5)), 370, 0, 1, 1)
    end

    -- Draw score
    love.graphics.print(Sidebar.playerStats.highscore, love.graphics.getWidth() - 130,  60)
    love.graphics.print(Sidebar.playerStats.score, love.graphics.getWidth() - 130,  200)

    -- Draw power-ups
    love.graphics.print("Power-ups:", love.graphics.getWidth() - sidebarWidth + margin, 450, 0, 1, 1)
    for i, powerUp in ipairs(Sidebar.playerStats.powerUps) do
        local icon = powerUps:getIcon(powerUp.type)
        if icon then
            if powerUp.flashing then
                if math.floor(powerUp.timer * 10) % 2 == 0 then
                    love.graphics.draw(icon, love.graphics.getWidth() - sidebarWidth + margin + ((i - 1) * (iconSize + 15)), 475, 0, 0.5, 0.5)
                end
            else
                love.graphics.draw(icon, love.graphics.getWidth() - sidebarWidth + margin + ((i - 1) * (iconSize + 15)), 475, 0, 0.5, 0.5)
            end
        end
    end

    powerUps:draw()
end


return Sidebar