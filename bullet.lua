local Object = require("classic")
local Bullet = Object:extend()

function Bullet:new(x, y, angle)
    
    self.image = love.graphics.newImage("Assets/laserRed.png")
    self.x = x
    self.y = y
    self.angle = angle or -math.pi / 2 
    self.speed = 350

    self.w = self.image:getWidth()
    self.h = self.image:getHeight()
    self.dead = false
end

function Bullet:checkCollision(objects)
    for i, obj in ipairs(objects) do
        local a_left = self.x - self.w / 2
        local a_right = self.x + self.w / 2
        local a_top = self.y - self.h / 2
        local a_bottom = self.y + self.h / 2

        local b_left = obj.x
        local b_right = obj.x + obj.w
        local b_top = obj.y
        local b_bottom = obj.y + obj.h

        if a_right > b_left and 
           a_left < b_right and 
           a_bottom > b_top and 
           a_top < b_bottom then
            self.dead = true

            return true, i
        end
    end
    return false
end

function Bullet:update(dt)
    local dx = math.cos(self.angle - math.rad(90)) * self.speed * dt
    local dy = math.sin(self.angle - math.rad(90)) * self.speed * dt
    self.x = self.x + dx
    self.y = self.y + dy

    local screenW = love.graphics.getWidth() - 200
    local screenH = love.graphics.getHeight()

    if self.x < 0 or self.x > screenW or self.y < 0 or self.y > screenH then
        self.dead = true
    end
end

function Bullet:draw()

    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        self.angle - math.rad(90) - math.pi / 2,
        1,
        1,
        self.w / 2,
        self.h / 2
    )
end

return Bullet