connotations_CA = attributes connotations_data
attribid:#(0x67174092, 0x48fc38bb)
(
	parameters connotations_params
	(
		sounds type:#stringtab tabsize:0 tabsizevariable:true
		
		shrapnels type:#materialtab tabsize:0 tabsizevariable:true
		
		explosions type:#materialtab tabsize:0 tabsizevariable:true
		
		slick type:#string default:"none"
		slick_x type:#integer default:100
		slick_y type:#integer default:100
		slick_z type:#integer default:100
		slick_width type:#float default:0.2
		slick_height type:#float default:0.2
		slick_length type:#float default:0.2
		min_skidduration type:#float default:20
		max_skidduration  type:#float default:20
		min_skidfriction type:#float default:0.6
		max_skidfriction type:#float default:0.6
		skidmaterial type:#integer default:1
		
		noncars type:#materialtab tabsize:0 tabsizevariable:true
		
		sideEffects type:#materialtab tabsize:0 tabsizevariable:true
		
		extensionFlag type:#integer default:0
		powerup type:#integer default:0
		awardcode type:#integer default:1
		credits type:#integer default:0
		timebonus type:#integer default:0
		textmessage type:#integer default:0
		scrollermessage type:#integer default:0
		runtimevars type:#stringtab tabsize:0 tabsizevariable:true
	)
)

