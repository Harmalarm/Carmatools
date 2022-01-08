preferences.spinnerPrecision = 4

--try destroydialog carWamSetup catch()
rollout carWamSetup "WAM Setup" (
	local listViewItemClass = dotNetclass "System.Windows.Forms.ListViewItem"
	local TreeNodeClass = dotnetclass "System.Windows.Forms.TreeNode"
	local posY = 4
	local crushEntry = undefined
	local smashEntry = undefined
	local levelEntry = undefined
	
	groupbox wamLimitsGroup "Crush Limits min/max" width:(width-8) height:106 pos:[4,posY]
		pickbutton wamLimitModel "Pick model to calculate limits" width:widthC pos:[colD,posY+=21]
		spinner limitMinX1 "left:"  range:[-999999,999999,0] type:#float scale:0.001 fieldwidth:40 width:widthB pos:[colA,posY+=21] 
		spinner limitMinX2 range:[-999999,999999,0] type:#float scale:0.001 fieldwidth:40 width:widthA pos:[colC,posY] 
		spinner limitMaxX1 "right:"range:[-999999,999999,0] type:#float scale:0.001 fieldwidth:40 width:widthB pos:[colD,posY] 
		spinner limitMaxX2 range:[-999999,999999,0] scale:0.001 type:#float fieldwidth:40 width:widthA pos:[colF,posY] 
		spinner limitMinY1 "front:" range:[-999999,999999,0] type:#float scale:0.001 fieldwidth:40 width:widthB pos:[colA,posY+=21] 
		spinner limitMinY2 range:[-999999,999999,0] type:#float scale:0.001 fieldwidth:40 width:widthA pos:[colC,posY] 
		spinner limitMaxY1 "rear:" range:[-999999,999999,0] type:#float scale:0.001 fieldwidth:40 width:widthB pos:[colD,posY] 
		spinner limitMaxY2 range:[-999999,999999,0] scale:0.001 type:#float fieldwidth:40 width:widthA pos:[colF,posY] 
		spinner limitMinZ1 "top" range:[-999999,999999,0] type:#float scale:0.001 fieldwidth:40 width:widthB pos:[colA,posY+=21] 
		spinner limitMinZ2 range:[-999999,999999,0] type:#float scale:0.001 fieldwidth:40 width:widthA pos:[colC,posY] 
		spinner limitMaxZ1 "bottom" across:2 range:[-999999,999999,0] type:#float scale:0.001 fieldwidth:40 width:widthB pos:[colD,posY] 
		spinner limitMaxZ2 range:[-999999,999999,0] scale:0.001 type:#float fieldwidth:40 width:widthA pos:[colF,posY] 
	groupbox wamGeneralGroup "General Settings:" width:(width-8) height:106 pos:[4,posY+=24]
		spinner bendabillityFactor "Bendabillity factor:" range:[0,1,1] scale:0.01 fieldwidth:40 width:widthC pos:[colD,posY+=21]
		spinner bendPointZmin "Bend point Z min/max:" range:[-999999,999999,-0.05] fieldwidth:40 scale:0.01 width:widthE pos:[colA,posY+=21]
		spinner bendPointZmax range:[-999999,999999,-0.05] scale:0.01 fieldwidth:40 width:widthA pos:[colF,posY]
		spinner snappabillityFactor "Snappabillity factor:" range:[0,1,1] scale:0.01 fieldwidth:40 width:widthC pos:[colA,posY+=21] 
		spinner ySplitPosition "Y split pos:" range:[-999999,999999,0] scale:0.01 fieldwidth:40 width:widthC pos:[colD,posY] 
		spinner driverPosX "Driver position X,Y,Z:" range:[-999999,999999,0.05] scale:0.01 fieldwidth:40 width:widthD pos:[colA,posY+=21]
		spinner driverPosY range:[-999999,999999,0.0] scale:0.01 fieldwidth:40 width:widthA pos:[colE,posY]
		spinner driverPosZ range:[-999999,999999,0.1] scale:0.01 fieldwidth:40 width:widthA pos:[colF,posY]
	
	groupbox wamEntriesGroup "Crush Data Entries:" width:(width-8) pos:[4,posY+=24] height:110
		dotNetControl wamEntriesList "System.Windows.Forms.ListView" width:(widthC-12) height:84 pos:[colA,posY+=21]
		button wamEntryAdd "Add Entry" width:widthC pos:[colD,posY-=21] tooltip:"Add selected objects from the scene"
		button wamEntryDel "Remove Entry" width:widthC pos:[colD,posY+=21] tooltip:"Remove selected objects from the list"
	groupbox wamEntryPropertiesGroup "Entry Properties" width:(width-8) pos:[4,posY+=70] height:224
		dropDownList wamSoftness "Softness:" items:#("soft", "normal", "hard", "uncrushable") default:2 width:widthB pos:[colA,posY+=21]
		dropDownList wamCrushType "Crush Type:" items:#("boring", "flap", "detach") default:1 width:widthB pos:[colC,posY]
		dropDownList wamShape "Shape:" items:#("box","sphere") width:widthB pos:[colE,posY]
		dropDownList wamdetachEase "Ease of detach:" items:#("very_easy","easy","normal","hard") width:widthB pos:[colA,posY+=42]
		dropDownList wamdetachType "Type:" items:#("normal","stubborn","fully_detach") width:widthB pos:[colC,posY]
		dropDownList wamFlapEase "Ease of flap:" items:#("very_easy","easy","normal","hard") width:widthB pos:[colA,posY]
		button wamFlapHingePoint1 "Point 1" width:widthA pos:[colC,posY+=18] tooltip:"hinge point 1"
		button wamFlapHingePoint2 "Point 2" width:widthA pos:[colD,posY] tooltip:"hinge point 2"
		button wamFlapHingePoint3 "Point 3" width:widthA pos:[colE,posY] tooltip:"shut point"
		checkbox wamFlapOpenable "Interact" width:widthA pos:[colF,posY+4] tooltip:"Check to make the flap operational by key press"
		label smashEntriesLabel "Smashables: (double click to set material and bitmap names)" width:widthF pos:[colA,posY+=30]
		dotNetControl smashEntriesList "System.Windows.Forms.TreeView" width:(widthD-12) height:84 pos:[colA,posY+=21]
		button wamSmashableAdd "Add smash" width:widthB pos:[colE,posY-=21] tooltip:"Double click list entry to change start bitmap name"
		button wamSmashableDel "Remove smash" width:widthB pos:[colE,posY+=21]
		button wamSmashLevelAdd "Add Level" width:widthB pos:[colE,posY+=21] tooltip:"Double click list entry to change level bitmap name"
		button wamSmashLevelDel "Remove Level" width:widthB pos:[colE,posY+=21]
	
	groupbox smashMaterialProperties "Material Properties:" width:(width-8) height:63 pos:[4,posY+=30]
		edittext smashStartBitmap "Start Bitmap Name:" text:"" width:widthF pos:[colA,posY+=21]
	
	groupbox smashTextureChangeLevel "Level Properties:" width:(width-8) height:63 pos:[4,posY-=21]
		button smashConnotationsEdit "Edit Connotations" width:widthC pos:[colA,posY+=21]
		spinner smashLevelThreshold "Trigger Threshold:" range:[0,1,0.0005] scale:0.0001 width:widthC fieldwidth:40 pos:[colD,posY]
		spinner smashLevelFlags "Flags:" range:[0,2,0] type:#integer width:widthC fieldwidth:40 pos:[colD,posY+=21]
	
	fn updateEntryControlStates = (
		crushState = crushEntry != undefined
		wamEntryPropertiesGroup.visible = crushState
		wamSoftNess.visible = crushState
		wamCrushType.visible = crushState
		wamEntryDel.visible = crushState
		
		flapState = false
		detachState = false
		if crushState then (
			flapState = (crushEntry.crushType == 2)
			detachState = (crushEntry.crushType == 3)
		)
		wamFlapEase.visible = flapState
		wamFlapHingePoint1.visible = wamFlapHingePoint2.visible = wamFlapHingePoint3.visible = flapState
		wamFlapOpenable.visible = flapState
		wamDetachEase.visible = detachState
		wamDetachType.visible = detachState
		
		wamShape.visible = detachState or flapState
		
		smashEntriesLabel.visible = crushState
		smashEntriesList.visible = crushState
		wamSmashableAdd.visible = crushState
	)
	
	fn updateSmashControlStates = (
		if smashEntriesList.nodes.count == 0 then (
			smashEntry = undefined
			levelEntry = undefined
		)
		crushState = crushEntry != undefined
		smashState = smashEntry != undefined
		levelState = levelEntry != undefined
		
		wamSmashableAdd.visible = crushState
		wamSmashableDel.visible = smashState
		wamSmashLevelAdd.visible = smashState
		if levelState then (
			wamSmashableAdd.visible = false
			wamSmashableDel.visible = false
			
		)
		wamSmashLevelAdd.visible = smashState
		wamSmashLevelDel.visible = levelState
		
		smashTextureChangeLevel.visible = levelState
		smashConnotationsEdit.visible = levelState
		smashLevelThreshold.visible = levelState
		smashLevelFlags.visible = levelState
		
		smashMaterialProperties.visible = smashState and not levelstate
		smashStartBitmap.visible = smashState and not levelstate

	)
	
	fn initWamEntriesList = (
		lv = wamEntriesList
		lv.multiSelect = false
		lv.backColor = dnColorWindow
		lv.View = (dotnetclass "system.windows.forms.view").details
		lv.fullRowSelect = true
		
		columnHeader = dotnetobject "system.windows.forms.columnheader"
		columnheader.text = ""
		columnheader.name = "col1"
		lv.columns.add "" (lv.width-21)
		lv.Scrollable = true;
		lv.headerStyle = (dotnetclass "system.windows.forms.ColumnHeaderStyle").none
		--lv.View = (dotnetclass "system.windows.forms.view").List
		
		rootnode.wamEntries = for wam in rootnode.wamEntries where (wam != undefined) collect wam
		entryCount = rootnode.wamEntries.count
		for i=1 to entryCount do (
			wam = rootnode.wamEntries[i]
			newItem = dotnetObject listViewItemClass wam.name
			newItem.tag = dotnetMxsValue wam
			newItem.BackColor = if ((mod i 2) == 0.0) then dnColorWindow else dnColorBackground
			newItem.UseItemStyleForSubItems=true
			lv.Items.Add newItem
		)
	)
	
	fn updateEntryControlValues = (
		if crushEntry != undefined then (
			wamSoftNess.selection = crushEntry.softness
			wamCrushType.selection = crushEntry.crushType
			wamDetachEase.selection = crushEntry.detachEase
			wamDetachType.selection = crushEntry.detachType
			wamShape.selection = crushEntry.shape
			wamFlapEase.selection = crushEntry.flapEase
			wamFlapHingePoint1.text = ("Point " + crushEntry.flapHingePoint1 as string)
			wamFlapHingePoint2.text = ("Point " + crushEntry.flapHingePoint2 as string)
			wamFlapHingePoint3.text = ("Point " + crushEntry.flapHingePoint3 as string)
			wamFlapOpenable.checked = crushEntry.flapOpenable
			
			smashEntriesList.Nodes.clear()
			for s in crushEntry.smashEntries do (
				smashNode = dotnetObject treeNodeClass s.name
				smashNode.tag = dotnetMxsValue s
				for l in s.levels do (
					levelNode = dotnetObject treeNodeClass l.name
					levelNode.tag = dotnetMxsValue l
					smashNode.Nodes.Add levelNode
				)
				smashEntriesList.Nodes.Add smashNode
			)
			smashEntriesList.ExpandAll()
		)
	)
	
	fn updateSmashLevelControlValues = (
		if levelEntry != undefined then (
			smashTextureChangeLevel.text = (levelEntry.name + " Properties:")
			smashLevelThreshold.range.z = levelEntry.threshold
			smashLevelFlags.range.z = levelEntry.flags
		)
	)
	
	on wamEntriesList SelectedIndexChanged i do (
		if wamEntriesList.selectedItems.count > 0 then (
			selectedNode = wamEntriesList.selecteditems.item[0]
			if selectedNode != undefined then (
				crushEntry = selectedNode.tag.value
				smashEntry = undefined
				levelEntry = undefined
			)
			else (
				crushEntry = undefined
				smashEntry = undefined
				levelEntry = undefined
			)
			updateEntryControlStates()
			updateEntryControlValues()
			updateSmashControlStates()
		)
	)
	
	fn updateWamControlValues = (
		limitMinX1.range.z = rootnode.xMins[1]
		limitMinX2.range.z = rootnode.xMins[2]
		limitMaxX1.range.z = rootnode.xMaxs[1]
		limitMaxX2.range.z = rootnode.xMaxs[2]
		limitMinY1.range.z = rootnode.yMins[1]
		limitMinY2.range.z = rootnode.yMins[2]
		limitMaxY1.range.z = rootnode.yMaxs[1]
		limitMaxY2.range.z = rootnode.yMaxs[2]
		limitMinZ1.range.z = rootnode.zMins[1]
		limitMinZ2.range.z = rootnode.zMins[2]
		limitMaxZ1.range.z = rootnode.zMaxs[1]
		limitMaxZ2.range.z = rootnode.zMaxs[2]
		
		bendabillityFactor.range.z = rootnode.bendabillityFactor
		bendPointZmin.range.z = rootnode.bendPointZmin
		bendPointZmax.range.z = rootnode.bendPointZmax
		snappabillityFactor.range.z = rootnode.snappabillityFactor
		ySplitPosition.range.z = rootnode.ySplitPosition
		driverPosX.range.z = rootnode.driverPos.x
		driverPosY.range.z = rootnode.driverPos.y
		driverPosZ.range.z = rootnode.driverPos.z
	)
	
	on carWamSetup open do (
		updateWamControlValues()
		wamEntriesList.HideSelection = false
		wamEntriesList.BackColor = dnColorBackground
		wamEntriesList.ForeColor = dnColorText
		initWamEntriesList()
		smashEntriesList.BackColor = dnColorBackground
		smashEntriesList.ForeColor = dnColorText
		smashEntriesList.HideSelection = false
		smashEntriesList.labeledit = true
		updateEntryControlStates()
		updateSmashControlStates()
		carWamSetup.height = posY+=24
	)
	
	on wamLimitModel picked obj do (
		if obj != undefined then (
			limit_width = obj.max.x - obj.min.x
			limit_length = obj.max.y - obj.min.y
			limit_height = obj.max.z - obj.min.z
			limitMinX1.range.z = rootnode.xMins[1] = obj.max.x-(0.1*limit_width)
			limitMinX2.range.z = rootnode.xMins[2] = obj.max.x-(0.4*limit_width)
			limitMaxX1.range.z = rootnode.xMaxs[1] = obj.min.x+(0.1*limit_width)
			limitMaxX2.range.z = rootnode.xMaxs[2] = obj.min.x+(0.4*limit_width)
			limitMinY1.range.z = rootnode.yMins[1] = obj.max.y-(0.1*limit_length)
			limitMinY2.range.z = rootnode.yMins[2] = obj.max.y-(0.4*limit_length)
			limitMaxY1.range.z = rootnode.yMaxs[1] = obj.min.y+(0.1*limit_length)
			limitMaxY2.range.z = rootnode.yMaxs[2] = obj.min.y+(0.4*limit_length)
			limitMinZ1.range.z = rootnode.zMins[1] = obj.max.z-(0.1*limit_height)
			limitMinZ2.range.z = rootnode.zMins[2] = obj.max.z-(0.4*limit_height)
			limitMaxZ1.range.z = rootnode.zMaxs[1] = obj.min.z+(0.1*limit_height)
			limitMaxZ2.range.z = rootnode.zMaxs[2] = obj.min.z+(0.4*limit_height)
		)
	)
	on limitMinX1 changed val do rootnode.xMins[1] = val
	on limitMinX2 changed val do rootnode.xMins[2] = val
	on limitMaxX1 changed val do rootnode.xMaxs[1] = val
	on limitMaxX2 changed val do rootnode.xMaxs[2] = val
	on limitMinY1 changed val do rootnode.yMins[1] = val
	on limitMinY2 changed val do rootnode.yMins[2] = val
	on limitMaxY1 changed val do rootnode.yMaxs[1] = val
	on limitMaxY2 changed val do rootnode.yMaxs[2] = val
	on limitMinZ1 changed val do rootnode.zMins[1] = val
	on limitMinZ2 changed val do rootnode.zMins[2] = val
	on limitMaxZ1 changed val do rootnode.zMaxs[1] = val
	on limitMaxZ2 changed val do rootnode.zMaxs[2] = val
		
	on bendabillityFactor changed val do rootnode.bendabillityFactor = val
	on bendPointZmin changed val do rootnode.bendPointZmin = val
	on bendPointZmax changed val do rootnode.bendPointZmax = val
	on snappabillityFactor changed val do rootnode.snappabillityFactor = val
	on ySplitPosition changed val do rootnode.ySplitPosition = val
	on driverPosX changed val do rootnode.driverPos.x = val
	on driverPosY changed val do rootnode.driverPos.y = val
	on driverPosZ changed val do rootnode.driverPos.z = val
		
	on wamSoftness selected i do crushEntry.softness = i
	on wamCrushType selected i do (
		crushEntry.crushType = i
		updateEntryControlStates()
	)
	on wamShape selected i do (
		crushEntry.shape = i
	)
	on wamDetachEase selected i do crushEntry.detachEase = i
	on wamDetachType selected i do crushEntry.detachType = i
	on wamFlapEase selected i do crushEntry.flapEase = i
	on wamFlapHingePoint1 pressed do (
		index = setCarmaVertex $ 
		crushEntry.flapHingePoint1 = index
		wamFlapHingePoint1.text = ("Point " + (index as string))
	)
	on wamFlapHingePoint2 pressed do (
		index = setCarmaVertex $ 
		crushEntry.flapHingePoint2 = index
		wamFlapHingePoint2.text = ("Point " + (index as string))
	)
	on wamFlapHingePoint3 pressed do (
		index = setCarmaVertex $ 
		crushEntry.flapHingePoint3 = index
		wamFlapHingePoint3.text = ("Point " + (index as string))
	)
	on wamFlapOpenable changed state do crushEntry.flapOpenable = state
	
	on wamEntryAdd pressed do (
		for obj in selection do (
			if finditem rootnode.wamEntries obj == 0 then (
				custAttributes.add obj wamEntryAttributes
				append rootnode.wamEntries obj
				
				newItem = dotnetObject listViewItemClass obj.name
				newItem.tag = dotnetMxsValue obj
				wamEntriesList.Items.Add newItem
				updateEntryControlStates()
			)
		)
	)
	
	on wamEntryDel pressed do (
		index = wamEntriesList.selecteditems.item[0].index
		deleteItem rootnode.wamEntries (index+1)
		custAttributes.delete crushEntry wamEntryAttributes
		crushEntry = undefined
		wamEntriesList.items.RemoveAt index
		updateEntryControlStates()
	)
	
	on smashEntriesList afterSelect do (
		selectedNode = smashEntriesList.selectedNode
		if selectedNode != undefined then (
			if selectedNode.parent == undefined then (
				smashEntry = selectedNode.tag.value
				levelEntry = undefined
				updateSmashControlStates()
				smashStartBitmap.text = smashEntry.startBitmap
			)
			else (
				smashEntry = selectedNode.parent.tag.value
				levelEntry = selectedNode.tag.value
				updateSmashControlStates()
				updateSmashLevelControlValues()
			)
		)
	)
	on smashEntriesList AfterLabelEdit txt do (
		if txt.label!=undefined then (
			selectedNode = smashEntriesList.selectedNode
			(selectedNode.tag.value).name = txt.label
			try (selectedNode.tag.value).lvl_bitmap = txt.label catch()
			if levelEntry != undefined then (
				updateSmashLevelControlValues()
			)
		)
	)
	
	on wamSmashableAdd pressed do (
		smashEntry = standard name:("Start Bitmap Name")
		custAttributes.add smashEntry Smash_CA
		append crushEntry.smashEntries smashEntry
		newNode = dotnetObject treeNodeClass smashEntry.name
		newNode.tag = dotnetMxsValue smashEntry
		smashEntriesList.Nodes.Add newNode
	)
	on wamSmashableDel pressed do (
		selectedNode = smashEntriesList.selectedNode
		if selectedNode != undefined then (
			index = smashEntriesList.selectedNode.index
			smashEntriesList.Nodes.RemoveAt (index)
			deleteItem crushEntry.smashEntries (index+1)
		)
		updateSmashControlStates()
	)
	on wamSmashLevelAdd pressed do (
		levelEntry = standard name:("Level Bitmap Name")
		custAttributes.add levelEntry textureChange_lvl_CA
		levelEntry.threshold = 0.005
		levelEntry.flags = 1
		append smashEntry.levels levelEntry
		
		conn = standard name:"Connotations"
		custattributes.add conn connotations_CA
		levelEntry.connotations = conn
		
		newNode = dotnetObject treeNodeClass levelEntry.name
		newNode.tag = dotnetMxsValue levelEntry
		smashNode = smashEntriesList.selectedNode
		if smashNode.parent != undefined then (
			smashNode = smashNode.parent
		)
		smashNode.Nodes.Addrange #(newNode)
		smashNode.expand()
		smashEntriesList.selectedNode = newNode
		updateSmashControlStates()
	)
	on wamSmashLevelDel pressed do (
		selectedNode = smashEntriesList.selectedNode
		parentNode = selectedNode.parent
		index = selectedNode.index
		parentNode.Nodes.RemoveAt index
		deleteItem smashEntry.levels (index+1)
	)
	on smashStartBitmap changed txt do (
		smashEntry.startBitmap = txt
	)
	on smashConnotationsEdit pressed do (
		conn = levelEntry.connotations
		print levelEntry
			print levelEntry.connotations
		if conn!=undefined then (
			
			rootnode.current_connotations = conn
			xpos = try ((getDialogpos carWamSetup)[1]+superwidth) catch 50
			ypos = try (getDialogpos carWamSetup)[2] catch 50
			createdialog connotationsEdit superWidth height xpos ypos  style:#(#style_titlebar, #style_border,#style_sysmenu, #style_resizing,#style_minimizebox) lockWidth:true
		)
	)
	on smashLevelThreshold changed val do levelEntry.threshold = val
	on smashLevelFlags changed val do levelEntry.flags = val
)
--createdialog carWamSetup width height 100 100