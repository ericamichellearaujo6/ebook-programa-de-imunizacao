-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")

-- Cria uma nova cena
local scene = composer.newScene()

-- Variável para armazenar o som
local somBotao
local somProx
local SomVolt


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
    local cartao1 = display.newImageRect(sceneGroup, "assets/cartao_contraindicacoes.png", 250, 330)
    local cartao2 = display.newImageRect(sceneGroup, "assets/cartao_adiamentos.png", 250, 330)
    local cartao3 = display.newImageRect(sceneGroup, "assets/cartao_eficacia.png", 250, 330)
     

    -- Definir as posições das imagens
    cartao1.x = display.contentCenterX - 250
    cartao1.y = display.contentCenterY  + 220
    
    cartao2.x = display.contentCenterX 
    cartao2.y = display.contentCenterY  + 220
    
    cartao3.x = display.contentCenterX + 250
    cartao3.y = display.contentCenterY + 220

     

-- Adicionar os ícones
local icon1 = createButton(sceneGroup, "assets/icone_contraindicacao.png", centerX - 250, centerY - 5, 0.5, 0.5)
local icon2 = createButton(sceneGroup, "assets/icone_adiamentos.png", centerX, centerY - 5, 0.5, 0.5)
local icon3 = createButton(sceneGroup, "assets/icone_eficacia.png", centerX + 250, centerY - 5, 0.5, 0.5)
  
-- Função para mover o ícone para o seu respectivo cartão
local function moveToCard(icon, card,SceneName)
    if icon and card then
        print("Movendo ícone para o cartão:", icon, "->", card.x, card.y)
        transition.to(icon, {
            time = 500,
            x = card.x, -- Mover o ícone para a posição X do cartão
            y = card.y + 65, -- Mover o ícone para a posição Y do cartão
            transition = easing.inOutQuad,
            onComplete = function()
                print("indo pra cena: " .. SceneName)
            composer.gotoScene(SceneName, { effect = "fade", time = 500 })
            end  
        })
    else
        print("Erro: Ícone ou cartão não encontrado.")
    end
end  

-- Adicionar eventos de toque nos ícones
icon1:addEventListener("tap", function()
    print("Ícone 1 tocado")
    moveToCard(icon1, cartao1,"contraindicacoes") -- Mover ícone1 para cartao1
end)

icon2:addEventListener("tap", function()
    print("Ícone 2 tocado")
    moveToCard(icon2, cartao2,"adiamentos") -- Mover ícone2 para cartao2
end)

icon3:addEventListener("tap", function()
    print("Ícone 3 tocado")
    moveToCard(icon3, cartao3,"eficacia") -- Mover ícone3 para cartao3
end)

     somBotao = audio.loadSound("assets/som.mp3") 
     somProx = audio.loadSound("assets/proximo.mp3")
     SomVolt = audio.loadSound("assets/anterior.mp3")

    -- Função para navegar para a próxima pagina
    local function onNextTap(event)
        audio.play(somProx)
        composer.gotoScene("page5", { effect = "slideLeft", time = 500 })
    end
 
    -- Função para voltar para a pagina anterior 
    local function onBackTap(event)
        audio.play(SomVolt)
        composer.gotoScene("page3", { effect = "slideRight", time = 500 })
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
