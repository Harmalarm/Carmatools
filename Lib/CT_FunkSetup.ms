--try destroydialog funkSetup catch()
rollout funkSetup "Funks" (
	local funk = undefined
	local placementPos = 24
	group "Funks in scene:" (
		dotNetControl funksList "System.Windows.Forms.ListView" width:(width-26) height:164 pos:[13,placementPos]
		button addFunk "Add selection" width:widthC pos:[colA,placementPos+=170] tooltip:"Add the funk attributes to the selected material (from material editor)"
		button delFunk "Remove selection" width:widthC pos:[colD,placementPos] tooltip:"Remove the funk attributes from the selected material (from material editor)"
		button editFunk "Add to Material editor" width:widthC pos:[colA,placementPos+=26] 
	)
	groupbox funkMain "Main:" width:(width-8) height:68 pos:[4,placementPos+=30]
		dropdownlist funk_distance "Activation:" items:#("Distance", "Contstant","Lastlap","Otherlaps") width:widthC pos:[colA,placementPos+=18] selection:1 label:false tooltip:"Distance = on proximity, Constant = always, Lastlap = on lastlap, Otherlaps = on other laps"width:150
		dropdownlist funk_lighting "Lighting:" items:#("No lighting") width:widthC pos:[colD,placementPos] selection:1 label:false tooltip:"Placeholder for eventual lighting settings"
	groupbox funkAnimation "Animation:" width:(width-8) height:128 pos:[4,placementPos+=52]
		dropdownlist funk_animation_type "Type:" items:#("None", "Roll", "Slither", "Throb","Rock") width:widthB pos:[colA,placementPos+=18] selection:1 label:false tooltip:"Change the animation of the material."
		dropdownlist funk_animation_mode "Mode:" align:#right items:#("Harmonic", "Linear", "Continuous") width:widthB pos:[colC,placementPos] selection:1 label:false tooltip:"Change the mode of the animation."
		spinner funk_animation_grfu "FunkRef:" range:[0,99,0] type:#integer fieldwidth:40 width:widthB pos:[colE,placementPos+21] tooltip:"For Cars only! Link this in the GroovyFunkRef setup"
	spinner funk_animation_speed_x "Speed X/Y:" type:#float range:[-999999,999999,1] scale: 0.1 fieldWidth:40 width:widthE pos:[colA,placementPos+=45]
		spinner funk_animation_speed_y "" type:#float range:[-999999,999999,1] scale: 0.1 fieldWidth:40 width:widthA pos:[colF,placementPos]
		spinner funk_animation_extent_x "Distance X/Y:"  type:#float range:[-999999,999999,1] scale: 0.1 fieldWidth:40 width:widthE pos:[colA,placementPos+=21]
		spinner funk_animation_extent_y "" type:#float range:[-999999,999999,1] scale: 0.1 fieldWidth:40 width:widthA pos:[colF,placementPos]
		spinner funk_animation_centre_x "Centre X/Y:" type:#float range:[-999999,999999,0.5] scale: 0.1 fieldWidth:40 width:widthE pos:[colA,placementPos+=21]
		spinner funk_animation_centre_y "" type:#float range:[-999999,999999,0.5] scale: 0.1 fieldWidth:40 width:widthA pos:[colF,placementPos]
		spinner funk_animation_period "Period:" type:#float range:[-999999,999999,2] scale: 0.1 fieldWidth:40 width:widthF pos:[colA,placementPos+=21]
		spinner funk_animation_angle "Angle:" type:#float range:[-999999,999999,25] scale: 0.1 fieldWidth:40 width:widthF pos:[colA,placementPos+=21]
	groupbox funkSequence "Sequence:" width:(width-8) height:108 pos:[4,placementPos-=16]
		dropdownlist funk_sequence_type "Type:" items:#("None","Frames") width:widthB pos:[colA,placementPos+=18] selection:1 label:false tooltip:"Change the animation of the texture." 
		dropdownlist funk_sequence_mode "Mode:" items:#("Continuous","Linear","Harmonic","Flash","TextureBits") width:widthB pos:[colC,placementPos] selection:1 label:false tooltip:"Continuous = repeated,\nlinear = directly moving,\nharmonic = ease in ease out,\nflash = jump from start to end\ntexturebits = slice a texture into bits" 
		dropdownlist funk_sequence_textureBitsType "BitsType:" items:#("B","BV","V","VB") width:widthB pos:[colE,placementPos] selection:1 label:false tooltip:"B = brake\nBV = brake and reverse\nV = reverse\nVB = reverse and brake"
		dropdownlist funk_sequence_playback "Playback:" items:#("Approximate","Accurate") width:widthC pos:[colA,placementPos+=44] selection:1 label:false tooltip:"Approximate = for all,\nAccurate = only for Continuous frames" width:150
		spinner funk_sequence_framerate "Framerate: " type:#float range:[0,999999,0.5] scale: 0.1 fieldWidth:40 width:widthC pos:[colD,placementPos+=19]
	groupbox funk_frame_group "Frame names:" width:(widthF+20) height:148 pos:[4,placementPos+=30]
		listbox funk_frames_list "" width:widthC height:7 pos:[colA,placementPos+=18] toolTip:"Collection of frames (bitmap names without extension)"
		button funk_frames_add "Add" width:(widthC/2) pos:[colA,placementPos+=102]
		button funk_frames_remove "Remove" width:(widthC/2) pos:[(colA+(widthC/2)),placementPos]
		edittext funk_frame_name "Frame Properties:" labelOnTop:true width:widthC pos:[colD,placementPos-=120]
		spinner funk_frame_x_count "X Count:" range:[0,99,1] type:#integer fieldwidth:40 width:widthF pos:[colA,placementPos+=40]
		spinner funk_frame_x_index "X Index:" range:[0,99,1] type:#integer fieldwidth:40 width:widthF pos:[colA,placementPos+=21]
		spinner funk_frame_y_count "Y Count:" range:[0,99,1] type:#integer fieldwidth:40 width:widthF pos:[colA,placementPos+=21]
		spinner funk_frame_y_index "Y Index:" range:[0,99,1] type:#integer fieldwidth:40 width:widthF pos:[colA,placementPos+=21]

	--specific rollout functions
	fn updateFunkControlStates funk = (
		mainState = (funk!=undefined)
		funkMain.visible = mainState
		funk_distance.visible = mainState
		funk_lighting.visible = mainState
		
		animType = try funk.animation_type catch 1
		funkAnimation.visible = mainState
		animationState = mainState and (animType > 1)
		
		funk_animation_type.visible = mainState
		funk_animation_mode.visible = animationState
		funk_animation_grfu.visible = animationState
		animationSpeedState = animationState and (animType>1) and (animType!=5)
		funk_animation_speed_x.visible = animationSpeedState
		funk_animation_speed_y.visible = animationSpeedState
		animationExtentState = animationState and (animType>2) and (animType!=5)
		funk_animation_extent_x.visible = animationExtentState
		funk_animation_extent_y.visible = animationExtentState
		animationCentreState = animationState and (animType>3)
		funk_animation_centre_x.visible = animationCentreState
		funk_animation_centre_y.visible = animationCentreState
		animationAngleState = animationState and (animType==5)
		funk_animation_period.visible = animationAngleState
		funk_animation_angle.visible = animationAngleState
	
		sequenceState = mainState and (try (funk.sequence_type!=1) catch false)
		funkSequence.visible = mainState
		funk_sequence_type.visible = mainState
		funk_sequence_mode.visible = sequenceState
		funk_sequence_mode.pos.y = placementPos
		funk_sequence_textureBitsType.visible = mainState and funk.sequence_mode==5
		funk_sequence_playback.visible = sequenceState
		funk_sequence_framerate.visible = mainState and funk.sequence_mode!=5
		
		funk_frame_group.visible = sequenceState
		funk_frames_list.visible = sequenceState
		funk_frames_add.visible = sequenceState
		funk_frames_remove.visible = sequenceState
		funk_frames_remove.pos.y = placementPos
		funk_frame_name.visible = sequenceState
		funk_frame_x_count.visible = sequenceState and funk.sequence_mode == 5
		funk_frame_x_index.visible = sequenceState and funk.sequence_mode == 5
		funk_frame_y_count.visible = sequenceState and funk.sequence_mode == 5
		funk_frame_y_index.visible = sequenceState and funk.sequence_mode == 5
	)
	fn updateFunkControlPositions funk = (
		mainState = funk!=undefined
		placementPos = 224
		animType = try funk.animation_type catch 1
		animationHeights = #(66,85,106,127,127)
		funkAnimation.height = animationHeights[animType]
		
		placementPos = if (animType == 5) then 383 else 425
		funk_animation_centre_x.pos.y = placementPos
		funk_animation_centre_y.pos.y = placementPos
		funk_animation_period.pos.y = placementPos+=21
		funk_animation_angle.pos.y = placementPos+=21
		
		positions = #(387,406,427,448,448)
		placementPos = positions[animType]
		
		sequenceState = mainState and (try (funk.sequence_type!=1) catch false)
		funkSequence.height = if sequenceState then 108 else 66
		funkSequence.pos.y = placementPos
		funk_sequence_type.pos.y = placementPos+=36
		funk_sequence_mode.pos.y = placementPos
		funk_sequence_textureBitsType.pos.y = placementPos
		funk_sequence_playback.pos.y = placementPos+=44
		funk_sequence_framerate.pos.y = placementPos+=6
		funk_frame_group.pos.y = placementPos+=24
		funk_frames_list.pos.y = placementPos+=18
		funk_frames_add.pos.y = placementPos+=102
		funk_frames_remove.pos.y = placementPos
		funk_frame_name.pos.y = placementPos-=102
		funk_frame_x_count.pos.y = placementPos+=21
		funk_frame_x_index.pos.y = placementPos+=21
		funk_frame_y_count.pos.y = placementPos+=21
		funk_frame_y_index.pos.y = placementPos+=21
		
		frameHeight = if sequenceState then 148 else 0
		funkSetup.height = 224 + 68 + funkAnimation.height + funkSequence.height + frameHeight + 36
		
		funksList.update()
	)
	fn updateFunkFrameControls funk i = (
		if funk!=undefined then (
			if i!=0 then (
				funk = getListViewSelectedItem funksList
				funk_frame_name.text = funk.frames_list[i]
				funk_frame_x_count.range.z = funk.frames_xCounts[i]
				funk_frame_x_index.range.z = funk.frames_xIndexes[i]
				funk_frame_y_count.range.z = funk.frames_yCounts[i]
				funk_frame_y_index.range.z = funk.frames_yIndexes[i]
			)
			else (
				funk_frame_name.text = ""
				funk_frame_x_count.range.z = 1
				funk_frame_x_index.range.z = 1
				funk_frame_y_count.range.z = 1
				funk_frame_y_index.range.z = 1
			)
			
		)
	)
	fn updateFunkControlValues funk = (
		if funk != undefined then (
			funk_distance.selection = funk.distance
			funk_lighting.selection = funk.lighting
			
			funk_animation_type.selection = funk.animation_type
			funk_animation_mode.selection = funk.animation_mode
			funk_animation_grfu.range.z = funk.animation_grfu
			funk_animation_speed_x.range.z = funk.animation_speed_x
			funk_animation_speed_x.range.z = funk.animation_speed_y
			funk_animation_extent_x.range.z = funk.animation_extent_x
			funk_animation_extent_y.range.z = funk.animation_extent_y
			funk_animation_centre_x.range.z = funk.animation_centre_x
			funk_animation_centre_y.range.z = funk.animation_centre_y
			
			funk_sequence_type.selection = funk.sequence_type
			funk_sequence_mode.selection = funk.sequence_mode
			funk_sequence_textureBitsType.selection = funk.sequence_texturebits
			funk_sequence_playback.selection = funk.sequence_playback
			funk_sequence_framerate.range.z = funk.sequence_framerate
			funk_frames_list.items = funk.frames_list as array
			
			if funk.frames_list.count > 0 then (
				updateFunkFrameControls funk 1
			)
		)
	)
	fn collectSceneFunks = (
		funks  = for m in (getclassinstances standard) where (hasAttribute m funk_CA) collect m
	)
	fn updateFunkListSubItems lv = (
		item = try lv.selecteditems.item[0] catch undefined
		if item != undefined then (
			o = item.tag.value
			item.subitems.item[0].text = o.name
			animation_types = #("None", "Roll", "Slither", "Throb")
			item.subitems.item[1].text = animation_types[o.animation_type]
			sequence_types = #("None","Frames")
			item.subitems.item[2].text = sequence_types[o.sequence_type]
		)
		funksList.Update()
	)
	fn addFunkListItem lv o = (
		itemCount = lv.Items.count
		items = #()
		
		li = dotNetObject "System.Windows.Forms.ListViewItem" o.name
		li.tag = dotNetMxsValue o
		li.BackColor = if ((mod itemCount 2) == 0.0) then dnColorWindow else dnColorBackground
		li.UseItemStyleForSubItems=true
		animation_types = #("None", "Roll", "Slither", "Throb","Rock")
		li.subitems.add animation_types[o.animation_type]
		sequence_types = #("None","Frames")
		li.subitems.add sequence_types[o.sequence_type]
		li.ForeColor = dnColorText
		append items li
		appendifunique lv.tag.value o

		lv.items.addRange items
	)
	fn buildFunksList = (
		funks = collectSceneFunks()
		funksList.tag =  dotNetMxsValue #()
		for i=1 to funks.count do (
			funk = funks[i]
			addFunkListItem funksList funk
		)
		funksList.Update()
	)

	--rollout events
	on funkSetup open do (
		funks = rootnode.funks = collectSceneFunks()
		
		initListView funksList #(#("Name",.5),#("Animation",.25),#("Sequence",.25))
		buildFunksList()
		setListViewSelection funksList 1
			
		updateFunkControlValues funk
		updateFunkControlStates funk
		updateFunkControlPositions funk
	)
	on addFunk pressed do (
		funk = medit.getcurmtl()
		custattributes.add funk funk_CA
		addFunkListItem funksList funk
		funksList.Update()
		setListViewSelection funksList funksList.items.count
	)
	on delFunk pressed do (
		funk = getListViewSelectedItem funksList
		if funk!=undefined then (
			custattributes.delete funk funk_CA
			deleteListViewItem funksList
		)
	)
	on editFunk pressed do (
		funk = getListViewSelectedItem funksList
		medit.PutMtlToMtlEditor funk (medit.GetActiveMtlSlot())
	)
	
	on funksList SelectedIndexChanged i do (
		funk = getListViewSelectedItem funksList
		updateFunkControlValues funk
		updateFunkControlStates funk
		updateFunkControlPositions funk
	)
	on funksList DoubleClick i do (
		funk = getListViewSelectedItem funksList
		funk.name = newString funk.name "Enter a new material name"
		updateFunkListSubItems funksList
	)
	
	on funk_distance selected i do try((getListViewSelectedItem funksList).distance = i) catch ()
	on funk_lighting selected i do try((getListViewSelectedItem funksList).lighting = i) catch ()
	on funk_animation_type selected i do (
		try(
			funk = getListViewSelectedItem funksList
			funk.animation_type = i
			--updateControlStates funk
			updateFunkControlStates funk
			updateFunkControlPositions funk
			updateFunkListSubItems funksList
		)
		catch ()
	)
	on funk_animation_mode selected i do try((getListViewSelectedItem funksList).animation_mode = i) catch ()
	on funk_animation_grfu changed val do try((getListViewSelectedItem funksList).animation_grfu = val) catch()
	on funk_animation_speed_x changed val do try((getListViewSelectedItem funksList).animation_speed_x = val) catch ()
	on funk_animation_speed_y changed val do try((getListViewSelectedItem funksList).animation_speed_y = val) catch ()
	on funk_animation_extent_x changed val do try((getListViewSelectedItem funksList).animation_extent_x = val) catch ()
	on funk_animation_extent_y changed val do try((getListViewSelectedItem funksList).animation_extent_y = val) catch ()
	on funk_animation_centre_x changed val do try((getListViewSelectedItem funksList).animation_centre_x = val) catch ()
	on funk_animation_centre_y changed val do try((getListViewSelectedItem funksList).animation_centre_y = val) catch ()
	
	on funk_animation_period changed val do try((getListViewSelectedItem funksList).animation_period = val) catch ()
	on funk_animation_angle changed val do try((getListViewSelectedItem funksList).animation_angle = val) catch ()
	
	on funk_sequence_type selected i do (
		try (
			funk = (getListViewSelectedItem funksList)
			funk.sequence_type = i
			updateFunkControlStates funk
			updateFunkControlPositions funk
			updateFunkListSubItems funksList
		)
		catch ()
	)
	on funk_sequence_mode selected i do (
		try((getListViewSelectedItem funksList).sequence_mode = i) catch()
		funk_sequence_framerate.visible = (i!=5)
		funk_sequence_textureBitsType.visible = (i==5)
		funk_frame_x_count.visible = (i==5)
		funk_frame_x_index.visible = (i==5)
		funk_frame_y_count.visible = (i==5)
		funk_frame_y_index.visible = (i==5)
		
	)
	on funk_sequence_texturebitsType selected i do (
		try((getListViewSelectedItem funksList).sequence_texturebits = i) catch()
	)
	on funk_sequence_playback selected i do try((getListViewSelectedItem funksList).sequence_playback = i) catch ()
	on funk_sequence_framerate changed val do try((getListViewSelectedItem funksList).sequence_framerate = val) catch ()
	
	on funk_frames_add pressed do (
		funk = (getListViewSelectedItem funksList)
		if funk != undefined then (
			append funk.frames_list "newframe"
			append funk.frames_xCounts 1
			append funk.frames_xIndexes 1
			append funk.frames_yCounts 1
			append funk.frames_yIndexes 1
			funk_frames_list.items = funk.frames_list as array
			funk_frames_list.selection = funk.frames_list.count
			updateFunkFrameControls funk funk.frames_list.count
		)
	)
	on funk_frames_remove pressed do (
		sel = funk_frames_list.selection
		funk = (getListViewSelectedItem funksList)
		if sel!=0 and funk!=undefined then (
			deleteitem funk.frames_list sel
			deleteitem funk.frames_xCounts sel
			deleteitem funk.frames_xIndexes sel
			deleteitem funk.frames_yCounts sel
			deleteitem funk.frames_yIndexes sel
			funk_frames_list.items = funk.frames_list as array
			funk_frames_list.selection = try sel catch funk_frames_list.items.count
			updateFunkFrameControls funk funk_frames_list.selection
		)
	)
	on funk_frames_list selected i do (
		updateFunkFrameControls funk i
	)
	on funk_frame_name entered txt do (
		sel = funk_frames_list.selection
		funk = (getListViewSelectedItem funksList)
		if sel!=0 and funk!=undefined then (
			funk.frames_list[sel] = txt
			funk_frames_list.items = funk.frames_list as array
		)			
	)
	on funk_frame_x_count changed val do (
		sel = funk_frames_list.selection
		funk = (getListViewSelectedItem funksList)
		if sel!=0 and funk!=undefined then (
			funk.frames_xCounts[sel] = val
			funk_frame_x_index.visible = val > 1
		)
	)
	on funk_frame_x_index changed val do (
		sel = funk_frames_list.selection
		funk = (getListViewSelectedItem funksList)
		if sel!=0 and funk!=undefined then (
			funk.frames_xIndexes[sel] = val
		)			
	)
	on funk_frame_y_count changed val do (
		sel = funk_frames_list.selection
		funk = (getListViewSelectedItem funksList)
		if sel!=0 and funk!=undefined then (
			funk.frames_yCounts[sel] = val
			funk_frame_y_index.visible = val > 1
		)
	)
	on funk_frame_y_index changed val do (
		sel = funk_frames_list.selection
		funk = (getListViewSelectedItem funksList)
		if sel!=0 and funk!=undefined then (
			funk.frames_yIndexes[sel] = val
		)			
	)
)
--createdialog funkSetup width height