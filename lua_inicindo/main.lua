-- Config. gerais do Projeto
ALTURA_DA_TELA = 480
LARGURA_DA_TELA = 320

MAX_OBJETOS_INIMIGOS = { 12, 23, 16, 13, 18, 17, 9 }

function houveColisao(a1, l1, x1, y1, a2, l2, x2, y2)
    return  (x2 < x1 + l1) and (x1 < x2 + l2) and (y1 < y2 + a2) and (y2 < y1 + a1)
end

-- Configurações dos Inimigos/Objetos
objetos = {}

function renderizaMeteoro()
    meteoro = {
        x = math.random(LARGURA_DA_TELA),
        y = -75,
        peso = math.random(4),
        moveNoEixo_horizontal = math.random(-1, 1)
    }

    table.insert(objetos, meteoro)
end

function moveMeteoro()
    for i, meteoro in pairs(objetos) do
        meteoro.y = meteoro.y + meteoro.peso
        meteoro.x = meteoro.x + meteoro.moveNoEixo_horizontal
    end
end

function removeMeteoro()
    for i = #objetos, 1, -1 do
        if objetos[i].y > (ALTURA_DA_TELA - 10) then
            table.remove(objetos, i)
        end
    end

end


-- Configurações do avatar do jogador

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


-- jogo
function love.load()
    love.window.setMode(LARGURA_DA_TELA, ALTURA_DA_TELA, { resizable = false})
    love.window.setTitle('SpaceNav')

    math.randomseed(os.time())

    background = love.graphics.newImage('img/background.png')
    meteoro_img = love.graphics.newImage('img/meteoro.png')

    nave.img = love.graphics.newImage(nave.src)

end

function love.update(dt)
    --Movimentos do player
    if love.keyboard.isDown('a', 'w', 's', 'd') or love.keyboard.isDown('up', 'left', 'down', 'right') then
        moveNaveDoJogador()
    end

    --Movimentos da ia
    removeMeteoro()
    if #objetos < math.random(#MAX_OBJETOS_INIMIGOS) then
        renderizaMeteoro()
    end
    moveMeteoro()

end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(nave.img, nave.x, nave.y)

    for i, meteoro in pairs(objetos) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end

end


