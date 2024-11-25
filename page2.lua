-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")

-- Cria uma nova cena
local scene = composer.newScene()

local btSomL
local btSomD

-- Variável para armazenar o som
local  somProx
local SomVolt
local audioPage2
local canal2


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
    local bg = display.newImageRect(sceneGroup, "assets/vacinacao.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY 

    -- Carregar o som do botão
    
    somProx = audio.loadSound("assets/proximo.mp3")
    SomVolt = audio.loadSound("assets/anterior.mp3")
    audioPage2 =  audio.loadSound("assets/page2.mp3")

    -- Função para navegar para a próxima pagina 
    local function onNextTap(event)
        audio.play(somProx)
        composer.gotoScene("page3", { effect = "slideLeft", time = 500 })
    end

    -- Função para voltar para a pagina anterior 
    local function onBackTap(event)
        audio.play(SomVolt)
        composer.gotoScene("page1", { effect = "slideRight", time = 500 })
    end

   -- função para ligar o som 
   local function onSoundOnTap(event)
    print("Ligando o som...")
   if  not canal2 then 
      canal2 = audio.play(audioPage2, { loops = -1 })  -- Reproduz som em loop
      print("Som ligado no canal: ", canal2)
   end
    btSomL.isVisible = false -- Esconde o botão "Ligar som"
    btSomD.isVisible = true -- Mostra o botão "Desligar som"
end

 -- função para desligar o som
local function onSoundOffTap(event)
    print("Desligando o som...")
  if canal2 then
    print("Som está ligado, desligando agora...")  
    audio.stop(canal2);
    canal2 = nil 
    print("Som desligado.")
  end
    btSomD.isVisible = false -- Esconde o botão "Desligar som"
    btSomL.isVisible = true -- Mostra o botão "Ligar som"
end
    -- Adicionando os botões

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
     btSomL = createButton(
        sceneGroup,
        "assets/som-ligar.png",
        display.contentWidth - 530,
        display.contentHeight - 55, 
        0.5, 
        0.5, 
        onSoundOnTap 
    )
    btSomL.isVisible = false --começa invisivel 

    -- botão 'Desligar Som'
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

    -- Adicionar os botões novos
    local NewButtons = 4
    local espacoEntreBotoes = 90
    local deslocamentoEsquerda = 50 

    -- Lista de imagens dos novos botões
    local newButtonImages = {
        "assets/bebe.png",
        "assets/adolescente.png",
        "assets/adulto_e_idoso.png",
        "assets/gestante.png"
    }

    -- Definir a escala 
    local scaleFactor = 0.9 

    local newButtons = {}
     somBotao = audio.loadSound("assets/som.mp3");
    for i = 1, NewButtons do
        newButtons[i] = createButton(
            sceneGroup,
            newButtonImages[i],
            (150 + ((i - 1) * (100 + espacoEntreBotoes))) - deslocamentoEsquerda,
            display.contentHeight - 255, 
            scaleFactor, 
            scaleFactor,
            function()
              audio.play(somBotao);
                --para o audio quado ofor pressionado o bt do calendario
                if canal2 then
                    audio.pause(canal2);
                end
                btSomL.isVisible = true  -- Torna o botão "Ligar som" visível
                btSomD.isVisible = false
                -- Direcionar para a pagina correspondente
                if i == 1 then
                    composer.gotoScene("calendario-crianca") -- Para o botão bebe
                elseif i == 2 then
                    composer.gotoScene("calendario-adolescente") -- Para o botão adolescente
                elseif i == 3 then
                    composer.gotoScene("calendario-adultoEidoso") -- Para o botão adulto_e_idoso
                elseif i == 4 then
                    composer.gotoScene("calendario-gestante") -- Para o botão gestante
                end
            end
        )
    end

     -- Reproduzir o som automaticamente ao carregar a cena
     canal2 = audio.play(audioPage2, { loops = -1 })  
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
       if not canal2 then
        canal2 = audio.play(audioPage2, { loops = -1 }) -- Reproduz o som em loop
       end
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
      if canal2 then
        audio.stop(canal2);
        canal2 = nil
      end 
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    
    if somBotao then
        audio.stop()
        audio.dispose(somBotao)
        somBotao = nil
    end
    if audioPage2 then
        if canal2 then
            audio.stop(canal2)
            audio.dispose(canal2)
            canal2 = nil
        end
        audio.dispose(audioPage2)
        audioPage2 = nil
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
