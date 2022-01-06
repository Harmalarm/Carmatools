--try destroydialog carQuickSetup catch()
rollout carQuickSetup "Quick Setup" (
	local posY = 4
	groupBox mainBodyProperties "Main Body:" width:(width-8) pos:[4,posY] height:80
		label mainBodyLabel "Pick mainbody object to automatically set the main properties:\n- weight, angular momentum and centre of mass " height:30 width:widthF pos:[colA,posY+=21]
		pickButton mainBody "Pick object" width:widthC pos:[colD,posY+=30] autoDisplay:true

	groupBox wheelProperties "Wheels:" width:(width-8) pos:[4,posY+=42] height:80
		pickButton wheelLeftFront "Pick Left Front" width:widthC pos:[colA,posY+=21] autoDisplay:true
		pickButton wheelRightFront "Pick Right Front" width:widthC pos:[colD,posY] autoDisplay:true
		pickButton wheelLeftRear "Pick Left Rear" width:widthC pos:[colA,posY+=21] autoDisplay:true
		pickButton wheelRightRear "Pick Right Rear" width:widthC pos:[colD,posY] autoDisplay:true
	
	groupBox suspensionProperties "Suspension:" width:(width-8) pos:[4,posY+=42] height:80
		pickButton suspensionLeftFront "Pick Left Front" width:widthC pos:[colA,posY+=21] autoDisplay:true
		pickButton suspensionRightFront "Pick Right Front" width:widthC pos:[colD,posY] autoDisplay:true
		pickButton suspensionLeftRear "Pick Left Rear" width:widthC pos:[colA,posY+=21] autoDisplay:true
		pickButton suspensionRightRear "Pick Right Rear" width:widthC pos:[colD,posY] autoDisplay:true
	
	groupBox finalProperties "Properties:" width:(width-8) pos:[4,posY+=42] height:50
		button setQuickSetup "Apply Settings" width:widthB pos:[colC,posY+=21]
	
	on carQuickSetup open do (
		carQuickSetup.height = posY+=34
	)
	
	on setQuickSetup pressed do (
		if querybox "This will reset all groove and mechanics settings to eagle3 default, are you sure?" then (
			
			general = rootnode.carGeneralData
			--set mechanics main body
			if mainBody.object != undefined then (
				mainActor = mainBody.object
				general.gravityCenter = (in coordsys mainActor mainActor.center)
				general.angularMomentum = in coordsys mainActor (mainActor.max - mainActor.min)
				
				sizes = mainActor.max - mainActor.min
				volume = abs sizes.x * abs sizes.y * abs sizes.z
				general.mass = volume * 35
				general.actorName = mainActor.name
			)
			
			--set wheels and suspension grooves
			rootnode.carGeneralData.wheelActors = #()
			rootnode.carGeneralData.grooves = #()
			rootnode.wheelsSteerable = #()
			if wheelLeftFront.object != undefined then (
				wheelActor = wheelLeftFront.object
				custAttributes.add wheelActor wheelAttributes
				appendifunique general.wheelActors wheelActor
				wheelActor.wheelPos = wheelActor.center
				wheelActor.identifier = 2
				wheelActor.steerable = true
				wheelActor.driven = false
				wheelActor.frictionAngle1 = 80.0
				wheelActor.frictionAngle2 = 80.5
				
				custAttributes.add wheelActor groove_CA
				appendifunique rootnode.grooves wheelActor
				wheelActor.lollipop = 1
				wheelActor.distance = 2
				wheelActor.animation_type = 2
				wheelActor.animation_mode = 6
				wheelActor.animation_grfu = 10
				wheelActor.animation_centre_x = 0
				wheelActor.animation_centre_y = 0
				wheelActor.animation_centre_z = 0
				wheelActor.animation_axis = 1
				
				rootnode.wheelsNonDriven[1] = 10
				
				rootnode.wheelDiameterNonDriven = abs (wheelActor.max.z - wheelActor.min.z)
			)
			if wheelRightFront.object != undefined then (
				wheelActor = wheelRightFront.object
				custAttributes.add wheelActor wheelAttributes
				appendifunique general.wheelActors wheelActor
				wheelActor.wheelPos = wheelActor.center
				wheelActor.identifier = 3
				wheelActor.steerable = true
				wheelActor.driven = false
				wheelActor.frictionAngle1 = 80.0
				wheelActor.frictionAngle2 = 80.5
				
				custAttributes.add wheelActor groove_CA
				appendifunique rootnode.grooves wheelActor
				wheelActor.lollipop = 1
				wheelActor.distance = 2
				wheelActor.animation_type = 2
				wheelActor.animation_mode = 6
				wheelActor.animation_grfu = 9
				wheelActor.animation_centre_x = 0
				wheelActor.animation_centre_y = 0
				wheelActor.animation_centre_z = 0
				wheelActor.animation_axis = 1
				
				rootnode.wheelsNonDriven[2] = 9
				
				rootnode.wheelDiameterNonDriven = abs (wheelActor.max.z - wheelActor.min.z)
			)
			if wheelLeftRear.object != undefined then (
				wheelActor = wheelLeftRear.object
				custAttributes.add wheelActor wheelAttributes
				appendifunique general.wheelActors wheelActor
				wheelActor.wheelPos = wheelActor.center
				wheelActor.identifier = 4
				wheelActor.steerable = false
				wheelActor.driven = true
				wheelActor.frictionAngle1 = 79.5
				wheelActor.frictionAngle2 = 80.5
				
				custAttributes.add wheelActor groove_CA
				appendifunique rootnode.grooves wheelActor
				wheelActor.lollipop = 1
				wheelActor.distance = 2
				wheelActor.animation_type = 2
				wheelActor.animation_mode = 6
				wheelActor.animation_grfu = 2
				wheelActor.animation_centre_x = 0
				wheelActor.animation_centre_y = 0
				wheelActor.animation_centre_z = 0
				wheelActor.animation_axis = 1
				
				rootnode.wheelsDriven[3] = 2
				
				rootnode.wheelDiameterDriven = abs (wheelActor.max.z - wheelActor.min.z)
			)
			if wheelRightRear.object != undefined then (
				wheelActor = wheelRightRear.object
				custAttributes.add wheelActor wheelAttributes
				appendifunique general.wheelActors wheelActor
				wheelActor.wheelPos = wheelActor.center
				wheelActor.identifier = 5
				wheelActor.steerable = false
				wheelActor.driven = true
				wheelActor.frictionAngle1 = 79.5
				wheelActor.frictionAngle2 = 80.5

				custAttributes.add wheelActor groove_CA
				appendifunique rootnode.grooves wheelActor
				wheelActor.lollipop = 1
				wheelActor.distance = 2
				wheelActor.animation_type = 2
				wheelActor.animation_mode = 6
				wheelActor.animation_grfu = 1
				wheelActor.animation_centre_x = 0
				wheelActor.animation_centre_y = 0
				wheelActor.animation_centre_z = 0
				wheelActor.animation_axis = 1
				
				rootnode.wheelsDriven[4] = 1
				
				rootnode.wheelDiameterDriven = abs (wheelActor.max.z - wheelActor.min.z)
			)
			
			if suspensionLeftFront.object != undefined then (
				suspensionActor = suspensionLeftFront.object
				custAttributes.add suspensionActor groove_CA
				appendifunique rootnode.grooves suspensionActor
				suspensionActor.lollipop = 1
				suspensionActor.distance = 2
				
				suspensionActor.path_type = 2
				suspensionActor.path_mode = 4
				suspensionActor.path_grfu = 4
				suspensionActor.path_centre_x = 0
				suspensionActor.path_centre_y = 0
				suspensionActor.path_centre_z = 0
				suspensionActor.path_extent_x = 0
				suspensionActor.path_extent_y = 0
				suspensionActor.path_extent_z = 1
				
				suspensionActor.animation_type = 3
				suspensionActor.animation_mode = 5
				suspensionActor.animation_grfu = 8
				suspensionActor.animation_centre_x = 0
				suspensionActor.animation_centre_y = 0
				suspensionActor.animation_centre_z = 0
				suspensionActor.animation_axis = 3
				suspensionActor.animation_speed = 0
				
				append rootnode.wheelsSteerable 8
				
				rootnode.suspensionFL[1] = 4
			)
			if suspensionRightFront.object != undefined then (
				suspensionActor = suspensionRightFront.object
				custAttributes.add suspensionActor groove_CA
				appendifunique rootnode.grooves suspensionActor
				suspensionActor.lollipop = 1
				suspensionActor.distance = 2
				
				suspensionActor.path_type = 2
				suspensionActor.path_mode = 4
				suspensionActor.path_grfu = 3
				suspensionActor.path_centre_x = 0
				suspensionActor.path_centre_y = 0
				suspensionActor.path_centre_z = 0
				suspensionActor.path_extent_x = 0
				suspensionActor.path_extent_y = 0
				suspensionActor.path_extent_z = 1
				
				suspensionActor.animation_type = 3
				suspensionActor.animation_mode = 5
				suspensionActor.animation_grfu = 7
				suspensionActor.animation_centre_x = 0
				suspensionActor.animation_centre_y = 0
				suspensionActor.animation_centre_z = 0
				suspensionActor.animation_axis = 3
				suspensionActor.animation_speed = 0
				
				rootnode.suspensionFR[1] = 3
				append rootnode.wheelsSteerable 7
			)
			if suspensionLeftRear.object != undefined then (
				suspensionActor = suspensionLeftRear.object
				custAttributes.add suspensionActor groove_CA
				appendifunique rootnode.grooves suspensionActor
				suspensionActor.lollipop = 1
				suspensionActor.distance = 2
				
				suspensionActor.path_type = 2
				suspensionActor.path_mode = 4
				suspensionActor.path_grfu = 6
				suspensionActor.path_centre_x = 0
				suspensionActor.path_centre_y = 0
				suspensionActor.path_centre_z = 0
				suspensionActor.path_extent_x = 0
				suspensionActor.path_extent_y = 0
				suspensionActor.path_extent_z = 1
				
				rootnode.suspensionRL[1] = 6
				
			)
			if suspensionRightRear.object != undefined then (
				suspensionActor = suspensionRightRear.object
				custAttributes.add suspensionActor groove_CA
				appendifunique rootnode.grooves suspensionActor
				suspensionActor.lollipop = 1
				suspensionActor.distance = 2
				
				suspensionActor.path_type = 2
				suspensionActor.path_mode = 4
				suspensionActor.path_grfu = 5
				suspensionActor.path_centre_x = 0
				suspensionActor.path_centre_y = 0
				suspensionActor.path_centre_z = 0
				suspensionActor.path_extent_x = 0
				suspensionActor.path_extent_y = 0
				suspensionActor.path_extent_z = 1
				
				rootnode.suspensionRR[1] = 5
			)
		)
	)
)
--createdialog carQuickSetup width height 100 100