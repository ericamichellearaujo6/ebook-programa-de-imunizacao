

local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

 -- Coordenadas para o centro da tela
 local centerX = display.contentCenterX
 local centerY = display.contentCenterY
 
 -- Add  imagem
 local bg = display.newImageRect("assets/monitoramento2.png", 768, 1024)
 
 -- centralizar a imagem na tela
 bg.x = centerX
 bg.y = centeraY
 bg.y = bg.y + 510  

    
 -- Adicionar botão 'voltar'
    local voltar = display.newImage("assets/voltar.png")

    voltar.x = display.contentWidth - 70 
    voltar.y = display.contentHeight - 55 
    
    -- Definir a escala 
       voltar.xScale = 0.5
       voltar.yScale = 0.5
    -- Adicionar evento de toque no botão 'voltar'
    voltar:addEventListener("tap", function(event)
        composer.gotoScene("page4")
    end  )  

-------------------------------------------------------------------------
   -- Adicionar botão 'Ligar som'
   local btSomL = display.newImage("assets/som-ligar.png")
 
      btSomL.x = display.contentWidth - 530 -- Centralizado horizontalmente
      btSomL.y = display.contentHeight - 55 -- Posicionado próximo à parte inferior

     -- Definir a escala desejada (por exemplo, 50% do tamanho original)
     btSomL.xScale = 0.5
     btSomL.yScale = 0.5

     -- Adicionar evento de som'
 
 -- Adicionar botão 'Desligar som'
   local btSomD = display.newImage("assets/som-desliga.png")
      
     btSomD.x = display.contentWidth - 220 -- Centralizado horizontalmente
     btSomD.y = display.contentHeight - 55 -- Posicionado próximo à parte inferior

     -- Definir a escala desejada (por exemplo, 50% do tamanho original)
     btSomD.xScale = 0.5
     btSomD.yScale = 0.5

      -- Adicionar evento de som'
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
