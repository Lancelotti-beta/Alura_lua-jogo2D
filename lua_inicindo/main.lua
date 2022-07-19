
-- Load some default values for our rectangle.
function love.load()
    love.window.setMode(320, 480, { resizable = false})
    love.window.setTitle('SpaceNav')

    background = love.graphics.newImage('img/background.png')

    x, y, w, h = 20, 20, 60, 20
end

-- -- Increase the size of the rectangle every frame.
function love.update(dt)
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        y = y - 1
    end
    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        y = y + 1
    end
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        x = x - 1
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        x = x + 1
    end
end

-- -- Draw a coloured rectangle.
function love.draw()

    love.graphics.draw(background, 0, 0)
    love.graphics.circle("line", x, y, 15)
end


-- function love.draw()
--     love.graphics.print('Hello World!', 400, 300)
-- end
