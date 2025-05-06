local object = require "classic"
local Level = object:extend()
local Sidebar = require "sidebar"


-- Assets
local background = love.graphics.newImage("Assets/Background.png")
local enemyImage = love.graphics.newImage("Assets/asteroid.png")
local enemyImage1 = love.graphics.newImage("Assets/meteor.png")
local enemyImage2 = love.graphics.newImage("Assets/planet.png")
local startlevelsfx = love.audio.newSource("Assets/Audio/GameStart.mp3", "static")
local music = love.audio.newSource("Assets/Audio/6.ogg", "stream")

local enemies = {
    {
        x = 200,
        y = 200,
        w = 64,
        h = 64,
        speed = 0,
        dx = 250,
        dy = 0,
    }
}

-- Initialize level
function Level.load()
    sidebar = Sidebar()
end

function Level:getEnemies()
    return enemies
end


    function Level:update(dt)
        if not music:isPlaying() then
            music:play()
        end
    for _, enemy in ipairs(enemies) do
            enemy.x = enemy.x + enemy.dx * dt
            if enemy.x < 0 or enemy.x + enemy.w > (love.graphics.getWidth() - 180) then
                enemy.dx = -enemy.dx
            end
        end
    
        -- Handle bullets and enemy collisions
        for i = #table_of_bullets, 1, -1 do
            local bullet = table_of_bullets[i]
            bullet:update(dt)
    
            -- Check for collisions with enemies
            local hit, enemyIndex = bullet:checkCollision(enemies)
            if hit then
                table.remove(enemies, enemyIndex)
                table.remove(table_of_bullets, i)
            elseif bullet.dead then
                table.remove(table_of_bullets, i)
        end
    end
end

-- Draw level
function Level.draw()
    -- Draw background
    love.graphics.draw(background, 0, 0, 0, 1, 0.4)
    -- Draw enemies
    for _, enemy in ipairs(enemies) do
        love.graphics.draw(enemyImage, enemy.x, enemy.y)
    end
end

return Level
