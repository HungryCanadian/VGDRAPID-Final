if arg[2] == "debug" then
    require("lldebugger").start()
end

local Menu = require "menu"
local Sidebar = require "sidebar"
local Level = require "level"


function love.load()
    menu = Menu()
    sidebar = Sidebar()
    level = Level()
end

function love.draw()
    if menu.playing then
        level:draw()
        sidebar:draw()
    else
        menu:draw()
        
    end

end

function love.update(dt)
    if menu.playing then
        level:update(dt)
        --sidebar:update(dt)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    menu:mousepressed(x, y, button, istouch, presses)
end


local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

