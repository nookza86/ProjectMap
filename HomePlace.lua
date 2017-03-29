local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local params, cx, cy, cw, ch
local Bg, BgBtn, BackBtn, TitleImage
local InformationBtn, MapBtn, ShareBtn, DiaryBtn

local function RemoveAll( event )
	if(event) then
		print( "deletePic in scene #HomePlace " .. params.PlaceName  )
		event:removeSelf( )
		event = nil
		
	end
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #HomePlace : create")
end

local function Check( event )
	print( event.target.id )
	local options = {params = {PlaceName = params.PlaceName}}
	
	if(event.phase == "ended") then
		if(event.target.id == "InformationBtn") then
			print( "Go to scene #Information " .. params.PlaceName )
			composer.gotoScene("information", options)

		elseif (event.target.id == "MapBtn") then
			print( "Go to scene #Map " .. params.PlaceName )
			composer.gotoScene("map", options)

		elseif (event.target.id == "ShareBtn") then
			print( "Go to scene #Share " .. params.PlaceName )
			composer.gotoScene("share", options)

		elseif (event.target.id == "DiaryBtn") then
			print( "Go to scene #Diary " .. params.PlaceName )
			composer.gotoScene("Diary", options)

		elseif (event.target.id == "BackBtn") then
			composer.gotoScene("overview")
		end
	end
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	params = event.params
	cx = display.contentCenterX
    cy = display.contentCenterY
    cw = display.contentWidth
    ch = display.contentHeight

	if (phase == "will") then
		print( "User Click " .. params.PlaceName .. " From Overview" )

		Bg = display.newImage("Phuket/Home/".. params.PlaceName .. "/bg.png", cx, cy )
		Bg:scale( 0.3, 0.3 ) 

		BgBtn = display.newImage("Phuket/Home/".. params.PlaceName .. "/box.png", cx + 170, cy )
		BgBtn:scale( 0.3, 0.33 )

		TitleImage = display.newImage("Phuket/Attraction Name/".. params.PlaceName .. ".png", cx - 100, cy - 100 )
		TitleImage:scale( 0.1, 0.1 )

		--InformationBtn = display.newImageRect( "Phuket/Button/information.png", 3000/30, 1280/30 )
		InformationBtn = widget.newButton(
    	{
	        width = 100,
	        height = 43,
	        defaultFile = "Phuket/Button/information.png",
	        overFile = "Phuket/Button/map.png",
	        id = "InformationBtn",
	        onEvent = Check
    	}
			)
		InformationBtn.x = BgBtn.x 
		InformationBtn.y = BgBtn.y - 90

		InformationBtn = widget.newButton(
    	{
	        width = 100,
	        height = 43,
	        defaultFile = "Phuket/Button/information.png",
	        overFile = "Phuket/Button/information.png",
	        id = "InformationBtn",
	        onEvent = Check
    	}
			)
		InformationBtn.x = BgBtn.x 
		InformationBtn.y = BgBtn.y - 90

		MapBtn = widget.newButton(
    	{
	        width = 100,
	        height = 43,
	        defaultFile = "Phuket/Button/map.png",
	        overFile = "Phuket/Button/map.png",
	        id = "MapBtn",
	        onEvent = Check
    	}
			)
		MapBtn.x = BgBtn.x 
		MapBtn.y = BgBtn.y - 30

		ShareBtn = widget.newButton(
    	{
	        width = 100,
	        height = 43,
	        defaultFile = "Phuket/Button/share.png",
	        overFile = "Phuket/Button/share.png",
	        id = "ShareBtn",
	        onEvent = Check
    	}
			)
		ShareBtn.x = BgBtn.x 
		ShareBtn.y = BgBtn.y + 30

		DiaryBtn = widget.newButton(
    	{
	        width = 100,
	        height = 43,
	        defaultFile = "Phuket/Button/diary.png",
	        overFile = "Phuket/Button/diary.png",
	        id = "DiaryBtn",
	        onEvent = Check
    	}
			)
		DiaryBtn.x = BgBtn.x 
		DiaryBtn.y = BgBtn.y + 90

		BackBtn = widget.newButton(
    	{
	        width = 43,
	        height = 43,
	        defaultFile = "Phuket/Button/back.png",
	        overFile = "Phuket/Button/back.png",
	        id = "BackBtn",
	        onEvent = Check
    	}
			)
		BackBtn.x = BgBtn.x - 400
		BackBtn.y = BgBtn.y + 110
		

	elseif (phase == "did") then
		print("Scene #HomePlace : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(Bg)
		RemoveAll(BgBtn)
		RemoveAll(InformationBtn)
		RemoveAll(MapBtn)
		RemoveAll(ShareBtn)
		RemoveAll(DiaryBtn)
		RemoveAll(BackBtn)
		RemoveAll(TitleImage)

		print("Scene #HomePlace : hide (will)")
	elseif (phase == "did") then
		print("Scene #HomePlace : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #HomePlace : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene