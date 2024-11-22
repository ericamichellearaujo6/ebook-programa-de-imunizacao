local composer = require("composer")

local scene = composer.newScene()

-- Variável global para o som
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
 

       -- Carregar o som do botão
       somBotao = audio.loadSound("assets/som.mp3") 

    -- Função para navegar para a próxima pagina
    local function onNextTap(event)
        audio.play(somBotao)
        composer.gotoScene("page1", { effect = "fade", time = 800 })
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

local btSomL = createButton(
    sceneGroup,
    "assets/som-ligar.png",
    display.contentWidth - 530,
    display.contentHeight - 55,
    0.5,
    0.5,
    onSoundOnTap
)

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

-- show
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        -- Código aqui é executado quando a cena já está na tela
    end
end

-- hide
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "did") then
        -- Código aqui é executado imediatamente após a cena sair da tela
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view

    -- Libere o som ao destruir a cena
    if somBotao then
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
