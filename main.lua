if arg[2] == "debug" then
    require("lldebugger").start()
end

local Menu = require "menu"
local Sidebar = require "sidebar"
local Level = require "level"
local Player = require "player"


function love.load()
    love.window.setTitle("Caspiran Asteroids")
    menu = Menu()
    sidebar = Sidebar()
    level = Level()
    player = Player()
end

function love.draw()
    if menu.playing then
        level:draw()
        sidebar:draw()
        player:draw()
    else
        menu:draw()
    end

end

function love.update(dt)
    if menu.playing then
        level:update(dt)
        player:update(dt)
        for _, bullet in ipairs(bullets) do
            bullet:update(dt)
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    menu:mousepressed(x, y, button, istouch, presses)
    level:mousepressed(x, y, button, istouch, presses)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" and menu.playing then
        player:keypressed(key, scancode, isrepeat)
    end

    if key == "escape" then
        love.event.quit()
    end
end


local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

