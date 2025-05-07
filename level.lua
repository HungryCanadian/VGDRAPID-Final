local object = require "classic"
local Level = object:extend()
local Sidebar = require "sidebar"
local Enemy = require "enemy"

-- Assets
local background = love.graphics.newImage("Assets/Background.png")
local startlevelsfx = love.audio.newSource("Assets/Audio/GameStart.mp3", "static")
local music = love.audio.newSource("Assets/Audio/6.ogg", "stream")

enemies = {}
local spawnTimer = 0
local spawnInterval = 2

-- Initialize level
function Level.load()
    sidebar = Sidebar()
    sidebar.spawnPowerUp("spread", 100, 100)
    sidebar.spawnPowerUp("bomb", 200, 200)
    sidebar.spawnPowerUp("shield", 300, 300)
end

function Level:getEnemies()
    return enemies
end

function Level:update(dt)
    -- Ensure music is playing
    if not music:isPlaying() then
        music:play()
    end

    -- Spawn new enemies based on timer
    spawnTimer = spawnTimer + dt
    if spawnTimer >= spawnInterval then
        -- Reset spawn timer and spawn a new enemy
        spawnTimer = spawnTimer - spawnInterval
        local spawnX = math.random(0, love.graphics.getWidth())
        local spawnY = math.random(0, love.graphics.getHeight())
        local speedX = math.random(-100, 100)
        local speedY = math.random(-100, 100)

        -- Add new enemy to the list
        table.insert(enemies, Enemy(spawnX, spawnY, 64, 64, speedX, speedY))
    end

    -- Update enemies
    for _, enemy in ipairs(enemies) do
        enemy:update(dt)
    end

    -- Handle bullets and enemy collisions
    for i = #table_of_bullets, 1, -1 do
        local bullet = table_of_bullets[i]
        bullet:update(dt)

        -- Check for collisions with enemies
        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            if enemy:checkCollision(bullet) then
                -- Split enemy into children
                local children = enemy:split()
                for _, child in ipairs(children) do
                    table.insert(enemies, child)
                end
                table.remove(enemies, j)
                table.remove(table_of_bullets, i)
            end
        end

        -- Remove bullet if marked as dead
        if bullet.dead then
            table.remove(table_of_bullets, i)
        end
    end

    -- Update the sidebar
    sidebar:update(dt)
end

function Level:draw()
    -- Draw background
    love.graphics.draw(background, 0, 0, 0, 1, 0.4)

    -- Draw enemies
    for i , enemy in ipairs(enemies) do
        enemy:draw()
    end
end

return Level