local composer = require("composer")
local scene = composer.newScene()

-- Variáveis globais para os sons
local somBotao
local audioMitos
local canalM
local btSomL
local btSomD

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

-- Configurações da página
function scene:create(event)
    local sceneGroup = self.view
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY

    -- Adicionar imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/mitos-e-verdades-final.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY

    -- Carregar os sons
    somBotao = audio.loadSound("assets/som.mp3") 
    audioMitos = audio.loadSound("assets/mitosEverdades.mp3")

    -- Função para voltar para a cena anterior
    local function onBackTap(event)
        if canalM then
            audio.stop(canalM)
            canalM = nil
        end
        audio.play(somBotao)
        composer.gotoScene("page5", { effect = "slideRight", time = 500 })
    end

    -- Função para ligar o som
    local function onSoundOnTap(event)
        if not canalM then
            canalM = audio.play(audioMitos, { loops = -1 }) -- Reproduz o som em loop
        end
        btSomL.isVisible = false
        btSomD.isVisible = true
    end

    -- Função para desligar o som
    local function onSoundOffTap(event)
        if canalM then
            audio.stop(canalM)
            canalM = nil
        end
        btSomD.isVisible = false
        btSomL.isVisible = true
    end

    -- Adicionar botões
    local btVolt = createButton(sceneGroup, "assets/voltar.png", 670, display.contentHeight - 980, 1.0, 1.0, onBackTap)
    btSomL = createButton(sceneGroup, "assets/som-ligar.png", display.contentWidth - 530, display.contentHeight - 55, 0.5, 0.5, onSoundOnTap)
    btSomL.isVisible = false
    btSomD = createButton(sceneGroup, "assets/som-desliga.png", display.contentWidth - 220, display.contentHeight - 55, 0.5, 0.5, onSoundOffTap)
    btSomD.isVisible = true
end

-- Função chamada quando a cena é mostrada
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "did" then
        if not canalM then
            canalM = audio.play(audioMitos, { loops = -1 }) -- Reproduz o som de fundo em loop
        end
    end
end

-- Função chamada quando a cena é escondida
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "did" then
        if canalM then
            audio.stop(canalM)
            canalM = nil
        end
    end
end

-- Função chamada quando a cena é destruída
function scene:destroy(event)
    local sceneGroup = self.view

    -- Libere os recursos de áudio
    if audioMitos then
        audio.dispose(audioMitos)
        audioMitos = nil
    end

    if somBotao then
        audio.dispose(somBotao)
        somBotao = nil
    end

    if btSom then
        audio.dispose(btSom)
        btSom = nil
    end
end

-- Adicionar ouvintes de eventos da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
