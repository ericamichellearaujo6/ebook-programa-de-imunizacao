local composer = require("composer")

local scene = composer.newScene()

-- Variável global para o som
local btSom
local audioContracapa
local canalContracapa
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
     local bg = display.newImageRect(sceneGroup,"assets/contracapa.png", 768, 1024)
     bg.x = centerX
     bg.y = centerY 
 

       -- Carregar o som do botão
       btSom = audio.loadSound("assets/som.mp3") 
       audioContracapa = audio.loadSound("assets/contracapa.mp3")
      

    -- Função para navegar para a pagina incicial
    local function onNextTap(event)
        
        if canalContracapa then 
            audio.stop(canalContracapa)
            canalContracapa = nil
        end  
        audio.play(btSom)
        composer.gotoScene("capa", { effect = "zoomInOut", time = 500 })
    end

     -- Função para navegar para a pagina anterior 
    local function onBackTap(event)
        if canalContracapa then 
            audio.stop(canalContracapa)
            canalContracapa = nil
        end  
        audio.play(btSom)
        composer.gotoScene("referencias", { effect = "slideRight", time = 500 })
    end
     

    --função para ligar o som
    local function onSoundOnTap(event)
        if not canalContracapa then
            canalContracapa = audio.play(audioContracapa, { loops = -1 }) -- Reproduz o som em loop
        end
        btSomL.isVisible = false -- Esconde "Ligar Som"
        btSomD.isVisible = true -- Mostra "Desligar Som"
    end
    
    --função para desligar o som
    local function onSoundOffTap(event)
        if canalContracapa then
            audio.stop(canalContracapa) -- Para o som
            canalContracapa = nil
        end
        btSomD.isVisible = false -- Esconde "Desligar Som"
        btSomL.isVisible = true -- Mostra "Ligar Som"
    end
------- add botoes

   -- Adicionar botão 'home'
   local btProx = createButton(
    sceneGroup,
    "assets/btHome.png",
    display.contentWidth - 70, 
    display.contentHeight - 55, 
    0.5, 
    0.5, 
    onNextTap 
)

-- Adicionar botão 'Voltar'
local btVolt = createButton(
    sceneGroup,
    "assets/bt-voltar.png",
    70, 
    display.contentHeight - 55, 
    0.5, 
    0.5, 
    onBackTap 
)

 
btSomL = createButton(
    sceneGroup,
    "assets/som-ligar.png",
    170,
    display.contentHeight - 150,
    0.5,
    0.5,
    onSoundOnTap
 )
 btSomL.isVisible = false 

  btSomD = createButton(
    sceneGroup,
    "assets/som-desliga.png",
    270,
    display.contentHeight - 150,
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
      
        if not canalContracapa then
            canalContracapa = audio.play(audioContracapa, { loops = -1 }) -- Reproduz em loop
            end
    end
end

-- hide
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
       
        if canalContracapa then
            audio.stop(canalContracapa)
            canalContracapa = nil
        end
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    
    
    if audioContracapa then
        audio.dispose(audioContracapa)
        audioContracapa = nil
    end

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
