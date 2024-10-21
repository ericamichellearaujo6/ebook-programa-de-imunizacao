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
    local bg = display.newImageRect(sceneGroup, "assets/contraindicacoes.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY

 -- Adicionar a imagens dos cartoes (AINDA SEM FUNCIONALIDADES)
    local cartao1 = display.newImageRect(sceneGroup, "assets/cartaoContra.png", 207, 276)
    local cartao2 = display.newImageRect(sceneGroup, "assets/cartaoAdia.png", 207, 276)
    local cartao3 = display.newImageRect(sceneGroup, "assets/cartaoEficacia.png", 207, 276)
     -- add o scanner
    local scaner = display.newImageRect(sceneGroup, "assets/scanner.png", 305, 275)

    -- Definir as posições das imagens
    cartao1.x = display.contentCenterX - 250
    cartao1.y = display.contentCenterY  + 100
    
    cartao2.x = display.contentCenterX 
    cartao2.y = display.contentCenterY  + 100
    
    cartao3.x = display.contentCenterX + 250
    cartao3.y = display.contentCenterY + 100
     
    scaner.x = display.contentCenterX + 250
    scaner.y = display.contentCenterY + 350

   
    -- Carregar o som
     somBotao = audio.loadSound("assets/som.mp3") 

    -- Função para navegar para a próxima pagina
    local function onNextTap(event)
        audio.play(somBotao)
        composer.gotoScene("page6", { effect = "slideLeft", time = 500 })
    end
 
    -- Função para voltar para a pagina anterior 
    local function onBackTap(event)
        audio.play(somBotao)
        composer.gotoScene("page4", { effect = "slideRight", time = 500 })
    end
     

    --- add os botoes -----

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

    --botão 'Ligar Som'
    local btSomL = createButton(
        sceneGroup,
        "assets/som-ligar.png",
        display.contentWidth - 530, 
        display.contentHeight - 55, 
        0.5, 
        0.5, 
        onSoundOnTap 
    )

    -- Adicionar botão 'Desligar Som'
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
