-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")
local scene = composer.newScene()

-- Variável para armazenar o som
local somBotao
local somColisao
local fimImagem = nil

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

-- Função para criar uma entidade flutuante ( vírus e bactérias)
local function criarEntidade(sceneGroup, imagePath, posX, posY)
    local entidade = display.newImage(sceneGroup, imagePath, 50, 50)
    entidade.x = posX
    entidade.y = posY
    entidade.xScale = 0.2
    entidade.yScale = 0.2
    return entidade
end 

-- Função de colisão 
local function verificarColisao(zeGotinha, entidade, grupoEntidade, i)
    if zeGotinha and entidade then 
    local distX = zeGotinha.x - entidade.x
    local distY = zeGotinha.y - entidade.y
    local distancia = math.sqrt(distX ^ 2 + distY ^ 2)
    local distanciaColisao = (zeGotinha.width * zeGotinha.xScale / 2) + (entidade.width * entidade.xScale / 2)

 


    
    if distancia < distanciaColisao then
        -- Som só toca quando houver colisão
        audio.play(somColisao)
        entidade:removeSelf()
        table.remove(grupoEntidade, i)

        -- Verifica se todas as entidades foram destruídas
        if #virusArray == 0 and #bacArray == 0 then
           if not fimImagem then
            print("Tentando carregar a imagem de vitória.")
             fimImagem = display.newImage(sceneGroup, "assets/img.png", 200, 200)
             fimImagem.x = display.contentCenterX
             fimImagem.y = display.contentCenterY
            end
         end
     end
   end 
end

-- Função de atualização genérica para qualquer grupo de entidades
local function atualizarColisao(zeGotinha)
    -- Verifica as colisões com os vírus
    for i = #virusArray, 1, -1 do
        local virus = virusArray[i]
        if virus then
            verificarColisao(zeGotinha, virus, virusArray, i)
        end
    end

    
    -- Verifica as colisões com as bactérias
    for i = #bacArray, 1, -1 do
        local bac = bacArray[i]
        if bac then
            verificarColisao(zeGotinha,bac, bacArray, i)
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY

    -- Adicionar imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/introducao.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY


   
    -- Adicionar o Zé Gotinha
    local zeGotinha = display.newImageRect(sceneGroup, "assets/gotinha.png", 100, 100)
    zeGotinha.x = display.contentWidth - 400
    zeGotinha.y = display.contentHeight - 200
    zeGotinha:scale(2.5, 2.5)

    -- Função para arrastar o Zé Gotinha
    local function arrastarImagem(event)
        if event.phase == "began" then
            display.getCurrentStage():setFocus(zeGotinha)
            zeGotinha.isFocus = true
            zeGotinha.offsetX = event.x - zeGotinha.x
            zeGotinha.offsetY = event.y - zeGotinha.y
        elseif event.phase == "moved" and zeGotinha.isFocus then
            zeGotinha.x = event.x - zeGotinha.offsetX
            zeGotinha.y = event.y - zeGotinha.offsetY
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus(nil)
            zeGotinha.isFocus = false
        end
        return true
    end

    zeGotinha:addEventListener("touch", arrastarImagem)

    -- Grupos de vírus e bactérias
    virusArray = {}
    bacArray = {}

    -- Posições para os vírus e bactérias
    local posiVirus = { 
        {x = 150, y = display.contentHeight - 190}, 
        {x = 370, y = display.contentHeight - 450}, 
        {x = 590, y = display.contentHeight - 250} 
    }

    local posiBac = {
         {x = 130, y = display.contentHeight - 450}, 
         {x = 540, y = display.contentHeight - 350},
         {x = 630, y = display.contentHeight - 490} 
        }

    -- Criação dos vírus e bactérias
    for i, pos in ipairs(posiVirus) do
        virusArray[i] = criarEntidade(sceneGroup, "assets/virus.png", pos.x, pos.y)
       
    end
    for i, pos in ipairs(posiBac) do
        bacArray[i] = criarEntidade(sceneGroup, "assets/bacteria.png", pos.x, pos.y)
    end

    -- Carregar o som do botão e colisão
    somBotao = audio.loadSound("assets/som.mp3")
    somColisao = audio.loadSound("assets/somDestruir.mp3")

    -- Função para verificar colisões em cada frame
    local function atualizar()
        atualizarColisao(zeGotinha)
    end

    Runtime:addEventListener("enterFrame", atualizar)

    -- Função para navegar para a próxima página
    local function onNextTap(event)
        audio.play(somBotao)
        composer.gotoScene("page2", { effect = "slideLeft", time = 500 })
    end

    -- Função para navegar para a página anterior
    local function onBackTap(event)
        audio.play(somBotao)
        composer.gotoScene("capa", { effect = "slideRight", time = 500 })
    end

    -- Criação dos botões de navegação e som
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

-- Funções show, hide e destroy
function scene:show(event)
    local phase = event.phase
    if phase == "did" then
        -- Quando a cena se torna visível
    end
end

function scene:hide(event)
    local phase = event.phase
    if phase == "did" then
        -- Quando a cena sai da tela
    end
end

function scene:destroy(event)
    if somBotao then
        audio.dispose(somBotao)
        somBotao = nil
    end
    if somColisao then
        audio.dispose(somColisao)
        somColisao = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
