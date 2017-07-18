local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
local mui = require( "materialui.mui" )
local toast = require('plugin.toast')
require("createAcc")
require("get-data")
require ("Network-Check")
require ("facebook.face")
--local facebook = require( "plugin.facebook.v4" )
local sqlite = require("sqlite3")
local path = system.pathForFile( "data.db", system.DocumentsDirectory )
local db = sqlite.open(path)
local params, cx, cy, cw, ch
local Bg, UserImage1, UserImage2, UserImage3, UserImage4
local BackBtn, ShareBtn
local FileName, member_no, NoAtt, DiaryNote, SelecFileImg
local CheckImg1, CheckImg2, CheckImg3, CheckImg4
local backgroundALpha
local CheckSelectImg = false
local myText

local function RemoveAll( event )
	if(event) then
		--print( "deletePic "  )
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
	print("Scene #share : create")
end

local function SelectImg( event )
	SelecFileImg = event.target.id
	print( SelecFileImg )
	
	local RecWidth = 0
	local RecHeight = 0
	local PositionX = 0
	local PositionY = 0
	
--[[
	backgroundALpha = display.newRect(PositionX,PositionY,RecWidth,RecHeight)
	backgroundALpha:setFillColor( black )
	backgroundALpha:scale( 0.2, 0.2 )
	backgroundALpha.alpha = 0.5
]]
	if (CheckSelectImg == true) then
		--RemoveAll(backgroundALpha)
		backgroundALpha:removeSelf( )
		backgroundALpha = nil
	end

	if (SelecFileImg == NoAtt .. "_" .. member_no .. "_1.jpg") then
		RecWidth = UserImage1.width
		RecHeight = UserImage1.height
		PositionX = UserImage1.x
		PositionY = UserImage1.y
		CheckSelectImg = true

	elseif (SelecFileImg == NoAtt .. "_" .. member_no .. "_2.jpg") then
		RecWidth = UserImage2.width
		RecHeight = UserImage2.height
		PositionX = UserImage2.x
		PositionY = UserImage2.y
		CheckSelectImg = true

	elseif (SelecFileImg == NoAtt .. "_" .. member_no .. "_3.jpg") then
		RecWidth = UserImage3.width
		RecHeight = UserImage3.height
		PositionX = UserImage3.x
		PositionY = UserImage3.y
		CheckSelectImg = true

	elseif (SelecFileImg == NoAtt .. "_" .. member_no .. "_4.jpg") then
		RecWidth = UserImage4.width
		RecHeight = UserImage4.height
		PositionX = UserImage4.x
		PositionY = UserImage4.y
		CheckSelectImg = true
	end	

	backgroundALpha = display.newImageRect( "check.png", RecWidth / 6, RecHeight / 6)
	backgroundALpha.x = PositionX
	backgroundALpha.y = PositionY
	
--[[
	backgroundALpha = display.newRect(PositionX,PositionY,RecWidth,RecHeight)
	backgroundALpha:setFillColor( black )
	backgroundALpha:scale( 0.2, 0.2 )
	backgroundALpha.alpha = 0.5
]]

end

local function loadImageListener( event )
	if(not event.isError) then
		
		print( event.response.filename, event.response.baseDirectory )
		if (event.response.filename == NoAtt .. "_" .. member_no .. "_1.jpg") then
			
			UserImage1 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							cx - 200,
							cy + 40 
							)
			UserImage1:scale( 0.2, 0.2 )
			UserImage1.id = event.response.filename
			UserImage1:addEventListener( "touch", SelectImg )

		end

		if (event.response.filename == NoAtt .. "_" .. member_no .. "_2.jpg") then

			UserImage2 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							cx - 70,
							cy + 40 
							)
			UserImage2:scale( 0.2, 0.2 )
			UserImage2.id = event.response.filename
			UserImage2:addEventListener( "touch", SelectImg )
		end

		if (event.response.filename == NoAtt .. "_" .. member_no .. "_3.jpg") then

			UserImage3 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							cx + 60,
							cy + 40 
							)
			UserImage3:scale( 0.2, 0.2 )
			UserImage3.id = event.response.filename
			UserImage3:addEventListener( "touch", SelectImg )
		end

		if (event.response.filename == NoAtt .. "_" .. member_no .. "_4.jpg") then

			UserImage4 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							cx + 190,
							cy + 40 
							)
			UserImage4:scale( 0.2, 0.2 )
			UserImage4.id = event.response.filename
			UserImage4:addEventListener( "touch", SelectImg )
		end
		native.setActivityIndicator( false )
	end

end



local function randomFlag( event )
	if isRechable() == false then 
 		native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
 		return
	end

	local url = "http://mapofmem.esy.es/admin/api/android_upload_api/upload/diary/" ..NoAtt .."/" .. event 
	print( url )
network.download( url , 
	"GET", 
	loadImageListener,
	{},
	event,
	system.DocumentsDirectory
	)

end

local function Check( event )
	print( event.target.id, params.PlaceName)
	local options = {params = {PlaceName = params.PlaceName}}
	if(event.phase == "ended") then
		if(event.target.id == "BackBtn") then
			print( "Go to scene #HomePlace " .. params.PlaceName )
			composer.gotoScene("HomePlace",options)
		elseif (event.target.id == "ShareBtn") then
			print( "Share with facebook button" )
			--buttonOnRelease("sharePhotoDialog")
			--local command = "postPhoto"
			local command = "sharePhotoDialog"
			--local command = "postLink"
			--local command = "postMessage"
			local caption = DiaryNote
			local AttNo = NoAtt
			local memNo = member_no
			local filename = SelecFileImg

			--myText.text = "n : " .. filename

			if (filename == nil or filename == "") then
				return
			else

			if isRechable() == false then 
 				native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
 				return
			end

				buttonOnRelease(command, caption, AttNo, memNo, filename)
			end

		else
			composer.gotoScene("share",options)
		end
	end
end

local function DropTableData(  )
	local NOOOO = 0	
	local sql2 = "SELECT id FROM personel;"
		for row in db:nrows(sql2) do
			NOOOO = row.id
		end
		
	local tablesetup = "DELETE FROM `diary`;"
	db:exec(tablesetup)

	 GetData(2 , NOOOO)

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
	    CheckImg1 = false
	    CheckImg2 = false
	    CheckImg3 = false
	    CheckImg4 = false
	  toast.show('Loading Image!')  
	    Bg = display.newImage("Phuket/share/" .. params.PlaceName .. "/bg.png", cx, cy )
		Bg:scale( 0.3, 0.3 ) 

		local sql = "SELECT att_no FROM attractions WHERE att_name = '".. params.PlaceName .."';"
		NoAtt = 0
		for row in db:nrows(sql) do
			NoAtt = row.att_no
		end

		local sql3 = "SELECT diary_note FROM diary WHERE att_no IN(SELECT att_no FROM attractions WHERE att_name = '".. params.PlaceName .."');"

		for row in db:nrows(sql3) do
			DiaryNote = row.diary_note
		end

		local sql = "SELECT member_no, diary_pic1, diary_pic2, diary_pic3, diary_pic4 FROM diary WHERE att_no IN (SELECT att_no FROM attractions WHERE att_name = '" .. params.PlaceName .. "' );"
		print( "SQL is : " .. sql )
		for row in db:nrows(sql) do
			print( row.member_no , row.diary_pic1, row.diary_pic2, row.diary_pic3, row.diary_pic4 )
			member_no = row.member_no

			if (row.diary_pic1 ~= "") then
				native.setActivityIndicator( true )
				CheckImg1 = true
				FileName = row.diary_pic1
				print( "1" )
				randomFlag(row.diary_pic1)
			end
-----------------------------------------2---------------------------------------------
			if (row.diary_pic2 ~= "") then
				native.setActivityIndicator( true )
				CheckImg2 = true
				print( "2" )
				FileName = row.diary_pic2
				randomFlag(row.diary_pic2)
			end
-----------------------------------------3---------------------------------------------
			if (row.diary_pic3 ~= "") then
				native.setActivityIndicator( true )
				CheckImg3 = true
				print( "3" )
				FileName = row.diary_pic3
				randomFlag(row.diary_pic3)
			end
-----------------------------------------4---------------------------------------------
			if (row.diary_pic4 ~= "") then
				native.setActivityIndicator( true )
				CheckImg4 = true
				print( "4" )
				FileName = row.diary_pic4
				randomFlag(row.diary_pic4)
			end

		end

		if (CheckImg1 == false) then
			print( "else1" )
			UserImage1 = display.newImageRect( "Phuket/share/" .. params.PlaceName .. "/addpicture.png", 999/9, 929/9 )
			UserImage1.x = cx - 200
			UserImage1.y = cy + 40
		end

		if (CheckImg2 == false) then
			print( "else2" )
			UserImage2 = display.newImageRect( "Phuket/share/" .. params.PlaceName .. "/addpicture.png", 999/9, 929/9 )
			UserImage2.x = cx - 70
			UserImage2.y =cy + 40
		end

		if (CheckImg3 == false) then
			print( "else3" )
			UserImage3 = display.newImageRect( "Phuket/share/" .. params.PlaceName .. "/addpicture.png", 999/9, 929/9 )
			UserImage3.x = cx + 60
			UserImage3.y = cy + 40
		end

		if (CheckImg4 == false) then
			print( "else4" )
			UserImage4 = display.newImageRect( "Phuket/share/" .. params.PlaceName .. "/addpicture.png", 999/9, 929/9 )
			UserImage4.x = cx + 190
			UserImage4.y = cy + 40
		end
		
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
		
		ShareBtn = widget.newButton(
    	{
	        width = 451/2.5,
	        height = 121/2.5,
	        defaultFile = "Phuket/Button/Button/share_on_fb.png",
	        overFile = "Phuket/Button/ButtonPress/share_on_fb.png",
	        id = "ShareBtn",
	        onEvent = Check
    	}
			)
		
		ShareBtn.x = cx + 180
		ShareBtn.y = cy + 130

		--native.setActivityIndicator( false )
	elseif (phase == "did") then
		print("Scene #share : show (did)")
		--timer.performWithDelay(3000, showScene)
		
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		RemoveAll(Bg)
		RemoveAll(UserImage1)
		RemoveAll(UserImage2)
		RemoveAll(UserImage3)
		RemoveAll(UserImage4)
		RemoveAll(BackBtn)
		RemoveAll(ShareBtn)

		print("Scene #share : hide (will)")
	elseif (phase == "did") then
		print("Scene #share : hide (did)")
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
	print("Scene #share : destroy")
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

Runtime:addEventListener( "key", onKeyEvent )

return scene