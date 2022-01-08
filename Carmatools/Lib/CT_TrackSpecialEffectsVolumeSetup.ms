tool envboxtool
(
	local envbox
	fn createenvbox = in coordsys grid envbox=box width:1 length:1 height:1 pos:gridPoint boxmode:true wirecolor:(color 255 0 0)
	on mousePoint click do
		case click of
		(
			1: createenvbox()
			3: (select envbox;#stop)
		)
	on mouseMove click do
		case click of
		(
			2: (envbox.width = gridDist.x; envbox.length = gridDist.y)
			3: envbox.height = gridDist.z
		)
)

--try destroydialog SpecialEffectsVolumeSetup catch()
rollout SpecialEffectsVolumeSetup "Special Effects Volume Setup" (
	local sev = undefined
	group "Special Effects Volumes in scene:" (
		dotNetControl sevList "System.Windows.Forms.ListView" width:(width-30) height:164 pos:[colA,24]
		button sevAdd "Add Volume" width:widthC pos:[colA,194] tooltip:"Add a special effects volume to the scene"
		button sevDel "Remove Volume" width:widthC pos:[colD,194] tooltip:"Remove the selected special effects volume from the scene"
	)
	local placementPos = 224
	groupbox sevEnvironment "Environment effects:" width:(width-8) height:64 pos:[4,225]
		spinner SEV_gravity "Gravity Multiplier:" type:#float range:[-100,100,1] scale: 0.1 fieldWidth:40 width:widthC pos:[colA,placementPos+=22] tooltip:"Use negative values for inverted gravity"
		spinner SEV_viscosity "Viscosity Multiplier:" type:#float range:[-100,100,1] scale: 0.1 fieldWidth:40 width:widthC pos:[colD,placementPos] tooltip:"Viscosity slows the car down, like in water"
		spinner SEV_cameffect "Camera effect:" type:#integer range:[-1,1,1] fieldWidth:40 width:widthC pos:[colA,placementPos+=22] tooltip:"-1 and 1 = normal\n0 = water zoom in/out"
		spinner SEV_skycolor "Sky colour:" type:#integer range:[-1,9999,-1] scale:1 fieldWidth:40 width:widthC pos:[colD,placementPos] tooltip:"-1 = normal pixelmap\n0 = black\n1 = use colour value from lighting setup"
	groupbox sevEffects "Side Effects:" width:(width-8) height:62 pos:[4,placementPos+=26]
		spinner SEV_cardamage "Car Damage per ms:" type:#integer range:[0,99,0] fieldWidth:40 width:widthC pos:[colA,placementPos+=20]
		spinner SEV_peddamage "Ped Damage per ms:" type:#integer range:[0,99,0] fieldWidth:40 width:widthC pos:[colD,placementPos]  
		spinner SEV_materialindex "Material Index:" type:#integer range:[0,99,0] fieldWidth:40  width:widthC pos:[colD,placementPos+=21]  
	groupbox sevSounds "Sounds:" width:(width-8) height:194 pos:[4,placementPos+=26]
		spinner SEV_entersnd "Enter Sound ID:" type:#integer range:[-1,9999,1600] scale: 1 fieldWidth:40 width:widthC pos:[colA,placementPos+=20]
		spinner SEV_exitsnd "Exit Sound ID:" type:#integer range:[-1,9999,1600] scale: 1 fieldWidth:40 width:widthC pos:[colD,placementPos]  
		spinner SEV_engsnd "Engine Sound:" type:#integer range:[-1,9999,1600] fieldWidth:40 width:widthC pos:[colD,placementPos+=21]  
		dropdownlist SEV_Soundtype "Ambient Sound Type:" items:#("NONE", "SATURATED", "SCATTERED") selection:1 width:widthC pos:[colA,placementPos+=20] tooltip:""
		listbox SEV_sounds "Ambient Sounds List:" items:#("None") height:6 width:widthC pos:[colD,placementPos] 
		button SEV_add_sound "Add Sound" width:(widthC/2) pos:[colD,placementPos+104] tooltip:"Add a sound index to the list"
		button SEV_remove_sound "Remove Sound" width:(widthC/2) pos:[colD+(widthC/2),placementPos+104]  tooltip:"Remove a sound index from the list"
		dropdownlist SEV_Sounddelay "Sound Delay" items:#("RANDOM", "CONTINUOUS") selection:1 width:widthC pos:[colA,placementPos+=44] tooltip:""
		spinner SEV_minimumint "Minimum Interval:" type:#integer range:[0,99,1] fieldWidth:40 width:widthC pos:[colA,placementPos+=44]
		spinner SEV_maximumint "Maximum Interval:" type:#integer range:[0,99,5] fieldWidth:40 width:widthC pos:[colA,placementPos+=21]
	label endlabel "" pos:[13,644]
	
	fn updateSevControlStates sev = (
		mainState = (sev!=undefined)
		sevEnvironment.visible = mainState 
		SEV_gravity.visible = mainState 
		SEV_viscosity.visible = mainState 
		SEV_cameffect.visible = mainState 
		SEV_skycolor.visible = mainState 
		sevEffects.visible = mainState 
		SEV_cardamage.visible = mainState 
		SEV_peddamage.visible = mainState 
		SEV_materialindex.visible = mainState 
		sevSounds.visible = mainState 
		SEV_entersnd.visible = mainState 
		SEV_exitsnd.visible = mainState 
		SEV_engsnd.visible = mainState 
		SEV_Soundtype.visible = mainState 
		
		ambientState = mainState and (try (sev.sndType > 1) catch(false))
		SEV_sounds.visible = ambientState
		SEV_add_sound.visible = ambientState
		SEV_remove_sound.visible = ambientState
		SEV_Sounddelay.visible = ambientState
		SEV_minimumint.visible = ambientState
		SEV_maximumint.visible = ambientState
	)
	
	fn updateSevControlPositions sev = (
		if sev!=undefined then (
			sevSounds.height = if sev.sndType>1 then 194 else 106
			SpecialEffectsVolumeSetup.height = 366+sevSounds.height
			sevList.update()
		)
	)
	
	fn updateSoundList sev = (
		if sev!=undefined then (
			if sev.sounds.count != 0 then (
				SEV_sounds.items = sev.sounds as array
			)
			else (
				SEV_sounds.items = #("None")
			)
		)
	)
	
	fn updateSevControlValues sev = (
		if sev!=undefined then (
			SEV_gravity.range.z = sev.ev_gravity
			SEV_viscosity.range.z = sev.viscosity
			SEV_cameffect.range.z = sev.cameff
			SEV_skycolor.range.z = sev.skycol
			
			SEV_cardamage.range.z = sev.cardam
			SEV_peddamage.range.z = sev.peddam
			SEV_materialindex.range.z = sev.matindx
			
			SEV_entersnd.range.z = sev.entsnd
			SEV_exitsnd.range.z = sev.exitsnd
			SEV_engsnd.range.z = sev.engsnd
			SEV_Soundtype.selection = sev.sndType
			
			updateSoundList sev
			SEV_Sounddelay.selection = sev.sndDelay
			SEV_minimumint.range.z = sev.minint
			SEV_maximumint.range.z = sev.maxint
		)
	)
	
	fn getSceneSev = (
		sev = for o in geometry where hasAttribute o sev_CA collect o
		qsort sev comparenames
		return sev
	)
	
	fn updateSevList lv = (
		sev = rootnode.sev
		lv.items.Clear()
		for i=1 to sev.count do (
			m = sev[i]
			types = #("None", "Saturated", "Scattered")
			addListItem lv m #((m.ev_gravity as string),types[m.sndType])
		)
		lv.Update()
	)
	
	fn updateSevListSubItems item = (
		if item != undefined then (
			m = item.tag.value
			types = #("None", "Saturated", "Scattered")
			sub = #((m.ev_gravity as string),types[m.sndType])
			updateListSubItems item sub
			sevList.update()
		)
	)

	on SpecialEffectsVolumeSetup open do (
		rootnode.sev = getSceneSev()
		initListView sevList #(#("Name",.4),#("Gravity",.3),#("SoundType",.3))
		sevList.tag = dotNetMxsValue (rootnode.track_general_attributes.sev as array)
		updateSevList sevList
		setListViewSelection sevList 1
	)
	on sevList SelectedIndexChanged i do (
		sev = getListViewSelectedItem sevList
		updateSevControlValues sev
		updateSevControlStates sev
		updateSevControlPositions sev
	)
	
	on sevAdd pressed do (
		startTool envboxtool
		envBox = $
		custattributes.add envBox sev_CA
		converttopoly envBox
		envBox.boxmode = true
		envBox.name = uniquename "envBox001"
		setTransformLockFlags envBox #{4,5,6}
		append rootnode.track_general_attributes.sev envBox
		updateSevList sevList
		setListViewSelection sevList sevList.items.count
	)
	on sevDel pressed do (
		item = sevList.selecteditems.item[0]
		if item !=undefined then (
			curIndex = item.index
			sev = getListViewSelectedItem sevList
			if isvalidnode sev then (
				delete sev
				deleteItem rootnode.sev (curIndex+1)
				deleteListViewItem sevList
				updateListViewColors sevList
			)
			try setListViewSelection sevList curIndex catch (setListViewSelection sevList 0)
		)
	)
	
	on SEV_gravity changed val do (
		try (
			sev.ev_gravity = val 
			updateSevListSubItems sevList.selecteditems.item[0]
		)
		catch()
	)
	on SEV_viscosity changed val do try sev.viscosity = val catch()
	on SEV_cameffect changed val do try sev.cameff = val catch()
	on SEV_skycolor changed val do try sev.skycol = val catch()
	on SEV_cardamage changed val do try sev.cardam = val catch()
	on SEV_peddamage changed val do try sev.peddam = val catch()
	on SEV_materialindex changed val do try sev.matindx = val catch()
	on SEV_entersnd changed val do try sev.entsnd = val catch()
	on SEV_exitsnd changed val do try sev.exitsnd = val catch()
	on SEV_engsnd changed val do try sev.engsnd = val catch()
	on SEV_Soundtype selected i do (
		try (
			sev.sndType = i
			updateSevControlStates sev
			updateSevControlPositions sev
			updateSevListSubItems sevList.selecteditems.item[0]
		)
		catch()
	)
	on SEV_add_sound pressed do	(
		try (
			newSound = newString "None" "Enter a valid sound index Number"
			append sev.sounds newSound
			updateSoundList sev
		)
		catch()
	)
	on SEV_remove_sound pressed do (
		try (
			deleteitem sev.sounds SEV_sounds.selection
			updateSoundList sev
		)
		catch()
	)
	on SEV_Sounddelay selected i do try sev.sndDelay = i catch()
	on SEV_minimumint changed val do try sev.minint = val catch()
	on SEV_maximumint changed val do try sev.maxint = val catch()
)
--createdialog SpecialEffectsVolumeSetup width height