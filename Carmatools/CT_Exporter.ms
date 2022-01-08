gc()

fn fwriteshort bf val = (
	val = bit.swapBytes val 1 2
	writeshort bf val
)

fn fwritelong bf val = (
	val = bit.swapBytes val 1 4
	val = bit.swapBytes val 2 3
	writelong bf val
)

fn fwritefloat bf val = (
	if val == 0 or val == -0 then (
		writefloat bf 0
	)
	else (
		val = bit.floatAsInt val
		val = bit.intashex val
		while val.count < 8 do val = "0" + val
		s = (substring val 7 2) + (substring val 5 2) + (substring val 3 2) + (substring val 1 2)
		val = bit.intAsFloat (bit.hexasint s)
		writefloat bf val
	)
)

fn hasattribute node atribName = (
	atribCheck = false
	if node != undefined then (
		custAtribCount = custattributes.count node
		if custAtribCount > 0 then (
			for i=1 to custAtribCount do (
				ca = custattributes.get node i
				if ca.name == atribName then (
					atribCheck = true
				)
			)
		)
	)
	atribCheck
)

scriptpath = pathConfig.GetDir #scripts+"\\Carma_Tools\\lib"
--scriptpath = "C:\\Users\\909754\\Google Drive\\Carmatools 2020\\CT_libraries"
--scriptpath = "C:\\Users\\harms\\Google Drive\\Carmatools 2020\\CT_libraries"
fileIn (scriptpath+"\\CT_CustomAttributes.ms")
fileIn (scriptpath+"\\MATLib.ms")
fileIn (scriptpath+"\\DATLib.ms")
fileIn (scriptpath+"\\ACTLib.ms")
filein (scriptPath+"\\CT_carCustomAttributes.ms")
filein (scriptPath+"\\CT_TrackCustomAttributes.ms")


try destroydialog CT_exporter catch()
rollout CT_exporter "Carmatools Exporter" (
	button setFile "Export Scene" width:150 height:30
	group "Options:" (
		label carmaVersionLabel "Version:" across:2
		radiobuttons carmaVersion ""	labels:#("C1","C2") tooltip:"Choose your game version" default:2 columns:2 width:100 align:#left
	)
	group "Quick exports:" (
		button matOnly "mat file only" width:130 height:18 align:#right
		button datOnly "dat file only" width:130 height:18 align:#right
		button actOnly "act file only" width:130 height:18 align:#right
	)
	on setFile pressed do (
		sdfFileName = GetSaveFileName caption:"Choose an exportname" types:"Sdf(*.SDF)|*.SDF"
		if sdfFileName != undefined then (
			sdfFile = createFile sdfFileName
			close sdfFile
			
			filePath = getfilenamepath sdfFileName
			fileName = getfilenamefile sdfFileName
			
			actFileName = filePath+fileName+".ACT"
			models = exportAct actFileName
			
			datFileName = filePath+fileName+".DAT"
			modelMaterials = exportDat models datFileName
			
			matFileName = filePath+fileName+".MAT"
			exportMat modelMaterials matFileName carmaVersion.state
		)
	)
	
	on matOnly pressed do (
		materials = getclassinstances standard
		matName = GetSaveFileName caption:"Choose an exportname" types:"Mat(*.MAT)|*.MAT"
		if matName != undefined do (
			exportMat materials matName carmaVersion.state
		)
	)
	on actOnly pressed do (
		actName = GetSaveFileName caption:"Choose an exportname" types:"Act(*.ACT)|*.ACT"
		if actName != undefined do (
			exportAct actName
		)
	)
	on datOnly pressed do (
		datFileName = GetSaveFileName caption:"Choose an exportname" types:"Dat(*.DAT)|*.DAT"
		if datFileName != undefined do (
			exportDat objects datFileName
		)
	)
)
createdialog CT_exporter