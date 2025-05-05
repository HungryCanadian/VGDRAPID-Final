local Object = require "classic"
local Sidebar = Object:extend()

-- Sidebar dimensions
local background = love.graphics.newImage("Assets/panel.png")

local sidebarWidth= 200
local screenHeight = love.graphics.getHeight()
local margin = 10
local iconSize = 32
local fontSize = 20
local font = love.graphics.newFont("Assets/Stargazer.ttf", fontSize)

-- Load assets
local lifeIcon = love.graphics.newImage("Assets/life.png")
local powerUpIcons = {
    --speed = love.graphics.newImage("Assets/speed.png"),
    shield = love.graphics.newImage("Assets/shield.png"),
    --bomb = love.graphics.newImage("Assets/bomb.png")
}

-- Initialize player stats
Sidebar.playerStats = {
    lives = 3,
    score = 0,
    powerUps = {}
}

-- Update player stats
function Sidebar.updateLives(lives)
    sidebar.playerStats.lives = lives
end

function Sidebar.addScore(score)
    Sidebar.playerStats.score = score
end

function Sidebar.addPowerUp(powerUpType)
    table.insert(Sidebar.playerStats.powerUps, powerUpType)
end

function Sidebar.removePowerUp(powerUpType)
    for i, powerUp in ipairs(Sidebar.playerStats.powerUps) do
        if powerUp == powerUpType then
            table.remove(Sidebar.playerStats.powerUps, i)
            break
        end
    end
end

-- Draw the sidebar
function Sidebar.draw()
    -- Sidebar background
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.rectangle("fill", love.graphics.getWidth() - sidebarWidth, 0, sidebarWidth, screenHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(background, love.graphics.getWidth() - sidebarWidth, 0, 0, 0.51, 0.72)
    

    -- Reset color
    love.graphics.setColor(1, 1, 1)

    -- Draw lives
    love.graphics.setFont(love.graphics.newFont("Assets/Stargazer.ttf", fontSize))
    love.graphics.setColor(1, 0, 0)
    love.graphics.print("Lives:", love.graphics.getWidth() - sidebarWidth + margin, margin)
    love.graphics.setColor(1, 1, 1)

    for i = 0, Sidebar.playerStats.lives - 1 do
        love.graphics.draw(
            lifeIcon,
            love.graphics.getWidth() - sidebarWidth + margin + (i * (iconSize + 5)),
            margin + 30,
            0,
            1,
            1
        )
    end

    -- Draw score
    love.graphics.print(
        "Score: " .. Sidebar.playerStats.score,
        love.graphics.getWidth() - sidebarWidth + margin,
        margin + 70
    )

    -- Draw power-ups
    love.graphics.print("Power-ups:", love.graphics.getWidth() - sidebarWidth + margin, margin + 120)

    for i, powerUp in ipairs(Sidebar.playerStats.powerUps) do
        local icon = powerUpIcons[powerUp]
        if icon then
            love.graphics.draw(
                icon,
                love.graphics.getWidth() - sidebarWidth + margin + ((i - 1) * (iconSize + 5)),
                margin + 150,
                0,
                1,
                1
            )
        end
    end
end

function Sidebar.update(dt)

end
return Sidebar
