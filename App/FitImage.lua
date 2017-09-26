function fitImage( displayObject, fitWidth, fitHeight, enlarge )

	if (displayObject == nil or displayObject.height == nil or displayObject.width == nil) then
		return
	end
	--
	-- first determine which edge is out of bounds
	--
	local scaleFactor = fitHeight / displayObject.height 
	local newWidth = displayObject.width * scaleFactor
	if newWidth > fitWidth then
		scaleFactor = fitWidth / displayObject.width 
	end
	if not enlarge and scaleFactor > 1 then
		return
	end
	--displayObject:scale( scaleFactor, scaleFactor )

	return scaleFactor
end
 