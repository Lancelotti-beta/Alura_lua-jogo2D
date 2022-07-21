-- Config. gerais do Projeto
ALTURA_DA_TELA = 480
LARGURA_DA_TELA = 320

MAX_OBJETOS_INIMIGOS = { 12, 23, 16, 13, 18, 17, 9 }

function houveColisao(a1, l1, x1, y1, a2, l2, x2, y2)
    return  (x2 < x1 + l1) and (x1 < x2 + l2) and (y1 < y2 + a2) and (y2 < y1 + a1)
end

function colidiu()
    for i, meteoro in ipairs(objetos) do
        if houveColisao(meteoro.altura, meteoro.largura, meteoro.x, meteoro.y, nave.altura, nave.largura, nave.x, nave.y) then
            somDeFudo:stop()
            somDeDerrota()
            destroiNave()
            FIM_DE_JOGO = true
        end
    end

end

function somDeDerrota()
    somDeDestricaoDaNave:play()
    somDeFimDeJogo:play()
end

-- Configurações dos Inimigos/Objetos
objetos = {}

function renderizaMeteoro()
    meteoro = {
        altura = 44,
        largura = 50,
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
    altura = 63,
    largura = 55,
    x = LARGURA_DA_TELA/2 - 64/2,
    y = ALTURA_DA_TELA - 70
}

function destroiNave()
    nave.src = 'img/explosao_nave.png'
    nave.img = love.graphics.newImage(nave.src)
    nave.largura = 67
    nave.altura = 77
end

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

function disparar()

end


-- jogo
function love.load()
    -- infos do jogo
    love.window.setMode(LARGURA_DA_TELA, ALTURA_DA_TELA, { resizable = false})
    love.window.setTitle('SpaceNav')

    math.randomseed(os.time())

    -- Imagens do jogo
    background = love.graphics.newImage('img/background.png')
    meteoro_img = love.graphics.newImage('img/meteoro.png')
    
    desparoDaNave = love.graphics.newImage('img/tiro.png')
    nave.img = love.graphics.newImage(nave.src)

    -- Sons do jogo
        --play() som de fundo e ações da nave
    somDeFudo = love.audio.newSource('audios/ambiente.wav' ,'static')
    somDeDisparo = love.audio.newSource('audios/disparo.wav' ,'static')


    somDeVitoria = love.audio.newSource('audios/winner.wav', 'static')

        --play() Game Over
    somDeDestricaoDaNave = love.audio.newSource('audios/destruicao.wav' ,'static')
    somDeFimDeJogo = love.audio.newSource('audios/game_over.wav', 'static')

    somDeFudo:setLooping(true)
    somDeFudo:play()

end

function love.update(dt)
    if not FIM_DE_JOGO then
        --Movimentos do player
        if love.keyboard.isDown('a', 'w', 's', 'd') or love.keyboard.isDown('up', 'left', 'down', 'right') then
            moveNaveDoJogador()
        end

        colidiu() 
    end
    
    --Movimentos da ia
    removeMeteoro()
    if #objetos < math.random(#MAX_OBJETOS_INIMIGOS) then
        renderizaMeteoro()
    end
    moveMeteoro()

end


function love.keypressed(tecla)
    if tecla == 'escape' then
        love.event.quit()
    elseif (tecla == 'space') or (tecla == 'z') then
        disparar()
    end
end


function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(nave.img, nave.x, nave.y)

    for i, meteoro in pairs(objetos) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end

end


