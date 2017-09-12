local composer = require("composer")
local widget = require("widget" )
local toast = require('plugin.toast')
local scene = composer.newScene()
local Bg, Title

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Loading : create")
end

local function listener1( obj )
    print( "Transition 1 completed on object: " .. tostring( obj ) )
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	
	if (phase == "will") then
		cx = display.contentCenterX
	    cy = display.contentCenterY
	    cw = display.contentWidth
	    ch = display.contentHeight

	    Bg = display.newImageRect("Phuket/Loading/bg.png", cw, ch )
	    Bg.x = cx 
		Bg.y = cy

		Title = display.newImageRect("Phuket/Loading/title.png", 724/3, 334/3 )
	    Title.x = cx 
		Title.y = cy - 30

		Glass = display.newImageRect("Phuket/Loading/glass.png", 302/3, 301/3 )
	    Glass.x = Title.x - 60 
		Glass.y = Title.y - 20

  

		transition.to( Glass, { time=800, x=Glass.x + 150, y=Glass.y, onComplete=listener1 } )
		transition.to( Glass, { time=200, delay=800, x=Glass.x + 150, y=Glass.y + 20 } )
		transition.to( Glass, { time=600, delay=1000, x=Glass.x - 40, y=Glass.y + 55 } )
		transition.to( Glass, { time=800, delay=1600, x=Glass.x + 150, y=Glass.y + 55 } )

		local options = {
    width = 192,
    height = 64,
    numFrames = 6,
    sheetContentWidth = 1152,
    sheetContentHeight = 64
}
local progressSheet = graphics.newImageSheet( "Phuket/Loading/widget-progress-view2.png", options )
 
-- Create the widget
local progressView = widget.newProgressView(
    {
        sheet = progressSheet,
        fillOuterLeftFrame = 1,
        fillOuterMiddleFrame = 2,
        fillOuterRightFrame = 3,
        fillOuterWidth = 64,
        fillOuterHeight = 64,
        fillInnerLeftFrame = 4,
        fillInnerMiddleFrame = 5,
        fillInnerRightFrame = 6,
        fillWidth = 64,
        fillHeight = 64,
        left = (cy / 2),
        top = (cx / 2) + 60,
        width = 400,
        isAnimated = true
    }
)
 
-- Set the progress to 50%
progressView:setProgress( 0.5 )

	

		print("Scene #Loading : show (will)")
	
	elseif (phase == "did") then
		print("Scene #Loading : show (did)")
		
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		return
		print("Scene #Loading : hide (will)")
	elseif (phase == "did") then
		return
		print("Scene #Loading : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #Loading : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene