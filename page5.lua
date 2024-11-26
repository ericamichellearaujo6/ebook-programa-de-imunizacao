-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")

-- Cria uma nova cena
local scene = composer.newScene()

local btSomL
local btSomD

-- Variável para armazenar o som
local btSom 
local audioPage5
local canal5

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
    local bg = display.newImageRect(sceneGroup, "assets/mitos-e-verdades.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY 
    
   -- add a imagem do celular
    local cel = display.newImageRect(sceneGroup, "assets/celular.png", 225, 225)
     -- Definir as posições das imagens
     cel.x = display.contentCenterX - 50
     cel.y = display.contentCenterY  + 290

    -- Carregar o som do botão proximo
      btSom = audio.loadSound("assets/som.mp3")
     audioPage5 = audio.loadSound("assets/page5.mp3")

    -- Função para navegar para a próxima pagina
    local function onNextTap(event)
        audio.play(btSom)
        composer.gotoScene("referencias", { effect = "slideLeft", time = 500 })
    end
    

    -- Função para navegar para a pagina anterior 
    local function onBackTap(event)
        audio.play(btSom)
        composer.gotoScene("page4", { effect = "slideRight", time = 500 })
    end

    -- função para ligar o som 
local function onSoundOnTap(event)
    print("Ligando o som...")
   if  not canal5 then 
      canal5 = audio.play(audioPage5, { loops = -1 })  -- Reproduz som em loop
      print("Som ligado no canal: ", canal5)
   end
    btSomL.isVisible = false -- Esconde o botão "Ligar som"
    btSomD.isVisible = true -- Mostra o botão "Desligar som"
end

 -- função para desligar o som
local function onSoundOffTap(event)
    print("Desligando o som...")
  if canal5 then
    print("Som está ligado, desligando agora...")  
    audio.stop(canal5);
    canal5 = nil 
    print("Som desligado.")
  end
    btSomD.isVisible = false -- Esconde o botão "Desligar som"
    btSomL.isVisible = true -- Mostra o botão "Ligar som"
end
    -- add botoes

    --  botão 'Próximo'
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
        if not canal5 then
            canal5 =  audio.play(audioPage5, { loops = -1 }) -- Reproduz o som em loop 
           end

    elseif (phase == "did") then

        local balanco = 1.5 --limite de aceleração
        local function movimentar(event)
            if math.abs(event.x) > balanco or math.abs(event.y) > balanco or math.abs(event.z) > balanco then
                -- remove 
                Runtime:removeEventListener("accelerometer",movimentar);

                --muda para a pagina
                composer.gotoScene("mitos-e-verdades", { effect = "fade", time = 500 })
            end 
        end

        -- add o acelerometro de novo
        Runtime:addEventListener("accelerometer", movimentar)
    end

end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
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
        btSom= nil
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
