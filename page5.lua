-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")

-- Cria uma nova cena
local scene = composer.newScene()

-- Variáveis para armazenar os botões
local btSomL
local btSomD

-- Variáveis para armazenar o som
local btSom
local audioPage5
local canal5

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
    local bg = display.newImageRect(sceneGroup, "assets/mitos-e-verdades.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY

    -- Adicionar a imagem do celular
    local cel = display.newImageRect(sceneGroup, "assets/celular.png", 225, 225)
    cel.x = display.contentCenterX - 50
    cel.y = display.contentCenterY + 290

    -- Carregar o som
    btSom = audio.loadSound("assets/som.mp3")
    audioPage5 = audio.loadSound("assets/page5.mp3")

    -- Função para navegar para a próxima página
    local function onNextTap(event)
        audio.play(btSom)
        composer.gotoScene("referencias", { effect = "slideLeft", time = 500 })
    end

    -- Função para navegar para a página anterior
    local function onBackTap(event)
        audio.play(btSom)
        composer.gotoScene("page4", { effect = "slideRight", time = 500 })
    end

    -- Função para ligar o som
    local function onSoundOnTap(event)
        print("Ligando o som...")
        if not canal5 then
            canal5 = audio.play(audioPage5, { loops = -1 })  
            print("Som ligado no canal: ", canal5)
        end
        btSomL.isVisible = false 
        btSomD.isVisible = true  
    end

    -- Função para desligar o som
    local function onSoundOffTap(event)
        print("Desligando o som...")
        if canal5 then
            print("Som está ligado, desligando agora...")
            audio.stop(canal5)
            canal5 = nil
            print("Som desligado.")
        end
        btSomD.isVisible = false 
        btSomL.isVisible = true  
    end

    -- Adicionar botões

    -- Botão 'Próximo'
    local btProx = createButton(
        sceneGroup, "assets/bt-prox.png", 
        display.contentWidth - 70, 
        display.contentHeight - 55, 
        0.5, 
        0.5,
         onNextTap
        )

    -- Botão 'Voltar'
    local btVolt = createButton(
        sceneGroup, 
        "assets/bt-voltar.png", 
        70, 
        display.contentHeight - 55,
         0.5, 
         0.5, 
         onBackTap
        )

    -- Botão 'Ligar Som'
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

    -- Botão 'Desligar Som'
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
        if not canal5 then
            canal5 = audio.play(audioPage5, { loops = -1 }) 
        end
    elseif (phase == "did") then
        -- Função para detectar o shake
        local function movimentar(event)
            if event then
                if event.x and event.y and event.z then
                    print("Acelerômetro - X: " .. event.x .. " Y: " .. event.y .. " Z: " .. event.z)
                    
                    local shakeThreshold = 2  -- Defina o limite de aceleração para detectar o shake
                    if math.abs(event.x) > shakeThreshold or math.abs(event.y) > shakeThreshold or math.abs(event.z) > shakeThreshold then
                        print("Shake detectado!")
                        composer.gotoScene("mitos-e-verdades", { effect = "fade", time = 500 })
                    else
                        print("Aceleração abaixo do limite")
                    end
                else
                    print("Erro: dados do acelerômetro não recebidos corretamente.")
                end
            else
                print("Erro: evento do acelerômetro não recebido.")
            end
        end

        -- Adicionar o listener de acelerômetro
        Runtime:addEventListener("accelerometer", movimentar)
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
       
        Runtime:removeEventListener("accelerometer", movimentar)
        if canal5 then
            audio.stop(canal5)
            canal5 = nil
        end
        btSomL.isVisible = false
        btSomD.isVisible = true
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

    if audioPage5 then
        if canal5 then
            audio.stop(canal5)
            canal5 = nil
        end
        audio.dispose(audioPage5)
        audioPage5 = nil
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
