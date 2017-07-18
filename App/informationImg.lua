local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local params, cx, cy, cw, ch
display.setStatusBar(display.HiddenStatusBar)
local slideView = require("Zunware_SlideView")
local BackBtn, topImages, a

local function RemoveAll( event )
	if(event) then
		--print( "deletePic in scene #Information " .. params.PlaceName  )
		event:removeSelf( )
		event = nil
		
	end
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #informatiom : create")
end

local function Check( event )
	print( event.target.id )
	
	if(event.phase == "ended") then
	
		local options = {params = {PlaceName = params.PlaceName}}
		print( "Go to scene #HomePlace " .. params.PlaceName )
		composer.gotoScene("information",options)
		
	end
end


function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	params = event.params
	if (phase == "will") then
		cx = display.contentCenterX
	    cy = display.contentCenterY
	    cw = display.contentWidth
	    ch = display.contentHeight

	    topImages = {
			"Phuket/Information/".. params.PlaceName .."/1.jpg",
			"Phuket/Information/".. params.PlaceName .."/2.jpg",
			"Phuket/Information/".. params.PlaceName .."/3.jpg",
			"Phuket/Information/".. params.PlaceName .."/4.jpg"
			--"top_04.png"
		}                   

 a = slideView.new(topImages, nil)
	a.y = 0

	BackBtn = widget.newButton(
    	{
	        width = 130/2.5,
	        height = 101/2.5,
	        defaultFile = "Phuket/Button/Button/back.png",
	        overFile = "Phuket/Button/ButtonPress/back.png",
	        id = "BackBtn",
	        onEvent = Check
    	}
			)
		
		BackBtn.x = cx - 230
		BackBtn.y = cy - 110	
		elseif (phase == "did") then
		print("Scene #informatiom : show (did)")

		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(BackBtn)
		--RemoveAll(a)
		--RemoveAll(topImages)
		
		a:removeSelf( )
		a = nil
		topImages = nil
		
		print("Scene #informatiom : hide (will)")
	elseif (phase == "did") then
		print("Scene #informatiom : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #informatiom : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene