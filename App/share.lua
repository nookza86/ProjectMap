local composer = require("composer")
local widget = require("widget" )
local scene = composer.newScene()
local json = require ("json")
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
local FileName, member_no, NoAtt
local CheckImg1, CheckImg2, CheckImg3, CheckImg4

local function RemoveAll( event )
	if(event) then
		print( "deletePic "  )
		event:removeSelf( )
		event = nil
		
	end
end

function scene:create(event)
	local sceneGroup = self.view
	print("Scene #share : create")
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
		end

		if (event.response.filename == NoAtt .. "_" .. member_no .. "_2.jpg") then

			UserImage2 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							cx - 70,
							cy + 40 
							)
			UserImage2:scale( 0.2, 0.2 )
		end

		if (event.response.filename == NoAtt .. "_" .. member_no .. "_3.jpg") then

			UserImage3 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							cx + 60,
							cy + 40 
							)
			UserImage3:scale( 0.2, 0.2 )
		end

		if (event.response.filename == NoAtt .. "_" .. member_no .. "_4.jpg") then

			UserImage4 = display.newImage( 
							event.response.filename, 
							event.response.baseDirectory,
							cx + 190,
							cy + 40 
							)
			UserImage4:scale( 0.2, 0.2 )
		end
	
	end
end



local function randomFlag( event )
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
			buttonOnRelease("sharePhotoDialog")
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
	  --  DropTableData(  )
	    Bg = display.newImage("Phuket/share/" .. params.PlaceName .. "/bg.png", cx, cy )
		Bg:scale( 0.3, 0.3 ) 

		local sql = "SELECT att_no FROM attractions WHERE att_name = '".. params.PlaceName .."';"
		NoAtt = 0
		for row in db:nrows(sql) do
			NoAtt = row.att_no
		end

		local sql = "SELECT member_no, diary_pic1, diary_pic2, diary_pic3, diary_pic4 FROM diary WHERE att_no IN (SELECT att_no FROM attractions WHERE att_name = '" .. params.PlaceName .. "' );"
		print( "SQL is : " .. sql )
		for row in db:nrows(sql) do
			print( row.member_no , row.diary_pic1, row.diary_pic2, row.diary_pic3, row.diary_pic4 )
			member_no = row.member_no

			if (row.diary_pic1 ~= "") then
				CheckImg1 = true
				FileName = row.diary_pic1
				print( "1" )
				randomFlag(row.diary_pic1)
			end
-----------------------------------------2---------------------------------------------
			if (row.diary_pic2 ~= "") then
				CheckImg2 = true
				print( "2" )
				FileName = row.diary_pic2
				randomFlag(row.diary_pic2)
			end
-----------------------------------------3---------------------------------------------
			if (row.diary_pic3 ~= "") then
				CheckImg3 = true
				print( "3" )
				FileName = row.diary_pic3
				randomFlag(row.diary_pic3)
			end
-----------------------------------------4---------------------------------------------
			if (row.diary_pic4 ~= "") then
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
	        width = 43,
	        height = 43,
	        defaultFile = "Phuket/Button/Button/back.png",
	        overFile = "Phuket/Button/ButtonPress/back.png",
	        id = "BackBtn",
	        onEvent = Check
    	}
			)
		
		BackBtn.x = cx - 240
		BackBtn.y = cy + 130
		
		ShareBtn = widget.newButton(
    	{
	        width = 250/1.5,
	        height = 60/1.5,
	        defaultFile = "Phuket/Button/Button/share_on_fb.png",
	        overFile = "Phuket/Button/ButtonPress/share_on_fb.png",
	        id = "ShareBtn",
	        onEvent = Check
    	}
			)
		
		ShareBtn.x = cx + 180
		ShareBtn.y = cy + 130

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

return scene