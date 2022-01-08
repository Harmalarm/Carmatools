sideEffect_CA = attributes sideEffect_data
attribid:#(0x7347c940, 0x77470657)
(
	parameters sideEffect_params
	(
		min_seff_delay type:#float default:0
		max_seff_delay type:#float default:0
		activation type:#integer default:2
		seff_name type:#string default:"*.DAT"
		seff_min_x type:#float default:-1.5
		seff_min_y type:#float default:-1.5
		seff_min_z type:#float default:-1.5
		seff_max_x type:#float default:1.5
		seff_max_y type:#float default:1.5
		seff_max_z type:#float default:1.5
		seff_direction type:#integer default:2
		seff_force type:#float default:4.4
	)
)

--try destroydialog sideEffectSetup catch()
rollout sideEffectSetup "Side Effect Properties" 
(
	local count = 0
	local conn = rootnode.current_connotations
	local sideEffect = undefined
	group "Side Effects in Smashable:" (
		dotNetControl sideEffectList "System.Windows.Forms.ListView" width:(widthF) height:164
		button sideEffectAdd "Add Side Effect" width:widthC across:2 tooltip:"Add a side effect to the current Smashable"
		button sideEffectDel "Remove Side Effect" width:widthC tooltip:"Remove a side effect from the current Smashable"
	)
	local placementPos = 224
	groupbox sideEffectTiming "Timing:" width:(width-8) height:50 pos:[4,placementPos]
		spinner min_seff_delay "Min/Max start delay:" range:[0,10,1] scale:0.01 fieldwidth:40 width:widthE pos:[colA,placementPos+=24]
		spinner max_seff_delay range:[0,10,1] scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementPos]
	groupbox placementActivation "Activation" width:(width-8) height:122 pos:[4,placementPos+=30]
		dropdownlist seff_activation "" items:#("absolute","relative") width:widthC pos:[colD,placementPos+=24]
		edittext seff_name "Modelname:" text:"*.DAT" fieldwidth:widthC autoDisplay:true pos:[colC-12,placementPos+=26]
		spinner seff_min_x "1st activation area corner:" range:[-9999,9999,-1.5] scale:0.01 fieldwidth:40 width:widthD pos:[colA,placementPos+=24]
		spinner seff_min_y "" range:[-9999,9999,-1.5] scale:0.01 fieldwidth:40 width:widthA pos:[colE,placementPos]	
		spinner seff_min_z "" range:[-9999,9999,-1.5] scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementPos]
		spinner seff_max_x "2nd activation area corner:" range:[-9999,9999,1.5] scale:0.01 fieldwidth:40 width:widthD pos:[colA,placementPos+=24]
		spinner seff_max_y "" range:[-9999,9999,1.5] scale:0.01 fieldwidth:40 width:widthA pos:[colE,placementPos]	
		spinner seff_max_z "" range:[-9999,9999,1.5] scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementPos]
	groupbox sideEffectMovement "Movement:" width:(width-8) height:74 pos:[4,placementPos+=30]
		dropdownlist seff_direction "" items:#("toward","away") selection:2 width:widthC pos:[colD,placementPos+=24]
		spinner seff_force "created force:" range:[0,9999,4.4] range:[0,0,0] type:#float scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementPos+=26]
	
	fn updateSideEffectControlStates sideEffect = (
		mainState = sideEffect != undefined
		
		sideEffectTiming.visible = mainState
		min_seff_delay.visible = mainState
		max_seff_delay.visible = mainState
		placementActivation.visible = mainState
		seff_activation.visible = mainState
		seff_name.visible = mainState
		seff_min_x.visible = mainState
		seff_min_y.visible = mainState
		seff_min_z.visible = mainState
		seff_max_x.visible = mainState
		seff_max_y.visible = mainState
		seff_max_z.visible = mainState
		sideEffectMovement.visible = mainState
		seff_direction.visible = mainState
		seff_force.visible = mainState
	)
	fn updateSideEffectControlValues sideEffect = (
		if sideEffect!= undefined then (
			min_seff_delay.range.z = sideEffect.min_seff_delay
			max_seff_delay.range.z = sideEffect.max_seff_delay
			seff_activation.selection = sideEffect.activation
			seff_name.text = sideEffect.seff_name
			seff_min_x.range.z = sideEffect.seff_min_x
			seff_min_y.range.z = sideEffect.seff_min_y
			seff_min_z.range.z = sideEffect.seff_min_z
			seff_max_x.range.z = sideEffect.seff_max_x
			seff_max_y.range.z = sideEffect.seff_max_y
			seff_max_z.range.z = sideEffect.seff_max_z
			seff_direction.selection = sideEffect.seff_direction
			seff_force.range.z = sideEffect.seff_force
		)
	)
	fn populateSideEffectList lv = (
		sideEffects = conn.sideEffects
		lv.Clear()
		lv.tag =  dotNetMxsValue #()
		addColumns lv #(#("Name",.4),#("Activation",.3),#("Direction",.3))
		for i=1 to sideEffects.count do (
			m = sideEffects[i]
			activations = #("Absolute","Relative")
			directions = #("Toward","Away")
			addListItem lv m #(activations[m.activation],directions[m.seff_direction])
		)
		lv.Update()
	)
	fn updateSideEffectListSubItems item = (
		if item != undefined then (
			m = item.tag.value
			activations = #("Absolute","Relative")
			directions = #("Toward","Away")
			updateListSubItems item #(activations[m.activation],directions[m.seff_direction])
			sideEffectList.update()
		)
	)
	on sideEffectSetup open do (
		sideEffectSetup.height = 642
		if conn != undefined then (
			initListView sideEffectList #(#("Name",.4),#("Activation",.3),#("Direction",.3))
			sideEffectList.tag = dotNetMxsValue conn.sideEffects
			populateSideEffectList sideEffectList
			setListViewSelection sideEffectList 1
				
			updateSideEffectControlStates sideEffect
			updateSideEffectControlValues sideEffect
		)
	)
	on sideEffectAdd pressed do (
		sideEffect = standard name:("Side Effect " + (conn.sideEffects.count as string))
		custattributes.add sideEffect sideEffect_CA
		append conn.sideEffects sideEffect
		addListItem sideEffectList sideEffect #("Relative","Away")
		setListViewSelection sideEffectList conn.sideEffects.count
	)
	on sideEffectDel pressed do (
		item = try sideEffectList.selecteditems.item[0] catch undefined
		if item!=undefined then (
			curindex = item.index
			shrapnel = getListViewSelectedItem sideEffectList
			if shrapnel!=undefined then (
				custattributes.delete sideEffect sideEffect_CA
				deleteItem conn.sideEffects (curIndex+1)
				deleteListViewItem sideEffectList
				updateListViewColors sideEffectList
			)
			try setListViewSelection sideEffectList curIndex catch (setListViewSelection sideEffectList 0)
		)
	)
	on sideEffectList SelectedIndexChanged i do (
		sideEffect = getListViewSelectedItem sideEffectList
		updateSideEffectControlStates sideEffect
		updateSideEffectControlValues sideEffect
	)
	on min_seff_delay changed val do sideEffect.min_seff_delay = val
	on max_seff_delay changed val do sideEffect.max_seff_delay = val
	on seff_activation selected i do (
		sideEffect.activation = i
		updateSideEffectListSubItems sideEffectList.selecteditems.item[0]
	)
	on seff_name entered txt do sideEffect.seff_name = txt
	on seff_min_x changed val do sideEffect.seff_min_x = val
	on seff_min_y changed val do sideEffect.seff_min_y = val
	on seff_min_z changed val do sideEffect.seff_min_z = val
	on seff_max_x changed val do sideEffect.seff_max_x = val
	on seff_max_y changed val do sideEffect.seff_max_y = val
	on seff_max_z changed val do sideEffect.seff_max_z = val
	on seff_direction selected i do (
		sideEffect.seff_direction = i
		updateSideEffectListSubItems sideEffectList.selecteditems.item[0]
	)
	on seff_force changed val do sideEffect.seff_force = val
)
--createdialog sideEffectSetup width height