--try destroydialog damageInfo catch()
rollout damageInfo "Damage Info" (
	local TreeNodeClass = dotnetclass "System.Windows.Forms.TreeNode"
	local placementPos = 4
	
	local damageImpact = undefined
	local damageClause = undefined
	local damageSystem = undefined
	
	groupbox damageInfoGroup "Impacts Overview" width:(width-8) height:330 pos:[4,placementPos]
	dotNetControl damageInfoTree "system.windows.forms.treeView" height:300 width:widthC pos:[colA,placementPos+=21]
	button damageClauseAdd "Add Clause" width:widthC pos:[colD,placementPos-=21] enabled:false
	button damageClauseDel "Remove Clause" width:widthC pos:[colD,placementPos+=21] enabled:false
	groupBox damageClauseProperties "Clause Properties:" width:widthC pos:[colD,placementPos+=42] height:90
	edittext damageClauseCondition "Rule:" width:(widthC-10) pos:[colD+5,placementPos+=21] enabled:false
	button damageSystemAdd "Add System" width:(widthC-10) pos:[colD+5,placementPos+=23] enabled:false
	button damageSystemDel "Remove System" width:(widthC-10) pos:[colD+5,placementPos+=21] enabled:false
	groupBox damageSystemProperties "System Properties:" width:widthC pos:[colD,placementPos+=42] height:85
	dropdownlist damageSystemID "ID:" items:#("engine","transmission","driver","steering","lf_wheel","rf_wheel","lr_wheel","rr_wheel","lf_brake","rf_brake","lr_brake","rr_brake") width:(widthC-10) pos:[colD+5,placementPos+=21] enabled:false
	spinner damageSystemValue "Value:" range:[-9999,9999,0.25] scale:0.01 fieldWidth:40 width:(widthC-10) pos:[colD+5,placementPos+=42] enabled:false
	
	button damageDefaults "Reset to Eagle default" width:(widthC-10) pos:[colD+5,placementPos+=48]
	
	fn buildDamageInfoTree = (
		--top impacts
		impact = standard name:"Top"
		custAttributes.add impact damageInfoImpactAttributes
		rootnode.damageInfo[1] = impact
		
		clause = standard name:"always"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(3)
		clause.damageValues = #(1.5)
		append impact.damageClauses clause
		
		--bottom impacts
		impact = standard name:"Bottom"
		custAttributes.add impact damageInfoImpactAttributes
		rootnode.damageInfo[2] = impact
		
		clause = standard name:"always"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(2)
		clause.damageValues = #(0.2)
		append impact.damageClauses clause
		
		clause = standard name:"z<0.25&x<0.25"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(5,9,4)
		clause.damageValues = #(0.5,0.5,0.2)
		append impact.damageClauses clause
		
		clause = standard name:"z<0.25&x>0.75"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(6,10,4)
		clause.damageValues = #(0.5,0.5,0.2)
		append impact.damageClauses clause
		
		clause = standard name:"z>0.75&x<0.25"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(7,11)
		clause.damageValues = #(0.5,0.5)
		append impact.damageClauses clause
		
		clause = standard name:"z>0.75&x>0.75"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(8,12)
		clause.damageValues = #(0.5,0.5)
		append impact.damageClauses clause
		
		--left impacts
		impact = standard name:"Left"
		custAttributes.add impact damageInfoImpactAttributes
		rootnode.damageInfo[3] = impact
		
		clause = standard name:"z>0.25&z<0.75"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(3)
		clause.damageValues = #(1.0)
		append impact.damageClauses clause
		
		clause = standard name:"z<0.25"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(5,9,4)
		clause.damageValues = #(0.5,0.5,0.3)
		append impact.damageClauses clause
		
		clause = standard name:"z>0.75"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(7,11)
		clause.damageValues = #(0.5,0.5)
		append impact.damageClauses clause
		
		--right impacts
		impact = standard name:"Right"
		custAttributes.add impact damageInfoImpactAttributes
		rootnode.damageInfo[4] = impact
		
		clause = standard name:"z>0.25&z<0.75"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(3)
		clause.damageValues = #(1.0)
		append impact.damageClauses clause
		
		clause = standard name:"z<0.25"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(6,10,4)
		clause.damageValues = #(0.5,0.5,0.3)
		append impact.damageClauses clause
		
		clause = standard name:"z>0.75"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(8,12)
		clause.damageValues = #(0.5,0.5)
		append impact.damageClauses clause
		
		--front impacts
		impact = standard name:"Front"
		custAttributes.add impact damageInfoImpactAttributes
		rootnode.damageInfo[5] = impact
		
		clause = standard name:"always"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(1,2)
		clause.damageValues = #(1.0,0.3)
		append impact.damageClauses clause
		
		clause = standard name:"x<0.25"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(5,9,4)
		clause.damageValues = #(0.5,0.5,0.5)
		append impact.damageClauses clause
		
		clause = standard name:"x>0.75"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(6,10,4)
		clause.damageValues = #(0.5,0.5,0.5)
		append impact.damageClauses clause
		
		--rear impacts
		impact = standard name:"Rear"
		custAttributes.add impact damageInfoImpactAttributes
		rootnode.damageInfo[6] = impact
		
		clause = standard name:"always"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(2)
		clause.damageValues = #(0.5)
		append impact.damageClauses clause
		
		clause = standard name:"x<0.25"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(7,11)
		clause.damageValues = #(0.5,0.5)
		append impact.damageClauses clause
		
		clause = standard name:"x>0.75"
		custAttributes.add clause damageInfoClauseAttributes
		clause.damageIds = #(8,12)
		clause.damageValues = #(0.5,0.5)
		append impact.damageClauses clause
	)
	
	fn updateDamageInfoTree tv = (
		tv.Nodes.clear()
		impacts = rootnode.damageInfo
		for i in impacts do (
			impact = dotnetObject treeNodeClass i.name
			impact.tag = dotnetMxsValue i
			for c in i.damageClauses do (
				clause = dotnetObject treeNodeClass c.name
				clause.tag = dotnetMxsValue c
				for j=1 to c.damageValues.count do (
					damageID = c.damageIds[j]
					damageValue = c.damageValues[j]
					idNames = #("engine","transmission","driver","steering","lf_wheel","rf_wheel","lr_wheel","rr_wheel","lf_brake","rf_brake","lr_brake","rr_brake")
					damageValue = dotnetObject treeNodeClass (idNames[damageID] + "," + (damageValue as string))
					clause.Nodes.AddRange #(damageValue)
				)
				impact.Nodes.AddRange #(clause)
			)
			tv.Nodes.Add impact
		)
		tv.ExpandAll()
	)
	
	fn updateDamageInfoControlValues = (
		if damageClause!=undefined then (
			damageClauseCondition.text = damageClause.name
		)
		if damageSystem!=undefined then (
			damageSystemID.selection = damageClause.damageIds[damageSystem]
			damageSystemValue.range.z = damageClause.damageValues[damageSystem]
		)
	)
	
	fn updateDamageInfoControlSelection selectedNode = (
		if selectedNode != undefined then (
			if selectedNode.tag != undefined then (
				selectedMaterial = selectedNode.tag.value
				if hasAttribute selectedMaterial damageInfoImpactAttributes then (
					damageImpact = selectedMaterial
					damageClause = undefined
					damageSystem = undefined
					damageClauseAdd.enabled = true
					damageClauseDel.enabled = false
					damageClauseCondition.enabled = false
					damageSystemAdd.enabled = false
					damageSystemDel.enabled = false
					damageSystemID.enabled = false
					damageSystemValue.enabled = false
				)
				if hasAttribute selectedMaterial damageInfoClauseAttributes then (
					damageClause = selectedMaterial
					damageImpact = selectedNode.parent.tag.value
					damageSystem = undefined
					damageClauseAdd.enabled = false
					damageClauseDel.enabled = true
					damageClauseCondition.enabled = true
					damageSystemAdd.enabled = true
					damageSystemDel.enabled = false
					damageSystemID.enabled = false
					damageSystemValue.enabled = false
				)
			)
			else (
				damageSystem = (selectedNode.index+1)
				damageClause = selectedNode.parent.tag.value
				damageImpact = selectedNode.parent.parent.tag.value
				damageClauseAdd.enabled = false
				damageClauseDel.enabled = false
				damageClauseCondition.enabled = false
				damageSystemAdd.enabled = false
				damageSystemDel.enabled = true
				damageSystemID.enabled = true
				damageSystemValue.enabled = true
			)
		)
		updateDamageInfoControlValues()
	)
	
	on damageInfo open do (
		--damageInfoTree.labeledit = true
		damageInfo.height = placementPos+=32
		damageInfoTree.HideSelection = false
		damageInfoTree.BackColor = dnColorBackground
		damageInfoTree.ForeColor = dnColorText
		if rootnode.damageInfo[1] == undefined then (
			buildDamageInfoTree()
		)
		updateDamageInfoTree damageInfoTree
		damageInfoTree.Nodes.Item[0].ensurevisible()
	)
	
	on damageInfoTree AfterSelect do (
		selectedNode = damageInfoTree.selectedNode
		updateDamageInfoControlSelection selectedNode
	)
	on damageClauseAdd pressed do (
		selectedNode = damageInfoTree.selectedNode
		newClause = standard name:"always"
		append damageImpact.damageClauses newClause
		custAttributes.add newClause damageInfoClauseAttributes
		newNode = dotnetObject treeNodeClass newClause.name
		newNode.tag = dotnetMxsValue newClause

		selectedNode.Nodes.AddRange #(newNode)
	)
	on damageClauseDel pressed do (
		selectedNode = damageInfoTree.selectedNode
		index = selectedNode.index
		deleteItem damageImpact.damageClauses (index+1)
		parentNode = damageInfoTree.selectedNode.parent
		parentNode.Nodes.RemoveAt (index)
	)
	on damageSystemAdd pressed do (
		selectedNode = damageInfoTree.selectedNode
		newId = 1
		newValue = 0.5
		append damageClause.damageIds newId
		append damageClause.damageValues newValue
		
		newSystem = (damageSystemId.items[newId] + "," + (newValue as string))
		newNode = dotnetObject treeNodeClass newSystem
		
		selectedNode.Nodes.AddRange #(newNode)
	)
	on damageSystemDel pressed do (
		deleteItem damageClause.damageIds damageSystem
		deleteItem damageClause.damageValues damageSystem
		
		parentNode = damageInfoTree.selectedNode.parent
		parentNode.Nodes.RemoveAt (damageSystem-1)
	)
	on damageClauseCondition changed txt do (
		selectedNode = damageInfoTree.selectedNode
		selectedNode.text = txt
		damageClause.name = txt
	)
	on damageSystemId selected i do (
		selectedNode = damageInfoTree.selectedNode
		selectedNode.text = (damageSystemId.items[i]+","+(damageSystemValue.value as string))
		damageClause.damageIds[damageSystem] = i
	)
	on damageSystemValue changed val do (
		selectedNode = damageInfoTree.selectedNode
		selectedNode.text = (damageSystemId.selected+","+(val as string))
		damageClause.damageValues[damageSystem] = val
	)
	on damageDefaults pressed do (
		if querybox "Are you sure you want to reset to default values?" then (
			buildDamageInfoTree()
			updateDamageInfoTree damageInfoTree
			damageInfoTree.Nodes.Item[0].ensurevisible()
		)
	)
)
--createdialog damageInfo width height 100 100