--custom tools
tool checkpoint_tool
(
	local checkpoint, x, y ,z 
	local edgevis = #(#(true,true,false),#(true,true,false))
	fn createcheckpoint =
	(
		in coordsys grid checkpoint=mesh vertices:#([-0.5,0,-0.5],[0.5,0,-0.5],[-0.5,0,.5],[.5,0,.5]) faces:#([1,2,4],[4,3,1]) pos:gridPoint wirecolor:(color 255 0 0)
		for face = 1 to edgevis.count do
		for i = 1 to 3 do
		setEdgeVis checkpoint face i edgeVis[face][i]
	)
	on mousePoint click do
	(
		if click == 1 do 
		(
			createcheckpoint()
			custattributes.add checkpoint checkp_CA
			append rootnode.checkp checkpoint
			select checkpoint
			#stop
		)
	)
)

tool multiplayerpoint_tool
(
	local multiplayerpoint
	
	local vertsarray = #([-0.125,-0.25,0],[0.125,-0.25,0],[-0.125,0.25,0],[0.125,0.25,0],[-0.048498,-0.0207384,0],[-0.048498,-0.141085,0],[0.048498,-0.141085,0],[0.048498,-0.0207384,0],[-0.048498,-0.0207384,0],[0.048498,-0.0207384,0],[0.148498,-0.0207384,0],[0,0.141087,0],[-0.148498,-0.0207384,0])
	local facesarray = #([1,2,4],[4,3,1],[6,7,8],[10,11,12],[8,10,12],[12,13,9],[12,9,5],[8,12,5],[6,8,5])
	local edgevis = #(#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,false,false),#(true,true,false),#(false,true,false),#(false,false,false),#(false,false,true))
	fn createmultiplayerpoint =
	(
		in coordsys grid multiplayerpoint=mesh vertices:vertsarray faces:facesarray pos:gridPoint wirecolor:(color 255 0 0)
		for face = 1 to edgevis.count do
		for i = 1 to 3 do
		setEdgeVis multiplayerpoint face i edgeVis[face][i]
	)
	on mousePoint click do
	(
		if click == 1 do 
		(
			createmultiplayerpoint()
			multiplayerpoint.name = ("multiplayerpoint" + " "+ ((rootnode.mstartp.count +1)as string))
			custattributes.add multiplayerpoint multiplayer_point_CA
			append rootnode.mstartp multiplayerpoint
			select multiplayerpoint
			#stop
		)
	)
)

tool startinggrid_tool
(
	local starting_grid_mesh
	local vertsArray = #([-0.125,-0.280637,0],[0.125,-0.280637,0],[-0.125,0.276376,0],[0.125,0.276376,0],[-1.125,-0.221494,0],[-1.125,-0.778506,0],[-0.875,-0.778506,0],[-0.875,-0.221494,0],[-0.125,-1.72362,0],[-0.125,-2.28064,0],[0.125,-2.28064,0],[0.125,-1.72362,0],[-1.125,-2.22149,0],[-1.125,-2.77851,0],[-0.875,-2.77851,0],[-0.875,-2.22149,0],[-0.125,-3.72362,0],[-0.125,-4.28064,0],[0.125,-4.28064,0],[0.125,-3.72362,0],[-1.125,-4.22149,0],[-1.125,-4.77851,0],[-0.875,-4.77851,0],[-0.875,-4.22149,0],[-0.125,-5.72362,0],[-0.125,-6.28064,0],[0.125,-6.28064,0],[0.125,-5.72362,0],[-1.125,-6.22149,0],[-1.125,-6.77851,0],[-0.875,-6.77851,0],[-0.875,-6.22149,0],[-0.548498,0.396723,0],[-0.548498,0.276376,0],[-0.451502,0.276376,0],[-0.451502,0.396723,0],[-0.548498,0.396723,0],[-0.451502,0.396723,0],[-0.351502,0.396723,0],[-0.5,0.558548,0],[-0.648498,0.396723,0])
	local facesArray = #([4,3,1],[1,2,4],[8,5,6],[6,7,8],[12,9,10],[10,11,12],[16,13,14],[14,15,16],[20,17,18],[18,19,20],[24,21,22],[22,23,24],[28,25,26],[26,27,28],[32,29,30],[30,31,32],[34,35,36],[38,39,40],[36,38,40],[40,41,37],[40,37,33],[36,40,33],[34,36,33])
	local edgeVis = #(#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,true,false),#(true,false,false),#(true,true,false),#(false,true,false),#(false,false,false),#(false,false,true))
	fn createstartinggrid = 
	(
		in coordsys grid starting_grid_mesh = mesh vertices:vertsArray faces:facesArray pos:gridPoint wirecolor:(color 255 0 0)
		for face = 1 to edgeVis.count do
		for i = 1 to 3 do
		setEdgeVis starting_grid_mesh face i edgeVis[face][i]
		custattributes.add starting_grid_mesh starting_grid_CA
		starting_grid_mesh.name = "_starting_grid"
	)
	on mousePoint click do
	(
		if click == 1
		then
		(								
			createstartinggrid()
			select starting_grid_mesh
			rootnode.startg = starting_grid_mesh
			#stop
		)
		else if p != undefined do (Startinggrid_helper.pos=worldPoint;Startinggrid_helper=undefined) #stop
	)
)

