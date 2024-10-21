-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")

-- Cria uma nova cena
local scene = composer.newScene()

-- Variável para armazenar o som
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
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Coordenadas para o centro da tela
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY

    -- Adicionar imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/introducao1.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY 

    -- Adicionar o ze gotinha 
 local zeGotinha = display.newImageRect(sceneGroup, "assets/gotinha.png", 100, 100) 
 zeGotinha.x = display.contentWidth - 690  
 zeGotinha.y = display.contentHeight - 200  

 -- Aumentar o tamanho do ze gotinha
 zeGotinha.xScale = 2.5  
 zeGotinha.yScale = 2.5  

  -- Adicionar o virus
  local zeGotinha = display.newImageRect(sceneGroup, "assets/virus.png", 100, 100)
  zeGotinha.x = display.contentWidth - 500  
  zeGotinha.y = display.contentHeight - 200  
 
  -- Aumentar o tamanho do virus
  zeGotinha.xScale = 0.9  
  zeGotinha.yScale = 0.9  

   -- Adicionar a bacteria 
 local zeGotinha = display.newImageRect(sceneGroup, "assets/bacteria.png", 100, 100)
 zeGotinha.x = display.contentWidth - 280  
 zeGotinha.y = display.contentHeight - 200  

 -- Aumentar o tamanho da bacteria
 zeGotinha.xScale = 0.9  
 zeGotinha.yScale = 0.9  
 
   -- Carregar o som do botão
   somBotao = audio.loadSound("assets/som.mp3") 

    -- Função para navegar para a próxima pagina
    local function onNextTap(event)
        audio.play(somBotao)
        composer.gotoScene("page3", { effect = "slideLeft", time = 500 })
    end

    -- Função para navegar para a pagina anterior 
    local function onBackTap(event)
        audio.play(somBotao)
        composer.gotoScene("capa", { effect = "slideRight", time = 500 })
    end

       -- Função para navegar para a continuação da  pagina
    local function onContinueTap(event)
        audio.play(somBotao)
        composer.gotoScene("page2", { effect = "slideLeft", time = 500 })
    end
    
    --- add os botoes 

    -- botão 'Continuação da pagina '
    local btContinua = createButton(
        sceneGroup,
        "assets/btContinua.png",
        display.contentWidth - 110, 
        display.contentHeight - 200, 
        0.7, 
        0.7, 
        onContinueTap
    )

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

    --  botão 'Voltar'
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
      local btSomL = createButton(
        sceneGroup,
        "assets/som-ligar.png",
        display.contentWidth - 530,
        display.contentHeight - 55, 
        0.5, 
        0.5, 
        onSoundOnTap 
    )

    -- botão 'Desligar Som'
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

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código aqui é executado quando a cena está prestes a aparecer na tela

    elseif (phase == "did") then
        -- Código aqui é executado quando a cena já está na tela

    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código aqui é executado quando a cena está prestes a sair da tela

    elseif (phase == "did") then
        -- Código aqui é executado imediatamente após a cena sair da tela

    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    -- Liberar o som quando a cena for destruída
    if somBotao then
        audio.stop()
        audio.dispose(somBotao)
        somBotao= nil
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
