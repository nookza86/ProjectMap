local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local params, cx, cy, cw, ch
local Bg, BgText, BackBtn, SaveBtn
local ImageUser1, ImageUser2, ImageUser3, ImageUser4, ImageUser5
local TitleImage, TitleBookImage, ScoreImage
local ImpressionImage, BeautyImage, CleanImage
local ImpressionRadioGroup, BeautyRadioGroup, CleanRadioGroup
local ImpressionRadioButton
local BeautyRadioButton
local CleanRadioButton
local DiaryGroup

local function RemoveAll( event )
	if(event) then
		print( "deletePic in scene #Diary " .. params.PlaceName  )
		event:removeSelf( )
		event = nil
		
	end
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Diary : create")
end

local function Check( event )

	local options = {params = {PlaceName = params.PlaceName}}
	if(event.phase == "ended") then
		print( "Go to scene #HomePlace " .. params.PlaceName )
		composer.gotoScene("HomePlace", options)
	end

end

local function onSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
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
		print( params.PlaceName )

		Bg = display.newImage("Phuket/Diary/bg.png", cx, cy )
		Bg:scale( 0.9, 0.9 ) 

		TitleImage = display.newImageRect( "Phuket/Diary/diary.png", 1683/12, 859/12 )
		TitleImage.x = cx - 40
		TitleImage.y = cy - 110

		TitleBookImage = display.newImageRect( "Phuket/Diary/book.png", 1200/20, 1022/20 )
		TitleBookImage.x = TitleImage.x + 110
		TitleBookImage.y = TitleImage.y

		BgText = display.newImageRect( "Phuket/Diary/bgtext.png", 1832/7, 814/5)
		BgText.x = cx + 70
		BgText.y = cy - 70

		ScoreImage = display.newImageRect( "Phuket/Diary/score.png", 1810/15, 894/15 )
		ScoreImage.x = cx 
		ScoreImage.y = cy + 70

		ImageUser1 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/12, 1280/12 )
		ImageUser1.x = cx - 170
		ImageUser1.y = cy - 100
		ImageUser1.name = "ImageUser1"

		ImageUser2 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/30, 1280/30 )
		ImageUser2.x = cx - 240
		ImageUser2.y = cy - 20
		ImageUser2.name = "ImageUser2"

		ImageUser3 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/30, 1280/30 )
		ImageUser3.x = ImageUser2.x + 50
		ImageUser3.y = ImageUser2.y 
		ImageUser3.name = "ImageUser3"

		ImageUser4 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/30, 1280/30 )
		ImageUser4.x = ImageUser3.x + 50
		ImageUser4.y = ImageUser3.y 
		ImageUser4.name = "ImageUser4"

		ImageUser5 = display.newImageRect( "Phuket/Diary/addpicture.png", 1280/30, 1280/30 )
		ImageUser5.x = ImageUser4.x + 50
		ImageUser5.y = ImageUser4.y 
		ImageUser5.name = "ImageUser5"

		ImpressionImage = display.newImageRect( "Phuket/Diary/impression.png", 1800/15, 568/15 )
		ImpressionImage.x = ImageUser4.x - 40
		ImpressionImage.y = cy + 130

		BeautyImage = display.newImageRect( "Phuket/Diary/beauty.png", 1588/20, 861/20 )
		BeautyImage.x = ImpressionImage.x 
		BeautyImage.y = ImpressionImage.y + 50

		CleanImage = display.newImageRect( "Phuket/Diary/clean.png", 1622/23, 758/23 )
		CleanImage.x = BeautyImage.x
		CleanImage.y = BeautyImage.y + 50
	
		-- Create a group for the radio button set
 	ImpressionRadioGroup = display.newGroup()
 	BeautyRadioGroup = display.newGroup()
 	CleanRadioGroup = display.newGroup()
 
-- Create two associated radio buttons (inserted into the same display group)
	ImpressionRadioButton = {}
	local position = ImpressionImage.x + 130
	local initialSwitch = true
	for i=1,5 do
		ImpressionRadioButton[i] = widget.newSwitch(
    {
        left = 150,
        top = 200,
        x = position,
        y = cy + 130,
        style = "radio",
        id = "ImpressionRadioButton".. i,
        initialSwitchState = initialSwitch,
        onPress = onSwitchPress
    }
	)
		initialSwitch = false
		position = position + 50
	end

	BeautyRadioButton = {}
	position = BeautyImage.x + 130
	initialSwitch = true
	for i=1,5 do
		BeautyRadioButton[i] = widget.newSwitch(
    {
        left = 150,
        top = 200,
        x = position,
        y = cy + 180,
        style = "radio",
        id = "BeautyRadioButton".. i,
        initialSwitchState = initialSwitch,
        onPress = onSwitchPress
    }
	)
		initialSwitch = false
		position = position + 50
	end

	CleanRadioButton = {}
	position = CleanImage.x + 130
	initialSwitch = true
	for i=1,5 do
		CleanRadioButton[i] = widget.newSwitch(
    {
        left = 150,
        top = 200,
        x = position,
        y = cy + 230,
        style = "radio",
        id = "CleanRadioButton".. i,
        initialSwitchState = initialSwitch,
        onPress = onSwitchPress
    }
	)
		initialSwitch = false
		position = position + 50
	end
