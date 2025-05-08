local object = require "classic"
local Level = object:extend()
local Sidebar = require "sidebar"
local Enemy = require "enemy"
local PowerUps = require "powerups"

-- Assets
local background = love.graphics.newImage("Assets/Background.png")
local music = love.audio.newSource("Assets/Audio/6.ogg", "stream")


local gameState = "playing"


enemies = {}
bullets = {}
powerUps = PowerUps()
local spawnTimer = 0
local spawnInterval = 0.75

-- Initialize level
function Level.load()
    sidebar = Sidebar()
end

function Level:getEnemies()
    return enemies
end

local function spawnEnemy()
    local spawnX = math.random(0, love.graphics.getWidth())
    local spawnY = math.random(0, love.graphics.getHeight())
    local speedX = math.random(-100, 100)
    local speedY = math.random(-100, 100)
    table.insert(enemies, Enemy(spawnX, spawnY, speedX, speedY))
end


local function handleCollisions(dt)
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet:update(dt)

        for j = #enemies, 1, -1 do
            local enemy = enemies[j]
            if enemy:checkCollision(bullet) then
                local scoreIncrement = 0
                if enemy.type == "meteor" then
                    scoreIncrement = 25
                elseif enemy.type == "asteroid" then
                    scoreIncrement = 10
                end
                sidebar:addScore(scoreIncrement)
                
                local children = enemy:split()
                for i, child in ipairs(children) do
                    table.insert(enemies, child)
                end

                -- Chance to spawn a power-up
                if math.random() < 0.05 then -- 5% chance
                    local powerUpTypes = { "spread", "shield" }
                    local powerUpType = powerUpTypes[math.random(#powerUpTypes)]
                    powerUps:spawn(powerUpType, enemy.x + enemy.w / 2, enemy.y + enemy.h / 2)
                end

                -- Remove the enemy and bullet
                table.remove(enemies, j)
                table.remove(bullets, i)
                break
            end
        end

        if bullet.dead then
            table.remove(bullets, i)
        end
    end
end

-- Check if player has lost all lives
local function checkGameOver()
    if player.lives <= 0 then
        gameState = "gameover"
    end
end

function Level:update(dt)
    if gameState == "playing" then
        if not music:isPlaying() then
            music:play()
        end

        -- Spawn enemies at intervals
        spawnTimer = spawnTimer + dt
        if spawnTimer >= spawnInterval then
            spawnTimer = spawnTimer - spawnInterval
            spawnEnemy()
        end

        -- Update enemies and check for collisions
        for i , enemy in ipairs(enemies) do
            enemy:update(dt)
        end

        handleCollisions(dt)
        sidebar:update(dt)

        checkGameOver()
    end
end

function Level:draw()
    if gameState == "playing" then
        love.graphics.draw(background, 0, 0, 0, 1, 0.4)

        for _, enemy in ipairs(enemies) do
            enemy:draw()
        end

        sidebar:draw()

        for _, bullet in ipairs(bullets) do
            bullet:draw()
        end
    elseif gameState == "gameover" then
        self:drawGameOver()
    end
end


-- Draw the Game Over screen with options to retry or quit
function Level:drawGameOver()
    if gameState == "gameover" then

    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    -- Draw a semi-transparent background
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, width, height)

    -- Draw the "Game Over" text
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(love.graphics.newFont(48))
    love.graphics.printf("Game Over", 0, height / 3, width, "center")

    -- Draw Retry Button
    love.graphics.setColor(0, 1, 0, 0.4)  -- Green button color
    love.graphics.rectangle("fill", 100, 400, 200, 50)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.printf("Retry", 100, 415, 200, "center")

    -- Draw Quit Button
    love.graphics.setColor(1, 0, 0, 0.4)  -- Red button color
    love.graphics.rectangle("fill", 100, 500, 200, 50)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Quit", 100, 515, 200, "center")
    end
end

-- Check for mouse clicks on the Game Over screen buttons
function Level:mousepressed(x, y, button, istouch, presses)
    if gameState == "gameover" then
        if x >= 100 and x <= 300 and y >= 400 and y <= 450 then
            -- Retry button clicked
            self:resetGame()
        elseif x >= 100 and x <= 300 and y >= 500 and y <= 550 then
            -- Quit button clicked
            love.event.quit()
        end
    end
end

-- Reset the game to start a new round
function Level:resetGame()
    music:stop()
    playerLives = 3
    sidebar.playerStats.lives = playerLives
    player.lives = playerLives
    sidebar.playerStats.score = 0

    enemies = {}
    bullets = {}

 menu.playing = false
 gameState = "playing"
end

return Level
