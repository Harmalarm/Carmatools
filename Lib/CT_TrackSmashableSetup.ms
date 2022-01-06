--try destroydialog smashableSetup catch()
rollout smashableSetup "Smashable Setup" height:910 (
	local smash = undefined
	local conn = undefined
	local lvl = undefined
	
	local mode = "Nochange"
	
	group "Smashables in scene:" (
		dotNetControl smashList "System.Windows.Forms.ListView" width:(widthF) height:164
		button smashAdd "Add selection" width:widthC across:2 tooltip:"Add the groove attributes to the selection (from scene)"
		button smashDel "Remove selection" width:widthC tooltip:"Remove the groove attributes from the selection (from scene or list)"
	)
	local placementPos = (224)
	groupbox smash_main "Main Properties:" width:(width-8) height:97 pos:[4,placementPos]
		label smash_lbl1 "Mode:" align:#left pos:[colA,placementPos+=22]
		dropdownlist smash_mode "" width:widthB pos:[colB,placementPos] items:#("NoChange","ReplaceModel","Remove") selection:1 labelontop:false tooltip:"Select the mode for the Smashable"
		spinner smash_flags "Flags:" range:[0,1,0] pos:[colF,placementPos] type:#integer fieldwidth:40 width:widthA tooltip:"Not clear what these do, but 0 and 1 work"
		spinner smash_threshold "Threshold:" range:[0,9999999,1] fieldwidth:40 width:widthA pos:[colF,placementPos+=22] tooltip:"The main impact threshold for the Smashable to trigger"	
		label smash_lbl2 "Type:" pos:[colA,placementPos]
		radiobuttons smash_type ""	labels:#("Model","Material") pos:[colB,placementPos] tooltip:"Select the type of trigger for this Smashable" default:1 columns:2
		edittext  smash_triggerName "Trigger Name" fieldwidth:widthD pos:[colA+42,placementPos+=22]
		--pickbutton smash_triggerModel "Trigger Model" width:150 pos:[colE,272] autoDisplay:true
		--materialbutton smash_triggerMaterial "Trigger Material" width:150 pos:[colE,272]
	
	local showRepl = (mode == "ReplaceModel")
	local placementPos = 324
	groupbox smash_replacemodel_group "ReplaceModel:" width:(width-8) pos:[4,placementPos] height:90 visible:showRepl
		pickbutton smash_replacemodel "Pick a model" width:150 pos:(smash_replacemodel_group.pos+[9,20]) autodisplay:true visible:showRepl tooltip:"Pick a model from the scene. It should contain a & prefix!"
		spinner repl_firechance "fire/smoke chance:" range:[0,100,100] type:#integer fieldwidth:40 align:#right offset:[0,-22] visible:showRepl tooltip:"The chance of any fire/smoke spawning"
		spinner repl_firecollumns "fire/smoke collumns:" range:[0,9,1] type:#integer fieldwidth:40 visible:showRepl tooltip:"The number of fire/smoke spawn points"
		spinner repl_firemax range:[0,3,0] type:#integer align:#right fieldwidth:40 visible:showRepl 
		spinner repl_firemin "min/max smokiness:" range:[0,3,0] type:#integer fieldwidth:40 width:-8 pos:(repl_firemax.pos+[-50,0]) visible:showRepl tooltip:"The range of smoke types to be used,\n0=fire,\n1=black smoke,\n2=grey smoke,\n3=white smoke"
	
	local showConn = true
	
	groupbox smash_connotations "Connotations:" width:(width-8) height:136 pos:[4,304] visible:showConn
		label conn_sounds_count "0	sounds" align:#left width:200 pos:[13,324] visible:showConn
		label conn_shrapnels_count "0	shrapnels"  align:#left width:150 visible:showConn
		label conn_explosion_count "0	explosions" align:#left width:150 visible:showConn
		label conn_slick_mat "none	slick material" align:#left width:150 visible:showConn
		label conn_noncar_count "0	noncars affected" align:#left width:150 visible:showConn
		label conn_sideeff_count "0	side effects" align:#left width:150 pos:[colD,324] visible:showConn
		label conn_extension_flags "0	extension flags" align:#left width:150 pos:[colD,342] visible:showConn
		label conn_powerups_count "0	powerups given" align:#left width:150 pos:[colD,360] visible:showConn
		label conn_awardcode_count "none	awardcode" align:#left width:150 pos:[colD,378] visible:showConn
		label conn_runtimevar_count "0	runtime variables" align:#left width:150 pos:[colD,396] visible:showConn
		button conn_edit "Edit Connotations" width:widthC pos:[colD,414] visible:showConn
	
	local showTexCh = (mode=="TextureChange")
	
	local placementPos = 324	
	groupbox smash_textureChange "TextureChange:" width:(width-8) height:96 pos:[4,placementPos] visible:showTexCh
		button smash_startBitmap "Bitmap:" width:64 height:64 pos:[colA,placementPos+=22]
		label smash_levellbl "Levels:" pos:[colC-10,placementPos]
		button smash_levelAdd "+" width:20 pos:[colC+30,placementPos] tooltip:"add a new Texture Change Level"
		button smash_levelDel "-" width:20 pos:[colC+30,placementPos+24] tooltip:"remove the last Texture Change level"
		listbox smash_TexChLevels "" height:4 pos:[colD,placementPos] fieldwidth:widthC width:widthC border:#none
	
	groupbox smash_textureChange_level "Level 1:" width:(width-8) height:96 pos:[4,placementPos+=80] visible:showTexCh
		button smash_levelBitmap "Bitmap:" width:64 height:64 pos:[colA,placementPos+=22]
		spinner smash_levelthreshold "Trigger Threshold:" range:[0,1,0.005] scale:0.001 width:widthB fieldwidth:40 pos:[colC,placementPos] visible:showTexCh
		spinner smash_levelFlags "Flags" range:[0,2,0] type:#integer width:widthB fieldwidth:40 pos:[colE,placementPos] visible:showTexCh
		label smash_levellbl1 "Collision type:" width:75 pos:[colC+36,placementPos+=22]
		dropdownlist smash_levelCollision "" items:#("Solid","Edges","PassThrough") width:widthB pos:[colE,placementPos] visible:showTexCh
		--button smash_levelConnotations "Edit Connotations" width:150 pos:[colE,462] visible:(showTexCh())
	
	label endlabel "" pos:[13,644]
	
	--rollout specific functions
	fn populateSmashList lv = (
		smashes = rootnode.smashables
		lv.Clear()
		lv.tag =  dotNetMxsValue #()
		addColumns lv #(#("Name",.4),#("Type",.3),#("Mode",.3))
		for i=1 to smashes.count do (
			m = smashes[i]
			types = #("Model","Material")
			modes = if (m.type == 1) then #("NoChange","ReplaceModel","Remove") else #("NoChange","TextureChange")
			addListItem lv m #(types[m.type],modes[m.mode])
		)
		lv.Update()
	)
	fn updateSmashListSubItems item = (
		if item != undefined then (
			m = item.tag.value
			types = #("Model","Material")
			modes = if (m.type == 1) then #("NoChange","ReplaceModel","Remove") else #("NoChange","TextureChange")
			sub = #(types[m.type],modes[m.mode])
			updateListSubItems item sub
			smashList.update()
		)
	)
	fn updateControlStates smash = (
		mode = ""
		if smash!=undefined then (
			type = smash.type
			--smash_triggerModel.visible = (type==1)
			--smash_triggerMaterial.visible = (type==2)
			smash_mode.items = if (type==1) then #("NoChange", "ReplaceModel","Remove") else  #("NoChange","TextureChange")
			mode = smash_mode.items[smash.mode]
		)
		
		showMain = (smash!=undefined)
		showTexCh = (mode=="TextureChange")
		showRepl = (mode=="ReplaceModel")
		showConn = (mode!="")
		
		smash_main.visible = showMain
		smash_lbl1.visible = showMain
		smash_mode.visible = showMain
		smash_flags.visible = showMain
		smash_threshold.visible = not showTexCh and showMain
		smash_lbl2.visible = showMain
		smash_type.visible = showMain
		smash_triggerName.visible = showMain
		
		--smash_triggerModel.visible = showMain
		--smash_triggerMaterial.visible = showMain
		
		smash_replacemodel_group.visible = showRepl
		smash_replacemodel.visible = showRepl
		repl_firechance.visible = showRepl
		repl_firecollumns.visible = showRepl
		repl_firemax.visible = showRepl
		repl_firemin.visible = showRepl
		
		smash_textureChange.visible = showTexCh
		smash_startBitmap.visible = showTexCh
		smash_levellbl.visible = showTexCh
		smash_levelAdd.visible = showTexCh
		smash_levelDel.visible = showTexCh
		smash_TexChlevels.visible = showTexCh
	
		smash_textureChange_level.visible = showTexCh
		smash_levelBitmap.visible = showTexCh
		smash_levelthreshold.visible = showTexCh
		smash_levelFlags.visible = showTexCh
		smash_levellbl1.visible = showTexCh
		smash_levelCollision.visible = showTexCh
		
		smash_connotations.visible = showConn
		conn_sounds_count.visible = showConn
		conn_shrapnels_count.visible = showConn
		conn_explosion_count.visible = showConn
		conn_slick_mat.visible = showConn
		conn_noncar_count.visible = showConn
		conn_sideeff_count.visible = showConn
		conn_extension_flags.visible = showConn
		conn_powerups_count.visible = showConn
		conn_awardcode_count.visible = showConn
		conn_runtimevar_count.visible = showConn
		conn_edit.visible = showConn
		
		ypos = 324
		if showRepl then ypos = 418
		if showTexCh then ypos = 526
		
		smash_connotations.pos = [3,ypos]
		conn_sounds_count.pos = [colA,ypos+20]
		conn_shrapnels_count.pos = [colA,ypos+38]
		conn_explosion_count.pos = [colA,ypos+56]
		conn_slick_mat.pos = [colA,ypos+74]
		conn_noncar_count.pos = [colA,ypos+92]
		conn_sideeff_count.pos = [colD,ypos+20]
		conn_extension_flags.pos = [colD,ypos+38]
		conn_powerups_count.pos = [colD,ypos+56]
		conn_awardcode_count.pos = [colD,ypos+74]
		conn_runtimevar_count.pos = [colD,ypos+92]
		conn_edit.pos = [colD,ypos+110]
	)
	fn updateControlValues smash = (
		if smash != undefined then (
			--main entries
			smash_type.state = smash.type
			smash_mode.selection = smash.mode
			smash_flags.range.z = smash.flags
			smash_threshold.range.z = smash.threshold
			--if (smash.type == 1) then smash_triggerModel.text = (try smash.model.name catch "Trigger Model")
			--if (smash.type == 2) then smash_triggerMaterial.text = (try smash.material.name catch "Trigger Material")
			smash_triggerName.text = smash.triggerName
			
			--replacemodel entries
			smash_replacemodel.text = try smash.replacemodel.name catch "ReplaceModel:"
			repl_firechance.range.z = smash.firechance
			repl_firecollumns.range.z = smash.firecollumns
			repl_firemax.range.z = smash.firemax
			repl_firemin.range.z = smash.firemin
			
			--texturechange entries
			updatePreviewBitmap smash_startBitmap smash.startBitmap 64 64 
			smash_TexChLevels.items = for l in smash.levels collect l.name
			
			sel = smash_TexChLevels.selection
			lvl = try smash.levels[sel] catch undefined
			if lvl != undefined then (
				updatePreviewBitmap smash_levelBitmap lvl.lvl_bitmap 64 64
				smash_textureChange_level.caption = ("Level "+sel as string)
				smash_levelthreshold.range.z = lvl.threshold
				smash_levelflags.range.z = lvl.flags
				smash_levelCollision.selection = lvl.coltype
			)
			
			--connotation entries
			conn = smash.connotations
			if smash.type==2 and smash.mode==2 then (
				conn = try lvl.connotations catch(smash.connotations)
			)
			
			conn_sounds_count.text = (conn.sounds.count as string + "	sounds")
			conn_shrapnels_count.text = (conn.shrapnels.count as string + "	shrapnels")
			conn_explosion_count.text = (conn.explosions.count as string + "	explosions")
			conn_slick_mat.text = (conn.slick + "	slick material")
			conn_noncar_count.text = (conn.noncars.count as string+ "	noncars affected")
			conn_sideeff_count.text = (conn.sideEffects.count as string + "	side effects")
			conn_extension_flags.text = (conn.extensionFlag as string + "	extension flags")
			conn_powerups_count.text = (conn.powerup as string + "	powerups given")
			codes = #("none","singleshot","repeated","doitregardless")
			conn_awardcode_count.text = (codes[conn.awardcode] + "	award code")
			conn_runtimevar_count.text = (conn.runtimevars.count as string+ "	runtime variables")
		)
	)
	
	--rollout events
	on smash_type changed i do (
		smash_mode.selection = 1
		try (
			smash.mode = 1
			smash.type = i
			updateControlStates smash
			updateSmashListSubItems smashList.selecteditems.item[0]
		)
		catch()
	)
	on smash_mode selected i do (
		try (
			smash.mode = i
			updateControlStates smash
			updateSmashListSubItems smashList.selecteditems.item[0]
		)
		catch()
	)
	on smashableSetup open do (
		initListView smashList #(#("Name",.4),#("Type",.3),#("Mode",.3))
		smashList.tag = dotNetMxsValue rootnode.track_general_attributes.smashables
		populateSmashList smashList
		setListViewSelection smashList 1
		updateControlStates smash
	)
	on smashAdd pressed do (
		smashName = newString "Smashable" "Enter a descriptive name for the smashable"
		if smashName != "" then (
			smash = standard name:smashName 
			custattributes.add smash Smash_CA
			print smash
			conn = standard name:"Connotations"
			custattributes.add conn connotations_CA
			smash.smash_data.connotations = conn
			lvl = standard name:"Level 1"
			custattributes.add lvl textureChange_lvl_CA
			lvl.connotations = conn
			smash.levels = #(lvl)
			
			append rootnode.smashables smash
			smashList.tag = dotNetMxsValue rootnode.track_general_attributes.smashables
			
			addListItem smashList smash #("Model","NoChange")
			setListViewSelection smashList smashList.items.count
		)
	)
	on smashDel pressed do (
		item = smashList.selecteditems.item[0]
		if item!=undefined then (
			curindex = item.index
			smash = getListViewSelectedItem smashList
			if smash!=undefined then (
				custattributes.delete smash smash_CA
				deleteItem rootnode.smashables (curIndex+1)
				deleteListViewItem smashList
				updateListViewColors smashList
			)
			try setListViewSelection smashList curIndex catch (setListViewSelection smashList 0)
		)
	)
	on smashList SelectedIndexChanged i do (
		smash = getListViewSelectedItem smashList
		updateControlstates smash
		updateControlValues smash
	)
	on smashList DoubleClick i do (
		item = smashList.selecteditems.item[0]
		smash = getListViewSelectedItem smashList
		smash.name = newString smash.name "Enter a descriptive name for the smashable"
		updateSmashListSubItems item
	)
	on smash_flags changed val do try smash.flags = val catch()
	on smash_threshold changed val do try smash.threshold = val catch()
	/*
	on smash_triggerModel picked obj do (
		if obj!=undefined and smash!=undefined then (
			smash.model = obj
		)
	)
	on smash_triggerModel rightclick do (
		if smash!=undefined then (
			smash.model = undefined
			smash_triggerModel.text = "Trigger Model"
		)
	)
	on smash_triggerMaterial picked mat do (
		if mat!=undefined and smash!=undefined then (
			smash.material = mat
			smash_triggerMaterial.text = mat.name
		)
	)
	on smash_triggerMaterial rightclick do (
		if smash!=undefined then (
			smash.material = undefined
			smash_triggerMaterial.text = "Trigger Material"
		)
	)
	*/
	on smash_triggerName changed txt do (
		smash.triggerName = txt
	)
	on smash_replacemodel picked obj do (
		if obj != undefined then try smash.replacemodel = obj catch ()
	)
	on repl_firechance changed val do try smash.firechance = val catch()
	on repl_firecollumns changed val do try smash.firecollumns = val catch()
	on repl_firemax changed val do try smash.firemax = val catch()
	on repl_firemin changed val do try smash.firemin = val catch()
	
	on smash_startBitmap pressed do (
		try smash.startBitmap = setPreviewBitmap smash_startBitmap 64 64 catch()
	)	
	on smash_startBitmap rightclick do (
		smash.startBitmap = "Bitmap:"
		updatePreviewBitmap smash_startBitmap smash.startBitmap 64 64 
	)
	on smash_levelAdd pressed do (
		lvl = standard name:("Level "+((smash_TexChLevels.items.count + 1) as string))
		custattributes.add lvl textureChange_lvl_CA
		append smash.levels lvl
		conn = standard name:"Connotations"
		custattributes.add conn connotations_CA
		lvl.connotations = conn
		smash_TexChLevels.items = for l in smash.levels collect l.name
		smash_TexChLevels.selection = smash_TexChLevels.items.count
		updateControlValues smash
	)
	on smash_levelDel pressed do (
		levelCount = smash.levels.count
		if levelCount > 1 then (
			deleteitem smash.levels levelCount
			smash_TexChLevels.items = for l in smash.levels collect l.name
			smash_TexChLevels.selection = levelCount-1
			updateControlValues smash
		)
	)
	on smash_TexChLevels selected i do updateControlValues smash
		
	on smash_levelBitmap pressed do try lvl.lvl_bitmap = setPreviewBitmap smash_levelBitmap 64 64 catch()
	on smash_levelBitmap rightclick do (
		lvl.lvlBitmap = "Bitmap:"
		updatePreviewBitmap smash_levelBitmap lvl.lvl_Bitmap 64 64
	)
	on smash_levelthreshold changed val do try lvl.threshold = val catch()
	on smash_levelFlags changed val do try lvl.flags = val catch()
	on smash_levelCollision selected i do try lvl.coltype = i catch()
	
	on conn_edit pressed do (
		if conn!=undefined then (
			rootnode.current_connotations = conn
			xpos = try ((getDialogpos trackSetup)[1]+superwidth) catch 50
			ypos = try (getDialogpos trackSetup)[2] catch 50
			
			createdialog connotationsEdit superWidth height xpos ypos  style:#(#style_titlebar, #style_border,#style_sysmenu, #style_resizing,#style_minimizebox) lockWidth:true
		)
	)
)
--createdialog smashableSetup width height