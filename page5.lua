-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")

-- Cria uma nova cena
local scene = composer.newScene()

-- Variáveis globais
local btSomL, btSomD, btSom, audioPage5, canal5

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

-- Função para detectar o shake (agora usando event.isShake)
local function movimentar(event)
    if event.isShake then
        print("O dispositivo foi chacoalhado!")
        composer.gotoScene("mitos-e-verdades", { effect = "fade", time = 500 })
    end
    return true
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY

    -- Imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/mitos-e-verdades.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY

    -- Adicionar imagem do celular
    local cel = display.newImageRect(sceneGroup, "assets/celular.png", 225, 225)
    cel.x = centerX - 50
    cel.y = centerY + 290

    -- Carregar sons
    btSom = audio.loadSound("assets/som.mp3")
    audioPage5 = audio.loadSound("assets/page5.mp3")

    -- Funções para botões
    local function onNextTap()
        audio.play(btSom)
        composer.gotoScene("referencias", { effect = "slideLeft", time = 500 })
    end

    local function onBackTap()
        audio.play(btSom)
        composer.gotoScene("page4", { effect = "slideRight", time = 500 })
    end

    local function onSoundOnTap()
        if not canal5 then
            canal5 = audio.play(audioPage5, { loops = -1 })
        end
        btSomL.isVisible = false
        btSomD.isVisible = true
    end

    local function onSoundOffTap()
        if canal5 then
            audio.stop(canal5)
            canal5 = nil
        end
        btSomD.isVisible = false
        btSomL.isVisible = true
    end

    -- Adicionar botões
    createButton(sceneGroup, "assets/bt-prox.png", display.contentWidth - 70, display.contentHeight - 55, 0.5, 0.5, onNextTap)
    createButton(sceneGroup, "assets/bt-voltar.png", 70, display.contentHeight - 55, 0.5, 0.5, onBackTap)

    btSomL = createButton(sceneGroup, "assets/som-ligar.png", display.contentWidth - 530, display.contentHeight - 55, 0.5, 0.5, onSoundOnTap)
    btSomD = createButton(sceneGroup, "assets/som-desliga.png", display.contentWidth - 220, display.contentHeight - 55, 0.5, 0.5, onSoundOffTap)

    btSomL.isVisible = false
end

-- show()
function scene:show(event)
    local phase = event.phase
    if (phase == "did") then
        if not canal5 then
            canal5 = audio.play(audioPage5, { loops = -1 })
        end
        Runtime:addEventListener("accelerometer", movimentar)
    end
end

-- hide()
function scene:hide(event)
    local phase = event.phase
    if (phase == "will") then
        Runtime:removeEventListener("accelerometer", movimentar)
        if canal5 then
            audio.stop(canal5)
            canal5 = nil
        end
    end
end

-- destroy()
function scene:destroy(event)
    if btSom then
        audio.dispose(btSom)
        btSom = nil
    end

    if audioPage5 then
        audio.dispose(audioPage5)
        audioPage5 = nil
    end
end

-- Adicionando listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
