local Object = require("classic")
local Player = Object:extend()
local Bullet = require("bullet")
local Level = require("level")

function Player:new()
    self.image = love.graphics.newImage("Assets/player.png")
    self.shieldImage = love.graphics.newImage("Assets/shield.png")
    self.x = 100
    self.y = 300
    self.w = 32
    self.h = 32
    self.speed= 100
    self.rotation = 0
    self.dx = 0
    self.dy = 0
    self.lives = 3
    self.invulnerable = false 
    self.flickerTime = 0
    self.flickerCount = 0
    self.spread = false
    self.shield = false
    self.spreadTimer = 0
    self.shieldTimer = 0
    self.bulletsfx = love.audio.newSource("Assets/Audio/Fire.wav", "static" )
    self.bulletsfx:setVolume(0.3)
end

function Player:load()
    level = Level()
end

function Player:update(dt)

    if self.spread then
        self.spreadTimer = self.spreadTimer - dt
        if self.spreadTimer <= 0 then
            self.spread = false
        end
    end

    if self.shield then
        self.shieldTimer = self.shieldTimer - dt
        if self.shieldTimer <= 0 then
            self.shield = false
        end
    end
 if not self.shield then
    self:checkCollisions()
 end
 self.dx = 0
 self.dy = 0
 if love.keyboard.isDown("a") then
     self.dx = -self.speed
 elseif love.keyboard.isDown("d") then
     self.dx = self.speed
 end
 if love.keyboard.isDown("w") then
         self.dy = -self.speed
 elseif love.keyboard.isDown("s") then
         self.dy = self.speed
 end

 -- Update player position
 self.x = self.x + self.dx * dt
 self.y = self.y + self.dy * dt

 if self.invulnerable then
     self.flickerTime = self.flickerTime + dt

     -- Toggle visibility every 0.1 seconds
     if self.flickerTime >= 0.2 then
         self.flickerTime = 0
         self.flickerCount = self.flickerCount + 1

         -- Stop invulnerability after 3 flickers
         if self.flickerCount >= 6 then -- 3 on-off cycles
             self.invulnerable = false
         end
     end
 end

 local mouseX, mouseY = love.mouse.getPosition()
 self.rotation = math.atan2(mouseY - self.y, mouseX - self.x) + math.rad(90)

 local windowWidth = love.graphics.getWidth()
 local windowHeight = love.graphics.getHeight()

    if self.x < 0 then
    self.x = 0
    elseif self.x + self.w > windowWidth -200 then
    self.x = windowWidth - 200 - self.w
    end
    if self.y < 0 then
        self.y = 0
        elseif self.y + self.h > windowHeight then
        self.y = windowHeight - self.h
        end
end

function Player:playSfx()
    local sound = self.bulletsfx:clone() -- Clone the original source
    sound:play() -- Play the cloned source
end

function Player:draw()
    if self.shield then 
        love.graphics.draw(
            self.shieldImage,
            self.x + self.w / 2,
            self.y + self.h / 2,
            self.rotation,
            0.5, 0.5,
            self.shieldImage:getWidth() / 2,
            self.shieldImage:getHeight() / 2
        )
    end
    if self.invulnerable and self.flickerCount % 2 == 0 then
        love.graphics.setColor(1, 1, 1, 0.5) -- Semi-transparent color
    else
        love.graphics.setColor(1, 1, 1, 1) -- Normal color
    end
    love.graphics.draw(
        self.image,
        self.x + self.w / 2,
        self.y + self.h / 2,
        self.rotation,
        0.45, 0.45,
        self.image:getWidth() / 2,
        self.image:getHeight() / 2
    )
    love.graphics.setColor(1, 1, 1, 1) -- Reset to default color
end

function Player:togglePowerUp(powerUpType)
    if powerUpType == "spread" then
        self.spread = true
        self.spreadTimer = 5
    elseif powerUpType == "shield" then
        self.shield = true
        self.shieldTimer = 5
    end
end


function Player:keypressed(key)
    if key == "space" then
        local spawnX = self.x + self.w / 2
        local spawnY = self.y + self.h / 2

        if not bullets then
            print("Error: Bullets table is nil!")
            return
        end
        player:playSfx()
        table.insert(bullets, Bullet(spawnX, spawnY, self.rotation))
        if self.spread then
            table.insert(bullets, Bullet(spawnX, spawnY, self.rotation + math.rad(5)))
            table.insert(bullets, Bullet(spawnX, spawnY, self.rotation - math.rad(5)))
        end
    end
end

function Player:checkCollisions()
    local enemies = level:getEnemies()
    if not enemies then
        print("Error: Enemies table is nil")
        return
    end
    for _, enemy in ipairs(enemies) do
        if self.x < enemy.x + enemy.w and
           self.x + self.w > enemy.x and
           self.y < enemy.y + enemy.h and
           self.y + self.h > enemy.y then
            self:playerHit()
        end
    end
end

function Player:playerHit()

    if not self.invulnerable then
        self.invulnerable = true
        self.flickerTime = 0
        self.flickerCount = 0

    self.lives = self.lives - 1 
    sidebar:updateLives(self.lives)

        if self.lives <= 0 then
            print("Game Over")
            -- put game over stuff here
        end
    end
end


return Player