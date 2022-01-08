--try destroydialog grooveSetup catch()
rollout grooveSetup "Grooves" (
	local grooves = #()
	local groove = undefined
	group "Grooves in scene:" (
		dotNetControl groovesList "System.Windows.Forms.ListView" width:(grooveSetup.width-26) height:164
		button addGroove "Add selection" width:150 across:2 tooltip:"Add the groove attributes to the selection (from scene)"
		button delGroove "Remove selection" width:150 tooltip:"Remove the groove attributes from the selection (from scene or list)"
	)
	local placementPos = 224
	groupbox grooveMain "main" width:(width-8) height:68 pos:[4,placementPos]
	
		dropdownlist groove_lollipop "lollipop:" items:#("None", "Xlollipop", "Ylollipop", "Zlollipop") width:widthC pos:[colA,placementPos+=18]
		dropdownlist groove_distance "distance:" items:#("Distant", "Constant") width:widthC pos:[colD,placementPos]
	
	groupbox groovePath "path" width:(width-8) height:132 pos:[4,placementPos+=54]
		dropdownlist groove_path_type "mode:" items:#("No Path", "Straight", "Circular") width:widthB pos:[colA,placementPos+=18]
		dropdownlist groove_path_mode "type:" items:#("Linear", "Harmonic", "Flash","Absolute (for suspensions)") width:widthB pos:[colC,placementPos]
		spinner groove_path_grfu "GrooveRef:" type:#integer range:[0,99,0] fieldwidth:40 width:widthB pos:[colE,placementPos+23] tooltip:"For cars only! Link these in the GroovyFunkRef Setup"
		spinner groove_path_centre_x "Centre X,Y,Z:" type:#float range:[-999999,999999,0] fieldwidth:40 scale: 0.1 width:widthD pos:[colA,placementPos+=44]
		spinner groove_path_centre_y "" type:#float range:[-999999,999999,0] fieldwidth:40 scale: 0.1 width:widthA pos:[colE,placementPos]
		spinner groove_path_centre_z "" type:#float range:[-999999,999999,0] fieldwidth:40 scale: 0.1 width:widthA pos:[colF,placementPos]
		spinner groove_path_extent_x "Extent X,Y,Z:" type:#float range:[-999999,999999,0] fieldwidth:40 width:widthD pos:[colA,placementPos+=21]
		spinner groove_path_extent_y "" type:#float range:[-999999,999999,0] fieldwidth:40 scale: 0.1 width:widthA pos:[colE,placementPos]
		spinner groove_path_extent_z "" type:#float range:[-999999,999999,0] fieldwidth:40 scale: 0.1 width:widthA pos:[colF,placementPos]
		spinner groove_path_speed "Speed:" type:#float range:[0,999999,1] scale: 0.1 fieldWidth:40 width:widthB pos:[colA,placementPos+=21]
		spinner groove_path_radius "Radius:" type:#float range:[0,999999,0] scale: 0.1 fieldWidth:40 width:widthB pos:[colC,placementPos]
		label groove_path_axis_label "Axis:" width:widthA pos:[colE+30,placementPos]
		dropdownlist groove_path_axis "" items:#("X", "Y", "Z") width:50 width:widthA pos:[colF+6,placementPos]
	groupbox grooveAnimation "Animation:" width:(width-8) height:132 pos:[4,placementPos+=32]
		dropdownlist groove_animation_type "type:" items:#("None","Spin","Rock","Shear","Throb") selection:1 width:widthB pos:[colA,placementPos+=18]
		dropdownlist groove_animation_mode "mode:" items:#("Linear","Harmonic","Flash","Continuous","Absolute (for steering wheels)","Controlled (for spinning wheels)") width:widthB pos:[colC,placementPos]
		spinner groove_animation_grfu "GrooveRef:" type:#integer range:[0,99,0] fieldwidth:40 width:widthB pos:[colE,placementPos+21] tooltip:"For cars only! Link these in the GroovyFunkRef Setup"
		spinner groove_animation_centre_x "Centre X,Y,Z:" type:#float range:[-999999,999999,0] scale: 0.1 fieldWidth:40 width:widthD pos:[colA,placementPos+=44]
		spinner groove_animation_centre_y "" type:#float range:[-999999,999999,0] scale: 0.1 fieldWidth:40 width:widthA pos:[colE,placementPos]
		spinner groove_animation_centre_z "" type:#float range:[-999999,999999,0] scale: 0.1 fieldWidth:40 width:widthA pos:[colF,placementPos]
		spinner groove_animation_extent_x "Extent X,Y,Z:" type:#float range:[-999999,999999,0] scale: 0.1 fieldWidth:40 width:widthD pos:[colA,placementPos+=21]
		spinner groove_animation_extent_y "" type:#float range:[-999999,999999,0] scale: 0.1 fieldWidth:40 width:widthA pos:[colE,placementPos]
		spinner groove_animation_extent_z "" type:#float range:[-999999,999999,0] scale: 0.1 fieldWidth:40 width:widthA pos:[colF,placementPos]
		spinner groove_animation_speed "Speed: " type:#float range:[-999999,999999,1] scale: 0.1 fieldWidth:40 width:widthB pos:[colA,placementPos+=21]
		spinner groove_animation_angle "Angle:" type:#float range:[-999999,999999,0] scale: 0.1 fieldWidth:40 width:widthB pos:[colC,placementPos]
		label groove_animation_axis_label "Axis:" pos:[colE+35,placementPos+=3]
		dropdownlist groove_animation_axis "" items:#("X","Y","Z") width:50 width:widthA pos:[colF+6,placementPos-=2]
	
	fn collectSceneGrooves = (
		grooves = for o in objects where (hasAttribute o groove_CA) and (isvalidnode o) collect o
		qSort grooves compareNames
		return grooves
	)
	
	fn addGrooveListItem lv o = (
		itemCount = lv.Items.count
		items = #()
		if (isvalidnode o) then (
			li = dotNetObject "System.Windows.Forms.ListViewItem" o.name
			li.tag = dotNetMxsValue o
			li.BackColor = if ((mod itemCount 2) == 0.0) then dnColorWindow else dnColorBackground
			li.UseItemStyleForSubItems=true
			li.subitems.add groove_lollipop.items[o.lollipop]
			li.subitems.add groove_path_type.items[o.path_type]
			li.subitems.add groove_animation_type.items[o.animation_type]
			li.ForeColor = dnColorText
			append items li
			appendifunique lv.tag.value o
		)
		lv.items.addRange items
	)
	
	
	
	fn updateGrooveControlValues groove = (
		if groove != undefined then (
			groove_lollipop.selection = groove.lollipop
			groove_distance.selection = groove.distance
			groove_path_type.selection = groove.path_type
			groove_path_mode.selection = groove.path_mode
			groove_path_grfu.range.z = groove.path_grfu
			
			groove_path_centre_x.range.z = groove.path_centre.x
			groove_path_centre_y.range.z = groove.path_centre.y
			groove_path_centre_z.range.z = groove.path_centre.z
			groove_path_extent_x.range.z = groove.path_extent.x
			groove_path_extent_y.range.z = groove.path_extent.y
			groove_path_extent_z.range.z = groove.path_extent.z
			
			groove_path_speed.range.z = groove.path_speed
			groove_path_radius.range.z = groove.path_radius
			groove_path_axis.selection = groove.path_axis
			
			groove_animation_type.selection = groove.animation_type
			groove_animation_mode.selection = groove.animation_mode
			groove_animation_grfu.range.z = groove.animation_grfu
			
			groove_animation_centre_x.range.z = groove.animation_centre.x
			groove_animation_centre_y.range.z = groove.animation_centre.y
			groove_animation_centre_z.range.z = groove.animation_centre.z
			groove_animation_extent_x.range.z = groove.animation_extent.x
			groove_animation_extent_y.range.z = groove.animation_extent.y
			groove_animation_extent_z.range.z = groove.animation_extent.z
			
			groove_animation_speed.range.z = groove.animation_speed
			groove_animation_angle.range.z = groove.animation_angle
			groove_animation_axis.selection = groove.animation_axis
		)
	)
	fn updateGrooveControlStates groove = (
		mainState = (groove!=undefined)
		grooveMain.visible = mainState
		groove_lollipop.visible = mainState
		groove_distance.visible = mainState
		
		groovePath.visible = mainState
		groove_path_type.visible = mainState
		
		path_type = try groove.path_type catch 1
		path_mode = try groove.path_mode catch 1
		straightState = (mainState and path_type==2)
		circularState = (mainState and path_type==3)
		groove_path_mode.visible = (mainState and (path_type != 1))
		groove_path_grfu.visible = (mainState and (path_mode == 4))
		groove_path_centre_x.visible = circularState
		groove_path_centre_y.visible = circularState
		groove_path_centre_z.visible = circularState
		groove_path_extent_x.visible = straightState
		groove_path_extent_y.visible = straightState
		groove_path_extent_z.visible = straightState
		groove_path_speed.visible = (mainState and (path_type != 1))
		groove_path_radius.visible = circularState
		groove_path_axis_label.visible = circularState
		groove_path_axis.visible = circularState
		
		grooveAnimation.visible = mainState
		groove_animation_type.visible = mainState
		
		animationType = try groove.animation_type catch 1
		animationMode = try groove.animation_mode catch 1
		
		groove_animation_mode.visible = (mainState and (animationType != 1))
		groove_animation_grfu.visible = (mainState and (animationMode > 4))
		groove_animation_centre_x.visible = (mainState and (animationType == 2))
		groove_animation_centre_y.visible = (mainState and (animationType == 2))
		groove_animation_centre_z.visible = (mainState and (animationType == 2))
		groove_animation_extent_x.visible = (mainState and (animationType > 2))
		groove_animation_extent_y.visible = (mainState and (animationType > 2))
		groove_animation_extent_z.visible = (mainState and (animationType > 2))
		groove_animation_speed.visible = (mainState and (animationType != 1))
		groove_animation_angle.visible = (mainState and (animationType == 3))
		groove_animation_axis_label.visible = (mainState and (animationType == 2 or animationType == 3))
		groove_animation_axis.visible = (mainState and (animationType == 2 or animationType == 3))
	)
	fn updateGrooveControlPositions groove = (
		if groove!=undefined then (
			
			placementPos = 358
			pathType = groove.path_type 

			heights = #(64,106,110)
			groovePath.height = heights[pathType]
			groove_path_centre_x.pos.y = placementPos
			groove_path_centre_y.pos.y = placementPos
			groove_path_centre_z.pos.y = placementPos
			groove_path_extent_x.pos.y = placementPos
			groove_path_extent_y.pos.y = placementPos
			groove_path_extent_z.pos.y = placementPos
			
			groove_path_speed.pos = if (pathType == 2) then [colF+spCorr,placementPos+=21] else [colB+spCorr,placementPos+=21]
			groove_path_radius.pos.y = placementPos
			groove_path_axis_label.pos.y = placementPos
			groove_path_axis.pos.y = placementPos
			
			positions = #(364,406,410)
			placementPos = positions[pathType]
			
			animationType = groove_animation_type.selection
			grooveAnimation.pos.y = placementPos
			heights = #(64,110,110,106,106)
			grooveAnimation.height = heights[animationType]
			groove_animation_type.pos.y = placementPos+=36
			groove_animation_mode.pos.y = placementPos
			groove_animation_grfu.pos.y = placementPos+5
			groove_animation_centre_x.pos.y = placementPos+=26
			groove_animation_centre_y.pos.y = placementPos
			groove_animation_centre_z.pos.y = placementPos
			groove_animation_extent_x.pos.y = placementPos
			groove_animation_extent_y.pos.y = placementPos
			groove_animation_extent_z.pos.y = placementPos
			
			positions = #(colB+spCorr,colD+spCorr,colB+spCorr,colF+spCorr,colF+spCorr)
			groove_animation_speed.pos = [positions[animationType],placementPos+=21]
			groove_animation_angle.pos.y = placementPos
			groove_animation_axis_label.pos.y = placementPos
			groove_animation_axis.pos.y = placementPos
			
			totalHeight = 224+68+groovePath.height+grooveAnimation.height+14
			grooveSetup.height = totalHeight
			groovesList.update()
		)
	)
	fn populateGrooveList lv = (
		grooves = collectSceneGrooves()
		groovesList.Clear()
		groovesList.tag =  dotNetMxsValue #()
		addColumns groovesList #(#("Name",.35),#("Lollipop",.2),#("Path",.2),#("Animation",.25))
		for i=1 to grooves.count do (
			o = grooves[i]
			addGrooveListItem groovesList o
		)
		lv.Update()
	)
		
	fn updateGrooveSelection = (
		oldGrooves = groovesList.tag.value
		listHit = 0
		for o in selection do (
			sel = finditem oldGrooves o
			if sel == 0 and (hasAttribute o groove_CA) then (
				addGrooveListItem groovesList o
			)
			else (
				if sel != 0 then (
					listHit = (sel-1)
				)
			)
		)
		setListViewSelection groovesList (listHit+1)
	)
	
	fn updateGrooveDelete = (
		delGrooves = (callbacks.notificationParam())
		oldGrooves = groovesList.tag.value
		for o in delGrooves do (
			print o.name
			sel = finditem oldGrooves o
			if sel!=0 then (
				groovesList.Items.RemoveAt[sel-1]
				deleteitem oldGrooves sel
			)
		)
		updateListViewColors groovesList
		groovesList.tag = dotNetMXSValue oldGrooves
		groovesList.Update()
	)
	
	fn updateGrooveAdd addGrooves= (
		oldGrooves = groovesList.tag.value
		listHit = 0
		for o in addGrooves do (
			sel = finditem oldGrooves o
			if sel == 0 and (hasAttribute o groove_CA) then (
				addGrooveListItem groovesList o
			)
			else (
				if sel != 0 then (
					listHit = (sel-1)
				)
			)
		)
		updateListViewColors groovesList
		setListViewSelection groovesList (listHit+1)
	)
	
	fn updateGrooveParam item = (
		if item != undefined then (
			o = item.tag.value
			item.subitems.item[1].text = groove_lollipop.items[o.lollipop]
			item.subitems.item[2].text = groove_path_type.items[o.path_type]
			item.subitems.item[3].text = groove_animation_type.items[o.animation_type]
		)
	)
	on grooveSetup open do (
		--reset all grooves
		rootnode.grooves = collectSceneGrooves()
		
		callbacks.addScript #SelectionSetChanged "grooveSetup.updateGrooveSelection()" id:#grooveSel
		callbacks.addScript #nodePreDelete "grooveSetup.updateGrooveDelete()" id:#grooveDel
		callbacks.addScript #sceneNodeAdded "grooveSetup.updateGrooveAdd (callbacks.notificationParam())" id:#grooveAdd
		
		initListView groovesList #(#("Name",.35),#("Lollipop",.2),#("Path",.2),#("Animation",.25))
		groovesList.tag = dotNetMxsValue rootnode.grooves
		populateGrooveList groovesList
		setListViewSelection groovesList 1
		
		groove = getListViewSelectedItem groovesList
		updateGrooveControlValues groove
		updateGrooveControlStates groove
		updateGrooveControlPositions groove
	)
	on grooveSetup close do (
		callbacks.removeScripts id:#grooveSel
		callbacks.removeScripts id:#grooveDel
		callbacks.removeScripts id:#grooveAdd
	)
	on groovesList SelectedIndexChanged i do (
		groove = getListViewSelectedItem groovesList
		
		updateGrooveControlValues groove
		updateGrooveControlStates groove
		updateGrooveControlPositions groove
		
	)
	on addGroove pressed do (
		for groove in selection do (
			custattributes.add groove groove_CA
		)
		updateGrooveAdd selection
		updateGrooveSelection()
	)
	
	on delGroove pressed do (
		groove = groovesList.selecteditems.item[0].tag.value
		sel = groovesList.selecteditems.item[0].index
		custattributes.delete groove groove_CA
		groovesList.selecteditems.clear()
	)
	
	on groove_lollipop selected i do (
		try groove.lollipop = i catch()
		updateGrooveParam (groovesList.selecteditems.item[0])
	)
	on groove_distance selected i do try groove.distance = i catch()
	on groove_path_type selected i do (
		try groove.path_type = i catch()
		updateGrooveParam (groovesList.selecteditems.item[0])
		updateGrooveControlStates groove
		updateGrooveControlPositions groove
	)
	on groove_path_mode selected i do (
		(try groove.path_mode = i catch())
		--updateGrooveParam (groovesList.selecteditems.item[0])
		updateGrooveControlStates groove
		--updateGrooveControlPositions groove
	)
	on groove_path_grfu changed val do try groove.path_grfu = val catch()
	on groove_path_centre_x changed val do try groove.path_centre.x = val catch()
	on groove_path_centre_y changed val do try groove.path_centre.y = val catch()
	on groove_path_centre_z changed val do try groove.path_centre.z = val catch()
	on groove_path_extent_x changed val do try groove.path_extent.x = val catch()
	on groove_path_extent_y changed val do try groove.path_extent.y = val catch()
	on groove_path_extent_z changed val do try groove.path_extent.z = val catch()
	on groove_path_speed changed val do try groove.path_speed = val catch()
	on groove_path_radius changed val do try groove.path_radius = val catch()
	on groove_path_axis selected i do try groove.path_axis = i catch()
	
	on groove_animation_type selected i do (
		try groove.animation_type = i catch()
		updateGrooveParam (groovesList.selecteditems.item[0])
		updateGrooveControlStates groove
		updateGrooveControlPositions groove
	)
	on groove_animation_mode selected i do (
		try groove.animation_mode = i catch()
		updateGrooveControlStates groove
	)
	on groove_animation_grfu changed val do try groove.animation_grfu = val catch()
	on groove_animation_centre_x changed val do try groove.animation_centre.x = val catch()
	on groove_animation_centre_y changed val do try groove.animation_centre.y = val catch()
	on groove_animation_centre_z changed val do try groove.animation_centre.z = val catch()
	on groove_animation_extent_x changed val do try groove.animation_extent.x = val catch()
	on groove_animation_extent_y changed val do try groove.animation_extent.y = val catch()
	on groove_animation_extent_z changed val do try groove.animation_extent.z = val catch()
	on groove_animation_speed changed val do try groove.animation_speed = val catch()
	on groove_animation_angle changed val do try groove.animation_angle = val catch()
	on groove_animation_axis selected i do try groove.animation_axis = i catch()
)
--createdialog grooveSetup width height