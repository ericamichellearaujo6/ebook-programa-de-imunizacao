local composer = require("composer")
local scene = composer.newScene()

-- Variáveis locais para a cena
local somBotao
local audioGestante
local canalG

local sprite
local escudo
local btNavegar
local btSomL
local btSomD

local animationComplete = false
local audioComplete = false

-- Função para criar botões
local function createButton(sceneGroup, imagePath, x, y, scaleX, scaleY, onTap)
    local button = display.newImage(sceneGroup, imagePath)
    button.x = x
    button.y = y
    button.xScale = scaleX or 1
    button.yScale = scaleY or 1
    if onTap then
        button:addEventListener("tap", onTap)
    end
    return button
end

-- Função para exibir o escudo e o botão de navegação
local function showShieldAndButton(sceneGroup, centerX, centerY)
    -- Garantir que o sprite seja removido antes de exibir o escudo
    if sprite and sprite.removeSelf then
        sprite:removeSelf()
        sprite = nil
    end

    if not escudo then
        escudo = display.newImage(sceneGroup, "assets/gotinhaGestante.png")
        escudo.x = centerX
        escudo.y = centerY - 50
        escudo.xScale = 1.5
        escudo.yScale = 1.5
        escudo.alpha = 1

        -- Tornar o botão de navegação visível
        btNavegar.isVisible = true
    end
end

-- Função chamada quando a animação termina
local function onAnimationComplete(event)
    if event.phase == "ended" then
        animationComplete = true
        checkConditions(sceneGroup, display.contentCenterX, display.contentCenterY)
    end
end

-- Função para verificar as condições de exibição
local function checkConditions(sceneGroup, centerX, centerY)
    if animationComplete and audioComplete then
        -- Garantir que a animação não esteja mais visível
        if sprite and sprite.removeSelf then
            sprite:removeSelf()
            sprite = nil
        end

        showShieldAndButton(sceneGroup, centerX, centerY)
    end
end

-- Função para recriar o sprite e a animação
local function recreateAnimation(sceneGroup, centerX, centerY)
    -- Remover sprite existente, se houver
    if sprite and sprite.removeSelf then
        sprite:removeSelf()
        sprite = nil
    end

    -- Configurar o sprite sheet
    local sheetOptions = {
        width = 666,
        height = 374,
        numFrames = 4,
        sheetContentWidth = 2664,
        sheetContentHeight = 374
    }

    local imageSheet = graphics.newImageSheet("assets/spriteGestante.png", sheetOptions)

    -- Configurar as sequências de animação
    local sequenceData = {
        {
            name = "animacao",
            start = 1,
            count = 4,
            time = 5000, -- Duração total da animação
            loopCount = 4 -- Repetições
        }
    }

    -- Função chamada quando a animação termina
    local function onAnimationComplete(event)
        if event.phase == "ended" then
            animationComplete = true
            checkConditions(sceneGroup, centerX, centerY)
        end
    end

    -- Criar o sprite
    sprite = display.newSprite(sceneGroup, imageSheet, sequenceData)
    sprite.x = centerX
    sprite.y = centerY + 2
    sprite.xScale = 0.9
    sprite.yScale = 0.9
    sprite:setSequence("animacao")
    sprite:play()

    -- Adicionar o listener para detectar quando a animação terminar
    sprite:addEventListener("sprite", onAnimationComplete)
end

-- -----------------------------------------------------------------------------------
-- Configurações da cena
-- -----------------------------------------------------------------------------------

function scene:create(event)
    local sceneGroup = self.view

    -- Coordenadas para o centro da tela
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY

    -- Adicionar imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/calendario-gestante.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY

    -- Carregar o som do botão e da cena
    somBotao = audio.loadSound("assets/som.mp3")
    audioGestante = audio.loadSound("assets/audioGestante.mp3")

    -- Criar animação
    recreateAnimation(sceneGroup, centerX, centerY)

    -- Botão 'Voltar'
    local function onBackTap(event)
        -- Parar o áudio
        if canalG then
            audio.stop(canalG)
            canalG = nil
        end
        -- Tocar som do botão e navegar
        audio.play(somBotao)
        composer.gotoScene("page2", { effect = "slideRight", time = 500 })
    end

    local btVolt = createButton(
        sceneGroup,
        "assets/voltar.png",
        670,
        display.contentHeight - 1000,
        1.0,
        1.0,
        onBackTap
    )

    -- Botão de Navegação
    local function onNavegarTap(event)
        composer.gotoScene("calendarioGestante", { effect = "slideLeft", time = 500 })
    end

    btNavegar = createButton(
        sceneGroup,
        "assets/balao.png",
        centerX,
        centerY + 300,
        1.5,
        1.5,
        onNavegarTap
    )
    btNavegar.isVisible = false

    -- Botões de áudio
    btSomL = createButton(
        sceneGroup,
        "assets/som-ligar.png",
        display.contentWidth - 530,
        display.contentHeight - 55,
        0.5,
        0.5,
        function()
            if not canalG or not audio.isChannelActive(canalG) then
                canalG = audio.play(audioGestante)
            end
            btSomL.isVisible = false
            btSomD.isVisible = true
        end
    )
    btSomL.isVisible = false -- Torna o botão "ligar áudio" invisível inicialmente

    btSomD = createButton(
        sceneGroup,
        "assets/som-desliga.png",
        display.contentWidth - 220,
        display.contentHeight - 55,
        0.5,
        0.5,
        function()
            if canalG then
                audio.stop(canalG)
                canalG = nil
            end
            btSomL.isVisible = true
            btSomD.isVisible = false
        end
    )
    btSomD.isVisible = true -- Torna o botão "desligar áudio" visível inicialmente
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        -- Reiniciar condições
        animationComplete = false
        audioComplete = false
        btNavegar.isVisible = false

        -- Recriar animação
        recreateAnimation(sceneGroup, display.contentCenterX, display.contentCenterY)

        -- Reproduzir áudio
        canalG = audio.play(audioGestante, {
            onComplete = function()
                audioComplete = true
                checkConditions(sceneGroup, display.contentCenterX, display.contentCenterY)
            end
        })
    end
end

function scene:hide(event)
    local phase = event.phase

    if (phase == "did") then
        -- Parar o áudio
        if canalG then
            audio.stop(canalG)
            canalG = nil
        end

        -- Remover sprite e outros elementos
        if sprite and sprite.removeSelf then
            sprite:removeSelf()
            sprite = nil
        end
        if escudo and escudo.removeSelf then
            escudo:removeSelf()
            escudo = nil
        end
    end
end

function scene:destroy(event)
    if somBotao then
        audio.dispose(somBotao)
    end
    if audioGestante then
        audio.dispose(audioGestante)
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
