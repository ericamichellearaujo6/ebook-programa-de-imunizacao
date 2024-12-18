-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")

-- Cria uma nova cena
local scene = composer.newScene()

local btSomL
local btSomD

-- Variável para armazenar o som
local btSom
local audioContraindicacoes
local canalContra
local resposta1
local explicacao1
local image
local btVolt

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
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Coordenadas para o centro da tela
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY

    -- Adicionar imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/info_contraindicacao.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY 

    -- Carregar os áudios
    btSom = audio.loadSound("assets/som.mp3") 
    audioContraindicacoes =  audio.loadSound("assets/contraindicacao.mp3") 
    resposta1 = audio.loadSound("assets/resposta1.mp3") 
    explicacao1 = audio.loadSound("assets/explicacao1.mp3") 

    -- Função para voltar para a página anterior
    local function onBackTap(event)
        audio.play(btSom)
        composer.gotoScene("page4", { effect = "slideRight", time = 500 })
    end

    -- Função para ligar o som
    local function onSoundOnTap(event)
        print("Ligando o som...")
        
        -- Se o som foi desligado antes, reinicie a cena
        if canalContra == nil then
            -- Resetar  para o estado inicial
            btSomL.isVisible = false
            btSomD.isVisible = true

            -- Reiniciar a tela, removendo imagens e botões antigos
            if image then
                display.remove(image)
                image = nil
            end

            if btVolt then
                display.remove(btVolt)
                btVolt = nil
            end

            
            canalContra = audio.play(audioContraindicacoes, { loops = -1 })
            print("Som ligado no canal: ", canalContra)
        end
    end

    -- Função para desligar o som e remover elementos da tela
    local function onSoundOffTap(event)
        print("Desligando o som...")

        -- Interrompe o áudio atual e limpa o canal
        if canalContra then
            print("Som está ligado, desligando agora...")
            audio.stop(canalContra)
            canalContra = nil
            print("Som desligado.")
        end

        -- Alterna a visibilidade dos botões de som
        btSomD.isVisible = false
        btSomL.isVisible = true

        -- Remove a imagem da explicação, se existente
        if image then
            display.remove(image)
            image = nil
        end

        -- Remove o botão "Voltar" somente se ele foi criado
        if btVolt then
            print("Removendo botão 'Voltar'.")
            display.remove(btVolt)
            btVolt = nil
        else
            print("Botão 'Voltar' não encontrado para remoção.")
        end

        -- Certifique-se de que o botão "Resposta1" está visível
        if btShowRect then
            btShowRect.isVisible = true
        end
    end

    -- Função para exibir a imagem e reproduzir os áudios 
    local function showImage()
        -- Verifica se há algum áudio em execução e o para
        if canalContra then
            audio.stop(canalContra)
            canalContra = nil
        end

        -- Remove a imagem existente, se houver
        if image then
            display.remove(image)
            image = nil
        end

        -- Reproduz o áudio de resposta1
        canalContra = audio.play(resposta1, {
            onComplete = function()
                -- Após o término do áudio resposta1, reproduz o áudio explicacao1
                canalContra = audio.play(explicacao1, {
                    onComplete = function()
                        -- Exibe o botão "Voltar" somente se ainda não foi criado
                        if not btVolt then
                            print("Criando botão 'Voltar'.")
                            btVolt = createButton(
                                sceneGroup,
                                "assets/resposta.png",
                                display.contentWidth - 200,
                                display.contentHeight - 160,
                                1.2,
                                1.2,
                                onBackTap
                            )
                        end
                    end
                })

                -- Exibe a imagem após iniciar o áudio explicacao1
                image = display.newImage(sceneGroup, "assets/explicacao1.png")
                image.x = display.contentCenterX - 50
                image.y = display.contentCenterY + 50
                image.xScale = 1.2
                image.yScale = 1.2
            end
        })
    end

    -- Função para o botão "Mostrar Imagem"
    local function onShowImageTap(event)
        -- Reproduz o som ao clicar no "Mostrar Imagem"
        if canalResposta1 then
            audio.stop(canalResposta1)
        end
        canalResposta1 = audio.play(resposta1)
        showImage()
    end

    -- Adicionar botão para mostrar a imagem
    btShowRect = createButton(
        sceneGroup,
        "assets/resposta1.png",  
        centerX + 200, 
        centerY - 250, 
        1.0, 
        1.0, 
        onShowImageTap
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
    btSomL.isVisible = false

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
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        if not canalContra then
            canalContra = audio.play(audioContraindicacoes, { loops = -1 }) 
        end
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        if canalContra then
            audio.stop(canalContra)
            canalContra = nil
        end

        if image then
            display.remove(image)
            image = nil
        end

        if canalResposta1 then
            audio.stop(canalResposta1)
            canalResposta1 = nil
        end 
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view

    if btSom then
        audio.stop()
        audio.dispose(btSom)
        btSom = nil
    end

    if btVolt then
        display.remove(btVolt)
        btVolt = nil
    end

    if btShowRect then
        display.remove(btShowRect)
        btShowRect = nil
    end
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
