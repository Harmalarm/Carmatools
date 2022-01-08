
fn parseCarWamFile wamFile = (
--wamFile = getOpenFileName types:"Wam(*.wam)|*.wam"
--(
	if wamFile != undefined then
	(
		f = openfile wamFile
		
		version = readNextLine f
		if (findstring version "VERSION" == undefined) then (
			print "Not a valid Carmageddon 2 car .WAM file"
			exit
		)
		
		versionType = (substitutestring version "VERSION " "") as integer
		
		rootnode.xMins = #(0,0)
		rootnode.xMaxs = #(0,0)
		rootnode.yMins = #(0,0)
		rootnode.yMaxs = #(0,0)
		rootnode.zMins = #(0,0)
		rootnode.zMaxs = #(0,0)
		
		xMinEntries = readNextInteger f
		for i=1 to xMinEntries do (
			rootnode.xMins[i] = (readNextFloat f)
		)
		xMaxEntries = readNextInteger f
		for i=1 to xMaxEntries do (
			rootnode.xMaxs[i] = (readNextFloat f)
		)
		yMinEntries = readNextInteger f
		for i=1 to yMinEntries do (
			rootnode.zMins[i] = (readNextFloat f)
		)
		yMaxEntries = readNextInteger f
		for i=1 to yMaxEntries do (
			rootnode.zMaxs[i] = (readNextFloat f)
		)
		zMinEntries = readNextInteger f
		for i=1 to zMinEntries do (
			rootnode.yMaxs[i] = (readNextFloat f)
		)
		zMaxEntries = readNextInteger f
		for i=1 to zMaxEntries do (
			rootnode.yMins[i] = (readNextFloat f)
		)
		
		rootnode.bendabillityFactor = readNextFloat f
		rootnode.bendPointZmin = readNextFloat f
		rootnode.bendPointZmax = readNextFloat f
		rootnode.snappabillityFactor = readNextFloat f
		rootnode.ySplitPosition = readNextFloat f
		rootnode.driverPos = readNextVector3 f
		
		crushEntryCount = readNextInteger f
		rootnode.wamEntries = #()
		for i=1 to crushEntryCount do (
			triggerName = readNextLine f
			wam = getNodeByName triggerName
			if wam == undefined then (
			)
			else (
				custAttributes.add wam wamEntryAttributes
				
				wam.softness = findItem #("soft", "normal", "hard", "uncrushable") (readNextLine f)
				wam.crushType = findItem #("boring", "flap", "detach") (readNextLine f)
				if wam.crushType == 2 then (
					wam.flapHingePoint1 = readNextInteger f
					wam.flapHingePoint2 = readNextInteger f
					wam.flapHingePoint3 = readNextInteger f
					wam.flapOpenable = readNextBoolean f
					wam.flapEase = findItem #("very_easy","easy","normal","hard") (readNextLine f)
					wam.shape = findItem #("box","sphere") (readNextLine f)
				)
				if wam.crushType == 3 then (
					wam.detachEase = findItem #("very_easy","easy","normal","hard") (readNextLine f)
					wam.detachType = findItem #("normal","stubborn","fully_detach") (readNextLine f)
					wam.shape = findItem #("box","sphere") (readNextLine f)
				)
				wam.smashEntries = #()
				smashEntryCount = readNextInteger f
				if smashEntryCount > 0 then (
					for i=1 to smashEntryCount do (
						smash = standard name:(readNextLine f)
						custAttributes.add smash Smash_CA
						smash.startBitmap = readNextLine f
						levelCount = readNextInteger f
						for j=1 to levelCount do (
							lvl = standard name:("level " +(j as string))
							custAttributes.add lvl textureChange_lvl_CA
							
							lvl.threshold = readNextFloat f
							lvl.flags = readNextInteger f
							lvl.connotations = readConnotations f (smash.name+"_"+lvl.name+"_connotations")
							bitmapCount = readNextInteger f
							for i=1 to bitmapCount do (
								lvl.lvl_bitmap = readNextLine f
							)
							lvl.name = lvl.lvl_bitmap
							append smash.levels lvl
						)
						append wam.smashEntries smash 
					)
				)
				append rootnode.wamEntries wam
			)
		)
		close f
	)
)