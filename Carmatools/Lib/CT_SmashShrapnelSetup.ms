shrapnel_CA = attributes shrapnel_data
attribid:#(0x3cad4839, 0x5d42437a)
(
	parameters shrapnel_params
	(
		type type:#integer default:1
		min_tocar type:#float default:0
		max_tocar type:#float default:0
		imp_velo type:#float default:1
		rand_velo type:#float default:10
		randup_velo type:#float default:2
		norm_velo type:#float default:0
		spinrate type:#integer default:100
		min_time type:#float default:0.75
		max_time type:#float default:1.25
		cutlength  type:#float default:0.005
		flag type:#integer default:0
		shardsmat type:#string default:""
		placement type:#integer default:1
		centre type:#integer default:1
		radius type:#float default:2.5
		height type:#float default:2.5
		width type:#float default:2.5
		bits_min type:#integer default:-1
		bits_max type:#integer default:-1
		firechance type:#integer default:0
		firecollumns type:#integer default:1
		firemin  type:#integer default:0
		firemax  type:#integer default:3
		model type:#string default:"Pick Model:"
		actornumber type:#integer default:1
		actor type:#string default:"Pick Model:"
		noncartxt type:#string default:"noncar TXT for actor:"
		ghostpartactor type:#string default:"Pick Ghostpart Model:"
	)
)

