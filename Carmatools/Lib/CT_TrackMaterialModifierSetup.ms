--try destroydialog materialModifierSetup catch()
rollout materialModifierSetup "Material Modifiers" (
	local placementPos = 24
	local matmod
	group "Material Modifiers" (
		listbox matMods_list "" width:widthC pos:[colA,placementPos] height:16 tooltip:"use the indexed number in front of your material names to link the properties to the material"
		button matMods_add "Add Mat Mod" width:(widthC/2) pos:[colA,placementPos+matMods_list.height+4] tooltip:"Add a new material modifier"
		button matMods_remove "Del Mat Mod" width:(widthC/2) pos:[colA+(widthC/2),placementPos+matMods_list.height+4] tooltip:"Remove the selected modifier"
		
		spinner mm_car_wall_friction "Car wall friction:" range:[0,99,1] type:#float fieldwidth:40 width:widthC pos:[colD,placementPos]
		spinner mm_tyre_road_friction "Tyre road friction:" range:[0,99,1] type:#float fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		spinner mm_downforce "Downforce:" range:[0,99,1] type:#float fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		spinner mm_bumpiness "Bumpiness:" range:[0,99,0] type:#float fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		spinner mm_tyre_sound_index "Tyre sound index:" range:[0,9999,0] type:#integer fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		spinner mm_crash_sound_index "Crash sound index:" range:[0,9999,0] type:#integer fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		spinner mm_scrape_sound_index "Scrape sound index:" range:[0,9999,0] type:#integer fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		spinner mm_sparkyness "Sparkyness:" range:[0,2,1] type:#integer fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		spinner mm_expansionroom "Tyre dust type:" range:[0,99,1] type:#integer fieldwidth:40 width:widthC pos:[colD,placementPos+=21] tooltip:"Index of the dust type to use for dust. 0=nodust 1=whitedust 2+=colored dust"
		dropdownlist mm_skidmark "" items:#("SKIDMARK.MAT","DESKID.MAT","GIBSMEAR.MAT","MUD1.MAT","OILSMEAR.MAT","SNOWSKID.MAT") selection:1 fieldwidth:40 width:widthC pos:[colD,placementPos+=26]
		label mm_end "" pos:[colA,placementPos+=34]
	)
	fn updateMatModControlStates matMod = (
		mainState = (matMod!=undefined)
		mm_car_wall_friction.visible = mainState
		mm_tyre_road_friction.visible = mainState
		mm_downforce.visible = mainState
		mm_bumpiness.visible = mainState
		mm_tyre_sound_index.visible = mainState
		mm_crash_sound_index.visible = mainState
		mm_scrape_sound_index.visible = mainState
		mm_sparkyness.visible = mainState
		mm_expansionroom.visible = mainState
		mm_skidmark.visible = mainState
	)
	fn updateMatModControlValues matMod = (
		if matMod != undefined then (
			mm_car_wall_friction.range.z = matMod.car_wall_friction
			mm_tyre_road_friction.range.z = matMod.tyre_road_friction
			mm_downforce.range.z = matMod.downforce
			mm_bumpiness.range.z = matMod.bumpiness
			mm_tyre_sound_index.range.z = matMod.tyre_snd_ind
			mm_crash_sound_index.range.z = matMod.crash_snd_ind
			mm_scrape_sound_index.range.z = matMod.scrape_snd_ind
			mm_sparkyness.range.z = matMod.sparkyness
			mm_expansionroom.range.z = matMod.expansionroom
			mm_skidmark.selection = matMod.skidmark
		)
	)
	
	fn updateMatModListSelection = (
		matMods_list.items = for m in rootnode.matMods collect m.name
		matMod = try rootnode.matMods[matMods_list.selection] catch(undefined)
		updateMatModControlStates matMod
		updateMatModControlValues matMod
	)
	
	on matMods_add pressed do (
		append rootnode.matMods (standard())
		matMod = rootnode.matMods[rootnode.matMods.count]
		matMod.name = "New mat modifier"
		custattributes.add matMod matMod_CA
		updateMatModListSelection()
		matMods_list.selection = matMods_list.items.count
		updateMatModListSelection()
	)
	on matMods_remove pressed do (
		if rootnode.matMods.count != 0 do
		(
			matMod = rootnode.matMods[matMods_list.selection]
			try custattributes.delete matMod matMod_CA catch()
			deleteitem rootnode.matMods matMods_list.selection
			updateMatModListSelection()
		)
	)
	on matMods_list selected i do (
		matMod = try rootnode.matMods[i] catch(undefined)
		updateMatModControlStates matMod
		updateMatModControlValues matMod
	)
	on matMods_list doubleClicked i do (
		matMod = try rootnode.matMods[i] catch(undefined)
		if matMod != undefined then (
			matMod.name = newString matMod.name "Enter a new name with a prefix index" 
			updateMatModListSelection()
		)
	)
	on mm_car_wall_friction changed val do try matMod.car_wall_friction = val catch()
	on mm_tyre_road_friction changed val do try matMod.tyre_road_friction = val catch()
	on mm_downforce changed val do try matMod.downforce = val catch()
	on mm_bumpiness changed val do try matMod.bumpiness = val catch()
	on mm_tyre_sound_index changed val do try matMod.tyre_snd_ind = val catch()
	on mm_crash_sound_index changed val do try matMod.crash_snd_ind = val catch()
	on mm_scrape_sound_index changed val do try matMod.scrape_snd_ind = val catch()
	on mm_sparkyness.range changed val do try matMod.sparkyness = val catch()
	on mm_expansionroom changed val do try matMod.expansionroom = val catch()
	on mm_skidmark selected i do try matMod.skidmark = i catch()
	
	local dusttype
	group "Dust Types" (
		label dusttype_label "These can be referenced from 2 and up. (0 and 1 are default)" pos:[colA,placementPos+=44]
		listbox dustTypes_list "" items:#() height:6 width:widthC pos:[colA,placementPos+=21]
		button dt_add "Add dust Type" width:(widthC/2) pos:[colA,placementPos+dustTypes_list.height+4]
		button dt_remove "Del Dust Type" width:(widthC/2) pos:[colA+(widthC/2),placementPos+dustTypes_list.height+4]

		colorpicker dustType_color "Dust color:" color:white height:20 fieldwidth:50 pos:[colE+4,placementPos]
		spinner dustType_qstrength "strength 1/4:" range:[0,1,0.25] fieldwidth:40 width:widthC pos:[colD,placementPos+=26]
		spinner dustType_hstrength "strenght 1/2:" range:[0,1,0.5] fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		spinner dustType_thrqstrength "strength 3/4:" range:[0,1,0.75] fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		label dustType_end "" pos:[colA,placementPos+=30]
	)
	fn updateDustTypeControlStates dustType = (
		mainState = dustType!=undefined
		dustType_color.visible = mainState
		dustType_qstrength.visible = mainState
		dustType_hstrength.visible = mainState
		dustType_thrqstrength.visible = mainState
	)
	fn updateDustTypeControlValues dustType = (
		if dustType!=undefined then (
			dustType_color.color = dustType.dcolor
			dustType_qstrength.range.z = dustType.qstrength
			dustType_hstrength.range.z = dustType.hstrength
			dustType_thrqstrength.range.z = dustType.tqstrength
		)
	)
	
	fn updateDustTypeListSelection = (
		dustTypes_list.items = for m in rootnode.dustTypes collect m.name
		dustType = try rootnode.dustTypes[dustTypes_list.selection] catch(undefined)
		updateDustTypeControlValues dustType
		updateDustTypeControlStates dustType
	)
	
	on dt_add pressed do (
		append rootnode.dustTypes (standard())
		dustType = rootnode.dustTypes[rootnode.dustTypes.count]
		dustType.name = uniquename "Dust Type 001"
		custattributes.add dustType dustType_CA
		updateDustTypeListSelection()
	)
	on dt_remove pressed do (
		if rootnode.dustTypes.count != 0 do
		(
			matMod = rootnode.dustTypes[dustTypes_list.selection]
			try custattributes.delete dustType dustType_CA catch()
			deleteitem rootnode.dustTypes dustTypes_list.selection
			updateDustTypeListSelection()
		)
	)
	on dustTypes_list selected i do (
		updateDustTypeListSelection()
	)
	on dustTypes_list doubleClicked i do (
		dustType = try rootnode.dustTypes[i] catch(undefined)
		if dustType != undefined then (
			dustType.name = newString dustType.name "Enter a new Description" 
			updateDustTypeListSelection()
		)
	)
	on dustType_color changed col do try dustType.dcolor = col catch()
	on dustType_qstrength changed val do try dustType.qstrength = val catch()
	on dustType_hstrength changed val do try dustType.hstrength = val catch()
	on dustType_thrqstrength changed val do try dustType.tqstrength = val catch()
	
	on materialModifierSetup open do (
		materialModifierSetup.height = 432
		matModCount = rootnode.matMods.count
		if matModCount == 0 then (
			append rootnode.matMods (standard())
			matMod = rootnode.matMods[rootnode.matMods.count]
			matMod.name = "Default (needed if you start adding)"
			custattributes.add matMod matMod_CA
			updateMatModListSelection()
		)
		
		updateMatModListSelection()
		updateDustTypeListSelection()
	)
)
--createdialog materialModifierSetup width height