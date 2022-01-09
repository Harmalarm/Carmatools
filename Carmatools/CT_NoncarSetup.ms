scriptDir = scriptspath + "\\Carma_tools\\"
LibDir = scriptDir + "Lib\\"

filein ( libDir + "CT_UIValues.ms" )
filein ( libDir + "CT_Functions.ms" )

--custom attributes
boundingShapeAttributes = attributes boundingShapeData attribID:#( 0x4601d78, 0x21adb7eb ) 
(
	parameters boundingShapeParamters (
		boundingShapeType type:#integer default:1
	)
)

noncar_CA = attributes noncar_data
attribID:#( 0xa5ac287, 0x5f123286 )
(
	parameters noncar_parameters 
	(
		index type:#integer default:0
		ac_x type:#float default:0.0
		ac_y type:#float default:0.0
		ac_z type:#float default:0.0
		dc_x type:#float default:0.0
		dc_y type:#float default:0.0
		dc_z type:#float default:0.0
		mass_a type:#float default:0.2
		mass_d type:#float default:0.2
		bend_angle type:#float default:10
		torque type:#float default:0.02
		shrapnel_count type:#integer default:1
		bounding_shapes type:#nodetab tabsize:0 tabsizevariable:true

		infinite_i type:#boolean default:false
		driveable_on type:#boolean default:false
		sparky type:#boolean default:false
		block_cam type:#boolean default:false
		
		tumble type:#boolean default:false
		tumble_factor type:#integer default:1
		tumble_threshold type:#float default:1.0
		
		world_friction type:#boolean default:false
		wf_amount type:#float default:1.0
		
		object_friction type:#boolean default:false
		of_amount type:#float default:2.0
		
		joint_type type:#index default:1
		joint_c1_x type:#float default:0.0
		joint_c1_y type:#float default:0.0
		joint_c1_z type:#float default:0.0
		joint_c2_x type:#float default:0.0
		joint_c2_y type:#float default:0.0
		joint_c2_z type:#float default:0.0
		joint_friction type:#float default:0.2
		joint_limits type:#float default:0.0
		joint_distance type:#float default:1.5
		joint_fa type:#float default:7
		joint_ra type:#float default:5
		joint_fr type:#float default:1
		joint_rr type:#float default:1
		joint_pauze type:#float default:5000
		joint_ign_wc type:#boolean default:false
		joint_rise_on type:#integer default:1
		joint_pushes type:#integer default:1
	)
	fn getowner = custattributes.getowner this
)
try destroyDialog noncarSetup catch()
--rollouts
rollout noncarProperties "Properties:" (
	local parentRoll = undefined
	local placementPos = 24
	group "Main:" (
		spinner noncar_index "Noncar number:" type:#integer range:[0, 99, 1] scale: 1 fieldWidth:40 width:widthF pos:[colA, placementPos] 
		spinner noncar_ac_x "Attached center X,Y,Z:" type:#float range:[-999999, 999999, 0] scale:0.1 fieldWidth:40 width:widthD pos:[colA, placementPos += 21] tooltip:"Relative to noncar world position"
		spinner noncar_ac_y "" type:#float range:[-999999, 999999, 0] scale: 0.1 fieldWidth:40 width:widthA pos:[colE, placementPos]
		spinner noncar_ac_z "" type:#float range:[-999999, 999999, 0] scale: 0.1 fieldWidth:40 width:widthA pos:[colF, placementPos]
		spinner noncar_dc_x "Detached center X,Y,Z:" type:#float range:[-999999, 999999, 0] scale:0.1 fieldWidth:40 width:widthD pos:[colA, placementPos += 21] tooltip:"Relative to noncar world position"
		spinner noncar_dc_y "" type:#float range:[-999999, 999999, 0] scale: 0.1 fieldWidth:40 width:widthA pos:[colE, placementPos]
		spinner noncar_dc_z "" type:#float range:[-999999, 999999, 0] scale: 0.1 fieldWidth:40 width:widthA pos:[colF, placementPos]
		spinner noncar_mass_a "Mass attached/detached:" type:#float range:[-999999, 999999, 0.2] scale:0.1 fieldWidth:40 width:widthE pos:[colA, placementPos += 21]
		spinner noncar_mass_d "" type:#float range:[-999999, 999999, 0.2] scale:0.1 fieldWidth:40 width:widthA pos:[colF, placementPos]
		spinner noncar_bend_angle "Bend Angle:" type:#float range:[-999999, 999999, 10] scale:0.1 fieldWidth:40 width:widthD pos:[colA, placementPos += 21]
		spinner noncar_torque "Torque:" type:#float range:[0, 90, 0.02] scale:1 fieldWidth:40 width:widthB pos:[colE, placementPos]
		spinner noncar_shrapnel_count "Shrapnel count:" type:#integer range:[0, 3, 1] scale:1 fieldWidth:40 width:widthF pos:[colA, placementPos += 21]
	)
	group "bounding shapes"	(
		listbox noncar_bounding_shapes "" height:5 width:widthC pos:[colA, placementPos += 45]
		
		dropdownlist noncar_bounding_types "Use shape as:" width:widthC pos:[colD, placementPos += 4] items:#( "Polyhedron", "Box", "Sphere", "Wire frame" ) 
		--pickbutton noncar_bounding_object "Select object:" width:widthC pos:[colD,placementPos+=47] 

		pickbutton noncar_addShape "add" width:( widthC / 2 ) pos:[colA, placementPos += 73]
		button noncar_delShape "remove" width:( widthC / 2 ) pos:[colA + ( widthC / 2 ), placementPos]
	)
	group "Keyword data" (
		checkbox noncar_infinite_i "Infinite I" width:widthB pos:[colA, placementPos += 50]
		checkbox noncar_drivable_on "Drivable on" width:widthB pos:[colC, placementPos]
		checkbox noncar_sparky "Sparky" width:widthB pos:[colE, placementPos]
		checkbox noncar_block_cam "Block Camera" width:widthB pos:[colA, placementPos += 21]
		checkbox noncar_tumble "Tumble" width:widthB pos:[colA, placementPos += 21]
		spinner noncar_tumble_factor "Factor:" type:#integer range:[1, 2, 1] scale: 1 fieldWidth:40 width:widthB pos:[colC, placementPos]
		spinner noncar_tumble_threshold "Threshold:" type:#float range:[0, 9999999, 1] scale:1 fieldWidth:40 width:widthB pos:[colE, placementPos]
		checkbox noncar_world_friction "World Friction" checked:false width:widthB pos:[colA, placementPos += 21]
		spinner noncar_wf_amount "Amount:" type:#float range:[0, 9999999, 1] scale:0.01 fieldWidth:40 width:widthB pos:[colE, placementPos]
		checkbox noncar_object_friction "Object Friction" checked:false width:widthB pos:[colA, placementPos += 21]
		spinner noncar_of_amount "Amount:" type:#float range:[0, 9999999, 2] scale:0.01 fieldWidth:40 width:widthB pos:[colE, placementPos]
	)
	groupbox jointType "Joint Type:" width:( width - 8 ) pos:[4, placementPos += 26] height:232
	dropdownlist noncar_joint_type "" width:widthC pos:[colA, placementPos += 24] items:#( "None", "Ball", "Hinge", "Translation" )
	spinner noncar_joint_c1_x "Joint centre point 1:" type:#float range:[-999999, 999999, 1] scale:0.1 fieldWidth:40 width:widthD pos:[colA, placementPos += 34]
	spinner noncar_joint_c1_y "" type:#float range:[-999999, 999999, 1] scale:0.1 fieldWidth:40 width:widthA pos:[colE, placementPos]
	spinner noncar_joint_c1_z "" type:#float range:[-999999, 999999, 1] scale:0.1 fieldWidth:40 width:widthA pos:[colF, placementPos]
	spinner noncar_joint_c2_x "Joint centre point 2:" type:#float range:[-999999, 999999, 1] scale: 0.1 fieldWidth:40 width:widthD pos:[colA, placementPos += 21]
	spinner noncar_joint_c2_y "" type:#float range:[-999999, 999999, 1] scale: 0.1 fieldWidth:40 width:widthA pos:[colE, placementPos]
	spinner noncar_joint_c2_z "" type:#float range:[-999999, 999999, 1] scale: 0.1 fieldWidth:40 width:widthA pos:[colF, placementPos]
	spinner noncar_joint_friction "Amount:" type:#float range:[-999999, 9999999, 0.2] scale:0.1 fieldWidth:40 width:widthE pos:[colA, placementPos += 21]
	spinner noncar_joint_limits "Nr. limits:" type:#integer range:[0, 99999999, 0] fieldWidth:40 width:widthA pos:[colF, placementPos]
	
	spinner noncar_joint_distance "Distance:" type:#float range:[-999999, 9999999, 0] scale: 0.1 fieldWidth:40 width:widthF pos:[colA, placementPos += 21]
	spinner noncar_joint_fa "Forward/Reverse Acceleration:" type:#float range:[-999999, 9999999, 1] scale: 0.1 fieldwidth:40 width:widthE pos:[colA, placementPos += 21]
	spinner noncar_joint_ra "" type:#float range:[-999999, 9999999, 1] scale: 0.1 fieldwidth:40 width:widthA pos:[colF, placementPos]
	spinner noncar_joint_fr "Forward/Reverse Resistance:" type:#float range:[-999999, 9999999, 1] scale: 0.1 fieldwidth:40 width:widthE pos:[colA, placementPos += 21]
	spinner noncar_joint_rr "" type:#float range:[-999999, 9999999, 1] scale: 1 fieldWidth:40 width:widthA pos:[colF, placementPos]
	
	spinner noncar_joint_pauze "Pauze at end:" type:#integer range:[0, 9999999, 5000] scale:1 fieldWidth:40 width:widthA pos:[colF, placementPos += 21]
	checkbox noncar_joint_ign_wc "Ign. world collision" checked:false width:widthB pos:[colA, placementPos += 23]
	dropdownlist noncar_joint_rise_on items:#( "Rise when driven", "Rise when hit" ) width:widthB pos:[colE, placementPos - 2]
	spinner noncar_joint_pushes "Nr. pushes:" type:#integer range:[0, 9999999, 1] scale:1 fieldWidth:40 width:widthB pos:[colC, placementPos + 1]
	
	
	fn getNoncar = (
		lv = parentRoll.noncarList
		o = try ( lv.selecteditems.item[0].tag.value ) catch ( undefined )
	)
	fn updateBoundingShapeList noncar = (
		if noncar != undefined then (
			validShapes = #( )
			for i = noncar.bounding_shapes.count to 1 by -1 do (
				if noncar.bounding_Shapes[i] == undefined then deleteitem noncar.bounding_Shapes[i]
			)
		)
		noncar_bounding_shapes.items = ( for m in noncar.bounding_shapes collect m.name )
	)
	fn updateBoundingShapeControlStates noncar = (
		if noncar != undefined then (
			sel = noncar_bounding_shapes.selection
			noncar_bounding_types.visible = ( sel != 0 )
		)
	)
	fn updateBoundingShapeControlValues noncar = (
		if noncar != undefined then (
			sel = noncar_bounding_shapes.selection
			bshape = try noncar.bounding_shapes[sel] catch ( undefined )
			if bshape != undefined then (
				noncar_bounding_types.selection = try bshape.boundingshapetype catch ( 1 )
			)
			updateBoundingShapeControlStates noncar
		)
	)
	fn updateNoncarControlStates noncar = (
		state = ( noncar != undefined )
		updateBoundingShapeControlValues noncar
		type = try noncar.joint_type catch 1
		
		noncar_tumble_threshold.visible = noncar_tumble_factor.visible = ( state and noncar.tumble )
		noncar_wf_amount.visible = ( state and noncar.world_friction )
		noncar_of_amount.visible = ( state and noncar.object_friction )
		
		noncar_joint_c1_x.visible = noncar_joint_c1_y.visible = noncar_joint_c1_z.visible = ( state and noncar.joint_type > 1 )
		noncar_joint_c2_x.visible = noncar_joint_c2_y.visible = noncar_joint_c2_z.visible = ( state and noncar.joint_type > 2 )
		noncar_joint_limits.pos = if type == 2 then ( noncar_joint_c1_z.pos + [0, 21] ) else ( noncar_joint_c1_z.pos + [0, 42] )
		noncar_joint_friction.pos = if type == 2 then ( noncar_joint_c1_x.pos + [0, 21] ) else ( noncar_joint_c1_x.pos + [0, 42] )
		noncar_joint_distance.pos = ( noncar_joint_limits.pos + [0, 21] )
		noncar_joint_limits.visible = noncar_joint_friction.visible = ( state and noncar.joint_type > 1 )
		noncar_joint_distance.visible = ( state and noncar.joint_type == 4 )
		noncar_joint_ra.visible = noncar_joint_fa.visible = ( state and noncar.joint_type == 4 )
		noncar_joint_rr.visible = noncar_joint_fr.visible = ( state and noncar.joint_type == 4 )
		
		noncar_joint_pauze.visible = noncar_joint_ign_wc.visible = 
		noncar_joint_rise_on.visible = noncar_joint_pushes.visible = ( state and noncar.joint_type == 4 )
		
		heights = #( 52, 101, 122, 232 )
		jointType.height = heights[type]
		
		
		noncarProperties.height = 416 + jointType.height
	)
	fn updateNoncarControlValues noncar = (
		if noncar != undefined then (
			noncar_index.range.z = noncar.index
			noncar_ac_x.range.z = noncar.ac_x
			noncar_ac_y.range.z = noncar.ac_y
			noncar_ac_z.range.z = noncar.ac_z
			noncar_dc_x.range.z = noncar.dc_x
			noncar_dc_y.range.z = noncar.dc_y
			noncar_dc_z.range.z = noncar.dc_z
			noncar_mass_a.range.z = noncar.mass_a
			noncar_mass_d.range.z = noncar.mass_d
			noncar_bend_angle.range.z = noncar.bend_angle
			noncar_torque.range.z = noncar.torque
			noncar_shrapnel_count.range.z = noncar.shrapnel_count
			
			updateBoundingShapeList noncar
			
			noncar_infinite_i.checked = noncar.infinite_i
			noncar_drivable_on.checked = noncar.driveable_on
			noncar_sparky.checked = noncar.sparky
			noncar_block_cam.checked = noncar.block_cam
			noncar_tumble.checked = noncar.tumble
			noncar_tumble_factor.range.z = noncar.tumble_factor
			noncar_tumble_threshold.range.z = noncar.tumble_threshold
			noncar_world_friction.checked = noncar.world_friction
			noncar_wf_amount.range.z = noncar.wf_amount
			noncar_object_friction.checked = noncar.object_friction
			noncar_of_amount.range.z = noncar.of_amount
			
			noncar_joint_type.selection = noncar.joint_type

			noncar_joint_c1_z.range.z = noncar.joint_c1_z
			noncar_joint_c1_y.range.z = noncar.joint_c1_y
			noncar_joint_c1_x.range.z = noncar.joint_c1_x
			noncar_joint_c2_z.range.z = noncar.joint_c2_z
			noncar_joint_c2_y.range.z = noncar.joint_c2_y
			noncar_joint_c2_x.range.z = noncar.joint_c2_x
			
			noncar_joint_limits.range.z = noncar.joint_limits
			noncar_joint_friction.range.z = noncar.joint_friction
			
			noncar_joint_distance.range.z = noncar.joint_distance
			noncar_joint_ra.range.z = noncar.joint_ra
			noncar_joint_fa.range.z = noncar.joint_fa
			noncar_joint_rr.range.z = noncar.joint_rr
			noncar_joint_fr.range.z = noncar.joint_fr
			noncar_joint_pauze.range.z = noncar.joint_pauze
			noncar_joint_ign_wc.checked = noncar.joint_ign_wc
			noncar_joint_rise_on.selection = noncar.joint_rise_on
			noncar_joint_pushes.range.z = noncar.joint_pushes
		)
		updateNoncarControlStates noncar
	)
	
	
	on noncar_index changed val do try ( getNoncar()).index = val catch ()
	on noncar_ac_z changed val do try ( getNoncar()).ac_z = val catch ()
	on noncar_ac_y changed val do try ( getNoncar()).ac_y = val catch ()
	on noncar_ac_x changed val do try ( getNoncar()).ac_x = val catch ()
	on noncar_dc_z changed val do try ( getNoncar()).dc_z = val catch ()
	on noncar_dc_y changed val do try ( getNoncar()).dc_y = val catch ()
	on noncar_dc_x changed val do try ( getNoncar()).dc_x = val catch ()
	on noncar_mass_d changed val do try ( getNoncar()).mass_d = val catch ()
	on noncar_mass_a changed val do try ( getNoncar()).mass_a = val catch ()
	on noncar_torque changed val do try ( getNoncar()).torque = val catch ()
	on noncar_bend_angle changed val do try ( getNoncar()).bend_angle = val catch ()
	on noncar_shrapnel_count changed val do try ( getNoncar()).shrapnel_count = val catch ()
	on noncar_addShape picked bshape do (
		if bshape != undefined then (
			custattributes.add bshape boundingShapeAttributes
			try (
				noncar = ( getNoncar())
				append noncar.bounding_shapes bshape
				updateBoundingShapeList noncar
				noncar_bounding_shapes.selection = noncar_bounding_shapes.items.count
				updateBoundingShapeControlValues noncar
			)
			catch()
		)
	)
	on noncar_delShape pressed do (
		try (
			noncar = ( getNoncar())
			sel = noncar_bounding_shapes.selection
			deleteitem noncar.bounding_shapes sel
			updateBoundingShapeList noncar
			if noncar_bounding_shapes.items.count < sel then
			noncar_bounding_shapes.selection = ( sel - 1 )
			else 
			noncar_bounding_shapes.selection = sel
			updateBoundingShapeControlValues noncar
		)
		catch()
	)
	on noncar_bounding_shapes selected i do (
		noncar = ( getNoncar())
		updateBoundingShapeControlValues noncar
	)
	on noncar_bounding_shapes doubleclicked i do (
		noncar = ( getNoncar())
		sel = noncar_bounding_shapes.selection
		bshape = try noncar.bounding_shapes[sel] catch ( undefined )
		if bshape != undefined then (
			bshape.name = newString bshape.name "Enter a new descriptive name"
			updateBoundingShapeList noncar
		)
	)
	on noncar_bounding_types selected i do (
		noncar = ( getNoncar())
		sel = noncar_bounding_shapes.selection
		bshape = try noncar.bounding_shapes[sel] catch ( undefined )
		if bshape != undefined then (
			bshape.boundingshapetype = i
			updateBoundingShapeControlValues noncar
		)
	)
	on noncar_bounding_object picked o do (
		noncar = ( getNoncar())
		sel = noncar_bounding_shapes.selection
		bshape = try noncar.bounding_shapes[sel] catch ( undefined )
		if bshape != undefined then (
			bshape.bounding_shape_object = o
			updateBoundingShapeControlValues noncar
		)
	)
	on noncar_infinite_i changed state do try ( getNoncar()).infinite_i = state catch()
	on noncar_drivable_on changed state do try ( getNoncar()).driveable_on = state catch()
	on noncar_sparky changed state do try ( getNoncar()).sparky = state catch()
	on noncar_block_cam changed state do try ( getNoncar()).block_cam = state catch()
	
	on noncar_tumble changed state do (
		try ( getNoncar()).tumble = state catch()
		updateNoncarControlStates ( getNoncar())
		parentroll.updateNoncarListSubItems parentroll.noncarList
	)
	on noncar_tumble_threshold changed val do try ( getNoncar()).tumble_threshold = val catch ()
	on noncar_tumble_factor changed val do try ( getNoncar()).tumble_factor = val catch ()
	on noncar_world_friction changed state do (
		try ( getNoncar()).world_friction = state catch()
		updateNoncarControlStates ( getNoncar())
	)
	on noncar_wf_amount changed val do try ( getNoncar()).wf_amount = val catch ()
	on noncar_object_friction changed state do (
		try ( getNoncar()).object_friction = state catch()
		updateNoncarControlStates ( getNoncar())
	)
	on noncar_of_amount changed val do try ( getNoncar()).of_amount = val catch ()
	on noncar_joint_type selected i do (
		try ( getNoncar()).joint_type = i catch()
		updateNoncarControlStates ( getNoncar())
		parentroll.updateNoncarListSubItems parentroll.noncarList
	)
	on noncar_joint_c1_z changed val do try ( getNoncar()).joint_c1_z = val catch ()
	on noncar_joint_c1_y changed val do try ( getNoncar()).joint_c1_y = val catch ()
	on noncar_joint_c1_x changed val do try ( getNoncar()).joint_c1_x = val catch ()
	on noncar_joint_c2_z changed val do try ( getNoncar()).joint_c2_z = val catch ()
	on noncar_joint_c2_y changed val do try ( getNoncar()).joint_c2_y = val catch ()
	on noncar_joint_c2_x changed val do try ( getNoncar()).joint_c2_x = val catch ()
	on noncar_joint_limits changed val do try ( getNoncar()).joint_limits = val catch ()
	on noncar_joint_friction changed val do try ( getNoncar()).joint_friction = val catch ()
	on noncar_joint_distance changed val do try ( getNoncar()).joint_distance = val catch ()
	on noncar_joint_ra changed val do try ( getNoncar()).joint_ra = val catch ()
	on noncar_joint_fa changed val do try ( getNoncar()).joint_fa = val catch ()
	on noncar_joint_rr changed val do try ( getNoncar()).joint_rr = val catch ()
	on noncar_joint_fr changed val do try ( getNoncar()).joint_fr = val catch ()
	on noncar_joint_pauze changed val do try ( getNoncar()).joint_pauze = val catch ()
	on noncar_joint_ign_wc changed state do try ( getNoncar()).joint_ign_wc = state catch ()
	on noncar_joint_rise_on selected i do try ( getNoncar()).joint_rise_on = i catch ()
	on noncar_joint_pushes changed val do try ( getNoncar()).joint_pushes = val catch ()
)

