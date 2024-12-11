-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")

-- Cria uma nova cena
local scene = composer.newScene()

local btSomL
local btSomD

-- Variável para armazenar o som
local somProx
local SomVolt
local audioPage3
local canal3

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

    -- Ativar multitouch
    system.activate("multitouch")

    -- Adicionar imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/monitoramento.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY 

    local btEvento = display.newImage(sceneGroup, "assets/btEvento.png")
    btEvento.x = display.contentCenterX 
    btEvento.y = display.contentCenterY + 150
    btEvento.xScale = 0.9
    btEvento.yScale = 0.9

    local function trocaPagina()
        composer.gotoScene("eventos", { effect = "fade", time = 500 })
    end

    -- Função touch adaptada para multitouch
    local function touchListener(event)
        if event.phase == "began" then
            print("Toque iniciado")
        elseif event.phase == "moved" then
            print("Toque em movimento")
        elseif event.phase == "ended" then
            print("Toque finalizado")
            -- Verifique se dois dedos estão tocando simultaneamente
            if event.numTouches == 2 then
                trocaPagina()
            end
        end
        return true
    end

    -- Adicionando o evento touch no botão de evento
    btEvento:addEventListener("touch", touchListener)

    -- Carregar o som
    btSom = audio.loadSound("assets/som.mp3")
    audioPage3 = audio.loadSound("assets/page3.mp3")

    -- Função para navegar para a próxima pagina
    local function onNextTap(event)
        audio.play(btSom)
        composer.gotoScene("page4", { effect = "slideLeft", time = 500 })
    end

    -- Função para voltar para a pagina anterior 
    local function onBackTap(event)
        audio.play(btSom)
        composer.gotoScene("page2", { effect = "slideRight", time = 500 })
    end

    -- função para ligar o som
    local function onSoundOnTap(event)
        print("Ligando o som...")
        if not canal3 then
            canal3 = audio.play(audioPage3, { loops = -1 })  
            print("Som ligado no canal: ", canal3)
        end
        btSomL.isVisible = false 
        btSomD.isVisible = true 
    end

    -- função para desligar o som
    local function onSoundOffTap(event)
        print("Desligando o som...")
        if canal3 then
            print("Som está ligado, desligando agora...")  
            audio.stop(canal3)
            canal3 = nil 
            print("Som desligado.")
        end
        btSomD.isVisible = false 
        btSomL.isVisible = true 
    end

    -- botão 'Próximo'
    local btProx = createButton(
        sceneGroup,
        "assets/bt-prox.png",
        display.contentWidth - 70, 
        display.contentHeight - 55, 
        0.5, 
        0.5, 
        onNextTap 
    )

    -- botão 'Voltar'
    local btVolt = createButton(
        sceneGroup,
        "assets/bt-voltar.png",
        70, 
        display.contentHeight - 55, 
        0.5,
        0.5, 
        onBackTap 
    )

    -- botão 'Ligar Som'
    btSomL = createButton(
        sceneGroup,
        "assets/som-ligar.png",
        display.contentWidth - 530,
        display.contentHeight - 55, 
        0.5, 
        0.5, 
        onSoundOnTap 
    )
    btSomL.isVisible = false

    -- botão 'Desligar Som'
    btSomD = createButton(
        sceneGroup,
        "assets/som-desliga.png",
        display.contentWidth - 220,
        display.contentHeight - 55, 
        0.5, 
        0.5, 
        onSoundOffTap 
    )
    btSomD.isVisible = true

end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        if not canal3 then
            canal3 =  audio.play(audioPage3, { loops = -1 }) 
        end
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        if canal3 then
            audio.stop(canal3)
            canal3 = nil
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
    
    if audioPage3 then
        if canal3 then
            audio.stop(canal3)
            canal3 = nil
        end
        audio.dispose(audioPage3)
        audioPage3 = nil
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
