fn keepprocessfocus = if ( MaxVersion())[1] >= 9000 do ( dotnetClass "Application" ).doEvents()

fn freadbyte bf = ( return readbyte bf #unsigned )

fn freadshort bf = ( ( readbyte bf #unsigned * 256 ) + ( readbyte bf #unsigned ) )

fn freadlong bf = ( ( ( readbyte bf #unsigned ) * 16777216 ) + ( ( readbyte bf #unsigned ) * 65536 ) + ( ( readbyte bf #unsigned ) * 256 ) + ( readbyte bf #unsigned ) )

fn freadfloat bf =
(
	bf = readfloat bf
	i = bit.floatasint bf
	h = bit.intashex i
	while h.count < 8 do h = "0" + h
	
	s = ( substring h 7 2 ) + ( substring h 5 2 ) + ( substring h 3 2 ) + ( substring h 1 2 )
	bit.intAsFloat ( bit.hexasint s )
)

fn freadstring bf =
(
	return readstring bf
)

fn binend binfile = ( ftell binfile >= filesize )

fn getFilesRecursive root pattern = ( 
	dir_array = GetDirectories ( root + "/*" )
	for d in dir_array do (
		join dir_array ( GetDirectories ( d + "/*" ) )
	)
	join dir_array ( GetDirectories root )

	my_files = #( )
	for f in dir_array do (
		join my_files ( getFiles ( f + pattern ) )
	)
	my_files
)

try destroydialog CT_importer catch()
CT_importer = undefined

scriptpath = pathConfig.GetDir #scripts + "\\Carma_Tools\\lib"
--scriptpath = "C:\\Users\\harms\\Google Drive\\Carmatools 2020\\CT_libraries"
--scriptpath = "C:\\Users\\909754\\Google Drive\\Carmatools 2020\\CT_libraries"
fileIn ( scriptpath + "\\CT_Functions.ms" )
fileIn ( scriptpath + "\\CT_CustomAttributes.ms" )

fileIn ( scriptpath + "\\MATLib.ms" )
fileIn ( scriptpath + "\\DATLib.ms" )
fileIn ( scriptpath + "\\ACTLib.ms" )

filein ( scriptPath + "\\CT_carCustomAttributes.ms" )
fileIn ( scriptPath + "\\CT_CarTxtImport.ms" )
fileIn ( scriptPath + "\\CT_CarWamImport.ms" )

filein ( scriptPath + "\\CT_TrackCustomAttributes.ms" )
fileIn ( scriptPath + "\\CT_TrackTxtImport.ms" )


rollout CT_importer "Carmatools Importer" (
	local ct_gamedir = "C:\\Python\\VanillaC2\\"
	button getFile "Locate file" width:150 height:30
	label impProg "Progress:" width:150 --height:10 offset:[0,0]
	group "Options:" (
		checkbox scanDir "Scan File dir" checked:true tooltip:"scan the entire directory for possible associated files. Useful when dat, mat or act files are split"
		checkbox scanGameDir "Scan Game dir" checked:true tooltip:"Scan the game directories for associated files"
		checkbox importtxt "Import txt" checked:true tooltip:"Import the txt files for cars and tracks too"
		label gameDirLbl "Game dir:" align:#left enabled:scanGameDir.state
		edittext gameDir align:#left width:126 offset:[-4, 0] text:ct_gamedir across:2 enabled:scanGameDir.state
		button setGameDir "..." align:#right width:15 offset:[4, -2] enabled:scanGameDir.state
	)
	on scanGameDir changed state do (
		gameDirlbl.enabled = state
		gameDir.enabled = state
		setGameDir.enabled = state
	)
	
	on setGameDir pressed do (
		
	)
	
	on getFile pressed do (
		fullFileName = getopenfilename types:"All files (*.*)|*.*|SDF files (*.sdf)|*.sdf|ACT files(*.act)|*.act|DAT files(*.dat)|*.dat|MAT files(*.mat)|*.mat"
		if fullFileName != undefined then (
			fileType = getFilenameType fullFileName
			filePath = getFilenamePath fullFileName
			fileName = getFilenameFile fullFileName
			
			--create empty database arrays
			matMaterials = #( )
			datModels = #( )
			actActors = #( )
			
			--add nearby tiffrgb path for bitmap lookup
			sessionPaths.add #map ( filePath + "tiffrgb\\" )
			matFileName = ( filePath + fileName + ".mat" )
			if doesfileexist matFileName then (
				matMaterials = parseMat matFileName
			)
			datFileName = ( filePath + filename + ".dat" )
			if doesfileexist datFileName then (
				datModels = parseDat datFileName
			)
			actFileName = ( filePath + filename + ".act" )
			if doesfileexist actFileName then (
				actActors = parseAct actFileName
			)
			
			
			if scanDir.checked then (
				matFiles = getFiles ( filePath + "*.mat" )
				for fileName in matFiles do (
					matMaterials = join matMaterials ( parseMat fileName )
				)
				datFiles = getfiles ( filepath + "*.dat" )
				for fileName in datFiles do (
					datModels = join datModels ( parseDat fileName )
				)
			)
			
			--add game paths
			if scanGameDir.checked then (
				gameTexturePaths = #( )
				gameMatFilePaths = #( )
				gameDatFilePaths = #( )
				gameActFilePaths = #( )
				
				--c2 assets
				c2DataPath = ct_gameDir + "data\\"
				c2RegPath = c2DataPath + "reg\\"
				
				append gameTexturePaths ( c2RegPath + "PIXELMAP\\tiffrgb\\" ) 
				append gameMatFilePaths ( c2RegPath + "MATERIAL\\" )
				append gameMatFilePaths ( c2DataPath + "MATERIAL\\" )
				append gameDatFilePaths ( c2RegPath + "MODELS\\" )
				append gameDatFilePaths ( c2DataPath + "MODELS\\" )
				append gameActFilePaths ( c2DataPath + "ACTORS\\" )
				
				for p in gameTexturePaths do (
					if doesfileExist p then (
						sessionpaths.add #map p
					)
				)
				for p in gameMatFilePaths do (
					if doesfileExist p then (
						matFiles = getFiles ( p + "*.mat" )
						for fileName in matFiles do (
							matMaterials = join matMaterials ( parseMat fileName )
						)
					)
				)
				for p in gameDatFilePaths do (
					if doesfileExist p then (
						datFiles = getFiles ( p + "*.dat" )
						for fileName in matFiles do (
							datModels = join datModels ( parseDat fileName )
						)
					)
				)
			)
			
			--st = timestamp()
			--sort datModels Array
			qSort datModels compareModelNames
			--qsort datModels LookupTableComparator
			--format "QSort Time: %ms\n" (timestamp()-st)
			
			--import from act or sdf file
			if ( tolower fileType ) == ".act" or ( tolower fileType ) == ".sdf" then (
				--build every actor consecutively
				for Actor in actActors do (
					buildActor Actor datModels matMaterials
				)
				--cleanup source models
				for model in datModels do (
					if model != undefined then (
						if model.object != undefined then (
							delete model.object
							model.object = undefined
						)
					)
				)
			)
			
			--import from dat file
			if ( tolower fileType ) == ".dat" then (
				for model in datModels do (
					buildModel model matMaterials
				)
			)
			
			free actActors
			free datModels
			free matMaterials
			
			--clean sessionpaths
			mapPathCount = sessionpaths.count #map
			for i = 3 to mapPathCount do (
				sessionpaths.delete #map 3
			)
			
			if importtxt.checked then (
				txtFileName = ( filePath + filename + ".txt" )
				if doesfileExist txtFileName then (
					f = openFile txtFileName
					version = ( substituteString ( readNextLine f ) "VERSION " "" ) as integer
					nextLine = tolower ( readNextLine f )
					close f
					
					if findstring nextLine ".txt" != undefined then (
						parseCarTxtFile txtFileName
						wamFileName = ( filePath + fileName + ".wam" )
						if doesFileExist wamFileName then (
							parseCarWamFile wamFileName
						)
						
					)
					else (
						parseTrackTxtFile txtFileName
					)
				)
			)
		)
		impProg.text = "Progress: Import Complete"
	)
)
createdialog CT_importer 