--try destroydialog connotationsSetup catch()
rollout connotationsSetup "Connotations Main" (
	local conn = rootnode.current_connotations
	local placementPos = 4
	
	groupbox connSounds "Sounds:" width:(width-8) height:104 pos:[4,placementPos]
		listbox soundList "" items:#() height:5 selection:1 width:widthC pos:[colA,placementPos+=24]
		button soundAdd "Add sound" width:widthC pos:[colD,placementPos]
		button soundDel "Remove sound" width:widthC pos:[colD,placementPos+=24]
	groupbox connSlick "Slick:" width:(width-8) height:156 pos:[4,placementPos+=60]
		button slick_material "none" width:64 height:64 pos:[colA,placementPos+=24] tooltip:"pick a slick! rightclick to remove"
		spinner slick_x "Unk.:" range:[0,100,100] type:#integer fieldwidth:40 width:widthC pos:[colB,placementPos]
		spinner slick_y "" range:[0,100,100] type:#integer fieldwidth:40 width:widthA pos:[colE,placementPos]
		spinner slick_z "" range:[0,100,100] type:#integer fieldwidth:40 width:widthA pos:[colF,placementPos]
		spinner slick_width "W, H, L:" range:[0,9999,0.2] scale:0.01 fieldwidth:40 width:widthD pos:[colA,placementPos+=21]
		spinner slick_height "" range:[0,9999,0.2] scale:0.01 fieldwidth:40 width:widthA pos:[colE,placementPos]
		spinner slick_length "" range:[0,9999,0.2] scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementPos]
		spinner slick_min_skidduration "Min/Max duration:" range:[0,9999,20] scale:0.01 fieldwidth:40 width:widthE pos:[colA,placementPos+=21]
		spinner slick_max_skidduration "" range:[0,9999,20] scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementPos]
		spinner slick_min_skidfriction "Skid Friction:" range:[0,9999,0.6] scale:0.01 fieldwidth:40 width:widthE pos:[colA,placementPos+=21]
		spinner slick_max_skidfriction "" range:[0,9999,0.6] scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementPos]
		dropdownlist slick_skidmaterial "Skidmark Material:" items:#("SKIDMARK.MAT","DESKID.MAT","GIBSMEAR.MAT","MUD1.MAT","OILSMEAR.MAT","SNOWSKID.MAT") width:widthC pos:[colD,placementPos+=21]
	groupbox connExtensions "Extensions (Unknown)" width:(width-8) height:50 pos:[4,placementPos+=52]
		spinner extensionflag "Extension Flag:" range:[0,1,0] type:#integer fieldwidth:40 width:widthF pos:[colA,placementPos+=24] enabled:false
	groupbox connPowerup "Powerup granted:" width:(width-8) height:50 pos:[4,placementPos+=30]
		spinner roomturnoncode "Powerup number:" range:[0,99,0] type:#integer fieldwidth:40 width:widthF pos:[colA,placementPos+=24]
	groupbox connRuntime "Runtime Variables:" width:(width-8) height:104 pos:[4,placementPos+=30]
		listbox runvars "" height:5 width:widthC pos:[colA,placementPos+=24]
		button runvarAdd "add runtime variable" width:widthC pos:[colD,placementPos]
		button runvarDel "remove runtime variable" width:widthC pos:[colD,placementPos+=26]
		spinner runvarMin "min/max:" range:[0,10,0] type:#integer fieldwidth:40  width:widthE pos:[colA,placementPos+=26]
		spinner runvarMax range:[0,10,0] type:#integer fieldwidth:40 width:widthA pos:[colF,placementPos]
	groupbox connAwardCode "AwardCode granted:" width:(width-8) height:112 pos:[4,placementPos+=36]
		dropdownlist awardcode_trigger "" items:#("none","singleshot","repeated","doitregardless") width:widthC pos:[colA,placementPos+=24]
		spinner awardcode_credits "Credits:" range:[0,9999,4500] type:#integer fieldwidth:40 width:widthC pos:[colD,placementPos]
		spinner awardcode_timebonus "Time Bonus:" range:[0,9999,30] type:#integer fieldwidth:40 width:widthF pos:[colA,placementPos+=21]
		spinner awardcode_message "Text Message:" range:[0,9999,1] type:#integer fieldwidth:40 width:widthF pos:[colA,placementPos+=21]
		spinner awardcode_scroller "Scroller Message:" range:[0,9999,1] type:#integer fieldwidth:40 width:widthF pos:[colA,placementPos+=21]
	label connEnd "" pos:[colA,placementPos+=21]
		
	fn updateConnotationControlStates = (
		 
		slickState = (conn.slick != "none")
		connSlick.height = if slickState then 156 else 96
		slick_x.visible = slickState
		slick_y.visible = slickState
		slick_z.visible = slickState
		slick_width.visible = slickState
		slick_height.visible = slickState
		slick_length.visible = slickState
		slick_min_skidduration.visible = slickState
		slick_max_skidduration.visible = slickState
		slick_min_skidfriction.visible = slickState
		slick_max_skidfriction.visible = slickState
		slick_skidmaterial.visible = slickState
		
		placementPos = if slickState then 272 else 212
		connExtensions.pos = [4,placementPos]
		extensionflag.pos = [colF+spCorr,placementPos+=24]
		connPowerup.pos = [4,placementPos+=30]
		roomturnoncode.pos = [colF+spCorr,placementPos+=24]
		
		connRuntime.pos = [4,placementpos+=30]
		runvars.pos = [colA,placementPos+=24]
		runvarAdd.pos = [colD,placementPos]
		runvarDel.pos = [colD,placementPos+=26]
		runvarMin.pos = [colE+spCorr,placementPos+=26]
		runvarMax.pos = [colF+spCorr,placementPos]
		runvarState = conn.runTimeVars.count > 0
		runvarMin.visible = runvarState
		runvarMax.visible = runvarState
		
		connAwardCode.pos = [4,placementPos+=30]
		awardcode_trigger.pos = [colA,placementPos+=24]
		awardcode_credits.pos = [colF+spCorr,placementPos]
		awardcode_timebonus.pos = [colF+spCorr,placementPos+=21]
		awardcode_message.pos = [colF+spCorr,placementPos+=21]
		awardcode_scroller.pos = [colF+spCorr,placementPos+=21]
		
		expandAwardCode = (conn.awardcode > 1)
		connAwardCode.height = if expandAwardCode then 112 else 53
		connEnd.pos = if expandAwardCode then (connAwardCode.Pos + [9,108]) else (connAwardCode.Pos + [9,50])
		
		awardcode_credits.visible = expandAwardCode
		awardcode_timebonus.visible = expandAwardCode
		awardcode_message.visible = expandAwardCode
		awardcode_scroller.visible = expandAwardCode
	)
	fn updateConnotationControlValues = (
		soundList.items = (conn.sounds as array)
		updatePreviewBitmap slick_material conn.slick widthA widthA
		slick_x.range.z = conn.slick_x
		slick_y.range.y = conn.slick_y
		slick_z.range.z = conn.slick_z
		slick_width.range.z = conn.slick_width
		slick_height.range.z = conn.slick_height
		slick_length.range.z = conn.slick_length
		slick_min_skidduration.range.z = conn.min_skidduration
		slick_max_skidduration.range.z = conn.max_skidduration
		slick_min_skidfriction.range.z = conn.min_skidfriction
		slick_max_skidfriction.range.z = conn.max_skidfriction
		slick_skidmaterial.selection = conn.skidmaterial
		
		extensionflag.range.z = conn.extensionflag
		roomturnoncode.range.z = conn.powerup
		runvars.items = conn.runtimevars as array
		runvar = try filterstring runvars.selected "," catch #("0","0")
		runvarMin.range.z = runvar[1] as integer
		runvarMax.range.z = runvar[2] as integer
		
		awardcode_trigger.selection = conn.awardcode
		awardcode_credits.range.z = conn.credits
		awardcode_timebonus.range.z = conn.timebonus
		awardcode_message.range.z = conn.textmessage
		awardcode_scroller.range.z = conn.scrollermessage
	)
	on connotationsSetup open do (
		connotationsSetup.height = 642
		updateConnotationControlStates()
		updateConnotationControlValues()
	)
	on soundAdd pressed do (
		s = newString "" "Enter a 4 digit sound id"
		if s!="" then (
			appendifunique conn.sounds s
			soundList.items = (conn.sounds as array)
		)
	)
	on soundDel pressed do (
		sel = soundList.selection
		if sel!=0 then (
			deleteitem conn.sounds sel
			soundList.items = (conn.sounds as array)
		)
	)
	on slick_material pressed do (
		try conn.slick = setPreviewBitmap slick_material widthA widthA catch()
		updateConnotationControlStates()
	)
	on slick_material rightclick do (
		conn.slick = "none"
		updatePreviewBitmap slick_material conn.slick widthA widthA
		updateConnotationControlStates()
	)
	on slick_x changed val do conn.slick_x = val
	on slick_y changed val do conn.slick_y = val
	on slick_z changed val do conn.slick_z = val
	on slick_width changed val do conn.slick_width = val
	on slick_height changed val do conn.slick_height = val
	on slick_length changed val do conn.slick_length = val
	on slick_min_skidduration changed val do conn.min_skidduration = val
	on slick_max_skidduration changed val do conn.max_skidduration = val
	on slick_min_skidfriction changed val do conn.min_skidfriction = val
	on slick_max_skidfriction changed val do conn.max_skidfriction = val
	on slick_skidmaterial selected i do conn.skidmaterial = i
	on roomturnoncode changed val do conn.powerup = val
	on runvars selected i do (
		runvar = try filterstring runvars.selected "," catch #("0","0")
		runvarMin.range.z = runvar[1] as integer
		runvarMax.range.z = runvar[2] as integer
	)
	on runvarAdd pressed do (
		runvar = (runvarMin.value as string)+","+(runvarMax.value as string)
		append conn.runTimeVars runvar
		runvars.items = conn.runTimeVars as array
		runvarState = conn.runTimeVars.count > 0
		runvarMin.visible = runvarState
		runvarMax.visible = runvarState
		runvars.selection = runvars.items.count
	)
	on runvarDel pressed do (
		sel = runvars.selection
		if sel!=0 then (
			deleteitem conn.runTimeVars sel
			runvars.items = conn.runTimeVars as array
			runvarState = conn.runTimeVars.count > 0
			runvarMin.visible = runvarState
			runvarMax.visible = runvarState
		)
		runvars.selection = runvars.items.count
	)
	on runvarMin changed val do (
		sel = runvars.selection
		conn.runTimeVars[sel] = (runvarMin.value as string)+","+(runvarMax.value as string)
		runvars.items = conn.runTimeVars as array
	)
	on runvarMax changed val do (
		sel = runvars.selection
		conn.runTimeVars[sel] = (runvarMin.value as string)+","+(runvarMax.value as string)
		runvars.items = conn.runTimeVars as array
	)
	on awardcode_trigger selected i do (
		conn.awardcode = i
		updateConnotationControlStates()
	)
	on awardcode_credits changed val do conn.credits = val
	on awardcode_timebonus changed val do conn.timebonus = val
	on awardcode_message changed val do conn.textmessage = val
	on awardcode_scroller changed val do conn.scrollermessage = val
	
)
--createdialog connotationsSetup width height