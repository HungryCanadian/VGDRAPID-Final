local object = require "classic"
local Enemy = object:extend()

function Enemy:new(x, y, w, h, dx, dy)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.dx = dx
    self.dy = dy

    local types = { "asteroid", "planet", "meteor" }
    self.type = types[math.random(#types)]

    if self.type == "asteroid" then
        self.image = love.graphics.newImage("Assets/asteroid.png")
    elseif self.type == "planet" then
        self.image = love.graphics.newImage("Assets/planet.png")
    elseif self.type == "meteor" then
        self.image = love.graphics.newImage("Assets/meteor.png")
    end
end

function Enemy:setImage(imagePath)
    self.image = love.graphics.newImage(imagePath)
end

function Enemy:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- Bounce back if hitting screen edges
    if self.x < 0 or self.x + self.w > (love.graphics.getWidth() - 180) then
        self.dx = -self.dx
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
    local newType
    local children = {}

    if self.type == "planet" then
        newType = "meteor"
    elseif self.type == "meteor" then
        newType = "asteroid"
    else
        return children -- No splitting for asteroids
    end

    -- Create two new children with adjusted size and random velocities
    for i = 1, 2 do
        local dx = self.dx + math.random(-50, 50)
        local dy = self.dy + math.random(-50, 50)
        local child = Enemy(self.x, self.y, self.w / 2, self.h / 2, dx, dy, newType)
        table.insert(children, child)
    end

    return children
end

return Enemy