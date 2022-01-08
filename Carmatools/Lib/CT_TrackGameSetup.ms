--try destroydialog gameSetup catch()
rollout gameSetup "Game Settings"
(
	local placementPos = 24
	group "Game Directory" 
	(
		edittext gameDir "" autoDisplay:true width:(widthF-30) pos:[colA,placementPos]
		button gameDir_set "..." width:20 height:18 pos:[colF+30,placementPos]
	)
	groupbox gameStats "Stats" width:(width-8) pos:[4,placementPos+=30] height:98
		label statsLabel "data\RACES.txt - missing" width:widthF pos:[colA,placementPos+=18] height:70
		--label racesFile_found "missing" align:#left
		--label powerupFile "data\POWERUP.txt - missing" align:#left
		--label powerupFile_found "data\POWERUP.txt - missing" align:#left
		--label soundFile "data\SOUND\SOUND.txt - missing" align:#left
		--label soundFile_found "data\SOUND\SOUND.txt - missing" align:#left
		--label scrollersFile "data\SCROLLERS.txt - missing" align:#left
		--label scrollersFile_found "data\SCROLLERS.txt - missing" align:#left
		--label textFile "data\TEXT.txt - missing" align:#left
		--label textFile_found "data\TEXT.txt - missing" align:#left
	
	fn updateStats = (
		statsString = ""
		mainDir = gameDir.text
		rootnode.track_general_attributes.gameDir = mainDir
		dataDir = mainDir+"data\\"
		if doesfileexist (dataDir+"RACES.txt") then (statsString += "V RACES.TXT - Found")
		else ((statsString += "X RACES.TXT - Missing"))
		if doesfileexist (dataDir+"POWERUP.txt") then (statsString += "\nV POWERUP.TXT - Found")
		else ((statsString += "\nX POWERUP.TXT - Missing"))
		if doesfileexist (dataDir+"SCROLLERS.txt") then (statsString += "\nV SCROLLERS.TXT - Found")
		else ((statsString += "\nX SCROLLERS.TXT - Missing"))
		if doesfileexist (dataDir+"TEXT.txt") then (statsString += "\nV TEXT.TXT - Found")
		else ((statsString += "\nX TEXT.TXT - Missing"))
		if doesfileexist (dataDir+"\Sound\SOUND.txt") then (statsString += "\nV SOUND.TXT - Found")
		else ((statsString += "\nX SOUND.TXT - Missing"))
		
		statsLabel.text = statsString
	)
	on gameDir_set pressed do (
		tempDir = getSavePath caption:"select an export path" initialDir:(maxFilePath)
		if tempDir != undefined do (
			gameDir.text = tempDir + "\\"
			updateStats()
		)
	)
	on gameDir changed val do (
		updateStats()
	)
	on gameSetup open do (
		gameSetup.height = 158
		gameDir.text = try rootnode.track_general_attributes.gameDir catch ""
		updateStats()
	)
)
--createdialog gameSetup width height