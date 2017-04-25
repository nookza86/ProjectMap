local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local Bg, cx, cy, cw, ch
local TitleImage, UsernameImage, CountryImage, UserImage
local KataImage, KamalaImage, ChalongImage, KaronImage, PatongImage, BigbuddhaImage, BangpaeImage
local SettingBtn, OkBtn
--local params

local function RemoveAll( event )
	if(event) then
		print( "deletePic in profile"  )
		event:removeSelf( )
		event = nil
		
	end
end

local function Check( event )
	local obj = event.target.id

	print( obj )
	if(event.phase == "ended") then
		if(obj == "ok") then
			composer.gotoScene("overview")

		elseif(obj == "setting") then
--[[
			local myRoundedRect = display.newRoundedRect( cx, cy, cw, ch, 1 )
			myRoundedRect:setFillColor( 1,0,1 )
			myRoundedRect.alpha = 0.1

			local options = {
			    isModal = true,
			    effect = "fade",
			    time = 400,
			}
 			composer.showOverlay( "setting", options )
			]]
		elseif(obj == "watchalong") then
			
			local options = {params = {PlaceName = "Chalong Temple"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "bangpae") then
		
			local options = {params = {PlaceName = "BangPae"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "bigbuddha") then
			
			local options = {params = {PlaceName = "Big buddha"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "kata") then
			
			local options = {params = {PlaceName = "Kata Beach"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "serpent") then
			
			local options = {params = {PlaceName = "Serpent"}}
			--composer.gotoScene("HomePlace", options)

		elseif(obj == "kamala") then
			
			local options = {params = {PlaceName = "Kamala Beach"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "karon") then
			
			local options = {params = {PlaceName = "Karon Beach"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "patong") then
			
			local options = {params = {PlaceName = "Patong Beach"}}
			composer.gotoScene("HomePlace", options)

		elseif(obj == "profile") then
			
			local options = {params = {PlaceName = "Patong Beach"}}
			composer.gotoScene("profile", options)
		end
	end
end
function scene:create(event)
	local sceneGroup = self.view
	print("Scene #Profile : create")
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	cx = display.contentCenterX
    cy = display.contentCenterY
    cw = display.contentWidth
    ch = display.contentHeight
	--params = event.params
	if (phase == "will") then
		Bg = display.newImageRect("Phuket/Profile/bg1.png", cw, ch )
		Bg.x = cx 
		Bg.y = cy 
		--Bg:scale( 0.3, 0.3 ) 

		TitleImage = display.newImageRect( "Phuket/Profile/profile.png", 369/2.5, 83/2.5 )
		TitleImage.x = cx 
		TitleImage.y = cy - 135

		UserImage = display.newImageRect( "Phuket/Profile/picpro.png", 387/3.5, 388/3.5 )
		UserImage.x = cx - 180
		UserImage.y = cy - 55

		UsernameImage = display.newImageRect( "Phuket/Profile/user.png", 400/3, 80/3 )
		UsernameImage.x = UserImage.x + 180
		UsernameImage.y = UserImage.y - 30

		CountryImage = display.newImageRect( "Phuket/Profile/country.png", 486/3, 55/3 )
		CountryImage.x = UsernameImage.x
		CountryImage.y = UsernameImage.y + 40

		KataImage = widget.newButton(
    	{
	        width = 532/3.5,
	        height = 126/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/kata_0.png",
	        overFile = "Phuket/Profile/NameActractionPress/kata_0.png",
	        id = "kata",
	        onEvent = Check
    	}
			)
		KataImage.x = cx - 180 
		KataImage.y = cy + 40

		KamalaImage = widget.newButton(
    	{
	        width = 564/3.5,
	        height = 126/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/kamala_0.png",
	        overFile = "Phuket/Profile/NameActractionPress/kamala_0.png",
	        id = "kamala",
	        onEvent = Check
    	}
			)
		KamalaImage.x = KataImage.x + 170
		KamalaImage.y = KataImage.y

		ChalongImage = widget.newButton(
    	{
	        width = 621/3.5,
	        height = 126/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/chalong_0.png",
	        overFile = "Phuket/Profile/NameActractionPress/chalong_0.png",
	        id = "watchalong",
	        onEvent = Check
    	}
			)
		ChalongImage.x = KamalaImage.x + 180
		ChalongImage.y = KamalaImage.y

		KaronImage = widget.newButton(
    	{
	        width = 532/3.5,
	        height = 127/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/karon_0.png",
	        overFile = "Phuket/Profile/NameActractionPress/karon_0.png",
	        id = "karon",
	        onEvent = Check
    	}
			)
		KaronImage.x = KataImage.x 
		KaronImage.y = KataImage.y + 40

		PatongImage = widget.newButton(
    	{
	        width = 565/3.5,
	        height = 127/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/patong_0.png",
	        overFile = "Phuket/Profile/NameActractionPress/patong_0.png",
	        id = "patong",
	        onEvent = Check
    	}
			)
		PatongImage.x = KaronImage.x + 170
		PatongImage.y = KaronImage.y 

		BigbuddhaImage = widget.newButton(
    	{
	        width = 556/3.5,
	        height = 127/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/bigbuddha_0.png",
	        overFile = "Phuket/Profile/NameActractionPress/bigbuddha_0.png",
	        id = "bigbuddha",
	        onEvent = Check
    	}
			)
		BigbuddhaImage.x = PatongImage.x + 170
		BigbuddhaImage.y = PatongImage.y 

		BangpaeImage = widget.newButton(
    	{
	        width = 767/3.5,
	        height = 126/3.5,
	        defaultFile = "Phuket/Profile/NameActraction/bangpae_0.png",
	        overFile = "Phuket/Profile/NameActractionPress/bangpae_0.png",
	        id = "bangpae",
	        onEvent = Check
    	}
			)
		BangpaeImage.x = PatongImage.x
		BangpaeImage.y = PatongImage.y + 40

		SettingBtn = widget.newButton(
    	{
	        width = 70/1.5,
	        height = 70/1.5,
	        defaultFile = "Phuket/Button/Button/setting.png",
	        overFile = "Phuket/Button/ButtonPress/setting.png",
	        id = "setting",
	        onEvent = Check
    	}
			)
		SettingBtn.x = cx - 230
		SettingBtn.y = cy + 130

		OkBtn = widget.newButton(
    	{
	        width = 100/1.5,
	        height = 50/1.5,
	        defaultFile = "Phuket/Button/Button/ok.png",
	        overFile = "Phuket/Button/ButtonPress/ok.png",
	        id = "ok",
	        onEvent = Check
    	}
			)
		OkBtn.x = cx + 230
		OkBtn.y = cy + 130

		print("Scene #Profile : show (will)")
	
	elseif (phase == "did") then
		print("Scene #Profile : show (did)")
		
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(Bg)
		RemoveAll(TitleImage)
		RemoveAll(UsernameImage)
		RemoveAll(CountryImage)
		RemoveAll(UserImage)
		RemoveAll(KataImage)
		RemoveAll(KamalaImage)
		RemoveAll(ChalongImage)
		RemoveAll(KaronImage)
		RemoveAll(PatongImage)
		RemoveAll(BigbuddhaImage)
		RemoveAll(BangpaeImage)
		RemoveAll(SettingBtn)
		RemoveAll(OkBtn)
		print("Scene #Profile : hide (will)")
	elseif (phase == "did") then
		
		print("Scene #Profile : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #Profile : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene