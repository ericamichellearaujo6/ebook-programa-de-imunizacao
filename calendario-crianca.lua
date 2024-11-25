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

---------------------------------------------------------------------------------
-- Configurações da página
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    local sceneGroup = self.view

     -- Coordenadas para o centro da tela
     local centerX = display.contentCenterX
     local centerY = display.contentCenterY
 
     -- Adicionar imagem de fundo
    local bg = display.newImageRect(sceneGroup,"assets/calendario_crianca.png", 768, 1024)
     bg.x = centerX
     bg.y = centerY 
 

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

    -- Função para redirecionar para diferentes páginas
    local function onVerticalButtonTap(event)
        audio.play(somBotao)
        
        -- Verifique qual botão foi pressionado e redirecione para a página correspondente
        if event.target.id == 1 then
            composer.gotoScene("crianca0234", { effect = "slideLeft", time = 500 })
        elseif event.target.id == 2 then
            composer.gotoScene("crianca567", { effect = "slideLeft", time = 500 })
        elseif event.target.id == 3 then
            composer.gotoScene("crianca91215", { effect = "slideLeft", time = 500 })
        elseif event.target.id == 4 then
            composer.gotoScene("crianca4567910", { effect = "slideLeft", time = 500 })
        end
    end

       -- Definindo as posições individuais para os botões
    local posiBt = {
        { x = 328, y = 340, id = 1 }, -- Botão 1
        { x = 325, y = 530, id = 2 }, -- Botão 2
        { x = 330, y = 700, id = 3 }, -- Botão 3
        { x = 330, y = 860, id = 4 } -- Botão 4
    }

    -- Criando os 4 botões verticais e atribuindo IDs para identificar qual botão foi pressionado
    for i,posi in ipairs(posiBt) do
        local button = createButton(
            sceneGroup,
            "assets/bt_mais.png",  -- Substitua pelo caminho da sua imagem
            posi.x,
            posi.y ,
            1.0,
            1.0,
            onVerticalButtonTap
        )
        button.id = i  -- Atribui um ID exclusivo para cada botão
    end
end

 -- Carregar o som do botão
 somBotao = audio.loadSound("assets/som.mp3") 



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
