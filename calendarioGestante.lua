local composer = require("composer")

local scene = composer.newScene()

-- Variável global para o som
local somBotao


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
-- Configurações da página
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    local sceneGroup = self.view

     -- Coordenadas para o centro da tela
     local centerX = display.contentCenterX
     local centerY = display.contentCenterY
 
     -- Adicionar imagem de fundo
    local bg = display.newImageRect(sceneGroup,"assets/calendarioGestante.png", 768, 1024)
     bg.x = centerX
     bg.y = centerY 

       -- Carregar o som do botão
       somBotao = audio.loadSound("assets/som.mp3") 

    -- Função para voltar para a cena anterior 
    local function onBackTap(event)
        audio.play(somBotao)
        composer.gotoScene("page2", { effect = "slideRight", time = 500 })
    end

-- Adicionar botão 'Voltar'
local btVolt = createButton(
    sceneGroup,
    "assets/voltar.png",
    670, 
    display.contentHeight - 980, 
    1.0, 
    1.0, 
    onBackTap 
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
        if escudo then
            escudo:removeSelf()
            escudo = nil  -- Garantir que o objeto seja removido da memória
        end
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
   -- Remove o escudo se ele existir
   if escudo then
    escudo:removeSelf()
    escudo = nil  -- Garantir que o objeto seja removido da memória
 end
    -- Libere o som ao destruir a cena
    if somBotao then
        audio.dispose(somBotao)
        somBotao = nil
    end

    if audioGestante then
        if canalG then
            audio.stop(canalG)
            canalG = nil
        end
        audio.dispose(audioGestante)
        audioGestante = nil
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
