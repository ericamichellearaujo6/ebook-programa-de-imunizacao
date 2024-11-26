-- Importa o módulo composer para gerenciamento de cenas
local composer = require("composer")

-- Cria uma nova cena
local scene = composer.newScene()

local btSomL
local btSomD

-- Variável para armazenar o som
local btSom
local audioEficacia
local canalEficacia
local resposta3
local explicacao3
local image
local btVolt

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
    local bg = display.newImageRect(sceneGroup, "assets/info_contraindicacao.png", 768, 1024)
    bg.x = centerX
    bg.y = centerY 

    -- Carregar os áudios
    btSom = audio.loadSound("assets/som.mp3") 
    audioEficacia =  audio.loadSound("assets/eficacia.mp3") 
    resposta3 = audio.loadSound("assets/resposta3.mp3") 
    explicacao3 = audio.loadSound("assets/explicacao3.mp3") 

    -- Função para voltar para a página anterior
    local function onBackTap(event)
        audio.play(btSom)
        composer.gotoScene("page4", { effect = "slideRight", time = 500 })
    end

    -- Função para ligar o som
    local function onSoundOnTap(event)
        print("Ligando o som...")
        
        -- Se o som foi desligado antes, reinicie a cena
        if canalEficacia == nil then
            -- Resetar tudo para o estado inicial
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

            -- Reproduz o áudio de contraindicações
            canalEficacia = audio.play(audioEficacia, { loops = -1 })
            print("Som ligado no canal: ", canalEficacia)
        end
    end

    -- Função para desligar o som e remover elementos da tela
    local function onSoundOffTap(event)
        print("Desligando o som...")

        -- Interrompe o áudio atual e limpa o canal
        if canalEficacia then
            print("Som está ligado, desligando agora...")
            audio.stop(canalEficacia)
            canalEficacia = nil
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

    -- Função para exibir a imagem e reproduzir os áudios com controle de sequência
    local function showImage()
        -- Verifica se há algum áudio em execução e o para
        if canalEficacia then
            audio.stop(canalEficacia)
            canalEficacia = nil
        end

        -- Remove a imagem existente, se houver
        if image then
            display.remove(image)
            image = nil
        end

        -- Reproduz o áudio de resposta1
        canalEficacia = audio.play(resposta3, {
            onComplete = function()
                -- Após o término do áudio resposta1, reproduz o áudio explicacao1
                canalEficacia = audio.play(explicacao3, {
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
                image = display.newImage(sceneGroup, "assets/explicacao3.png")
                image.x = display.contentCenterX - 50
                image.y = display.contentCenterY + 50
                image.xScale = 1.0
                image.yScale = 1.0
            end
        })
    end

    -- Função para o botão "Mostrar Imagem"
    local function onShowImageTap(event)
        -- Reproduz o som ao clicar no "Mostrar Imagem"
        if canalResposta3 then
            audio.stop(canalResposta3)
        end
        canalResposta3 = audio.play(resposta3)
        showImage()
    end

    -- Adicionar botão para mostrar a imagem
    btShowRect = createButton(
        sceneGroup,
        "assets/resposta3.png",  -- Imagem do botão para exibir o retângulo
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
        if not canalEficacia then
            canalEficacia = audio.play(audioEficacia, { loops = -1 }) -- Reproduz o som em loop
        end
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        if canalEficacia then
            canalEficacia.stop(canalEficacia)
            canalEficacia = nil
        end

        if image then
            display.remove(image)
            image = nil
        end

        if canalResposta3 then
            audio.stop(canalResposta3)
            canalResposta3 = nil
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

-- Adiciona os eventos do ciclo de vida da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
