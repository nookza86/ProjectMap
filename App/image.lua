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
			else
			   print( "File does not exist", reason )  --> File does not exist    apple.txt: No such file or directory
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

return image