rollout noncarSetup "Noncar Setup" (
	--ui locals
	local bmargin = 250
	local roll = undefined
	
	--ui controls
	group "Noncar setups in scene:" (
		dotNetControl noncarList "System.Windows.Forms.ListView" width:( noncarSetup.width - 26 ) height:150
		button addnoncar "Add selection" width:150 align:#left across:2 tooltip:"Add the noncar setup attributes to the selection (from scene)"
		button delnoncar "Remove selection" width:150 align:#right tooltip:"Remove the noncar attributes from the selection (from list or scene)"
	)
	subrollout noncarSub "" width:( noncarSetup.width - 8 ) offset:[-9, 0] height:( noncarSetup.height - bmargin )
	button noncarExport "Export selected txt file" width:150 align:#right pos:( noncarSub.pos + [170, ( noncarSub.height + 9 )] )
	
	--ui functions
	fn collectSceneNoncars = (
		noncars = for o in objects where ( hasAttribute o noncar_CA ) collect o
	)
	fn updateNoncarListSubItems lv = (
		item = try lv.selecteditems.item[0] catch undefined
		if item != undefined then (
			o = item.tag.value
			item.subitems.item[0].text = o.name
			item.subitems.item[1].text = ( o.tumble as string )
			types = #( "None", "Ball", "Hinge", "Translation" )
			item.subitems.item[2].text = types[o.joint_type]
		)
		noncarList.Update()
	)
	fn addNoncarListItem lv o = (
		itemCount = lv.Items.count
		items = #( )
		
		li = dotNetObject "System.Windows.Forms.ListViewItem" o.name
		li.tag = dotNetMxsValue o
		li.BackColor = if ( ( mod itemCount 2 ) == 0.0 ) then dnColorWindow else dnColorBackground
		li.UseItemStyleForSubItems = true
		li.subitems.add ( o.tumble as string )
		types = #( "None", "Ball", "Hinge", "Translation" )
		li.subitems.add types[o.joint_type]
		li.ForeColor = dnColorText
		append items li
		appendifunique lv.tag.value o

		lv.items.addRange items
	)
	fn buildNoncarList = (
		noncars = collectSceneNoncars()
		noncarList.tag = dotNetMxsValue #( )
		for i = 1 to noncars.count do (
			noncar = noncars[i]
			addNoncarListItem noncarList noncar
		)
		noncarList.Update()
	)
	
	--ui events
	on noncarSetup open do (
		addsubrollout noncarSub noncarProperties
		roll = noncarSub.rollouts[1]
		roll.parentroll = noncarSetup
		
		initListView noncarList #( #( "Name", .5 ), #( "Tumble", .25 ), #( "Animation", .25 ) )
		buildNoncarList()
		setListViewSelection noncarList 1
		noncar = getListViewSelectedItem noncarList
		roll.updateNoncarControlValues noncar
	)
	on addNoncar pressed do (
		for noncar in selection do (
			custattributes.add noncar noncar_CA
			addNoncarListItem noncarList noncar
			noncarList.Update()
			setListViewSelection noncarList noncarList.items.count
		)
	)
	on delNoncar pressed do (
		noncar = getListViewSelectedItem noncarList
		if noncar != undefined then (
			custattributes.delete noncar noncar_CA
			deleteListViewItem noncarList
			updateListViewColors noncarList
		)
	)
	on noncarList SelectedIndexChanged i do (
		noncar = getListViewSelectedItem noncarList
		roll.updateNoncarControlValues noncar
	)
	on noncarExport pressed do (
		global noncar = ( getListViewSelectedItem noncarList )
		filein ( libDir + "CT_NoncarTXT.ms" )
	)
	on noncarSetup resized size do (
		my_rof_size = size
		noncarSub.height = ( size.y - bmargin )
		noncarExport.pos = noncarSub.pos + [170, ( noncarSub.height + 9 )]
	)
)
createdialog noncarSetup superwidth 750 style:#( #style_titlebar, #style_border, #style_sysmenu, #style_resizing, #style_minimizebox ) lockWidth:true
