--try destroyDialog mechanicsSetup catch()
rollout mechanicsSetup "Mechanics" (
	local placementPos = 0
	local itemheight = 20
	local general = try rootnode.carGeneralData catch undefined
	local wheelActor = undefined
	
	groupBox generalGroup "General" pos:[4,placementpos+=4] width:(width-8) height:(itemheight*4)
		spinner turningCircle "Turning circle:" range:[0,9,0.5] fieldwidth:40 width:widthC pos:[colA,placementPos+=itemheight]
		spinner brakeMultiplier "Brake multiplier:" range:[0,9,1] fieldwidth:40 width:widthC pos:[colD,placementPos]
		spinner strengthMultiplier "Strength multiplier:" range:[0,9,1] fieldwidth:40 width:widthC pos:[colA,placementPos+=itemheight]
		spinner gearsNumber "Number of gears:" range:[0,9,6] type:#integer fieldwidth:40 width:widthC pos:[colD,placementPos]
		spinner topSpeed "Top speed:" range:[0,9999,200] type:#integer fieldwidth:40 width:widthC pos:[colA,placementPos+=itemheight]
		spinner acceleration "Acceleration:" range:[0,99,5] fieldwidth:40 width:widthC pos:[colD,placementPos]
	
	groupBox rootGroup "Root Part" pos:[4,placementpos+=itemheight] width:(width-8) height:(itemheight*5)
		edittext actorName "Main Actor File:" width:widthD pos:[colA,placementPos+=itemheight]
		pickbutton pickActor "Pick:" width:widthB height:18 pos:[colE,placementPos] tooltip:"Pick from scene for auto calc."
		spinner gravityCenterX "Center of gravity X,Y,Z:" range:[-9999,9999,0] fieldwidth:40 width:widthD pos:[colA,placementPos+=itemheight]
		spinner gravityCenterY "" range:[-9999,9999,0] fieldwidth:40 width:widthA pos:[colE,placementPos]
		spinner gravityCenterZ "" range:[-9999,9999,0] fieldwidth:40 width:widthA pos:[colF,placementPos]
		spinner angularMomentumX "Angular Momentum Proportions:" range:[-9999,9999,0] fieldwidth:40 width:widthD pos:[colA,placementPos+=itemheight]
		spinner angularMomentumY "" range:[-9999,9999,0] fieldwidth:40 width:widthA pos:[colE,placementPos]
		spinner angularMomentumZ "" range:[-9999,9999,0] fieldwidth:40 width:widthA pos:[colF,placementPos]
		spinner mass "Mass:" range:[-9999,9999,1.5] fieldwidth:40 width:widthC pos:[colA,placementPos+=itemheight]
		spinner downForce "Downforce:" range:[-9999,9999,50] fieldwidth:40 width:widthC pos:[colD,placementPos]
		
	
	groupbox wheelsGroup "Wheels" pos:[4, placementPos+=itemheight] width:(width-8) height:(itemheight*11)
		listbox wheelsList width:widthC height:4 pos:[colA,placementPos+=itemheight]
		pickbutton wheelAdd "Add wheel" width:widthB pos:[colE,placementPos] tooltip:"Pick a model from the scene to add as a wheel"
		button wheelDel "Remove wheel" width:widthB pos:[colE,placementPos+=itemheight] tooltip:"Remove the selected entry from the wheels list"
		spinner wheelPosX "Wheel Position X,Y,Z:" range:[-999,999,0] scale:0.0001 fieldWidth:40 width:widthD pos:[colA,placementPos+=(itemheight*2)] enabled:false
		spinner wheelPosY "" range:[-999,999,0] scale:0.0001 fieldWidth:40 width:widthA pos:[colE,placementPos] enabled:false
		spinner wheelPosZ "" range:[-999,999,0] scale:0.0001 fieldWidth:40 width:widthA pos:[colF,placementPos] enabled:false
		checkbox wheelSteerable "Steerable" width:widthB pos:[colD,placementPos+=itemheight] enabled:false
		checkbox wheelDriven "Driven" width:widthA pos:[colF,placementPos] enabled:false
		label wheelIdentifierLabel "Identifier:" width:widthA pos:[colC,((placementPos+=itemheight)+4)] enabled:false
		dropdownlist wheelIdentifier "" items:#("","left front","right front","left rear","right rear") width:widthC pos:[colD,placementPos] enabled:false
		spinner suspensionGive "suspension give" range:[0,9,0.01] scale:0.01 fieldwidth:40 width:widthC pos:[colA,placementPos+=(itemheight+4)] enabled:false
		spinner dampingFactor "damping factor:" range:[0,9,1] scale:0.01 fieldwidth:40 width:widthC pos:[colD,placementPos] enabled:false
		spinner frictionReduction "friction reduction:" range:[0,9,1] fieldwidth:40 width:widthC pos:[colD,placementPos+=(itemheight)] enabled:false
		spinner frictionAngle1 "friction angle 1:" type:#float range:[0,180,79.5] scale:0.1 fieldwidth:40 width:widthC pos:[colA,placementPos+=itemheight] enabled:false
		spinner frictionAngle2 "friction angle 2:" type:#float range:[0,180,80.5] scale:0.1 fieldwidth:40 width:widthC pos:[colD,placementPos] enabled:false
		spinner tractionMultiplier "traction multiplier:" type:#float range:[0,999999,2] scale:0.1 fieldwidth:40 width:widthC pos:[colA,placementPos+=itemheight] enabled:false
		spinner rollingResistance "rolling resistance:" type:#float range:[0,1,0.05] scale:0.01 fieldwidth:40 width:widthC pos:[colD,placementPos] enabled:false
	
	fn updateWheelActorList sel = (
		general = rootnode.carGeneralData
		
		--clean list of actors that are missing the wheelAttributes
		properWheelActors = #()
		for wheelActor in general.wheelActors do (
			if hasAttribute wheelActor wheelAttributes then (
				append properWheelActors wheelActor
			)
		)
		general.wheelActors = properWheelactors
		
		--generate wheelActor List and enable button accordingly
		wheelsList.items = for actor in general.wheelActors collect actor.name
		wheelAdd.enabled = (general.wheelActors.count < 6)

		--set properties for selected wheelActor
		wheelActor = undefined
		if sel <= wheelsList.items.count and sel != 0 then (
			wheelsList.selection = sel
			wheelActor = general.wheelActors[sel]
		)
		wheelPosX.enabled = wheelPosY.enabled = wheelPosZ.enabled = (wheelActor != undefined)
		wheelIdentifier.enabled = wheelDriven.enabled = wheelSteerable.enabled = wheelIdentifierLabel.enabled = suspensionGive.enabled = dampingFactor.enabled = (wheelActor != undefined)
		frictionReduction.enabled = frictionAngle1.enabled = frictionAngle2.enabled = tractionMultiplier.enabled = rollingResistance.enabled = (wheelActor != undefined)
		
		wheelPosX.range.z = try wheelActor.wheelPos.x catch(0)
		wheelPosY.range.z = try wheelActor.wheelPos.y catch(0)
		wheelPosZ.range.z = try wheelActor.wheelPos.z catch(0)
		wheelIdentifier.selection = try wheelActor.identifier catch(1)
		wheelDriven.checked = try wheelActor.driven catch(false)
		wheelSteerable.checked = try wheelActor.steerable catch(false)
		suspensionGive.range.z = try wheelActor.suspensionGive catch 0.01
		dampingFactor.range.z = try wheelActor.dampingFactor catch 1
		frictionReduction.range.z = try wheelActor.frictionReduction catch 1
		frictionAngle1.range.z = try wheelActor.frictionAngle1 catch 79.5
		frictionAngle2.range.z = try wheelActor.frictionAngle2 catch 80.5
		tractionMultiplier.range.z = try wheelActor.tractionMultiplier catch 2
		rollingResistance.range.z = try wheelActor.rollingResistance catch 0.05
	)
	
	fn updateMechanicsValues sel = (
		general = rootnode.carGeneralData
		turningCircle.range.z = general.turningCircle
		brakeMultiplier.range.z = general.brakeMultiplier
		strengthMultiplier.range.z = general.strengthMultiplier
		gearsNumber.range.z = general.gearsNumber
		topSpeed.range.z = general.topSpeed
		acceleration.range.z = general.acceleration
		
		gravityCenterX.range.z = general.gravityCenter.x
		gravityCenterY.range.z = general.gravityCenter.y
		gravityCenterZ.range.z = general.gravityCenter.z
		angularMomentumX.range.z = general.angularMomentum.x
		angularMomentumY.range.z = general.angularMomentum.y
		angularMomentumZ.range.z = general.angularMomentum.z
		mass.range.z = general.mass
		downForce.range.z = general.downForce
		actorName.text = try general.actorName catch ""
			
		updateWheelActorList sel
	)
	
	on mechanicsSetup open do (
		updateMechanicsValues 1
	)
	on pickActor picked mainActor do (
		if mainActor != undefined then (
			general.gravityCenter = (in coordsys mainActor mainActor.center)
			general.angularMomentum = in coordsys mainActor (mainActor.max - mainActor.min)
			sizes = mainActor.max - mainActor.min
			volume = abs sizes.x * abs sizes.y * abs sizes.z
			general.mass = volume * 35
			
			general.actorName = mainActor.name
			updateMechanicsValues wheelsList.selection
		)
	)
	
	on turningCircle changed val do general.turningCircle = val
	on brakeMultiplier changed val do general.brakeMultiplier = val
	on strengthMultiplier changed val do general.StrengthMultiplier = val
	on gearsNumber changed val do general.gearsNumber = val
	on topSpeed changed val do general.topSpeed = val
	on acceleration changed val do general.acceleration = val
		
	on gravityCenterX changed val do general.gravityCenter.x = val
	on gravityCenterY changed val do general.gravityCenter.y = val
	on gravityCenterZ changed val do general.gravityCenter.z = val
	on angularMomentumX changed val do general.angularMomentum.x = val
	on angularMomentumY changed val do general.angularMomentum.y = val
	on angularMomentumZ changed val do general.angularMomentum.z = val
	on mass changed val do general.mass = val
	on downForce changed val do general.downForce = val
	on actorName changed txt do general.actorName = txt
		
	on wheelAdd picked wheelActor do (
		if wheelActor!=undefined then (
			custattributes.add wheelActor wheelAttributes
			wheelActor.wheelPos = wheelActor.center
			append general.wheelActors wheelActor
			updateWheelActorList general.wheelActors.count
		)
	)
	on wheelDel pressed do (
		sel = wheelsList.selection
		if sel != 0 then (
			wheelActor = general.wheelActors[sel]
			custAttributes.delete wheelActor wheelAttributes
			deleteItem general.wheelActors sel
			if general.wheelActors.count == 1 then (
				updateWheelActorList 1
			)
			else (
				updateWheelActorList (sel-1)
			)
		)
	)
	on wheelsList selected i do (
		updateWheelactorList i
	)
	on wheelPosX changed val do try wheelActor.wheelPos.x = val catch()
	on wheelPosY changed val do try wheelActor.wheelPos.y = val catch()
	on wheelPosZ changed val do try wheelActor.wheelPos.z = val catch()
	on wheelIdentifier selected i do try wheelActor.identifier = i catch ()
	on wheelDriven changed val do try wheelActor.driven = val catch()
	on wheelSteerable changed val do try wheelActor.steerable = val catch()
	on suspensionGive changed val do try wheelActor.suspensionGive = val catch()
	on dampingFactor changed val do try wheelActor.dampingFactor = val catch()
	on frictionReduction changed val do try wheelActor.frictionReduction = val catch()
	on frictionAngle1 changed val do try wheelActor.frictionAngle1 = val catch() 
	on frictionAngle2 changed val do try wheelActor.frictionAngle2 = val catch()
	on tractionMultiplier changed val do try wheelActor.tractionMultiplier = val catch()
	on rollingResistance changed val do try wheelActor.rollingResistance = val catch()
	
)
--createdialog mechanicsSetup width height