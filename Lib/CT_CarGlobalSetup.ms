--try destroydialog carGlobalSetup catch ()
rollout carGlobalSetup "Car Globals"
(
	local placementPos = 0
	local itemheight = 20
	local general = try rootnode.carGeneralData catch undefined
		
	local cameraTurnOffMat = undefined
	local cameraTurnOffBitmap = undefined
	
	local listViewItemClass = dotnetclass "System.Windows.Forms.ListViewItem"
	
	groupBox globals "Globals" pos:[4, placementPos+=4] width:(width-8) height:(itemheight*4)
		spinner softnessFactor "Softness factor:" type:#float range:[0,9999,0.7]  pos:[colA,placementPos+=itemheight] fieldwidth:40 width:widthC --controller:rootnode.carGeneralData.softnessFactor
		dropdownlist stealWorthyNess items:#("stealworthy","unstealable") pos:[colB,placementPos+itemheight] fieldwidth:40 width:widthB
		spinner engineSoundNormal "Normal engine noise:" type:#integer range:[0,9999,3500] pos:[colD,placementPos] fieldwidth:40 width:widthC
		spinner engineSoundTunnel "Tunnel engine noise:" type:#integer range:[0,9999,3501] pos:[colD,placementPos+=itemheight] fieldwidth:40 width:widthC
		spinner engineSoundUnderwater "Underwater noise:" type:#integer range:[0,9999,3502] pos:[colD,placementPos+=itemheight] fieldwidth:40 width:widthC
	groupbox drivableStuff "Drivable Stuff" pos:[4,placementPos+=itemheight] width:(width-8) height:(itemheight*5)
		spinner headPosX "Driver head position:" type:#float scale:0.001 range:[-9999,9999,0] pos:[colB,placementPos+=itemheight] fieldwidth:40 width:widthC
		spinner headPosY ""  type:#float scale:0.001 range:[-9999,9999,0] pos:[colE,placementPos] fieldwidth:40 width:widthA
		spinner headPosZ "" type:#float scale:0.001 range:[-9999,9999,0] pos:[colF,placementPos] fieldwidth:40 width:widthA
		spinner headAngleX "Driver head angles:" type:#float scale:0.001 range:[-9999,9999,0] pos:[colC,placementPos+=itemheight] fieldwidth:40 width:widthC
		spinner headAngley type:#float scale:0.001 range:[-9999,9999,0] pos:[colF,placementPos] fieldwidth:40 width:widthA
		spinner mirrorPosX "Mirror position:" type:#float scale:0.001 range:[-9999,9999,0] pos:[colB,placementPos+=itemheight] fieldwidth:40 width:widthC
		spinner mirrorPosY "" type:#float scale:0.001 range:[-9999,9999,0] pos:[colE,placementPos] fieldwidth:40 width:widthA
		spinner mirrorPosZ "" type:#float scale:0.001 range:[-9999,9999,0] pos:[colF,placementPos] fieldwidth:40 width:widthA
		spinner mirrorAngle "Mirror angle:" type:#float scale:0.001 range:[-9999,9999,0] pos:[colD,placementPos+=itemheight] fieldwidth:40 width:widthC
	groupbox cameraPositions "Camera Positions" pos:[4,placementPos+=21] width:(width-8) height:(itemheight*3)
		spinner cameraPosBumperX "Bumper Camera X,Y,Z:" type:#float scale:0.001 range:[-9999,9999,0] pos:[colB,placementPos+=itemheight] fieldwidth:40 width:widthC
		spinner cameraPosBumperY "" type:#float scale:0.001 range:[-9999,9999,0] pos:[colE,placementPos] fieldwidth:40 width:widthA
		spinner cameraPosBumperZ "" type:#float scale:0.001 range:[-9999,9999,0] pos:[colF,placementPos] fieldwidth:40 width:widthA
		spinner cameraPosCockpitX "Cockpit Camera X,Y,Z:" type:#float scale:0.001 range:[-9999,9999,0] pos:[colB,placementPos+=itemheight] fieldwidth:40 width:widthC
		spinner cameraPosCockpitY "" type:#float scale:0.001 range:[-9999,9999,0] pos:[colE,placementPos] fieldwidth:40 width:widthA
		spinner cameraPosCockpitZ "" type:#float scale:0.001 range:[-9999,9999,0] pos:[colF,placementPos] fieldwidth:40 width:widthA
	groupbox shrapnels "Shrapnel Colors"  pos:[4,placementPos+=itemheight] width:(width-8) height:(itemheight*4)
		dotnetControl shrapnelColorList "System.Windows.Forms.ListView" height:55 width:widthC pos:[colA,placementPos+=itemheight]
		button colorAdd "Add color" width:widthB pos:[colE,placementPos-=21]
		button matNameAdd "Add Mat Name" width:widthB pos:[colE,placementPos+=21]
		fn initShrapnelColorList = 
		(
			lv = shrapnelColorList
			lv.View = (dotnetclass "system.windows.forms.view").details
			lv.gridLines = false
			lv.fullRowSelect = true
			lv.multiSelect = false
		
			lv.headerstyle = (dotnetclass "system.windows.forms.ColumnHeaderStyle").none
			lv.borderstyle = (dotnetclass "system.windows.forms.Borderstyle").Fixed3D --fixedSingle
			lv.backColor = dnColorWindow
			lv.columns.add "Colors" (shrapnelColorList.width - 26)
			
			for col in rootnode.shrapnelColors do (
				maxColor = try execute col catch undefined
				if classof maxColor == color then (
					li = dotNetObject listViewItemClass ""
					li.BackColor = (dnColor c:[maxColor.r,maxColor.g,maxColor.b])
					lv.items.addRange #(li)
				)
				else (
					li = dotNetObject listViewItemClass col
					li.ForeColor = dnColorText
					lv.items.addRange #(li)
				)
			)
		)
	groupbox boundingShapesGroup "Bounding Shapes" pos:[4,placementPos+=42] width:(width-8) height:(itemheight*5)
		listbox boundingShapes height:5 pos:[colA,placementPos+=itemheight] width:widthC
		pickbutton boundingShapeAdd "Pick shape" width:widthB pos:[colE, placementPos] autodisplay:false 
		button boundingShapeDel "Remove" width:widthB pos:[colE,placementPos+=itemheight]
		dropdownlist boundingShapeType "Use shape as:" items:#("Polyhedron","Box", "Sphere","Wire frame") width:widthB pos:[colE, placementPos+=itemheight] enabled:false
	groupbox FirePoints "Fire Points (click to set mainmodel selected vertex, rightclick to reset)" pos:[4,placementpos+=(itemheight*2)] width:(width-8) height:(itemheight*5)
		button fp_eng "Engine: 1" tooltip:"set selected vertex" width:widthB pos:[colA,placementPos+=itemheight]
		button fp_tsm "Transmission: 1" tooltip:"set selected vertex" width:widthB pos:[colC,placementPos]
		button fp_driver "Driver: 1" tooltip:"set selected vertex" width:widthB pos:[colE,placementPos]
		button fp_steer "Steering: 1" tooltip:"set selected vertex" width:widthB pos:[colA,placementPos+=itemheight]
		button fp_flbr "fl brake: 1" tooltip:"set selected vertex" width:widthB fieldwidth:40 pos:[colC,placementPos]
		button fp_frbr "fr brake: 1" tooltip:"set selected vertex" width:widthB fieldwidth:40 pos:[colE,placementPos]
		button fp_rlbr "rl brake: 1" tooltip:"set selected vertex" width:widthB fieldwidth:40 pos:[colA,placementPos+=itemheight]
		button fp_rrbr "rr brake: 1" tooltip:"set selected vertex" width:widthB fieldwidth:40 pos:[colC,placementPos]
		button fp_flwhl "fl wheel: 1" tooltip:"set selected vertex" width:widthB fieldwidth:40 pos:[colE,placementPos]
		button fp_frwhl "fr wheel 1:" tooltip:"set selected vertex" width:widthB fieldwidth:40 pos:[colA,placementPos+=itemheight]
		button fp_rlwhl "rl wheel 1:" tooltip:"set selected vertex" width:widthB fieldwidth:40 pos:[colC,placementPos]
		button fp_rrwhl "rr wheel: 1" tooltip:"set selected vertex" width:widthB fieldwidth:40 pos:[colE,placementPos]
	groupbox cameraTurnOffMatsGroup "Camera turn off materials: (double click to rename)" width:(width-8) pos:[4,placementpos+=21] height:136
		local TreeNodeClass = dotnetclass "System.Windows.Forms.TreeNode" 
		dotNetControl cameraTurnOffMatsList "system.windows.forms.treeView" height:110 width:widthC pos:[colA,placementPos+=21]
		button turnOffMatAdd "Add Material" width:widthB pos:[colD+6,placementPos-=21]
		button turnOffMatDel "Remove Material" width:widthB pos:[colD+6,placementPos+=21]
		groupbox turnOffMatBitmaps "Bitmap Control" width:widthC pos:[colD+6,placementPos+=21] height:68
		button bitmapAdd "Add bitmap" width:widthB pos:[colE,placementPos+=21]
		button bitmapDel "Remove bitmap" width:widthB pos:[colE,placementPos+=21]
	label endlabel "" pos:[colA,placementPos+=10]
	
		
	fn cleanBoundingShapes = (
		correctShapes = #()
		for s in general.boundingShapes do (
			if s!=undefined then (
				if hasAttribute s boundingShapeAttributes then append correctShapes s
			)
		)
		general.boundingShapes = correctShapes
		boundingShapes.items = for s in general.boundingShapes collect s.name
	)

	fn setBoundingShapeSelection i = (
		if i!=0 and i <= general.boundingShapes.count then (
			boundingShapes.selection = i
			boundingShape = general.boundingShapes[i]
			boundingShapeType.enabled = true
			boundingShapeType.selection = boundingShape.boundingShapeType 
		)
		else (
			boundingShapeType.enabled = false
			boundingShapeType.selection = 1
		)
	)
	
	fn updateCameraTurnOffMatsList = (
		for mat in rootnode.cameraTurnOffMats do (
			if hasAttribute mat cameraTurnOffMatAttributes then (
				matNode = dotnetObject treeNodeClass mat.name
				matNode.tag = dotnetMxsValue mat
				for bm in mat.cameraTurnOffBitmaps do (
					bmNode = dotnetObject treeNodeClass bm
					matNode.Nodes.Addrange #(bmNode)
				)
				cameraTurnOffMatsList.Nodes.Add matNode
			)
		)
	)
	
	fn updateControlValues = (
		general = rootnode.carGeneralData
		softnessFactor.range.z = general.softnessFactor
		engineSoundNormal.range.z = general.engineSoundNormal
		engineSoundTunnel.range.z = general.engineSoundTunnel
		engineSoundUnderwater.range.z = general.engineSoundUnderwater
		stealWorthyness.selection = general.stealWorthyness
		
		headPosX.range.z = general.headPos.x
		headPosY.range.z = -general.headPos.z
		headPosZ.range.z = general.headPos.y
		headAngleX.range.z = general.headAngles.x
		headAngleY.range.z = general.headAngles.y
		mirrorPosX.range.z = general.mirrorPos.x
		mirrorPosY.range.z = -general.mirrorPos.z
		mirrorPosZ.range.z = general.mirrorPos.y
		mirrorAngle.range.z = general.mirrorAngle
		
		cameraPosBumperX.range.z = general.cameraPosBumper.x
		cameraPosBumperY.range.z = -general.cameraPosBumper.z
		cameraPosBumperZ.range.z = general.cameraPosBumper.y
		cameraPosCockpitX.range.z = general.cameraPosCockpit.x
		cameraPosCockpitY.range.z = -general.cameraPosCockpit.z
		cameraPosCockpitZ.range.z = general.cameraPosCockpit.y
		
		--shrapnelColors.items = for c in general.shrapnelColors collect c
		--shrapnelColorSelector.color = try (execute shrapnelColors.selected) catch(color 255 255 255)
		
		cleanBoundingShapes()
		setBoundingShapeSelection general.boundingShapes.count
		boundingShapes.items = for s in general.boundingShapes collect s.name
		
		fp_eng.text = "Engine: "+ (general.firePoints[1] as string)
		fp_tsm.text = "Transmission: "+(general.firePoints[2] as string)
		fp_driver.text = "Driver: "+(general.firePoints[3] as string)
		fp_steer.text = "Steering: "+(general.firePoints[4] as string)
		fp_flbr.text = "fl brake: "+(general.firePoints[5] as string)
		fp_frbr.text = "fr brake: "+(general.firePoints[6] as string)
		fp_rlbr.text = "rl brake: "+(general.firePoints[7] as string)
		fp_rrbr.text = "rr brake: "+(general.firePoints[8] as string)
		fp_flwhl.text = "fl wheel: "+(general.firePoints[9] as string)
		fp_frwhl.text = "fr wheel: "+(general.firePoints[10] as string)
		fp_rlwhl.text = "rl wheel: "+(general.firePoints[11] as string)
		fp_rrwhl.text = "rr wheel: "+(general.firePoints[12] as string)
		
		updateCameraTurnOffMatsList()
	)		
	
	on carGlobalSetup open do (
		cameraTurnOffMatsList.HideSelection = false
		cameraTurnOffMatsList.BackColor = dnColorBackground
		cameraTurnOffMatsList.ForeColor = dnColorText
		cameraTurnOffMatsList.labeledit = true
		
		initShrapnelColorList()
		
		updateControlValues()
		carGlobalSetup.height = placementPos+itemheight+4	
	)
	on softnessFactor changed val do general.softnessFactor = val
	on engineSoundNormal changed val do general.engineSoundNormal = val
	on engineSoundTunnel changed val do general.engineSoundTunnel = val
	on engineSoundUnderwater changed val do general.engineSoundUnderwater = val
	on stealWorthyNess selected sel do general.stealWorthyness = sel
		
	on headPosX changed val do general.headPos.x = val
	on headPosY changed val do general.headPos.z = -val
	on headPosZ changed val do general.headPos.y = val
	on headAngleX changed val do general.headAngles.x = val
	on headAngleY changed val do general.headAngles.y = val
	on mirrorPosX changed val do general.mirrorPos.x = val
	on mirrorPosY changed val do general.mirrorPos.z = -val
	on mirrorPosZ changed val do general.mirrorPos.y = val
	on mirrorAngle changed val do general.mirrorAngle = val
		
	on cameraPosBumperX changed val do general.cameraPosBumper.x = val
	on cameraPosBumperY changed val do general.cameraPosBumper.z = -val
	on cameraPosBumperZ changed val do general.cameraPosBumper.y = val
	on cameraPosCockpitX changed val do general.cameraPosCockpit.x = val
	on cameraPosCockpitY changed val do general.cameraPosCockpit.z = -val
	on cameraPosCockpitZ changed val do general.cameraPosCockpit.y = val
	
	on shrapnelColorList MouseClick arg do (
		listItem =  shrapnelColorList.GetItemAt arg.x arg.y
		if listItem != undefined then (
			if arg.button==arg.Button.Left then (
				col = rootnode.shrapnelColors[listItem.index+1]
				maxColor = try execute col catch undefined
				if classof maxColor == color then (
					newColor = colorPickerDlg maxColor "Pick a color" alpha:false
					if newColor != undefined then (
						listItem.BackColor = dnColor c:[newColor.r,newColor.g,newColor.b]
						rootnode.shrapnelColors[listItem.index+1] = (newColor as string)
					)
				)
				else (
					newColor = newString col "Enter a new .MAT name:"
					if newColor != undefined then (
						rootnode.shrapnelColors[listItem.index+1] = (newColor as string)
					)
				)
			)
			if arg.button==arg.button.right then (
				deleteItem rootnode.shrapnelColors (listItem.index+1)
				shrapnelColorList.Items.Remove(listItem)
			)
		)
	)
	
	on colorAdd pressed do (
		newColor = colorPickerDlg (color 128 128 128) "Pick a color" alpha:false
		if newColor != undefined then (
			listItem = dotNetObject listViewItemClass ""
			listItem.BackColor = dnColor c:[newColor.r,newColor.g,newColor.b]
			shrapnelColorList.items.addRange #(listItem)
			append rootnode.shrapnelColors (newColor as string)
		)
	)
	on matNameAdd pressed do (
		newColor = newString "*.MAT" "Enter a new .MAT name:"
		if newColor != undefined then (
			listItem = dotNetObject listViewItemClass newColor
			listItem.ForeColor = dnColorText
			shrapnelColorList.items.addRange #(listItem)
			append rootnode.shrapnelColors (newColor as string)
		)
	)
	/*
	on shrapnelColors selected i do (
		shrapnelColorSelector.color = try (execute shrapnelColors.selected) catch (color 255 255 255)
	)
	on shrapnelColorSelector changed col do (
		sel = shrapnelColors.selection
		if sel != 0 then (
			shrapnelColors.items[sel] = col as string
			shrapnelColors.items = shrapnelColors.items
			general.shrapnelColors = shrapnelColors.items
		)
	)
	on shrapnelColorAdd pressed do (
		newColor = color 255 255 255
		shrapnelColorSelector.color = newColor
		shrapnelColors.items = join shrapnelColors.items #(newColor as string)
		general.shrapnelColors = shrapnelColors.items
	)
	on shrapnelColorDel pressed do (
		sel = shrapnelColors.selection
		if sel != 0 then (
			shrapnelColors.items = deleteitem shrapnelColors.items sel
			general.shrapnelColors = shrapnelColors.items
			shrapnelColorSelector.color = color 255 255 255
		)
	)
	*/
	on boundingShapeAdd picked obj do (
		if obj!=undefined then (
			custattributes.add obj boundingShapeAttributes
			appendifunique general.boundingShapes obj
			cleanBoundingShapes()
			setBoundingShapeSelection general.boundingShapes.count
		)
	)
	on boundingShapes selected i do (
		setBoundingShapeSelection i
	)
	on boundingShapeDel pressed do (
		sel = boundingShapes.selection
		if sel != 0 then (
			boundingShape = general.boundingShapes[sel]
			custattributes.delete boundingShape 1
			deleteitem general.boundingShapes sel
			cleanBoundingShapes()
			setBoundingShapeSelection sel
		)
	)
	on boundingShapeType selected i do (
		sel = boundingShapes.selection
		boundingShape = general.boundingShapes[sel]
		boundingShape.boundingShapeType = i
	)
	on fp_eng pressed do (
		index = setCarmaVertex $; general.firePoints[1] = index; fp_eng.text = ("Engine: " + (index as string))
	)
	on fp_eng rightclick do (
		general.firePoints[1] = 1; fp_eng.text = ("Engine: 1")
	)
	on fp_tsm pressed do (
		index = setCarmaVertex $; general.firePoints[2] = index; fp_tsm.text = ("Transmission: " + (index as string))
	)
	on fp_tsm rightclick do (
		general.firePoints[2] = 1; fp_tsm.text = ("Transmission: 1")
	)
	on fp_driver pressed do (
		index = setCarmaVertex $; general.firePoints[3] = index; fp_driver.text = ("Driver: " + (index as string))
	)
	on fp_driver rightclick do (
		general.firePoints[3] = 1; fp_driver.text = ("Driver: 1")
	)
	on fp_steer pressed do (
		index = setCarmaVertex $; general.firePoints[4] = index; fp_steer.text = ("Steering: " + (index as string))
	)
	on fp_steer rightclick do (
		general.firePoints[4] = 1; fp_steer.text = ("Steering: 1")
	)
	on fp_flbr pressed do (
		index = setCarmaVertex $; general.firePoints[5] = index; fp_flbr.text = ("fl brake: " + (index as string))
	)
	on fp_flbr rightclick do (
		general.firePoints[5] = 1; fp_flbr.text = ("fl brake: 1")
	)
	on fp_frbr pressed do (
		index = setCarmaVertex $; general.firePoints[6] = index; fp_frbr.text = ("fr brake: " + (index as string))
	)
	on fp_frbr rightclick do (
		general.firePoints[6] = 1; fp_frbr.text = ("fr brake: 1")
	)
	on fp_rlbr pressed do (
		index = setCarmaVertex $; general.firePoints[7] = index; fp_rlbr.text = ("rl brake: " + (index as string))
	)
	on fp_rlbr rightclick do (
		general.firePoints[7] = 1; fp_rlbr.text = ("rl brake: 1")
	)
	on fp_rrbr pressed do (
		index = setCarmaVertex $; general.firePoints[8] = index; fp_rrbr.text = ("rr brake: " + (index as string))
	)
	on fp_rrbr rightclick do (
		general.firePoints[8] = 1; fp_rrbr.text = ("rr brake: 1")
	)
	on fp_flwhl pressed do (
		index = setCarmaVertex $; general.firePoints[9] = index; fp_flwhl.text = ("fl wheel: " + (index as string))
	)
	on fp_flwhl rightclick do (
		general.firePoints[9] = 1; fp_flwhl.text = ("fl wheel: 1")
	)
	on fp_frwhl pressed do (
		index = setCarmaVertex $; general.firePoints[10] = index; fp_frwhl.text = ("fr wheel: " + (index as string))
	)
	on fp_frwhl rightclick do (
		general.firePoints[10] = 1; fp_frwhl.text = ("fr wheel: 1")
	)
	on fp_rlwhl pressed do (
		index = setCarmaVertex $; general.firePoints[11] = index; fp_rlwhl.text = ("rl wheel: " + (index as string))
	)
	on fp_rlwhl rightclick do (
		general.firePoints[11] = 1; fp_rlwhl.text = ("rl wheel: 1")
	)
	on fp_rrwhl pressed do (
		index = setCarmaVertex $; general.firePoints[12] = index; fp_rrwhl.text = ("rr wheel: " + (index as string))
	)
	on fp_rrwhl rightclick do (
		general.firePoints[12] = 1; fp_rrwhl.text = ("rr wheel: 1")
	)
	
	on cameraTurnOffMatsList AfterSelect do (
		selectedNode =  cameraTurnOffMatsList.selectedNode
		if selectedNode != undefined then (
			parentNode = selectedNode.parent
			if parentNode != undefined then (
				cameraTurnOffBitmap = (selectedNode.index + 1)
				cameraTurnOffMat = parentNode
				turnOffMatAdd.enabled = true
				turnOffMatDel.enabled = false
				bitmapAdd.enabled = false
				bitmapDel.enabled = true
			)
			else (
				cameraTurnOffMat = selectedNode
				turnOffMatAdd.enabled = true
				turnOffMatDel.enabled = true
				bitmapAdd.enabled = true
				bitmapDel.enabled = false
			)
		)
	)
	
	on cameraTurnOffMatsList AfterLabelEdit txt do (
		if txt.label!=undefined then (
			selectedNode = cameraTurnOffMatsList.selectedNode
			try (
				(selectedNode.tag.value).name = txt.label
			)
			catch (
				index = selectedNode.index
				(cameraTurnOffMat.tag.value).cameraTurnOffBitmaps[index+1] = txt.label
			)
		)
	)
	
	on turnOffMatAdd pressed do (
		newMat = standard name:"Material Name"
		custattributes.add newMat cameraTurnOffMatAttributes
		append rootnode.cameraTurnOffMats newMat
		matNode = dotnetObject treeNodeClass newMat.name
		matNode.tag = dotnetMxsValue newMat
		cameraTurnOffMatsList.Nodes.Add matNode
	)
	on turnOffMatDel pressed do (
		index = cameraTurnOffMat.index
		deleteitem rootnode.cameraTurnOffMats (index+1)
		cameraTurnOffMatsList.Nodes.RemoveAt (index)
	)
	
	on bitmapAdd pressed do (
		newBitmap = "Bitmap Name"
		newNode = dotnetObject treeNodeClass newBitmap
		cameraTurnOffMat.Nodes.addRange #(newNode)
		append (cameraTurnOffMat.tag.value.cameraTurnOffBitmaps) newBitmap
	)
	on bitmapDel pressed do (
		selectedNode = cameraTurnOffMatsList.selectedNode
		index = selectedNode.index
		deleteItem (cameraTurnOffMat.tag.value).cameraTurnOffBitmaps (index+1)
		cameraTurnOffMat.Nodes.RemoveAt (index)
	)
)
--createdialog carGlobalSetup width height 50 50
