local Object = require "classic"
local Menu = Object:extend()
local Level = require "level"

local level = Level()

function Menu:new()
    self.options = {{text = "Start Game", action = 
    
    function() 
    self.playing = true 
    playing = true
    self.music:stop()
    self.startsfx:play() 

    end},
                    {text = "Exit", action = 
                    function() 
                        love.event.quit() 
                    end},
}

    self.font = love.graphics.newFont(24)
    self.buttonWidth = 250
    self.buttonHeight = 100
    self.buttonSpacing = 20
    self.startY = 350
    self.centerX = love.graphics.getWidth() / 2 - self.buttonWidth / 2
    self.playing = false
    self.backgroundImage = love.graphics.newImage("Assets/casteroids.png")
    self.music = love.audio.newSource("Assets/Audio/8bit.wav", "stream")
    self.music:setVolume(0.25)
    self.startsfx = love.audio.newSource("Assets/Audio/GameStart.mp3", "static")
    self.startsfx:setVolume(0.2)
end

function Menu:isMouseOverButton(x, y, buttonIndex)
    local buttonY = self.startY + (buttonIndex - 1) * (self.buttonHeight + self.buttonSpacing)
    return x >= self.centerX and x <= self.centerX + self.buttonWidth and
           y >= buttonY and y <= buttonY + self.buttonHeight
end

function Menu:mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        for i, _ in ipairs(self.options) do
            if self:isMouseOverButton(x, y, i) then
                self.options[i].action()
            end
        end
    end
end

function Menu:draw()
    if not self.music:isPlaying() then
        self.music:play()
    end
    love.graphics.clear(0.2, 0.2, 0.2)
    love.graphics.setFont(self.font)
    love.graphics.setColor(0.2,0.2,0.2)

    for i, item in ipairs(self.options) do
        local buttonY = self.startY + (i - 1) * (self.buttonHeight + self.buttonSpacing)

        local mx, my = love.mouse.getPosition()
        if self:isMouseOverButton(mx, my, i) then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end

        love.graphics.rectangle("fill", self.centerX, buttonY, self.buttonWidth, self.buttonHeight, 10)

        love.graphics.setColor(0, 0, 0) -- Black for text
        love.graphics.printf(item.text, self.centerX, buttonY + self.buttonHeight / 4, self.buttonWidth, "center")
    end
    love.graphics.setColor(1, 1, 1) -- White for text
    love.graphics.draw(self.backgroundImage, 0, 0, 0, 1.75, 1.35)
end


return Menu