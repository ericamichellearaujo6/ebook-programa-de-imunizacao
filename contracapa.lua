local composer = require("composer")

local scene = composer.newScene()

-- Variável global para o som
local somBotao


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
 

    -- Adicionar botão 'home'
    local btHome = display.newImage("assets/btHome.png")
    btHome.x = display.contentWidth - 70 
    btHome.y = display.contentHeight - 55 
    btHome.xScale = 0.5
    btHome.yScale = 0.5

    -- Carregar o som do botão
    somBotao = audio.loadSound("assets/som.mp3") 

    -- Função para navegar para a próxima pagina
    local function onNextTap(event)
        audio.play(somBotao) 
        composer.gotoScene("capa", { effect = "zoomInOut", time = 700 })
    end

    -- Adicionar evento de toque no botão 'home'
    btHome:addEventListener("tap", onNextTap)

    

    -- Adicionar todos os elementos ao grupo da cena
    sceneGroup:insert(bg)
    sceneGroup:insert(btHome)
   
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
