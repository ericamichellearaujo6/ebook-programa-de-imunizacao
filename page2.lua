-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")

-- Cria uma nova cena
local scene = composer.newScene()

local btSomL
local btSomD

-- Variável para armazenar o som
local btSom
local audioPage2
local canal2

-- Função  para criar botões
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
    local bg = display.newImageRect(sceneGroup, "assets/vacinacao.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY 

    -- Imagem da UBS
    local img = display.newImageRect(sceneGroup, "assets/ubs.png", 250, 250)
    img.x = display.contentCenterX - 10
    img.y = display.contentCenterY + 250

    -- Adicionar os ícones
    local espacoIcone = 100  -- Define o espaçamento entre os ícones

    -- Posições X ajustadas para os ícones ficarem ao lado do outro
    local icon1 = createButton(sceneGroup, "assets/bebe.png", centerX - 3 * espacoIcone, centerY - 10, 0.8, 0.8)
    local icon2 = createButton(sceneGroup, "assets/adolescente.png", centerX - espacoIcone, centerY - 10, 0.8, 0.8)
    local icon3 = createButton(sceneGroup, "assets/adulto_e_idoso.png", centerX + espacoIcone, centerY - 10, 0.8, 0.8)
    local icon4 = createButton(sceneGroup, "assets/gestante.png", centerX + 3 * espacoIcone, centerY - 10, 0.8, 0.8)

    -- Carregar o som do botão
    btSom = audio.loadSound("assets/som.mp3")
    audioPage2 = audio.loadSound("assets/page2.mp3")

    -- Função para navegar para a próxima página 
    local function onNextTap(event)
        audio.play(btSom)
        composer.gotoScene("page3", { effect = "slideLeft", time = 500 })
    end

    -- Função para voltar para a página anterior 
    local function onBackTap(event)
        audio.play(btSom)
        composer.gotoScene("page1", { effect = "slideRight", time = 500 })
    end

    -- Função para ligar o som 
    local function onSoundOnTap(event)
        print("Ligando o som...")
        if not canal2 then 
            canal2 = audio.play(audioPage2, { loops = -1 })  
            print("Som ligado no canal: ", canal2)
        end
        btSomL.isVisible = false 
        btSomD.isVisible = true 
    end

    -- Função para desligar o som
    local function onSoundOffTap(event)
        print("Desligando o som...")
        if canal2 then
            print("Som está ligado, desligando agora...")  
            audio.stop(canal2);
            canal2 = nil 
            print("Som desligado.")
        end
        btSomD.isVisible = false 
        btSomL.isVisible = true 
    end

    -- Adicionando os botões de navegação
    local btProx = createButton(sceneGroup, "assets/bt-prox.png", display.contentWidth - 70, display.contentHeight - 55, 0.5, 0.5, onNextTap)
    local btVolt = createButton(sceneGroup, "assets/bt-voltar.png", 70, display.contentHeight - 55, 0.5, 0.5, onBackTap)

    -- Botões de som
    btSomL = createButton(sceneGroup, "assets/som-ligar.png", display.contentWidth - 530, display.contentHeight - 55, 0.5, 0.5, onSoundOnTap)
    btSomL.isVisible = false -- começa invisível 
    btSomD = createButton(sceneGroup, "assets/som-desliga.png", display.contentWidth - 220, display.contentHeight - 55, 0.5, 0.5, onSoundOffTap)
    btSomD.isVisible = true

    -- Função para mover o ícone até a imagem da UBS, carregar a nova cena, e depois voltar o ícone
    local function moveToUBSAndNavigate(icon, sceneName, originalPosition)
        -- Animação de movimento até a UBS
        transition.to(icon, { x = img.x, y = img.y, time = 500, onComplete = function()
            -- Navega para a cena correspondente após o movimento
            composer.gotoScene(sceneName, { effect = "slideLeft", time = 500 })

            -- Após um tempo, move o ícone de volta para sua posição original
            transition.to(icon, { x = originalPosition.x, y = originalPosition.y, time = 500 })
        end })
    end

    -- Função para os ícones
    icon1:addEventListener("tap", function()
        audio.play(btSom)
        moveToUBSAndNavigate(icon1, "calendario-crianca", { x = centerX - 3 * espacoIcone, y = centerY - 10 }) -- Cena para o botão bebê
    end)
    icon2:addEventListener("tap", function()
        audio.play(btSom)
        moveToUBSAndNavigate(icon2, "calendario-adolescente", { x = centerX - espacoIcone, y = centerY - 10 }) -- Cena para o botão adolescente
    end)
    icon3:addEventListener("tap", function()
        audio.play(btSom)
        moveToUBSAndNavigate(icon3, "calendario-adulto", { x = centerX + espacoIcone, y = centerY - 10 }) -- Cena para o botão adulto e idoso
    end)
    icon4:addEventListener("tap", function()
        audio.play(btSom)
        moveToUBSAndNavigate(icon4, "calendario-gestante", { x = centerX + 3 * espacoIcone, y = centerY - 10 }) -- Cena para o botão gestante
    end)
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
       if not canal2 then
            canal2 = audio.play(audioPage2, { loops = -1 }) 
       end
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        if canal2 then
            audio.stop(canal2);
            canal2 = nil
        end 
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view

    if btSom then
        audio.stop()
        audio.dispose(btSom)
        btSom = nil
    end
    if audioPage2 then
        if canal2 then
            audio.stop(canal2)
            audio.dispose(canal2)
            canal2 = nil
        end
        audio.dispose(audioPage2)
        audioPage2 = nil
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
