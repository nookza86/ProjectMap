local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local toast = require('plugin.toast')
local params, cx, cy, cw, ch
local Bg, BgText, BackBtn
local Recommend, TextDesField
local AttImg, NearAtt, FrameAttImg
local NumberOfRecPlace = {}
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
display.setStatusBar(display.HiddenStatusBar)
local slideView = require("Zunware_SlideView")

local function RemoveAll( event )
	if(event) then
		--print( "deletePic in scene #Information " .. params.PlaceName  )
		event:removeSelf( )
		event = nil
		
	end
end

local function onKeyEvent( event )
    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
   -- native.showAlert( "Error", message, { "OK" } )
 
    -- If the "back" key was pressed on Android or Windows Phone, prevent it from backing out of the app
    if ( event.keyName == "back" ) then
        local platformName = system.getInfo( "platformName" )
        if ( platformName == "Android" ) or ( platformName == "WinPhone" ) then
        	
            return true
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #informatiom : create")
end

local function Check( event )
	print( event.target.id )
	print( event.phase )

	if(event.target.id == "img") then
		local options = {params = {PlaceName = params.PlaceName}}
			print( "Go to scene #HomePlace " .. params.PlaceName )
			composer.gotoScene("informationImg",options)
	end
	if(event.phase == "ended") then
		if(event.target.id == "BackBtn") then
			local options = {params = {PlaceName = params.PlaceName}}
			print( "Go to scene #HomePlace " .. params.PlaceName )
			composer.gotoScene("HomePlace",options)

		elseif(event.target.id == "img") then
			local options = {params = {PlaceName = params.PlaceName}}
			print( "Go to scene #HomePlace " .. params.PlaceName )
			composer.gotoScene("informationImg",options)
		else
 			local options = {params = {PlaceName = event.target.id}}
 			composer.gotoScene("HomePlace",options)
		end
	end
end

local function RecommendPlace( PlaceNamee )
	local filename = system.pathForFile( "Rule.json", system.ResourceDirectory )
		local decoded, pos, msg = json.decodeFile( filename )
		local RuleOtherNo = 0
		local nationality = "Other"
		local CountRec = {}
		if not decoded then
		    print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
		else
		    print( "File successfully decoded!" )
--------------------check where is number of other rule ------------------------------
		    for idx, val in ipairs(decoded.rule) do
		    	if (nationality == val.nationality) then
		    		RuleOtherNo = val.no
		    		print( "Rule No. " .. RuleOtherNo )
		    		print( "Rule nationality is " .. val.nationality)
		    		print( "-------------------------------------------------" )
		    		break
		    	end-- if nation
			end--for 1
----------------------------------check where is attractions name------------------
			for idx, val in ipairs(decoded["rule"][RuleOtherNo]["recommend"]) do
				 if (decoded["rule"][RuleOtherNo]["recommend"][idx]["name"] == PlaceNamee) then
				 	RuleOtherAttractionNo = idx
				  	print( "Attraction name : " .. decoded["rule"][RuleOtherNo]["recommend"][idx]["name"])
				  	print( "No. " .. RuleOtherAttractionNo )
				  	print( "-------------------------------------------------" )
				  	break
				 end 
			end
---------------------------list reccommend place----------------------------------
			for j,v in ipairs(decoded["rule"][RuleOtherNo]["recommend"][RuleOtherAttractionNo]["recommend"]) do
				CountRec[j] = v
				print( "Recommend no : " .. j,v ) 
			end
			print( "-------------------------------------------------" )
	end -- decode
	return CountRec
end

local function DescripField(  )
	local sql = "SELECT descriptions FROM attractions WHERE att_name = '".. params.PlaceName .."';"
	--	print(sql)
		for row in db:nrows(sql) do
			TextDesField.text = row.descriptions
			--print(row.descriptions )
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

	    Bg = display.newImageRect("Phuket/Information/bg.png", cw, ch )
	    Bg.x = cx 
		Bg.y = cy 
		--Bg:scale( 0.3, 0.3 ) 
		
		BgText = display.newImageRect( "Phuket/Information/text.png", 1222/4, 637/4)
		BgText.x = cx + 60
		BgText.y = cy - 20
		

		TextDesField = native.newTextBox( BgText.x , BgText.y, BgText.width - 30 , BgText.height - 30, 100 )
	    TextDesField.text = ""
	    TextDesField.hasBackground = false
	    TextDesField.isEditable = false
	    TextDesField.font = native.newFont( "Cloud-Light", 14 )

		
		 timer.performWithDelay( 300, DescripField )
		--TextDesField.isFontSizeScaled = true

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
		
		BackBtn.x = cx - 240
		BackBtn.y = cy - 110

		NumberOfRecPlace = RecommendPlace(params.PlaceName)
		
		--print( NumberOfRecPlace )
		local PositionX = cx 
		local PositionY = cy + 80
		Recommend = {}
		for i=1, #NumberOfRecPlace do
				Recommend[i] = widget.newButton(
	    	{
		       -- width = 300/2.5,
		       -- height = 60/2.5,
		        defaultFile = "Phuket/Button/RButton/".. NumberOfRecPlace[i] ..".png",
		        overFile = "Phuket/Button/RButtonPress/".. NumberOfRecPlace[i] ..".png",
		        id = NumberOfRecPlace[i],
		        onEvent = Check
	    	}
				)
			if (i == 3) then
				PositionX = cx + 70
				PositionY = cy + 120
				print( "if 3" )
			end

			Recommend[i].x = PositionX 
			Recommend[i].y = PositionY 
			Recommend[i]:scale(0.4,0.4)
			PositionX = PositionX + 150
			
		end
		

		AttImg = display.newImageRect( "Phuket/Information/".. params.PlaceName .."/1.jpg", cw, ch)
		AttImg.x = cx - 160
		AttImg.y = cy - 20
		AttImg:scale( 0.2, 0.2 ) 
		AttImg:addEventListener("touch", Check)
		AttImg.id = "img"

		FrameAttImg = display.newImageRect( "Phuket/Information/frame_pic.png", cw, ch)
		FrameAttImg.x = cx - 160
		FrameAttImg.y = cy - 20
		FrameAttImg:scale( 0.21, 0.22 ) 



		print( AttImg.width, AttImg.height )

		NearAtt = display.newImageRect( "Phuket/Information/text_nearby.png", 362, 137)
		NearAtt.x = cx - 130
		NearAtt.y = cy + 85
		NearAtt:scale( 0.25, 0.25 ) 

		elseif (phase == "did") then
		print("Scene #informatiom : show (did)")

		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(Bg)
		RemoveAll(BgText)
		RemoveAll(BackBtn)
		RemoveAll(TextDesField)
		RemoveAll(AttImg)
		RemoveAll(NearAtt)

	for i=1, #NumberOfRecPlace do
		Recommend[i]:removeSelf( )
		Recommend[i] = nil
	end
		
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

Runtime:addEventListener( "key", onKeyEvent )

return scene