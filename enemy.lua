local object = require "classic"
local Enemy = object:extend()

function Enemy:new(x, y, dx, dy)
    self.x = x
    self.y = y
    self.dx = dx
    self.dy = dy

    local types = { "asteroid", "meteor" }
    self.type = types[math.random(#types)]

    if self.type == "asteroid" then
        self.image = love.graphics.newImage("Assets/asteroid.png")
    elseif self.type == "meteor" then
        self.image = love.graphics.newImage("Assets/meteor.png")
    end

    self.w = self.image:getWidth()
    self.h = self.image:getHeight()
end

function Enemy:setImage(imagePath)
    self.image = love.graphics.newImage(imagePath)
    self.w = self.image:getWidth()
    self.h = self.image:getHeight()
end

function Enemy:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- Bounce back if hitting screen edges
    if self.x < 0 or self.x + self.w > (love.graphics.getWidth() - 180) then
        self.dx = -self.dx
    elseif self.y < 0 or self.y + self.h > (love.graphics.getHeight()) then
        self.dy = -self.dy
    end
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Enemy:checkCollision(bullet)
    return bullet.x < self.x + self.w and
           bullet.x + bullet.w > self.x and
           bullet.y < self.y + self.h and
           bullet.y + bullet.h > self.y
end

function Enemy:split()
    if self.type ~= "meteor" then
        print("Cannot split non-meteor enemy: " .. self.type)
        return {}
    end

    local asteroids = {}
    print("Splitting meteor into smaller asteroids")
    
    for i = 1, 2 do
        local dx = self.dx + math.random(-50, 50)
        local dy = self.dy + math.random(-50, 50)
        local asteroid = Enemy(self.x, self.y, dx, dy)
        
        asteroid.type = "asteroid"
        asteroid:setImage("Assets/asteroid.png")
        
        table.insert(asteroids, asteroid)
    end

    return asteroids
end

return Enemy