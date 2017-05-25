local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local params, cx, cy, cw, ch
local Bg, BgText, BackBtn
local Recommend, TextDesField
local NumberOfRecPlace = {}
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)

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
		if(event.target.id == "BackBtn") then
			local options = {params = {PlaceName = params.PlaceName}}
			print( "Go to scene #HomePlace " .. params.PlaceName )
			composer.gotoScene("HomePlace",options)
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

		BgText = display.newImageRect( "Phuket/Information/text.png", 1222/3.3, 637/3.3)
		BgText.x = cx + 80
		BgText.y = cy - 30

		TextDesField = native.newTextBox( BgText.x , BgText.y, BgText.width, BgText.height, 100 )
	    TextDesField.text = ""
	    TextDesField.hasBackground = false
	    TextDesField.isEditable = false
	    --TextDesField.size = 16
	    TextDesField.font = native.newFont( "Cloud-Light", 16 )

		local sql = "SELECT descriptions FROM attractions WHERE att_name = '".. params.PlaceName .."';"
	--	print(sql)
		for row in db:nrows(sql) do
			TextDesField.text = row.descriptions
			--print(row.descriptions )
		end

		--TextDesField.isFontSizeScaled = true

		BackBtn = widget.newButton(
    	{
	        width = 43,
	        height = 43,
	        defaultFile = "Phuket/Button/Button/back.png",
	        overFile = "Phuket/Button/ButtonPress/back.png",
	        id = "BackBtn",
	        onEvent = Check
    	}
			)
		
		BackBtn.x = cx - 240
		BackBtn.y = cy + 100

		NumberOfRecPlace = RecommendPlace(params.PlaceName)
		
		--print( NumberOfRecPlace )
		local PositionX = cx + 60
		local PositionY = cy + 90
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
				PositionX = cx + 60
				PositionY = cy + 130
				print( "if 3" )
			end

			Recommend[i].x = PositionX 
			Recommend[i].y = PositionY 
			Recommend[i]:scale(0.5,0.5)
			PositionX = PositionX + 150
			
		end



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