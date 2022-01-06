explosion_CA = attributes explosion_data
attribid:#(0x258a8419, 0x10c411b0)
(
	parameters explosion_params
	(
		min_expl type:#integer default:1
		max_expl type:#integer default:1
		min_delay type:#float default:0
		max_delay type:#float default:0
		offset_x type:#float default:0
		offset_y type:#float default:0
		offset_z type:#float default:0
		min_xfactor type:#float default:0
		max_xfactor type:#float default:0.1
		min_yfactor type:#float default:0
		max_yfactor type:#float default:0.1
		min_zfactor type:#float default:0
		max_zfactor type:#float default:0.1
		min_framerate type:#integer default:8
		max_framerate type:#integer default:8
		min_scalefactor type:#float default:15
		max_scalefactor type:#float default:15
		rotmode type:#integer default:1
		frames type:#stringtab tabsize:0 tabsizevariable:true
	)
)

--try destroydialog explosionSetup catch()
rollout explosionSetup "Explosion Setup"
(
	local conn = rootnode.current_connotations
	local explosion = undefined
	group "Explosions in Smashable:" (
		dotNetControl explosionList "System.Windows.Forms.ListView" width:(widthF) height:164
		button explosionAdd "Add Explosion" width:widthC across:2 tooltip:"Add a explosion effect to the current Smashable"
		button explosionDel "Remove Explosion" width:widthC tooltip:"Remove a explosion effect from the currnet Smashable"
	)
	groupbox explosionTiming "Timing:" width:(width-8) height:50
		spinner min_expl_delay "Min/Max start delay:" range:[0,10,0] type:#float scale:0.01 fieldwidth:40 width:widthE 
		spinner max_expl_delay ""range:[0,10,0] type:#float scale:0.01 fieldwidth:40 width:widthA
	groupbox explosionPlacement "Placement:" width:(width-8) height:134
		spinner min_expl "Min/Max explosion count:" range:[0,10,1] type:#integer fieldwidth:40 width:widthE	
		spinner max_expl ""range:[0,10,1] type:#integer fieldwidth:40 width:widthA
		spinner expl_offset_x "Offset XYZ:" range:[-9999,9999,0] type:#float scale:0.01 fieldwidth:40 width:widthD
		spinner expl_offset_y "" range:[-9999,9999,0.1] type:#float scale:0.01 fieldwidth:40 width:widthA
		spinner expl_offset_z "" range:[-9999,9999,0] type:#float scale:0.01 fieldwidth:40 width:widthA
		spinner min_expl_xfactor "Min/Max X count" range:[-9999,9999,0] type:#float scale:0.01 fieldwidth:40 width:widthE
		spinner max_expl_xfactor range:[-9999,9999,0.1] type:#float scale:0.01 fieldwidth:40 width:widthA
		spinner min_expl_yfactor "Min/Max Y count" range:[-9999,9999,0] type:#float scale:0.01 fieldwidth:40 width:widthE
		spinner max_expl_yfactor range:[-9999,9999,0.1] type:#float scale:0.01 fieldwidth:40 width:widthA
		spinner min_expl_zfactor "Min/Max Z count" range:[-9999,9999,0] type:#float scale:0.01 fieldwidth:40 width:widthE
		spinner max_expl_zfactor range:[-9999,9999,0.1] type:#float scale:0.01 fieldwidth:40 width:widthA
	groupbox explosionBehaviour "Behaviour:" width:(width-8) height:96
		spinner min_expl_framerate "Min/Max framerate:" range:[0,9999,8] type:#integer fieldwidth:40 width:widthF	
		spinner max_expl_framerate range:[0,9999,8] type:#integer fieldwidth:40 width:widthA
		spinner min_expl_scalefactor "scalefactor:" range:[0,9999,15] type:#float scale:0.01 fieldwidth:40 width:widthF
		spinner max_expl_scalefactor range:[0,9999,15] type:#float scale:0.01 fieldwidth:40 width:widthA
		dropdownlist expl_rotmode "" items:#("randomrotate","norotate") width:150 width:widthC
	groupbox explosionFrames "Frames:" width:(width-8) height:116
		listbox expl_frames_list "" items:#() width:widthC height:6
		button expl_frames_add "Add frame" width:widthC align:#right offset:[0,-90]
		button expl_frames_remove "Remove frame" width:widthC align:#right
		spinner expl_frames_opac "opacity:" range:[0,100,75] type:#integer fieldwidth:40 width:widthC
		label expl_label6 "" offset:[0,0]
		
		
		
	
	fn updateExplosionControlPositions explosion = (
		--placement
		placementPos = 224

		explosionTiming.pos = [4,placementPos]
		min_expl_delay.pos = [colE+spCorr,placementPos+=24]
		max_expl_delay.pos = [colF+spCorr,placementPos]
		
		explosionPlacement.pos = [4,placementPos+=30]
		min_expl.pos = [colE+spCorr,placementPos+=24]
		max_expl.pos = [colF+spCorr,placementPos]
		expl_offset_x.pos = [colD+spCorr,placementPos+=21]
		expl_offset_y.pos = [colE+spCorr,placementPos]
		expl_offset_z.pos = [colF+spCorr,placementPos]
		min_expl_xfactor.pos = [colE+spCorr,placementPos+=21]
		max_expl_xfactor.pos = [colF+spCorr,placementPos]
		min_expl_yfactor.pos = [colE+spCorr,placementPos+=21]
		max_expl_yfactor.pos = [colF+spCorr,placementPos]
		min_expl_zfactor.pos = [colE+spCorr,placementPos+=21]
		max_expl_zfactor.pos = [colF+spCorr,placementPos]
		
		explosionBehaviour.pos = [4,placementPos+=30]
		min_expl_framerate.pos = [colE+spCorr,placementPos+=24]
		max_expl_framerate.pos = [colF+spCorr,placementPos]
		min_expl_scalefactor.pos = [colE+spCorr,placementPos+=24]
		max_expl_scalefactor.pos = [colF+spCorr,placementPos]
		expl_rotmode.pos = [colD,placementPos+=21]
		
		explosionFrames.pos = [4,placementPos+=30]
		expl_frames_list.pos = [colA,placementPos+=24]
		expl_frames_add.pos = [colD,placementPos]
		expl_frames_remove.pos = [colD,placementPos+=24]
		expl_frames_opac.pos = [colF+spCorr,placementPos+=24]
	)
	
	fn updateExplosionControlStates explosion = (
		mainState = (explosion != undefined)

		explosionTiming.visible = mainState
		min_expl_delay.visible = mainState
		max_expl_delay.visible = mainState
		
		explosionPlacement.visible = mainState
		min_expl.visible = mainState
		max_expl.visible = mainState
		expl_offset_x.visible = mainState
		expl_offset_y.visible = mainState
		expl_offset_z.visible = mainState
		min_expl_xfactor.visible = mainState
		max_expl_xfactor.visible = mainState
		min_expl_yfactor.visible = mainState
		max_expl_yfactor.visible = mainState
		min_expl_zfactor.visible = mainState
		max_expl_zfactor.visible = mainState
		
		explosionBehaviour.visible = mainState
		min_expl_framerate.visible = mainState
		max_expl_framerate.visible = mainState
		min_expl_scalefactor.visible = mainState
		max_expl_scalefactor.visible = mainState
		expl_rotmode.visible = mainState
		
		explosionFrames.visible = mainState
		expl_frames_list.visible = mainState
		expl_frames_add.visible = mainState
		expl_frames_remove.visible = mainState
		expl_frames_opac.visible = mainState
		
	)
	fn updateExplosionFrameControlValues explosion = (
		if explosion != undefined then (
			expl_frames_list.items = for f in explosion.frames collect f
			sel = expl_frames_list.selection
			if sel!=0 then (
				frame = explosion.frames[sel]
				nameBits = filterstring frame ","
				expl_frames_opac.range.z = (nameBits[2] as integer)
			)
		)
	)
	fn updateExplosionControlValues explosion = (
		if explosion != undefined then (
			min_expl_delay.range.z = explosion.min_delay
			max_expl_delay.range.z = explosion.max_delay
			
			min_expl.range.z = explosion.min_expl
			max_expl.range.z= explosion.max_expl
			expl_offset_x.range.z = explosion.offset_x
			expl_offset_y.range.z = explosion.offset_y
			expl_offset_z.range.z = explosion.offset_z
			min_expl_xfactor.range.z = explosion.min_xfactor
			max_expl_xfactor.range.z = explosion.max_xfactor
			min_expl_yfactor.range.z = explosion.min_yfactor
			max_expl_yfactor.range.z = explosion.max_yfactor
			min_expl_zfactor.range.z = explosion.min_zfactor
			max_expl_zfactor.range.z = explosion.max_zfactor
			
			min_expl_framerate.range.z = explosion.min_framerate
			max_expl_framerate.range.z = explosion.max_framerate
			min_expl_scalefactor.range.z = explosion.min_scalefactor
			max_expl_scalefactor.range.z = explosion.max_scalefactor
			expl_rotmode.selection = explosion.rotmode
			
			updateExplosionFrameControlValues explosion
		)
	)
	
	fn populateExplosionList lv = (
		explosions = conn.explosions
		lv.Clear()
		lv.tag =  dotNetMxsValue #()
		addColumns lv #(#("Name",1))
		for i=1 to explosions.count do (
			m = explosions[i]
			addListItem lv m #()
		)
		lv.Update()
	)
	fn updateExplosionListSubItems item = (
		if item != undefined then (
			m = item.tag.value
			updateListSubItems item #()
			explosionList.update()
		)
	)
	fn update_frames_list = (
		expl_frames_list.items = for f in frames collect f
		sel = expl_frames_list.selection
		if sel!=0 then (
			frame = frames[sel]
			namebits = filterstring frame ","
			expl_frames_opac.range = [0,100,(namebits[2] as integer)]
		)
	)
	
	on explosionSetup open do (
		explosionSetup.height = 642
		if conn != undefined then (
			initListView explosionList #(#("Name",1))
			explosionList.tag = dotNetMxsValue conn.explosions
			populateExplosionList explosionList
			setListViewSelection explosionList 1
				
			updateExplosionControlPositions explosion
			updateExplosionControlStates explosion
			updateExplosionControlValues explosion
		)
	)
	on explosionAdd pressed do (
		explosion = standard name:("Explosion " + (conn.explosions.count as string))
		custattributes.add explosion explosion_CA
		append conn.explosions explosion
		addListItem explosionList explosion #("Test")
		setListViewSelection explosionList conn.explosions.count
	)
	on explosionDel pressed do (
		item = try explosionList.selecteditems.item[0] catch undefined
		if item!=undefined then (
			curindex = item.index
			explosion = getListViewSelectedItem explosionList
			if explosion!=undefined then (
				custattributes.delete explosion explosion_CA
				deleteItem conn.explosions (curIndex+1)
				deleteListViewItem explosionList
				updateListViewColors explosionList
			)
			try setListViewSelection explosionList curIndex catch (setListViewSelection explosionList 0)
		)
	)
	on explosionList SelectedIndexChanged i do (
		explosion = getListViewSelectedItem explosionList
		updateExplosionControlPositions explosion
		updateExplosionControlStates explosion
		updateExplosionControlValues explosion
	)
	on explosionList DoubleClick i do (
		explosion.name = newString explosion.name "Enter a new descriptive name:"
		updateExplosionListSubItems explosionList.selecteditems.item[0]
	)
	on min_expl_delay changed val do explosion.min_delay = val
	on max_expl_delay changed val do explosion.max_delay = val
	on min_expl changed val do explosion.min_expl = val
	on max_expl changed val do explosion.max_expl = val
	on expl_offset_x changed val do explosion.offset_x = val
	on expl_offset_y changed val do explosion.offset_y = val
	on expl_offset_z changed val do explosion.offset_z = val
	on min_expl_xfactor changed val do explosion.min_xfactor = val
	on max_expl_xfactor changed val do explosion.max_xfactor = val
	on min_expl_yfactor changed val do explosion.min_yfactor = val
	on max_expl_yfactor changed val do explosion.max_yfactor = val
	on min_expl_zfactor changed val do explosion.min_zfactor = val
	on max_expl_zfactor changed val do explosion.max_zfactor = val

	on min_expl_framerate changed val do explosion.min_framerate = val
	on max_expl_framerate changed val do explosion.max_framerate = val
	on min_expl_scalefactor changed val do explosion.min_scalefactor = val
	on max_expl_scalefactor changed val do explosion.max_scalefactor = val
	on expl_rotmode selected i do explosion.rotmode = i
	on expl_frames_list selected i do (
		updateExplosionFrameControlValues explosion
	)
	on expl_frames_add pressed do (
		frame = newString "" "Enter a frame name (name of texture)"
		if frame != "" then (
			frame = frame + "," + (expl_frames_opac.value as string)
			append explosion.frames Frame
			updateExplosionFrameControlValues explosion
		)
	)
	on expl_frames_remove pressed do (
		sel = expl_frames_list.selection
		if sel!=0 then (
			deleteitem explosion.frames sel
			updateExplosionFrameControlValues explosion
		)
	)
	on expl_frames_opac changed val do (
		sel = expl_frames_list.selection
		if sel!=0 then (
			frame = explosion.frames[sel]
			nameBits = filterstring frame ","
			frame = nameBits[1]+ "," + (expl_frames_opac.value as string)
			explosion.frames[sel] = frame
			updateExplosionFrameControlValues explosion
		)
	)
	
)
--createdialog explosionSetup width height