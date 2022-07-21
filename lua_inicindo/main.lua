-- "Mecanica" do Projeto
ALTURA_DA_TELA = 480
LARGURA_DA_TELA = 320
PONTOS = 0
NUMERO = 10
contando = (PONTOS - NUMERO)*(-1)

MAX_OBJETOS_INIMIGOS = { 12, 23, 16, 13, 18, 17, 9 }

function houveColisao(a1, l1, x1, y1, a2, l2, x2, y2)
    return  (x2 < x1 + l1) and (x1 < x2 + l2) and (y1 < y2 + a2) and (y2 < y1 + a1)
end

function meteoroColidiuComNave()
    for i, meteoro in ipairs(objetos) do
        if houveColisao(meteoro.altura, meteoro.largura, meteoro.x, meteoro.y, nave.altura, nave.largura, nave.x, nave.y) then
            somDeFudo:stop()
            somDeDerrota()
            destroiNave()
            FIM_DE_JOGO = true
        end
    end
    
end

function tiroColidiuComMeteoro()
    for i = #nave.arma, 1, -1 do
        for m = #objetos, 1, -1 do
            if houveColisao(objetos[m].altura, objetos[m].largura, objetos[m].x, objetos[m].y, nave.arma[i].altura, nave.arma[i].largura, nave.arma[i].x, nave.arma[i].y) then
                PONTOS = PONTOS + 1
                table.remove(nave.arma, i)
                table.remove(objetos, m)
                break
            end
        end
    end
end

function colidiu()
    meteoroColidiuComNave()
    tiroColidiuComMeteoro()
end

function objetivo()
    if PONTOS > NUMERO then
        VENCEDOR = true
        somDeFudo:stop()
        somDeVitoria:play()
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
    y = ALTURA_DA_TELA - 70,
    arma = {}
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

-- tiros da Nave
function prepararDisparo()
    somDeDisparo:play()
    local disparo = {
        x = nave.x + nave.largura/2,
        y = nave.y - nave.altura/4,
        altura = 16,
        largura = 16
    }

    table.insert(nave.arma, disparo)
end

function dispararTiro()
    for i = #nave.arma, 1, -1 do
        if nave.arma[i].y > 0 then
            nave.arma[i].y = nave.arma[i].y - 2
        else
            table.remove(nave.arma, i)
        end
    end
end


-- jogo
function love.load()
    -- infos do jogo
    love.window.setMode(LARGURA_DA_TELA, ALTURA_DA_TELA, { resizable = false})
    love.window.setTitle('SpaceNav')

    math.randomseed(os.time())

    -- Imagens do jogo
    background = love.graphics.newImage('img/background.png')
    telaDeGameOver = love.graphics.newImage('img/gameover.png')
    telaDePassouDeFase = love.graphics.newImage('img/vencedor.png')

    meteoro_img = love.graphics.newImage('img/meteoro.png')
    disparoDaNave = love.graphics.newImage('img/tiro.png')
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
    if not FIM_DE_JOGO and not VENCEDOR then
        --Movimentos do player
        if love.keyboard.isDown('a', 'w', 's', 'd') or love.keyboard.isDown('up', 'left', 'down', 'right') then
            moveNaveDoJogador()
        end
        -- Tiro da Nave
        dispararTiro()
    
        --Movimentos da ia
        removeMeteoro()
        if #objetos < math.random(#MAX_OBJETOS_INIMIGOS) then
            renderizaMeteoro()
        end
        moveMeteoro()
        
        colidiu()
        objetivo()
    end

end


function love.keypressed(tecla)
    if tecla == 'escape' then
        love.event.quit()
    elseif (tecla == 'space') or (tecla == 'z') then
        prepararDisparo()
    end
    if tecla == 'r' then
        love.event.quit("restart")
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.print('Pontos: '..(contando)..' / '..NUMERO, 10, 10)

    love.graphics.draw(nave.img, nave.x, nave.y)
    
    for i, meteoro in pairs(objetos) do
        love.graphics.draw(meteoro_img, meteoro.x, meteoro.y)
    end

    for i, disparo in pairs(nave.arma) do
        love.graphics.draw(disparoDaNave, disparo.x, disparo.y)
    end

    if FIM_DE_JOGO then
        love.graphics.draw(telaDeGameOver, LARGURA_DA_TELA/2 - telaDeGameOver:getWidth()/2, ALTURA_DA_TELA/2 - telaDeGameOver:getHeight()/2)
    end

    if VENCEDOR then
        love.graphics.draw(telaDePassouDeFase, LARGURA_DA_TELA/2 - telaDePassouDeFase:getWidth()/2, ALTURA_DA_TELA/2 - telaDePassouDeFase:getHeight()/2)
    end
end