--try destroydialog generalTrackSetup catch()
rollout generalTrackSetup "General Track Setup:" (
	local placementPos = 24
	group "Start Positions:"(
		button startingGridAdd "Starting Grid:" width:widthC pos:[colA,placementPos]
	)
	on startingGridAdd pressed do (
		startinggrid = rootnode.startg
		if startinggrid == undefined then
		(
			starttool startinggrid_tool
		)
		else
		(
			messagebox "Startinggrid helper already present in the scene"
			select startinggrid
		)
	)
	
	group "Multiplayer Starting Positions:" (
		listbox multiplayerPointList "" height:8 width:widthC pos:[colA,placementPos+=52]
		button multiplayerPointAdd "Add Startpoint" width:widthC pos:[colD,placementPos]
		button multiplayerPointDel "Delete Startpoint" width:widthC pos:[colD,placementPos+=26]
		label multiplayerPointEnd "" pos:[colA,placementPos+=80]
	)
	fn updateMultiplayerPointListItems = (
		multiplayerPointList.items = for multiplayerPoint in rootnode.mstartp collect multiplayerPoint.name
	)
	on multiplayerPointAdd pressed do (
		startTool multiplayerpoint_tool
		updateMultiplayerPointListItems()
	)
	on multiplayerPointDel pressed do (
		sel = multiplayerPointList.selection
		multiplayerpoint = try rootnode.mstartp[sel] catch undefined
		if multiplayerpoint != undefined then (
			custattributes.delete multiplayerpoint multiplayer_point_CA
			delete multiplayerPoint
			deleteitem rootnode.mstartp sel
		)
		updateMultiplayerPointListItems()
	)
	on multiplayerPointList selected i do (
		multiplayerpoint = try rootnode.mstartp[i] catch undefined
		if multiplayerpoint!=undefined then (
			select multiplayerpoint
		)
	)
	on multiplayerPointList doubleclicked i do (
		multiplayerpoint = try rootnode.mstartp[i] catch undefined
		if multiplayerpoint!=undefined then (
			multiplayerpoint.name = newString multiplayerpoint.name "Enter a new descriptive name"
		)
		updateMultiplayerPointListItems()
	)
	
	local checkpoint
	group "Checkpoints:"(
		listbox checkpointList "" height:8 width:widthC pos:[colA,placementPos+=52]
		button checkpointAdd "Add checkpoint" tooltip:"Add a new checkpoint" width:(widthC/2) pos:[colA,placementPos+checkpointList.height+4]
		button checkpointDel "Del checkpoint " tooltip:"Remove the selected checkpoint" width:(widthC/2) pos:[colA+widthC/2,placementPos+checkpointList.height+4]

		spinner checkPointBonus1 "bonus 1" type:#integer scale:1 fieldwidth:40 width:widthC pos:[colD,placementPos]
		spinner checkPointBonus2 "bonus 2" type:#integer scale:1 fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		spinner checkPointBonus3 "bonus 3" type:#integer scale:1 fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		label checkpointEnd "" pos:[colA,placementPos+=80]
	)
	fn updateCheckpointControlStates checkPoint = (
		mainState = checkpoint!=undefined
		checkPointBonus1.visible = mainState
		checkPointBonus2.visible = mainState
		checkPointBonus3.visible = mainState
	)
	fn updateCheckpointControlValues checkpoint = (
		if checkpoint!=undefined then (
			checkPointBonus1.range.z = checkpoint.bonus_1
			checkPointBonus2.range.z = checkpoint.bonus_2
			checkPointBonus3.range.z = checkpoint.bonus_3
		)
	)
	fn updateCheckPointListSelection index = (
		checkPoint = try rootnode.checkp[index] catch undefined
		updateCheckpointControlStates checkPoint
		updateCheckpointControlValues checkpoint
	)
	fn updateCheckPointListItems = (
		checkpointList.items = for checkpoint in rootnode.checkp collect checkpoint.name
		sel = checkpointList.selection = checkpointList.items.count
		updateCheckPointListSelection sel
	)
	on checkpointList selected i do (
		checkpoint = try rootnode.checkp[i] catch undefined
		updateCheckpointControlValues checkpoint
	)
	on checkpointAdd pressed do (
		startTool checkpoint_tool
		updateCheckPointListItems()
	)
	on checkpointDel pressed do (
		sel = checkPointList.selection
		checkpoint = try rootnode.checkp[sel] catch undefined
		if checkpoint != undefined then (
			custattributes.delete checkpoint checkp_CA
			delete checkPoint
			deleteitem rootnode.checkp sel
		)
		updateCheckPointListItems()
	)
	on checkpointBonus1 changed val do try checkpoint.bonus_1 = val catch()
	on checkpointBonus2 changed val do try checkpoint.bonus_2 = val catch()
	on checkpointBonus3 changed val do try checkpoint.bonus_3 = val catch()
	
	group "PathSystems:" (
		pickbutton opponentPath "Opponent Path:" autoDisplay:true tooltip:"Pick a spline shape to use as opponent path" width:widthC pos:[colA,placementPos+=42]
		pickbutton dronePath "Drone Path:" autoDisplay:true tooltip:"Pick a spline shape to use as basic drone path (you still need to manually add drones to a specific node to spawn them)" width:widthC pos:[colD,placementPos]
	)
	on opponentPath picked obj do (
		if (classof obj) == line do (
			rootnode.track_general_attributes.oppPath_object = obj
			obj.wirecolor = red
			opponentPath.text = "Opponent Path: " + obj.name
		)
	)
	on opponentPath rightclick do (
		rootnode.track_general_attributes.oppPath_object = undefined
		opponentPath.text = "Opponent Path:"
	)
	on dronePath picked obj do (
		if (classof obj) == line do (
			rootnode.track_general_attributes.dronePath_object = obj
			obj.wirecolor = yellow
			dronePath.text =  "Drone Path: " + obj.name
		)
	)
	on dronePath rightclick do (
		rootnode.track_general_attributes.dronePath_object = undefined
		dronePath.text = "Drone Path:"
	)
	local pedSpawn = undefined
	group "Ped spawn materials" (
		checkbox pedSpawnCheck "Include ped mats on export:" checked:rootnode.track_general_attributes.pedSpawn_check width:widthC pos:[colA, placementPos +=50]
		listbox pedSpawnList "Materials" items:#() width:widthC height:12 tooltip:"doubleclick items to add them to the material editor"
		
		spinner pedSpawn_movement_index "Movement Index:" type:#integer range:[0,1,0] fieldwidth:40 width:widthC pos:[colD,placementPos+=35]
		spinner pedSpawn_group_index "Group Index:" type:#integer range:[0,75,1] fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		spinner pedSpawn_density "Density:" type:#integer range:[-1,100,10] fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		listbox pedSpawn_exclusionList "Exclusion material:" width:widthB height:5 pos:[colD,placementPos+=21]
		button pedSpawn_exclusionAdd "Add Name" width:(widthA) pos:[colF,placementPos+=16]
		button pedSpawn_exclusionDel "Del Name"  width:(widthA) pos:[colF,placementPos+=27]
		spinner pedSpawn_exclusionFlag "Flag"  range:[0,2,0] fieldwidth:20 width:(widthA) type:#integer pos:[colF,placementPos+=27]
		spinner pedSpawn_exclusion2 "Exception material:" type:#integer range:[0,1,0] fieldwidth:40 width:widthC pos:[colD,placementPos+=21]
		button pedSpawnAdd "Add material" tooltip:"add the current selected material as ped spawn material. Do not use multi_sub_materials, just standard materials" width:(widthC/2) pos:[colA,placementPos+21]
		button pedSpawnDel "Del material" tooltip:"remove the selected material from the list" width:(widthC/2) pos:[colA+(widthC/2),placementPos+21]
	)
	fn updatePedSpawnControlStates pedSpawn = (
		mainState = pedSpawn != undefined
		pedSpawn_movement_index.visible = mainState
		pedSpawn_group_index.visible = mainState
		pedSpawn_density.visible = mainState
		pedSpawn_exclusionList.visible = mainState
		pedSpawn_exclusionAdd.visible = mainState
		pedSpawn_exclusionDel.visible = mainState
		pedSpawn_exclusionFlag.visible = mainState
		pedSpawn_exclusion2.visible = mainState
	)
	fn updatePedSpawnControlValues pedSpawn = (
		if pedSpawn!=undefined then (
			pedSpawn_movement_index.range.z = pedSpawn.movement_index
			pedSpawn_group_index.range.z = pedSpawn.group_index
			pedSpawn_density.range.z = pedSpawn.density
			pedSpawn_exclusionList.items = (pedSpawn.exclusion1 as array)
			exclusion = try pedspawn_exclusionList.selected catch undefined
			flag = if exclusion!=undefined then ((filterstring exclusion ",")[2] as integer) else 0
			pedSpawn_exclusionFlag.range.z = flag
		)
	)
	fn updatePedSpawnListSelection index = (
		pedSpawn = try rootnode.pedSpawn_mats[index] catch(undefined)
		updatePedSpawnControlValues pedSpawn
		updatePedSpawnControlStates pedSpawn
	)
	fn updatePedSpawnListItems = (
		pedSpawnList.items = for m in rootnode.track_general_attributes.pedSpawn_mats collect m.name
		updatePedSpawnListSelection pedSpawnList.items.count
	)
	on pedSpawnCheck changed state do rootnode.track_general_attributes.pedSpawn_check = state
	on pedSpawnList selected i do (
		updatePedSpawnListSelection i
	)
	on pedSpawnList doubleclicked i do (
		pedSpawn = try rootnode.track_general_attributes.pedSpawn_mats[i] catch()
		slot = medit.GetActiveMtlSlot()
		medit.PutMtlToMtlEditor pedSpawn slot 
	)
	on pedSpawnAdd pressed do (
		pedSpawn = medit.getcurmtl()
		custattributes.add pedSpawn pedSpawn_CA
		appendifunique rootnode.pedSpawn_mats pedSpawn
		updatePedSpawnListItems()
	)
	on pedSpawnDel pressed do (
		sel = pedSpawnList.selection
		if sel != 0 do
		(
			pedSpawn = rootnode.pedSpawn_mats[sel]
			try custattributes.delete pedSpawn pedSpawn_CA catch()
			deleteitem rootnode.pedSpawn_mats sel
			updatePedSpawnListItems()
		)
	)
	on pedSpawn_movement_index changed val do pedSpawn.movement_index = val
	on pedSpawn_group_index changed val do pedSpawn.group_index = val
	on pedSpawn_density changed val do pedSpawn.density = val
	on pedSpawn_exclusionList selected i do (
		if i!=0 then (
			exclusion = pedSpawn_exclusionList.selected
			flag = ((filterstring exclusion ",")[2] as integer)
			pedSpawn_exclusionFlag.range.z = flag 
		)
	)
	on pedSpawn_exclusionList doubleclicked i do (
		exclusion = newString "" "Enter a material name"
		if exclusion!="" then (
			exclusion = (exclusion + ","+(pedSpawn_exclusionFlag.value as string))
			pedSpawn.exclusion1[i] = exclusion
			pedSpawn_exclusionList.items = pedSpawn.exclusion1 as array
		)
	)
	on pedSpawn_exclusionAdd pressed do (
		exclusion = newString "" "Enter a material name"
		if exclusion!="" then (
			exclusion = (exclusion + ","+(pedSpawn_exclusionFlag.value as string))
			append pedSpawn.exclusion1 exclusion
			pedSpawn_exclusionList.items = pedSpawn.exclusion1 as array
		)
	)
	on pedSpawn_exclusionDel pressed do (
		sel = pedSpawn_exclusionList.selection
		if sel!=0 then (
			deleteitem pedSpawn.exclusion1 sel
			pedSpawn_exclusionList.items = pedSpawn.exclusion1 as array
			pedSpawn_exclusionList.selection = pedSpawn_exclusionList.items.count
		)
	)
	on pedSpawn_exclusionFlag changed val do (
		sel = pedSpawn_exclusionList.selection
		if sel!=0 then (
			exclusion = pedSpawn_exclusionList.selected
			exclusionName = (filterstring exclusion ",")[1]
			exclusion = (exclusionName+","+(val as string))
			pedSpawn.exclusion1[sel] = exclusion
			pedSpawn_exclusionList.items = pedSpawn.exclusion1 as array
		)
	)
	
	on pedSpawn_exclusion2 changed val do pedSpawn.exclusion2 = val
	
	on generalTrackSetup open do (
		generalTrackSetup.height = 690
		startingGridAdd.text = try rootnode.startg.name catch "Starting Grid"
		updateMultiplayerPointListItems()
		updateCheckPointListItems()
		opponentPath.text = try  "Opponent Path: " + rootnode.track_general_attributes.oppPath_object.name catch "Opponent Path:"
		dronePath.text = try  "Drone Path: " + rootnode.track_general_attributes.dronePath_object.name catch "Drone Path:"
		updatePedSpawnListItems()
	)
)
--createdialog generalTrackSetup width height