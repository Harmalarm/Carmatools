noncar_activation_CA = attributes noncar_activation_data
attribid:#(0x1afadfc7, 0x37c307d2)
(
	parameters noncar_activation_params
	(
		min_delay type:#float default:0
		max_delay type:#float default:0
		activation type:#integer default:1
		index  type:#integer default:-1
		min_x type:#float default:-1
		min_y type:#float default:-1
		min_z type:#float default:-1
		max_x type:#float default:1
		max_y type:#float default:1
		max_z type:#float default:1
		min_tocar  type:#float default:0
		max_tocar  type:#float default:0
		imp_velo  type:#float default:0
		rand_velo  type:#float default:0
		randup_velo  type:#float default:0
		norm_velo  type:#float default:0
		spinrate  type:#integer default:1
	)
)

--try destroydialog noncarActivationSetup catch ()
rollout noncarActivationSetup "Noncar Activation Setup:"
(
	local conn = rootnode.current_connotations
	local noncar = undefined
	group "Noncar Activations in Smashable:" (
		dotNetControl noncarList "System.Windows.Forms.ListView" width:(widthF) height:164
		button noncarAdd "Add Noncar Activation" width:widthC across:2 tooltip:"Add a noncar activations effect to the current Smashable"
		button noncarDel "Remove NoncarActivation" width:widthC tooltip:"Remove a noncar activations effect from the current Smashable"
	)
	local placementPos = 224
	groupbox noncarTiming "Timing:" width:(width-8) height:50 pos:[4,placementPos]
		spinner nonc_min_delay "Chain activation Delay:" range:[0,10,0] scale:0.01 fieldwidth:40 width:widthE pos:[colA,placementPos+=24] tooltip:"Delay before the next activation. 0,0 = instant"
		spinner nonc_max_delay range:[0,10,0] scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementPos]
	groupbox noncarActivation "Activation:" width:(width-8) height:118 pos:[4,placementPos+=30]
		spinner nonc_index "noncar index:" range:[-1,99,-1] type:#integer fieldwidth:40 width:widthF pos:[colA,placementPos+=24]
		dropdownlist nonc_activation "" items:#("absolute","relative") width:150 align:#right width:widthC pos:[colD,placementPos +=21]
		spinner nonc_min_x "1st activation area corner:" range:[-9999,9999,-10] scale:0.01 fieldwidth:40 width:widthD pos:[colA,placementPos +=26]
		spinner nonc_min_y "" range:[-9999,9999,-10] scale:0.01 fieldwidth:40 width:widthA pos:[colE,placementPos]	
		spinner nonc_min_z "" range:[-9999,9999,-10] scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementPos]
		spinner nonc_max_x "2nd activation area corner:" range:[-9999,9999,10] scale:0.01 fieldwidth:40 width:widthD pos:[colA,placementPos +=21]
		spinner nonc_max_y "" range:[-9999,9999,10] scale:0.01 fieldwidth:40 width:widthA pos:[colE,placementPos]
		spinner nonc_max_z "" range:[-9999,9999,10] scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementPos]
	groupbox noncarMovement "Movement"  width:(width-8) height:154 pos:[4,placementPos+=30]
		spinner nonc_min_tocar "min/max speed towards car:" range:[-9999,9999,0] scale:0.01 fieldwidth:40 width:widthE pos:[colA,placementPos+=24]
		spinner nonc_max_tocar range:[-9999,9999,0] scale:0.01 fieldwidth:40 width:widthA pos:[colF,placementPos]
		spinner nonc_imp_velo "Impact Velocity:" range:[0,9999,0] type:#float scale:0.01 fieldwidth:40 width:widthF pos:[colA,placementPos+=21]
		spinner nonc_rand_velo "Random Horizontal Velocity:" range:[0,9999,0] type:#float scale:0.01 fieldwidth:40 width:widthF pos:[colA,placementPos+=21]
		spinner nonc_randup_velo "Random Vertical Velocity:" range:[0,9999,0] type:#float scale:0.01 fieldwidth:40 width:widthF pos:[colA,placementPos+=21]
		spinner nonc_norm_velo "Random Normal Velocity:" range:[0,9999,0] type:#float scale:0.01 fieldwidth:40 width:widthF pos:[colA,placementPos+=21]
		spinner nonc_spinrate "spin rate:" range:[0,9999,0] type:#integer fieldwidth:40 width:widthF pos:[colA,placementPos+=21]
		
	fn updateNoncarControlStates noncar = (
		mainState = noncar!=undefined
		
		noncarTiming.visible = mainState
		nonc_min_delay.visible = mainState
		nonc_max_delay.visible = mainState
		noncarActivation.visible = mainState
		nonc_index.visible = mainState
		nonc_activation.visible = mainState
		nonc_min_x.visible = mainState
		nonc_min_y.visible = mainState
		nonc_min_z.visible = mainState
		nonc_max_x.visible = mainState
		nonc_max_y.visible = mainState
		nonc_max_z.visible = mainState
		noncarMovement.visible = mainState
		nonc_min_tocar.visible = mainState
		nonc_max_tocar.visible = mainState
		nonc_imp_velo.visible = mainState
		nonc_rand_velo.visible = mainState
		nonc_randup_velo.visible = mainState
		nonc_norm_velo.visible = mainState
		nonc_spinrate.visible = mainState
	)
	fn updateNoncarControlValues noncar = (
		if noncar!=undefined then (
			nonc_min_delay.range.z = noncar.min_delay
			nonc_max_delay.range.z = noncar.max_delay
			nonc_index.range.z = noncar.index
			
			nonc_activation.selection = noncar.activation
			nonc_min_x.range.z = noncar.min_x
			nonc_min_y.range.z = noncar.min_y
			nonc_min_z.range.z = noncar.min_z
			nonc_max_x.range.z = noncar.max_x
			nonc_max_y.range.z = noncar.max_y
			nonc_max_z.range.z = noncar.max_z

			nonc_min_tocar.range.z = noncar.min_tocar
			nonc_max_tocar.range.z = noncar.max_tocar
			nonc_imp_velo.range.z = noncar.imp_velo
			nonc_rand_velo.range.z = noncar.rand_velo
			nonc_randup_velo.range.z = noncar.randup_velo
			nonc_norm_velo.range.z = noncar.norm_velo
			nonc_spinrate.range.z = noncar.spinrate
		)
	)
	fn populateNoncarList lv = (
		noncars = conn.noncars
		lv.Clear()
		lv.tag =  dotNetMxsValue #()
		addColumns lv  #(#("Name",.5),#("Index",.2),#("Activation",.3))
		for i=1 to noncars.count do (
			m = noncars[i]
			types = #("Absolute","Relative")
			addListItem lv m #(m.index as string,types[m.activation])
		)
		lv.Update()
	)
	fn updateNoncarListSubItems item = (
		if item != undefined then (
			m = item.tag.value
			types = #("Absolute","Relative")
			updateListSubItems item #(m.index as string, types[m.activation])
			noncarList.update()
		)
	)
	
	on noncarActivationSetup open do (
		noncarActivationSetup.height = 642
		if conn != undefined then (
			initListView noncarList #(#("Name",.5),#("Index",.2),#("Activation",.3))
			noncarList.tag = dotNetMxsValue conn.noncars
			populateNoncarList noncarList
			setListViewSelection noncarList 1
				
			updateNoncarControlStates noncar
			updateNoncarControlValues noncar
		)
	)
	on noncarList SelectedIndexChanged i do (
		noncar = getListViewSelectedItem noncarList
		updateNoncarControlStates noncar
		updateNoncarControlValues noncar
	)
	on noncarList DoubleClick i do (
		noncar.name = newString noncar.name "Enter a new descriptive name:"
		updateNoncarListSubItems noncarList.selecteditems.item[0]
	)
	on noncarAdd pressed do (
		noncar = standard name:("noncar " + (conn.noncars.count as string))
		custattributes.add noncar noncar_activation_CA
		append conn.noncars noncar
		addListItem noncarList noncar #("-1","Absolute")
		setListViewSelection noncarList conn.noncars.count
	)
	on noncarDel pressed do (
		item = try noncarList.selecteditems.item[0] catch undefined
		if item!=undefined then (
			curindex = item.index
			noncar = getListViewSelectedItem noncarList
			if noncar!=undefined then (
				custattributes.delete noncar noncar_activation_CA
				deleteItem conn.noncars (curIndex+1)
				deleteListViewItem noncarList
				updateListViewColors noncarList
			)
			try setListViewSelection noncarList curIndex catch (setListViewSelection noncarList 0)
		)
	)
	on nonc_min_delay changed val do noncar.min_delay = val
	on nonc_max_delay changed val do noncar.max_delay = val
	on nonc_index changed val do (
		noncar.index = val
		updateNoncarListSubItems noncarList.selecteditems.item[0]
	)
	
	on nonc_activation selected i do (
		noncar.activation = i
		updateNoncarListSubItems noncarList.selecteditems.item[0]
	)
	on nonc_min_x changed val do noncar.min_x = val
	on nonc_min_y changed val do noncar.min_y = val
	on nonc_min_z changed val do noncar.min_z = val
	on nonc_max_x changed val do noncar.max_x = val
	on nonc_max_y changed val do noncar.max_y = val
	on nonc_max_z changed val do noncar.max_z = val

	on nonc_min_tocar changed val do noncar.min_tocar = val
	on nonc_max_tocar changed val do noncar.max_tocar = val
	on nonc_imp_velo changed val do noncar.imp_velo = val
	on nonc_rand_velo changed val do noncar.rand_velo = val
	on nonc_randup_velo changed val do noncar.randup_velo = val
	on nonc_norm_velo changed val do noncar.norm_velo = val
	on nonc_spinrate changed val do noncar.spinrate = val
	
)
--createdialog noncarActivationSetup width height