
ALTURA_DA_TELA = 480
LARGURA_DA_TELA = 320


nave = {
    src = 'img/14bis.png',
    altura = 64,
    largura = 64,
    x = LARGURA_DA_TELA/2 - 64/2,
    y = ALTURA_DA_TELA - 70
}


function moveNaveDoJogador()
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        nave.y = nave.y - 1
    end
    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        nave.y = nave.y + 1
    end
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        nave.x = nave.x - 1
    end
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        nave.x = nave.x + 1
    end
end

function love.load()
    love.window.setMode(LARGURA_DA_TELA, ALTURA_DA_TELA, { resizable = false})
    love.window.setTitle('SpaceNav')

    background = love.graphics.newImage('img/background.png')
    nave.imagem = love.graphics.newImage(nave.src)

end

-- -- Increase the size of the rectangle every frame.
function love.update(dt)
    if love.keyboard.isDown('a', 'w', 's', 'd') or love.keyboard.isDown('up', 'left', 'down', 'right') then
        moveNaveDoJogador()
    end

end

-- -- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(nave.imagem, nave.x, nave.y)

    --love.graphics.circle("line", x, y, 15)
end


-- function love.draw()
--     love.graphics.print('Hello World!', 400, 300)
-- end