--try destroydialog ShrapnelSetup catch()
rollout ShrapnelSetup "Shrapnel Setup"
(
	local conn = rootnode.current_connotations
	local shrapnel = undefined
	group "Shrapnels in Smashable:" (
		dotNetControl shrapnelList "System.Windows.Forms.ListView" width:(widthF) height:164
		button shrapnelAdd "Add Shrapnel" width:widthC across:2 tooltip:"Add a shrapnel effect to the current Smashable"
		button shrapnelDel "Remove Shrapnel" width:widthC tooltip:"Remove a shrapnel effect from the currnet Smashable"
	)
	
	local veloPos = 224
	groupbox shrapnelVelocities "Velocities:" width:(width-8) height:110 pos:[4,veloPos]
		spinner shrapnel_min_tocar "min/max speed towards car:" range:[0,10,0] type:#float scale:0.01 fieldwidth:40 width:widthE pos:[colA,veloPos+24]
		spinner shrapnel_max_tocar "" range:[0,10,0] type:#float scale:0.01 fieldwidth:40 width:widthA pos:[colF,veloPos+24]
		spinner shrapnel_rand_velo "rand. hor./rand. vert. velocity:" range:[0,10,10] type:#float scale:0.01 width:widthE fieldwidth:40 pos:[colA,veloPos+45]
		spinner shrapnel_randup_velo "" range:[0,10,2] type:#float scale:0.01 fieldwidth:40 width:widthA pos:[colF,veloPos+45]
		spinner shrapnel_imp_velo "impact/normal velocity:" range:[0,10,1] type:#float scale:0.01 width:widthE fieldwidth:40 pos:[colA,veloPos+66]
		spinner shrapnel_norm_velo "" range:[0,10,0] type:#float scale:0.01 fieldwidth:40 width:widthA pos:[colF,velopos+66]
		spinner shrapnel_spinrate "spin rate:" range:[0,999999,100] type:#integer fieldwidth:40 width:widthF pos:[colA,velopos+87]

	local typePos = veloPos+114
	groupbox shrapnelType "Type:" width:(width-8) height:46 pos:[4,typePos]
		dropdownlist shrapnel_type "" items:#("shards","noncars","ghostparts") selection:3 width:widthC pos:[colA,typePos+18]
	
	local propheights = #(88,112,88)
	groupbox shrapnelTypeProps "Shards" width:(width-8) height:(propheights[shrapnel_type.selection]) pos:[4,typePos+=50]
		spinner shrapnel_min_time "Min/Max lifespan:" range:[0,10,.75] type:#float scale:0.01 fieldwidth:40 width:widthE pos:[colA,typePos+18]
		spinner shrapnel_max_time ""range:[0,10,1.25] type:#float scale:0.01 fieldwidth:40 width:widthA pos:[colF,typePos+18]
		--noncar and ghostpart stuff
		spinner shrapnel_bits_min "Min/Max Bits:" range:[-1,10,-1] type:#integer fieldwidth:40 width:widthE pos:[colA,typePos+39] tooltip:"Enter -1 for both to use every bit in the shrapnel material once)"
		spinner shrapnel_bits_max range:[-1,10,-1] type:#integer fieldwidth:40 width:widthA pos:[colF,typePos+39]
		--shards stuff
		spinner shrapnel_cutlength "min cut length:" range:[0,10,0.005] type:#float scale:0.001 fieldwidth:40 width:widthD pos:[colA,typePos+39] visible:(shrapnel_type.selection == 1)
		spinner shrapnel_flag "flags:"range:[0,1,0] type:#integer fieldwidth:40 width:widthC pos:[colD,typePos+39] visible:(shrapnel_type.selection == 1)
		edittext shrapnel_shardsmat "Shards Material name:" width:widthE pos:[colB,typePos+60] visible:(shrapnel_type.selection == 1) tooltip:"Name of a material "
		--noncarstuff
		edittext shrapnel_model "Main Actor Model:" autodisplay:true fieldwidth:widthD pos:[colA,typePos+60] visible:(shrapnel_type.selection == 2)
		spinner shrapnel_actornumber "actors in file:" range:[0,1,1] type:#integer fieldwidth:40 width:widthC pos:[colD,typePos+84] visible:(shrapnel_type.selection == 2)
		edittext shrapnel_actor "Actor Name:" autodisplay:true fieldwidth:widthD pos:[colA,typePos+108] visible:(shrapnel_type.selection == 2)
		edittext shrapnel_noncartxt "noncar TXT for actor:" fieldwidth:widthD pos:[colD,typePos+132] visible:(shrapnel_type.selection == 2)
		--ghostpart stuff
		button shrapnel_ghostpartActor "Ghostpart Model:" autodisplay:true width:widthC pos:[colD,typePos+60] visible:(shrapnel_type.selection == 3)

	local placementPos = typePos + 422
	groupbox shrapnelPlacement "Placement Mode:" width:(width-8) height:69 pos:[4,placementPos]
		dropdownlist shrapnel_placement "" items:#("Actorbased","Sphereclumped","Boxclumped") width:widthC pos:[colA,placementPos+=18]
		dropdownlist clumping_centre "Centre:" items:#("impact","model") width:widthC pos:[colD,placementPos-18]
		
		spinner shrapnel_radius "Placement radius:" range:[0,9999,2.5] type:#float scale:0.01 fieldwidth:40 width:widthF pos:[colA,placementPos+=24]
		spinner shrapnel_width "Placement width/height" type:#float scale:0.01 range:[0,9999,2.5] fieldwidth:40 width:widthE pos:[colA,PlacementPos+=18]
		spinner shrapnel_height "" range:[0,9999,2.5] type:#float scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementpos]

	local firePos = placementPos+104
	groupbox shrapnelFire "Fire Properties:" width:(width-8) height:60 pos:[4,firePos]
		spinner shrapnel_firechance "Chance of fire:" range:[0,100,100] type:#integer fieldwidth:40 width:widthC pos:[colA,firepos+=18]
		spinner shrapnel_firecollumns "Nr. Collumns:" range:[0,9,1] type:#integer fieldwidth:40 width:widthC pos:[colD,firePos]
		spinner shrapnel_firemin "Min/Max smokiness:" range:[0,3,0] type:#integer fieldwidth:40 width:widthE pos:[colA,firePos+=18] tooltip:"0 = fire\n1 = black smoke\n2 = grey smoke\n3 = white smoke"
		spinner shrapnel_firemax range:[0,3,0] type:#integer fieldwidth:40 width:widthA pos:[colF,firePos]
	label shrapnelEnd "" pos:[4,656]
	
	
	fn updateShrapnelControlStates Shrapnel = (
		mainState = (shrapnel != undefined)
		type = try shrapnel.type catch 0
		
		shrapnelVelocities.visible = mainState
		shrapnel_min_tocar.visible = mainState
		shrapnel_max_tocar.visible = mainState
		shrapnel_rand_velo.visible = mainState
		shrapnel_randup_velo.visible = mainState
		shrapnel_imp_velo.visible = mainState
		shrapnel_norm_velo.visible = mainState
		shrapnel_spinrate.visible = mainState
		
		shrapnelType.visible = mainState
		shrapnel_type.visible = mainState
		
		typeNames = #("Shards:","Noncars:","Ghostparts:")
		propHeights = #(88,136,88)
		
		shrapnelTypeProps.caption = try typeNames[type] catch("")
		shrapnelTypeProps.height = try propHeights[type] catch(106)
		shrapnelTypeProps.visible = mainState
		
		typePositions = #(406,384,406)
		placementPos = 	try typePositions[type] catch(406)
		
		--shards and ghostpart stuff
		shrapnel_min_time.visible = (mainState and (type != 2))
		shrapnel_max_time.visible = (mainState and (type != 2))
		shrapnel_min_time.pos = [colE+spCorr,placementPos]
		shrapnel_max_time.pos = [colF+spCorr,PlacementPos]
		
		--noncar and ghostpart stuff
		shrapnel_bits_min.visible = (mainState and (type != 1))
		shrapnel_bits_max.visible = (mainState and (type != 1))
		shrapnel_bits_min.pos = [colE+spCorr,placementPos+=22]
		shrapnel_bits_max.pos = [colF+spCorr,PlacementPos]
		
		--shards stuff
		shardsState = (mainState and type==1)
		shrapnel_cutlength.visible = shardsState
		shrapnel_flag.visible = shardsState
		shrapnel_shardsmat.visible = shardsState
		
		--noncarstuff
		noncarState = (mainState and type==2)
		shrapnel_model.visible = noncarState
		shrapnel_actornumber.visible = noncarState
		shrapnel_actor.visible = noncarState
		shrapnel_noncartxt.visible = noncarState
		shrapnel_model.pos = [colC,placementPos+=22]
		shrapnel_actornumber.pos = [colF+spCorr,placementPos+=22]
		shrapnel_actor.pos = [colC,placementPos+=22]
		shrapnel_noncartxt.pos = [colC,placementPos+=22]
		
		--ghostpart stuff
		shrapnel_ghostpartActor.visible = (mainState and (type == 3))
		
		typePositions = #(480,528,480)
		placementPos = 	try typePositions[type] catch(500)
		
		placementState = mainState and not shardsState
		placementHeights = #(48,69,69)
		shrapnelPlacement.visible = placementState
		shrapnelPlacement.pos = [4,placementPos]
		shrapnelPlacement.height = try placementHeights[shrapnel.placement] catch 69
		
		clumpingType = try shrapnel.placement catch 0
		clumpingMainState = (placementState and (clumpingType != 0))
		shrapnel_placement.visible = clumpingMainState
		shrapnel_placement.pos = [colA,(placementPos+=18)]
		
		clumpingActorState = (placementState and (clumpingType > 1))
		clumpingSphereState = (placementState and (clumpingType == 2))
		clumpingBoxState = (placementState and (clumpingType == 3))
			
		clumping_centre.visible = clumpingActorState
		clumping_centre.pos = [colD,placementPos]
		shrapnel_radius.visible = clumpingSphereState
		shrapnel_radius.pos = [colF+spCorr,placementPos+=26]
		shrapnel_width.visible = clumpingBoxState
		shrapnel_width.pos = [colE+spCorr,placementPos]
		shrapnel_height.visible = clumpingBoxState
		shrapnel_height.pos = [colF+spCorr,placementPos]
		
		if not clumpingActorState then placementPos-=21
			
		fireState = noncarState and shrapnel.firechance > 0
		fireHeights = #(60,42)
		
		shrapnelFire.visible = noncarState
		shrapnelFire.pos = [4,placementpos+=29]
		shrapnelFire.height = if fireState then fireHeights[1] else fireHeights[2]
		shrapnel_firechance.visible =noncarState
		shrapnel_firechance.pos = [colC+spCorr,placementpos+=18]
		
		
		shrapnel_firecollumns.visible = fireState
		shrapnel_firecollumns.pos = [colF+spCorr,placementpos]
		shrapnel_firemin.visible = fireState
		shrapnel_firemin.pos = [colE+spCorr,placementpos+=18]
		shrapnel_firemax.visible = fireState
		shrapnel_firemax.pos = [colF+spCorr,placementpos]
	)
	fn updateShrapnelControlValues Shrapnel = (
		if shrapnel!=undefined then (
			shrapnel_min_tocar.range.z = shrapnel.min_tocar
			shrapnel_max_tocar.range.z = shrapnel.max_tocar
			shrapnel_rand_velo.range.z = shrapnel.rand_velo
			shrapnel_randup_velo.range.z = shrapnel.randup_velo
			shrapnel_imp_velo.range.z = shrapnel.imp_velo
			shrapnel_norm_velo.range.z = shrapnel.norm_velo
			shrapnel_spinrate.range.z = shrapnel.spinrate
			
			shrapnel_type.selection = shrapnel.type
			
			shrapnel_min_time.range.z = shrapnel.min_time
			shrapnel_max_time.range.z = shrapnel.max_time
			
			shrapnel_bits_min.range.z = shrapnel.bits_min
			shrapnel_bits_max.range.z = shrapnel.bits_max
			
			shrapnel_cutlength.range.z = shrapnel.cutlength
			shrapnel_flag.range.z = shrapnel.flag
			shrapnel_shardsmat.text = shrapnel.shardsmat
			
			shrapnel_model.text = shrapnel.model
			shrapnel_actornumber.range.z = shrapnel.actornumber
			shrapnel_actor.text = shrapnel.actor
			shrapnel_noncartxt.text = shrapnel.noncartxt
			
			shrapnel_ghostpartActor.text = shrapnel.ghostpartactor

			shrapnel_placement.selection = shrapnel.placement
			clumping_centre.selection = shrapnel.centre
			shrapnel_radius.range.z = shrapnel.radius
			shrapnel_width.range.z = shrapnel.width
			shrapnel_height.range.z = shrapnel.height
			
			shrapnel_firechance.range.z = shrapnel.firechance
			shrapnel_firecollumns.range.z = shrapnel.firecollumns
			shrapnel_firemin.range.z = shrapnel.firemin
			shrapnel_firemax.range.z = shrapnel.firemax
		)
	)
	fn populateShrapnelList lv = (
		shrapnels = conn.shrapnels
		lv.Clear()
		lv.tag =  dotNetMxsValue #()
		addColumns lv #(#("Name",.6),#("Type",.4))
		for i=1 to shrapnels.count do (
			m = shrapnels[i]
			types = #("Shards","Noncars","Ghostparts")
			addListItem lv m #(types[m.type])
		)
		lv.Update()
	)
	fn updateShrapnelListSubItems item = (
		if item != undefined then (
			m = item.tag.value
			types = #("Shards","Noncars","Ghostparts")
			updateListSubItems item #(types[m.type])
			shrapnelList.update()
		)
	)
	
	on ShrapnelSetup open do (
		shrapnelSetup.height = 666
		if conn != undefined then (
			initListView shrapnelList #(#("Name",.6),#("Type",.4))
			shrapnelList.tag = dotNetMxsValue conn.shrapnels
			populateShrapnelList shrapnelList
			setListViewSelection shrapnelList 1
				
			updateShrapnelControlStates shrapnel
			updateShrapnelControlValues shrapnel
		)
	)
	on ShrapnelAdd pressed do (
		shrapnel = standard name:("Shrapnel " + (conn.shrapnels.count as string))
		custattributes.add shrapnel shrapnel_CA
		append conn.shrapnels shrapnel
		addListItem shrapnelList shrapnel #("Shards")
		setListViewSelection shrapnelList conn.shrapnels.count
	)
	on ShrapnelDel pressed do (
		item = try shrapnelList.selecteditems.item[0] catch undefined
		if item!=undefined then (
			curindex = item.index
			shrapnel = getListViewSelectedItem shrapnelList
			if shrapnel!=undefined then (
				custattributes.delete shrapnel shrapnel_CA
				deleteItem conn.shrapnels (curIndex+1)
				deleteListViewItem shrapnelList
				updateListViewColors shrapnelList
			)
			try setListViewSelection shrapnelList curIndex catch (setListViewSelection shrapnelList 0)
		)
	)
	on shrapnelList SelectedIndexChanged i do (
		shrapnel = getListViewSelectedItem shrapnelList
		updateShrapnelControlStates shrapnel
		updateShrapnelControlValues shrapnel
	)
	on shrapnelList DoubleClick i do (
		shrapnel.name = newString shrapnel.name "Enter a new descriptive name:"
		updateShrapnelListSubItems shrapnelList.selecteditems.item[0]
	)
	on shrapnel_type selected i do (
		shrapnel.type = i
		updateShrapnelControlStates shrapnel
		updateShrapnelListSubItems shrapnelList.selecteditems.item[0]
	)
	on shrapnel_min_tocar changed val do try shrapnel.min_tocar = val catch()
	on shrapnel_max_tocar changed val do try shrapnel.max_tocar = val catch()
	on shrapnel_rand_velo changed val do try shrapnel.rand_velo = val catch()
	on shrapnel_randup_velo changed val do try shrapnel.randup_velo = val catch()
	on shrapnel_imp_velo changed val do try shrapnel.imp_velo = val catch()
	on shrapnel_norm_velo changed val do try shrapnel.norm_velo = val catch()
	on shrapnel_spinrate changed val do try shrapnel.spinrate = val catch()
	on shrapnel_min_time changed val do try shrapnel.min_time = val catch()
	on shrapnel_max_time changed val do try shrapnel.max_time = val catch()
	on shrapnel_bits_min changed val do try shrapnel.bits_min = val catch()
	on shrapnel_bits_max changed val do try shrapnel.bits_max = val catch()
	on shrapnel_cutlength changed val do try shrapnel.cutlength = val catch()
	on shrapnel_flag changed val do try shrapnel.flag = val catch()
	on shrapnel_shardsmat entered txt do try shrapnel.shardsmat = txt catch()
	on shrapnel_model changed txt do (
		shrapnel.model = txt
	)
	on shrapnel_actornumber changed val do try shrapnel.actornumber = val catch()
	on shrapnel_actor changed txt do (
		shrapnel.actor = txt
	)
	on shrapnel_noncartxt changed txt do (
		shrapnel.noncartxt = txt
	)
	on shrapnel_ghostpartActor pressed do (
		try (
			actName = getOpenFileName()
			if actName != undefined do (
				shrapnel.ghostpartActor = filenamefrompath actName
				shrapnel_ghostpartActor.text = filenamefrompath actName
			)
		)
		catch()
	)
	on shrapnel_ghostpartActor rightclick do (
		shrapnel.ghostpartActor = "Ghostpart Model:"
		shrapnel_ghostpartActor.text = "Ghostpart Model:"
	)
	on shrapnel_placement selected i do (
		shrapnel.placement = i
		updateShrapnelControlStates shrapnel
	)
	on clumping_centre selected i do shrapnel.centre = i
	on shrapnel_radius changed val do shrapnel.radius = val
	on shrapnel_width changed val do shrapnel.width = val
	on shrapnel_height changed val do shrapnel.height = val
	on shrapnel_firechance changed val do (
		shrapnel.firechance = val
		updateShrapnelControlStates shrapnel
	)
	on shrapnel_firecollumns changed val do shrapnel.firecollumns = val
	on shrapnel_firemin changed val do shrapnel.firemin = val
	on shrapnel_firemax changed val do shrapnel.firemax = val
	
)
--createdialog shrapnelSetup width height