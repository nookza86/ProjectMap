local image = {}

function image.Delete( Filename )
	local lfs = require( "lfs" )
 	--print( "FINDING : " ..Filename )
	-- Get raw path to the app documents directory
	local doc_path = system.pathForFile( "", system.DocumentsDirectory )
	 
	for file in lfs.dir( doc_path ) do
	    -- "file" is the current file or directory name
	    
	    if (file == Filename) then

	    	result, reason = os.remove( Filename )
	    	if result then
			   print( "File removed" )
			   --local alert = native.showAlert( "Error", "File removed.", { "OK" })
			else
			   print( "File does not exist", reason )  --> File does not exist    apple.txt: No such file or directory
			--local alert = native.showAlert( "File does not exist", reason, { "OK" })
			end

	    end
	end
end

function image.CleanDir( Dir )
	local lfs = require( "lfs" )
 
	--local doc_dir = system.DocumentsDirectory;
	local doc_dir = Dir
	local doc_path = system.pathForFile("", doc_dir)
	local resultOK, errorMsg
	 
	for file in lfs.dir(doc_path) do
	    local theFile = system.pathForFile(file, doc_dir)
	 
	    if (lfs.attributes(theFile, "mode") ~= "directory") then
	        resultOK, errorMsg = os.remove(theFile)
	 
	        if (resultOK) then
	            print(file.." removed")
	            --local alert = native.showAlert( "Error", file .. " removed.", { "OK" })
	        else
	            print("Error removing file: "..file..":"..errorMsg)
	            --local alert = native.showAlert( "Error", "Error removing file: "..file..":"..errorMsg, { "OK" })
	        end
	    end
	end 
	return true
end

function image.Remove( Filename, Dir )
	--local destDir = system.DocumentsDirectory  -- Location where the file is stored
	local destDir = Dir
	local result, reason = os.remove( system.pathForFile( Filename, destDir ) )
	  
	if result then
	   print( "File removed" )
	   --local alert = native.showAlert( "RR", Filename .. " removed.", { "OK" })
	else
	   print( "File does not exist", reason )  --> File does not exist    apple.txt: No such file or directory
		--local alert = native.showAlert( "File does not exist", reason, { "OK" })
	end
end

function image.reName( OldName, NewName  )
	--local alert = native.showAlert( "Error", OldName.. " " .. NewName.. " " ..  tostring(Path), { "OK" })
    -- Get raw path to the app documents directory
    local doc_path = system.pathForFile( "", system.TemporaryDirectory )
    local destDir = system.TemporaryDirectory
    local IsRename = false
    for file in lfs.dir( doc_path ) do
        -- "file" is the current file or directory name
        print( "Found file: " .. file )
        --local alert = native.showAlert( "Found", file .. " : " .. OldName, { "OK" })

        if (file == OldName .. ".jpg") then
        	--local alert = native.showAlert( "Found", "file", { "OK" })
            local result, reason = os.rename(
                system.pathForFile( OldName .. ".jpg", destDir ),
                system.pathForFile( "" .. NewName .. ".jpg", destDir )
            )

            if result then
                print( "File renamed" )
                --local alert = native.showAlert( "Error", "File renamed.", { "OK" })
                IsRename = true
                return IsRename

            else          
                print( "File not renamed", reason )  --> File not renamed    orange.txt: No such file or directory
            	--local alert = native.showAlert( "File not renamed", reason, { "OK" })
            	IsRename = false
            	return IsRename
            	
            end

        end
    end

end

local function loadImageListener( event )

	if(not event.isError) then
		return true
	end
	
end

function image.Load( AttractionNo, Filename )
	if isRechable() == false then 
 		--native.showAlert( "No Internet","It seems internet is not Available. Please connect to internet.", { "OK" } )
 		toast.show("It seems internet is not Available.\n Please connect to internet.")
 		return
	end

	local url = "http://mapofmem.esy.es/admin/api/android_upload_api/upload/diary/" ..AttractionNo .."/" .. Filename 
	--print( url )
network.download( url , 
	"GET", 
	loadImageListener,
	{},
	Filename,
	system.DocumentsDirectory
	)

end

function image.getWidth(  )
	return 256
end

function image.getHeight(  )
	return 256
end

return image