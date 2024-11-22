-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")

-- Cria uma nova cena
local scene = composer.newScene()

-- Variável para armazenar o som
local somBotao

-- Função auxiliar para criar botões
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
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Coordenadas para o centro da tela
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY

    -- Adicionar imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/info_adiamentos.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY 

    -- Carregar o som
    somBotao = audio.loadSound("assets/som.mp3") 

    -- Função para voltar para a página anterior
    local function onBackTap(event)
        audio.play(somBotao)
        composer.gotoScene("page5", { effect = "slideRight", time = 500 })
    end

    -- Função para exibir a imagem e o botão 'Voltar'
    local function showImage()
        -- Criar e exibir a imagem
        local image = display.newImage(sceneGroup, "assets/explicacao2.png")
        image.x = display.contentCenterX - 30
        image.y = display.contentCenterY + 10
        image.xScale = 1.2
        image.yScale = 1.2

        -- Criar o botão 'Voltar'
        local btVolt = createButton(
            sceneGroup,
            "assets/resposta.png",
            display.contentWidth - 260,
            display.contentHeight - 195, 
            1.2, 
            1.2, 
            onBackTap
        )
    end

    -- Adicionar botão para mostrar a imagem
    local btShowRect = createButton(
        sceneGroup,
        "assets/resposta2.png",  -- Imagem do botão para exibir a retângulo
        centerX + 200, 
        centerY - 250, 
        1.0, 
        1.0, 
        showImage
    )

    -- botão 'Ligar Som'
    local btSomL = createButton(
        sceneGroup,
        "assets/som-ligar.png",
        display.contentWidth - 530,
        display.contentHeight - 55, 
        0.5, 
        0.5, 
        onSoundOnTap
    )

    -- botão 'Desligar Som'
    local btSomD = createButton(
        sceneGroup,
        "assets/som-desliga.png",
        display.contentWidth - 220,
        display.contentHeight - 55, 
        0.5, 
        0.5, 
        onSoundOffTap
    )
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código aqui é executado quando a cena está prestes a aparecer na tela

    elseif (phase == "did") then
        -- Código aqui é executado quando a cena já está na tela

    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código aqui é executado quando a cena está prestes a sair da tela

    elseif (phase == "did") then
        -- Código aqui é executado imediatamente após a cena sair da tela

    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view

    if somBotao then
        audio.stop()
        audio.dispose(somBotao)
        somBotao = nil
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
