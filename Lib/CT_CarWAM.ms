fileName = GetSaveFileName caption:"Choose an exportname" types:"Wam(*.WAM)|*.WAM"
if fileName != undefined do
(
	wamFile = createfile fileName
	
	format "VERSION 4\n\n" to:wamFile
	
	format "// Sub member: Master-crush data\n" to:wamFile
	--xmins
	if rootnode.wamCrushLimits[2] > 0 then (
		writeLine #(2) "// Number of 'X mins' entries.\n" wamFile
		writeLine #(rootnode.xMins[1]) "// X mins\n" wamFile
		writeLine #(rootnode.xMins[2]) "// X mins\n" wamFile
	)
	else (
		writeLine #(1) "// Number of 'X mins' entries.\n" wamFile
		writeLine #(rootnode.xMins[1]) "// X mins\n" wamFile
	)
	--xmaxs
	if rootnode.wamCrushLimits[4] > 0 then (
		writeLine #(2) "// Number of 'X maxs' entries.\n" wamFile
		writeLine #(rootnode.xMaxs[1]) "// X maxs\n" wamFile
		writeLine #(rootnode.xMaxs[2]) "// X maxs\n" wamFile
	)
	else (
		writeLine #(1) "// Number of 'X maxs' entries.\n" wamFile
		writeLine #(rootnode.xMaxs[1]) "// X maxs\n" wamFile
	)
	--ymins
	if rootnode.wamCrushLimits[10] > 0 then (
		writeLine #(2) "// Number of 'Y mins' entries.\n" wamFile
		writeLine #(rootnode.yMins[1]) "// Y mins\n" wamFile
		writeLine #(rootnode.yMins[2]) "// Y mins\n" wamFile
	)
	else (
		writeLine #(1) "// Number of 'Y mins' entries.\n" wamFile
		writeLine #(rootnode.yMins[1]) "// Y mins\n" wamFile
	)
	--ymaxs
	if rootnode.wamCrushLimits[12] > 0 then (
		writeLine #(2) "// Number of 'Y maxs' entries.\n" wamFile
		writeLine #(rootnode.yMaxs[1]) "// Y maxs\n" wamFile
		writeLine #(rootnode.yMaxs[2]) "// Y maxs\n" wamFile
	)
	else (
		writeLine #(1) "// Number of 'Y maxs' entries.\n" wamFile
		writeLine #(rootnode.yMaxs[1]) "// Y maxs\n" wamFile
	)
	--zmins
	if rootnode.wamCrushLimits[6] > 0 then (
		writeLine #(2) "// Number of 'Z mins' entries.\n" wamFile
		writeLine #(rootnode.zMins[1]) "// Z mins\n" wamFile
		writeLine #(rootnode.zMins[2]) "// Z mins\n" wamFile
	)
	else (
		writeLine #(1) "// Number of 'Z mins' entries.\n" wamFile
		writeLine #(rootnode.zMins[1]) "// Z mins\n" wamFile
	)
	--zmaxs
	if rootnode.wamCrushLimits[8] > 0 then (
		writeLine #(2) "// Number of 'Z maxs' entries.\n" wamFile
		writeLine #(rootnode.zMaxs[1]) "// Z maxs\n" wamFile
		writeLine #(rootnode.zMaxs[2]) "// Z maxs\n" wamFile
	)
	else (
		writeLine #(1) "// Number of 'Z maxs' entries.\n" wamFile
		writeLine #(rootnode.zMaxs[1]) "// Z maxs\n" wamFile
	)
	writeLine #(rootnode.bendabillityFactor) "// Bendability factor\n" wamFile
	writeLine #(rootnode.bendPointZmin) "// Bend point Z min\n" wamFile
	writeLine #(rootnode.bendPointZmax) "// Bend point Z max\n" wamFile
	writeLine #(rootnode.snappabillityFactor) "// Snappability factor\n" wamFile
	writeLine #(rootnode.ySplitPosition) "// Y split position\n" wamFile
	writeLine #(rootnode.driverPos.x,rootnode.driverPos.z,-rootnode.driverPos.y) "// Driver position\n" wamFile
	
	writeLine #(rootnode.wamEntries.count) "// Number of 'Crush data' entries.\n" wamFile
	for i=1 to rootnode.wamEntries.count do (
		wam = rootnode.wamEntries[i]
		format ("// entry "+((i-1) as string)+"\n") to:wamFile
		writeLine #(wam.name) "// Actor\n" wamFile
		softNessEntries = #("soft", "normal", "hard", "uncrushable")
		writeLine #(softNessEntries[wam.softNess]) "// Softness\n" wamFile
		crushTypes = #("boring", "flap", "detach")
		writeLine #(crushTypes[wam.crushType]) "// Crush type\n" wamFile
		if wam.crushType == 2 then (
			writeLine #(wam.flapHingePoint1) "// Hinge point 0\n" wamFile
			writeLine #(wam.flapHingePoint2) "// Hinge point 1\n" wamFile
			writeLine #(wam.flapHingePoint3) "// Hinge point 2\n" wamFile
			if wam.flapOpenable then writeLine #(1) "// Kev-o-flap\n" wamFile
			else writeLine #(0) "// Kev-o-flap\n" wamFile
			flapEaseEntries = #("very_easy","easy","normal","hard")
			writeLine #(flapEaseEntries[wam.flapEase]) "// Ease of flap\n" wamFile
			detachShapes = #("box","sphere")
			writeLine #(detachShapes[wam.shape]) "// Shape\n" wamFile
		)
		if wam.crushType == 3 then (
			detachEaseTypes = #("very_easy","easy","normal","hard")
			writeLine #(detachEaseTypes[wam.detachEase]) "// Ease of detachement\n" wamFile
			detachTypes = #("normal","stubborn","fully_detach")
			writeLine #(detachTypes[wam.detachType]) "// Type\n" wamFile
			detachShapes = #("box","sphere")
			writeLine #(detachShapes[wam.shape]) "// Shape\n" wamFile
		)
		writeLine #(wam.smashEntries.count) "// Number of 'Smash data' entries\n\n" wamFile
		for j = 1 to wam.smashEntries.count do (
			smash = wam.smashEntries[j]
			writeLine #(smash.name) "// Name of Material\n" wamFile
			writeLine #(smash.startBitmap) "// Pixelmap to be used when intact\n" wamFile
			writeLine #(smash.levels.count) "// Number of Levels\n" wamFile
			for k=1 to smash.levels.count do (
				lvl = smash.levels[k]
				writeline #(lvl.threshold) ("// Trigger threshold for level "+(k as string)+"\n") wamFile
				writeline #(lvl.flags) ("// Flags for level "+(k as string)+"\n\n") wamFile
				writeLine #("// Connotations for level "+(k as string)) "\n" wamFile indent:1
				writeconnotations lvl.connotations wamFile
				format "\n" to:wamFile
				writeline #(1) "// number of pixelmaps\n" wamFile
				writeline #((getfilenamefile lvl.lvl_bitmap)) ("// Pixemap for level "+(k as string)+"\n\n") wamFile
			)
		)
	)
	close wamFile
)