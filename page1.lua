-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")
local scene = composer.newScene()


 local btSomL = nil
 local btSomD = nil
    
-- Variável para armazenar o som
local somColisao
local btSom
local audioPage1
local canal1

-- Inicializando as tabelas virus e bacterias
local virus = {}
local bacterias = {}

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

-- Função para fazer virus e bacterias  flutuarem
local function flutuar(objeto)
    transition.to(objeto, {
        y = objeto.y - 20, 
        time = 1000, 
        transition = easing.inOutSine, 
        onComplete = function()
            transition.to(objeto, {
                y = objeto.y + 20, 
                time = 1000, 
                transition = easing.inOutSine, 
                onComplete = function()
                    
                    flutuar(objeto)
                end
            })
        end
    })
end

-- Função de colisão
local function verColisao(obj1, obj2)
    if obj1 == nil or obj2 == nil then
        return false
    end

    local distancia = math.sqrt((obj2.x - obj1.x)^2 + (obj2.y - obj1.y)^2)
    local limitecoli = (obj1.width / 2) + (obj2.width / 2)

    if distancia < limitecoli then
        print("Colidiu! Distância:", distancia, "Limite Colisão:", limitecoli) 
        return true
    else
        return false
    end
end

 --carregando sons
 somColisao = audio.loadSound("assets/somDestruir.mp3")
 btSom = audio.loadSound("assets/som.mp3")
 audioPage1 = audio.loadSound("assets/page1.mp3")

 

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

            if canal1 then
                audio.stop(canal1)
                canal1 = nil
            end
           btSomL.isVisible = true
           btSomD.isVisible = false

            display.getCurrentStage():setFocus(zeGotinha)
            zeGotinha.isFocus = true
            zeGotinha.offsetX = event.x - zeGotinha.x
            zeGotinha.offsetY = event.y - zeGotinha.y
            print("Arrastando iniciou!")
        elseif event.phase == "moved" and zeGotinha.isFocus then
            zeGotinha.x = event.x - zeGotinha.offsetX
            zeGotinha.y = event.y - zeGotinha.offsetY
            print("Movendo Zé Gotinha para:", zeGotinha.x, zeGotinha.y)

            -- Verificar colisão com os vírus
            for i = 1, #virus do
                print("Verificando colisão com o vírus", i)
                if verColisao(zeGotinha, virus[i]) then
                    print("colidiu com o vírus")
                    audio.play(somColisao)
                    virus[i]:removeSelf()
                    table.remove(virus, i)

                   -- verifica se todos os virus foram eliminados
                   if #virus == 0 and #bacterias == 0 then
                    local fimImage = display.newImageRect(sceneGroup, "assets/img.png", 390, 390)
                    fimImage.x = display.contentCenterX
                    fimImage.y = display.contentCenterY + 200

                    zeGotinha:removeSelf()
                end
                    break
                end
            end

            -- Verificar colisão com as bactérias
            for i = 1, #bacterias do
                print("Verificando colisão com a bactéria", i)
                if verColisao(zeGotinha, bacterias[i]) then
                    print("colidiu com a bactéria")
                    audio.play(somColisao)
                    bacterias[i]:removeSelf()
                    table.remove(bacterias, i)

                    -- verifica se todos os virus foram eliminados
                    if #virus == 0 and #bacterias == 0 then
                        local fimImage = display.newImageRect(sceneGroup, "assets/img.png", 390, 390)
                        fimImage.x = display.contentCenterX
                        fimImage.y = display.contentCenterY + 200

                        zeGotinha:removeSelf()
                    end

                    break
                end
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus(nil)
            zeGotinha.isFocus = false
        end
        return true
    end

    zeGotinha:addEventListener("touch", arrastarImagem)

    

    -- Posições dos vírus
    local posiVirus = {
        {x = 100, y = display.contentHeight - 400},
        {x = 480, y = display.contentHeight - 400},
        {x = 700, y = display.contentHeight - 350},
        {x = 590, y = display.contentHeight - 190},
    }

    -- Posições das bactérias
    local posiBac = {
        {x = 100, y = display.contentHeight - 200},
        {x = 300, y = display.contentHeight - 400},
        {x = 700, y = display.contentHeight - 500},
    }

    -- Criar vírus e adicionar à tabela
    for i = 1, #posiVirus do
        table.insert(virus, display.newImageRect(sceneGroup, "assets/virus.png", 110, 110))
        virus[i].x = posiVirus[i].x
        virus[i].y = posiVirus[i].y
        print("Vírus criado:", i, "Posição:", virus[i].x, virus[i].y)
        flutuar(virus[i])  
    end

    -- Criar bactérias e adicionar à tabela
    for i = 1, #posiBac do
        table.insert(bacterias, display.newImageRect(sceneGroup, "assets/bacteria.png", 110, 110))
        bacterias[i].x = posiBac[i].x
        bacterias[i].y = posiBac[i].y
        print("Bactéria criada:", i, "Posição:", bacterias[i].x, bacterias[i].y)
        flutuar(bacterias[i]) 
    end


    -- Função para navegar para a próxima página
    local function onNextTap(event)
         if canal1 then 
          audio.stop(canal1);
        end
        audio.play(btSom)
        composer.gotoScene("page2", { effect = "slideLeft", time = 500 })
    end

    -- Função para navegar para a página anterior
    local function onBackTap(event)
        if canal1 then 
            audio.stop(canal1);
        end
        audio.play(btSom)
        composer.gotoScene("capa", { effect = "slideRight", time = 500 })
    end

    -- função para ligar o som 
    local function onSoundOnTap(event)
        print("Ligando o som...")
       if  not canal1 then 
        canal1 = audio.play(audioPage1, { loops = -1 })  
        print("Som ligado no canal: ", canal1)
       end
        btSomL.isVisible = false 
        btSomD.isVisible = true 
    end

     -- função para desligar o som
    local function onSoundOffTap(event)
        print("Desligando o som...")
      if canal1 then
        print("Som está ligado, desligando agora...")  
        audio.stop(canal1);
        canal1 = nil 
        print("Som desligado.")
      end
        btSomD.isVisible = false 
        btSomL.isVisible = true 
    end

    -- Criação dos botões 
    local btProx = createButton(
        sceneGroup,
        "assets/bt-prox.png",
        display.contentWidth - 70,
        display.contentHeight - 55,
        0.5,
        0.5,
        onNextTap
    )

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
        display.contentWidth - 530,
        display.contentHeight - 55,
        0.5,
        0.5,
        onSoundOnTap
    )
    btSomL.isVisible = false -- Começa invisível

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

end

-- Funções show, hide e destroy
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "did" then
         if not canal1 then
          canal1 = audio.play(audioPage1, { loops = -1 }) 
         end
    end
end

function scene:hide(event)
    local phase = event.phase

    if phase == "did" then 
        if canal1 then
      audio.stop(canal1)
        canal1 = nil
       end
    end
end

function scene:destroy(event)

    if btSom then
        audio.dispose(btSom)
        btSom = nil
    end
    if somColisao then
        audio.dispose(somColisao)
        somColisao = nil
    end
    
    if audioPage1 then
        if canal1 then
            audio.stop(canal1)
            audio.dispose(canal1)
            canal1 = nil
        end
        audio.dispose(audioPage1)
        audioPage1 = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
