local object = require "classic"
local Level = object:extend()
local Sidebar = require "sidebar"


-- Assets
local background = love.graphics.newImage("assets/Background.png")
local playerImage = love.graphics.newImage("assets/player.png")
local enemyImage = love.graphics.newImage("assets/asteroid.png")
local enemyImage1 = love.graphics.newImage("assets/meteor.png")
local enemyImage2 = love.graphics.newImage("assets/planet.png")

-- Entities
local player = {
    x = 100,
    y = 300,
    width = 32,
    height = 32,
    speed = 75,
    rotation = 0,
    dx = 0,
    dy = 0,
    lives = 3,
    invulnerable = false,
    flickerTime = 0,
    flickerCount = 0 
}

local enemies = {
    {
        x = 200,
        y = 200,
        width = 64,
        height = 64,
        speed = 0,
        dx = 250,
        dy = 0,
    }
}

-- Initialize level
function Level.load()
sidebar = Sidebar()
end

-- Update level
function Level:update(dt)
    -- Player movement
    player.dx = 0
    player.dy = 0
    if love.keyboard.isDown("a") then
        player.dx = -player.speed
    elseif love.keyboard.isDown("d") then
        player.dx = player.speed
    end
    if love.keyboard.isDown("w") then
            player.dy = -player.speed
    elseif love.keyboard.isDown("s") then
            player.dy = player.speed
    end

    -- Update player position
    player.x = player.x + player.dx * dt
    player.y = player.y + player.dy * dt

    if player.invulnerable then
        player.flickerTime = player.flickerTime + dt

        -- Toggle visibility every 0.1 seconds
        if player.flickerTime >= 0.2 then
            player.flickerTime = 0
            player.flickerCount = player.flickerCount + 1

            -- Stop invulnerability after 3 flickers
            if player.flickerCount >= 6 then -- 3 on-off cycles
                player.invulnerable = false
            end
        end
    end

    local mouseX, mouseY = love.mouse.getPosition()
    player.rotation = math.atan2(mouseY - player.y, mouseX - player.x) + math.rad(90)

    -- Update enemies
    for _, enemy in ipairs(enemies) do
        enemy.x = enemy.x + enemy.dx * dt
        if enemy.x < 0 or enemy.x + enemy.width > (love.graphics.getWidth() - 180 ) then
            enemy.dx = -enemy.dx
        end
    end

    -- Check for collisions
    if self:checkCollisions() then
        -- Handle collision (e.g., reset player position, reduce health, etc.)
        print("Collision detected!")
        player.x = 350
        player.y = 400
        player.lives = player.lives - 1
    end
end

-- Draw level
function Level.draw()
    -- Draw background
    love.graphics.draw(background, 0, 0, 0, 1, 0.4)
    -- Draw player
    if player.invulnerable and player.flickerCount % 2 == 0 then
        love.graphics.setColor(1, 1, 1, 0.5) -- Semi-transparent color
    else
        love.graphics.setColor(1, 1, 1, 1) -- Normal color
    end
    love.graphics.draw(
        playerImage,
        player.x + player.width / 2,
        player.y + player.height / 2,
        player.rotation,
        0.45, 0.45,
        playerImage:getWidth() / 2,
        playerImage:getHeight() / 2
    )

    -- Draw enemies
    for _, enemy in ipairs(enemies) do
        love.graphics.draw(enemyImage, enemy.x, enemy.y)
    end
end

-- Check if the player collides with an enemy
function Level:checkCollisions()
    for _, enemy in ipairs(enemies) do
        if player.x < enemy.x + enemy.width and
           player.x + player.width > enemy.x and
           player.y < enemy.y + enemy.height and
           player.y + player.height > enemy.y then
            self:playerHit()
        end
    end
    return false
end

function Level:playerHit()

    if not player.invulnerable then
        -- Trigger invulnerability and flickering
        player.invulnerable = true
        player.flickerTime = 0
        player.flickerCount = 0

    player.lives = player.lives - 1 
    sidebar.updateLives(player.lives)

        if player.lives <= 0 then
            print("Game Over") -- Handle game over logic
        end
    end
end

return Level
