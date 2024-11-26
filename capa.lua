local composer = require("composer")

local scene = composer.newScene()

-- Variável global para o som

local btSom
local audioCapa
local canalAudio
local btSomL
local btSomD



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


--carregar o som do audio
 audioCapa = audio.loadSound("assets/capa.mp3")
 -- Carregar o som do botão proximo 
 btSom = audio.loadSound("assets/som.mp3") 

-- -----------------------------------------------------------------------------------
-- Configurações da página
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    local sceneGroup = self.view

     -- Coordenadas para o centro da tela
     local centerX = display.contentCenterX
     local centerY = display.contentCenterY
 
     -- Adicionar imagem de fundo
     local bg = display.newImageRect(sceneGroup, "assets/capa.png", 768, 1024)
     bg.x = centerX
     bg.y = centerY 
 

    -- Função para navegar para a próxima pagina
    local function onNextTap(event)

        if canalAudio then 
            audio.stop(canalAudio)
            --canalAudio = nil
        end  
        audio.play(btSom)
        composer.gotoScene("page1", { effect = "fade", time = 800 })
    end

    --função para ligar o som
    local function onSoundOnTap(event)
        if not canalAudio then
            canalAudio = audio.play(somCapa, { loops = -1 }) -- Reproduz o som em loop
        end
        btSomL.isVisible = false -- Esconde "Ligar Som"
        btSomD.isVisible = true -- Mostra "Desligar Som"
    end
    
    --função para desligar o som
    local function onSoundOffTap(event)
        if canalAudio then
            audio.stop(canalAudio) -- Para o som
            canalAudio = nil
        end
        btSomD.isVisible = false -- Esconde "Desligar Som"
        btSomL.isVisible = true -- Mostra "Ligar Som"
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

-- show
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
      
        if not canalAudio then
        canalAudio = audio.play(audioCapa, { loops = -1 }) -- Reproduz em loop
        end  
    end
end

-- hide
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then

        if canalAudio then
            audio.stop(canalAudio)
            canalAudio = nil
        end
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view

    if audioCapa then
        audio.dispose(audioCapa)
        audioCapa = nil
    end

    -- Libere o som ao destruir a cena
    if btSom then
        audio.dispose(btSom)
        btSom = nil
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
