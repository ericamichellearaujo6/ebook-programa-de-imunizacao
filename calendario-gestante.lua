local composer = require("composer")
local scene = composer.newScene()

-- Variáveis locais para a cena
local somBotao
local audioGestante
local canalG
local sprite
local escudo
local btNavegar
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
            time = 5000,  -- Duração total da animação
            loopCount = 4 -- Apenas uma vez
        }
    }

    -- Função para exibir a imagem no fim da animação
    local function showShieldAndButton()
        if not escudo then
            escudo = display.newImage("assets/gotinhaGestante.png")
            escudo.x = centerX
            escudo.y = centerY - 50
            escudo.xScale = 1.5
            escudo.yScale = 1.5
            escudo.alpha = 1

            -- Exibir o botão "Navegar" após o escudo ser exibido
            btNavegar.isVisible = true
        end
    end

    local function checkConditions()
        -- Mostrar o escudo e o botão somente após o áudio e a animação terminarem
        if animationComplete and audioComplete then
            showShieldAndButton()
        end
    end

    -- Função chamada quando a animação termina
    local function onAnimationComplete(event)
        if event.phase == "ended" then
            animationComplete = true
            sprite:removeSelf()
            checkConditions()
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

    -- Reproduzir o áudio
    canalG = audio.play(audioGestante, { onComplete = function()
        audioComplete = true
        checkConditions()
    end })

    -- Função para voltar para a cena anterior
    local function onBackTap(event)
        -- Parar o áudio
        if canalG then
            audio.stop(canalG)
            canalG = nil
        end

        -- Remover elementos da cena
        if escudo then
            escudo:removeSelf()
            escudo = nil
        end
        if sprite then
            sprite:removeSelf()
            sprite = nil
        end

        -- Tocar som do botão de navegação
        audio.play(somBotao)
        composer.gotoScene("page2", { effect = "slideRight", time = 500 })
    end

    -- Função para o botão de navegação
    local function onNavegarTap(event)
        composer.gotoScene("calendario", { effect = "slideLeft", time = 500 })
    end

    -- Adicionar botão 'Voltar'
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
    btNavegar = createButton(
        sceneGroup,
        "assets/balao.png",
        centerX,
        centerY + 300,  -- Ajustar posição do botão
        1.0,
        1.0,
        onNavegarTap
    )
    btNavegar.isVisible = false -- Começa invisível
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        -- Reiniciar o áudio e a animação caso a página seja revisitada
        animationComplete = false
        audioComplete = false
        btNavegar.isVisible = false
        if not canalG then
            canalG = audio.play(audioGestante, { onComplete = function()
                audioComplete = true
                checkConditions()
            end })
        end

        if sprite then
            sprite:setSequence("animacao")
            sprite:play()
        end
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        -- Parar o áudio quando a cena for ocultada
        if canalG then
            audio.stop(canalG)
            canalG = nil
        end

        -- Remover o escudo
        if escudo then
            escudo:removeSelf()
            escudo = nil
        end
    end
end

function scene:destroy(event)
    local sceneGroup = self.view

    -- Liberar recursos
    if somBotao then
        audio.dispose(somBotao)
        somBotao = nil
    end

    if audioGestante then
        audio.dispose(audioGestante)
        audioGestante = nil
    end
end

-- Listeners da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