--[[
	ImpressionRadioButton1 = widget.newSwitch(
    {
        left = 150,
        top = 200,
        x = cx - 50,
        y = cy + 100,
        style = "radio",
        id = "RadioButton1",
        initialSwitchState = true,
        onPress = onSwitchPress
    }
	)
	
	 
	local ImpressionRadioButton2 = widget.newSwitch(
	    {
	        left = 250,
	        top = 200,
	        x = ImpressionRadioButton1.x + 40,
       		y = ImpressionRadioButton1.y,
	        style = "radio",
	        id = "RadioButton2",
	        onPress = onSwitchPress
	    }
	)

	local ImpressionRadioButton3 = widget.newSwitch(
	    {
	        left = 250,
	        top = 200,
	        x = ImpressionRadioButton2.x + 40,
       		y = ImpressionRadioButton2.y,
	        style = "radio",
	        id = "RadioButton3",
	        onPress = onSwitchPress
	    }
	)

	local ImpressionRadioButton4 = widget.newSwitch(
	    {
	        left = 250,
	        top = 200,
	        x = ImpressionRadioButton3.x + 40,
       		y = ImpressionRadioButton3.y,
	        style = "radio",
	        id = "RadioButton4",
	        onPress = onSwitchPress
	    }
	)

	local ImpressionRadioButton5 = widget.newSwitch(
	    {
	        left = 250,
	        top = 200,
	        x = ImpressionRadioButton4.x + 40,
       		y = ImpressionRadioButton4.y,
	        style = "radio",
	        id = "RadioButton5",
	        onPress = onSwitchPress
	    }
	)
	]]
	for i=1,5 do
	ImpressionRadioGroup:insert( ImpressionRadioButton[i] )	
	BeautyRadioGroup:insert( BeautyRadioButton[i] )	
	CleanRadioGroup:insert( CleanRadioButton[i] )
end
	

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
		BackBtn.y = cy - 130
		BackBtn.name = "BackBtn"

		SaveBtn = widget.newButton(
    	{
	        width = 150/1.5,
	        height = 45/1.5,
	        defaultFile = "Phuket/Button/Button/save.png",
	        overFile = "Phuket/Button/ButtonPress/save.png",
	        id = "SaveBtn",
	        onEvent = Check
    	}
			)
		
		SaveBtn.x = cx 
		SaveBtn.y = cy + 280
		SaveBtn.name = "SaveBtn"

		
		ImageUser1:addEventListener( "touch", Check )
		ImageUser2:addEventListener( "touch", Check )
		ImageUser3:addEventListener( "touch", Check )
		ImageUser4:addEventListener( "touch", Check )
		ImageUser5:addEventListener( "touch", Check )


		scrollView = widget.newScrollView(
    {
        top = 90,
        left = 0,
        width = display.contentWidth,
        height = display.contentHeight,
        scrollWidth = cw,
        scrollHeight = ch,
        --topPadding = 20,
        bottomPadding = 200,
        hideBackground = true,
       -- hideScrollBar = true,
       -- isBounceEnabled = false,
        horizontalScrollDisabled = true
        }
    )

		DiaryGroup = display.newGroup()

		--DiaryGroup:insert( Bg )
		--DiaryGroup:insert( TitleImage )
		--DiaryGroup:insert( TitleBookImage )
		DiaryGroup:insert( BgText )
		DiaryGroup:insert( ImageUser1 )
		DiaryGroup:insert( ImageUser2 )
		DiaryGroup:insert( ImageUser3 )
		DiaryGroup:insert( ImageUser4 )
		DiaryGroup:insert( ImageUser5)
		DiaryGroup:insert( ScoreImage )
		DiaryGroup:insert( ImpressionImage )
		DiaryGroup:insert( BeautyImage )
		DiaryGroup:insert( CleanImage )
		DiaryGroup:insert( SaveBtn )

    scrollView:insert( DiaryGroup )
    scrollView:insert( ImpressionRadioGroup )
    scrollView:insert( BeautyRadioGroup )
    scrollView:insert( CleanRadioGroup )

	elseif (phase == "did") then
		print("Scene #Diary : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		scrollView:remove( DiaryGroup )
	    scrollView:remove( ImpressionRadioGroup )
	    scrollView:remove( BeautyRadioGroup )
	    scrollView:remove( CleanRadioGroup )

	    DiaryGroup:remove( BgText )
		DiaryGroup:remove( ImageUser1 )
		DiaryGroup:remove( ImageUser2 )
		DiaryGroup:remove( ImageUser3 )
		DiaryGroup:remove( ImageUser4 )
		DiaryGroup:remove( ImageUser5)
		DiaryGroup:remove( ScoreImage )
		DiaryGroup:remove( ImpressionImage )
		DiaryGroup:remove( BeautyImage )
		DiaryGroup:remove( CleanImage )
		DiaryGroup:remove( SaveBtn )

		RemoveAll( Bg )
		RemoveAll( BgText )
		RemoveAll( ImageUser1 )
		RemoveAll( ImageUser2 )
		RemoveAll( ImageUser3 )
		RemoveAll( ImageUser4 )
		RemoveAll( ImageUser5)
		RemoveAll( ScoreImage )
		RemoveAll( ImpressionImage )
		RemoveAll( BeautyImage )
		RemoveAll( CleanImage )
		RemoveAll( SaveBtn )
		RemoveAll( BackBtn )
		RemoveAll( TitleImage )
		RemoveAll( TitleBookImage )

		RemoveAll( DiaryGroup )
		RemoveAll( scrollView )

	for i=1,5 do
		ImpressionRadioGroup:remove( ImpressionRadioButton[i] )	
		BeautyRadioGroup:remove( BeautyRadioButton[i] )	
		CleanRadioGroup:remove( CleanRadioButton[i] )
	end


		print("Scene #Diary : hide (will)")
	elseif (phase == "did") then
		print("Scene #Diary : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #Diary : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene