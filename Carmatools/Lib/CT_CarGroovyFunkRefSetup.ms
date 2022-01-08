--try destroydialog groovyFunkRefSetup catch()
rollout groovyFunkRefSetup "Groovy Funk Reference" (
	local placementPos = 0
	local itemheight = 20
	local general = try rootnode.carGeneralData catch undefined
		
	groupbox suspensionParts "Suspension Part References" pos:[4, placementPos+=4] width:(width-8) height:(itemheight*5)
		label suspensionFLLabel "Front Left:" width:widthB pos:[colA,placementPos+=itemheight]
		spinner suspensionFL1 width:widthA pos:[colC,placementPos] type:#integer range:[-1,99,-1]
		spinner suspensionFL2 width:widthA pos:[colD,placementPos] type:#integer range:[-1,99,-1]
		spinner suspensionFL3 width:widthA pos:[colE,placementPos] type:#integer range:[-1,99,-1]
		spinner suspensionFL4 width:widthA pos:[colF,placementPos] type:#integer range:[-1,99,-1]
		label suspensionFRLabel "Front right:" width:widthB pos:[colA,placementPos+=itemheight]
		spinner suspensionFR1 width:widthA pos:[colC,placementPos] type:#integer range:[-1,99,-1]
		spinner suspensionFR2 width:widthA pos:[colD,placementPos] type:#integer range:[-1,99,-1]
		spinner suspensionFR3 width:widthA pos:[colE,placementPos] type:#integer range:[-1,99,-1]
		spinner suspensionFR4 width:widthA pos:[colF,placementPos] type:#integer range:[-1,99,-1]
		label suspensionRLLabel "Rear Left:" width:widthB pos:[colA,placementPos+=itemheight]
		spinner suspensionRL1 width:widthA pos:[colC,placementPos] type:#integer range:[-1,99,-1]
		spinner suspensionRL2 width:widthA pos:[colD,placementPos] type:#integer range:[-1,99,-1]
		label suspensionRRLabel "Rear Right:" width:widthB pos:[colA,placementPos+=itemheight]
		spinner suspensionRR1 width:widthA pos:[colC,placementPos] type:#integer range:[-1,99,-1]
		spinner suspensionRR2 width:widthA pos:[colD,placementPos] type:#integer range:[-1,99,-1]
	groupbox wheelParts "Rotating Wheels" pos:[4, placementPos+=itemheight] width:(width-8) height:(itemheight*3)
		label drivenWheelsLabel "Driven Wheels:" width:widthB pos:[colA,placementPos+=itemheight]
		spinner drivenWheel1 width:widthA pos:[colC,placementPos] type:#integer range:[-1,99,-1]
		spinner drivenWheel2 width:widthA pos:[colD,placementPos] type:#integer range:[-1,99,-1]
		spinner drivenWheel3 width:widthA pos:[colE,placementPos] type:#integer range:[-1,99,-1]
		spinner drivenWheel4 width:widthA pos:[colF,placementPos] type:#integer range:[-1,99,-1]
		label nonDrivenWheelsLabel "Non Driven Wheels:" width:widthB pos:[colA,placementPos+=itemheight]
		spinner nonDrivenWheel1 width:widthA pos:[colC,placementPos] type:#integer range:[-1,99,-1]
		spinner nonDrivenWheel2 width:widthA pos:[colD,placementPos] type:#integer range:[-1,99,-1]
		spinner nonDrivenWheel3 width:widthA pos:[colE,placementPos] type:#integer range:[-1,99,-1]
		spinner nonDrivenWheel4 width:widthA pos:[colF,placementPos] type:#integer range:[-1,99,-1]
	groupbox steeringWheelsGroup "Rotating Wheels" pos:[4, placementPos+=itemheight] width:(width-8) height:((itemheight*4)+6)
		listbox steeringWheels height:3 pos:[colA,placementPos+=itemheight] width:widthC
		button steeringWheelAdd "Add Wheel" pos:[colE,placementPos] width:widthB
		button steeringWheelDel "Del Wheel" pos:[colE,placementPos+=itemheight] width:widthB
		spinner steeringWheelRef "reference:" fieldwidth:40 width:widthB pos:[colB,placementPos+=(itemheight+6)] type:#integer range:[-1,99,-1] enabled:false
	
	fn updateGroovyFunkRefValues = (
		general = rootnode.carGeneralData
		suspensionFL1.range.z = general.suspensionFL[1]
		suspensionFL2.range.z = general.suspensionFL[2]
		suspensionFL3.range.z = general.suspensionFL[3]
		suspensionFL4.range.z = general.suspensionFL[4]
		suspensionFR1.range.z = general.suspensionFR[1]
		suspensionFR2.range.z = general.suspensionFR[2]
		suspensionFR3.range.z = general.suspensionFR[3]
		suspensionFR4.range.z = general.suspensionFR[4]
		suspensionRL1.range.z = general.suspensionRL[1]
		suspensionRL2.range.z = general.suspensionRL[2]
		suspensionRR1.range.z = general.suspensionRR[1]
		suspensionRR2.range.z = general.suspensionRR[2]
		
		drivenWheel1.range.z = general.wheelsDriven[1]
		drivenWheel2.range.z = general.wheelsDriven[2]
		drivenWheel3.range.z = general.wheelsDriven[3]
		drivenWheel4.range.z = general.wheelsDriven[4]
		nonDrivenWheel1.range.z = general.wheelsNonDriven[1]
		nonDrivenWheel2.range.z = general.wheelsNonDriven[2]
		nonDrivenWheel3.range.z = general.wheelsNonDriven[3]
		nonDrivenWheel4.range.z = general.wheelsNonDriven[4]
		
		steeringWheels.items = for i in general.wheelsSteerable collect (i as string)
		if steeringWheels.items.count > 0 then (
			steeringWheels.selection = 1
			steeringWheelRef.range.z = general.wheelsSteerable[1]
			steeringWheelRef.enabled = true
		)
	)
	
	on groovyFunkRefSetup open do (
		groovyFunkRefSetup.height = placementPos+=itemheight
		updateGroovyFunkRefValues()
	)
	on suspensionFL1 changed val do general.suspensionFL[1] = val
	on suspensionFL2 changed val do general.suspensionFL[2] = val
	on suspensionFL3 changed val do general.suspensionFL[3] = val
	on suspensionFL4 changed val do general.suspensionFL[4] = val
	on suspensionFR1 changed val do general.suspensionFR[1] = val
	on suspensionFR2 changed val do general.suspensionFR[2] = val
	on suspensionFR3 changed val do general.suspensionFR[3] = val
	on suspensionFR4 changed val do general.suspensionFR[4] = val
	on suspensionRL1 changed val do general.suspensionRL[1] = val
	on suspensionRL2 changed val do general.suspensionRL[2] = val
	on suspensionRR1 changed val do general.suspensionRR[1] = val
	on suspensionRR2 changed val do general.suspensionRR[2] = val
		
	on drivenWheel1 changed val do general.wheelsDriven[1] = val
	on drivenWheel2 changed val do general.wheelsDriven[2] = val
	on drivenWheel3 changed val do general.wheelsDriven[3] = val
	on drivenWheel4 changed val do general.wheelsDriven[4] = val
		
	on nonDrivenWheel1 changed val do general.wheelsNonDriven[1] = val
	on nonDrivenWheel2 changed val do general.wheelsNonDriven[2] = val
	on nonDrivenWheel3 changed val do general.wheelsNonDriven[3] = val
	on nonDrivenWheel4 changed val do general.wheelsNonDriven[4] = val
	
	on steeringWheelAdd pressed do (
		append general.wheelsSteerable -1
		steeringWheels.items = for i in general.wheelsSteerable collect (i as string)
		steeringWheelRef.range.z = -1
		steeringWheelRef.enabled = true
	)
	on steeringWheelDel pressed do (
		sel = steeringWheels.selection
		if sel != 0 then (
			deleteitem general.wheelsSteerable sel
			steeringWheels.items = for i in general.wheelsSteerable collect (i as string)
			if sel <= steeringWheels.items.count then (
				steeringWheelRef.range.z = general.wheelsSteerable[sel]
			)
			else(
				if steeringWheels.items.count != 0 then (
					steeringWheels.selection = sel-1
					steeringWheelRef.range.z = general.wheelsSteerable[sel-1]
				)
			)
			if steeringWheels.items.count == 0 then (
				steeringWheelRef.range.z = -1
				steeringWheelRef.enabled = false
			)
		)
	)
	on steeringWheelRef changed val do (
		sel = steeringWheels.selection
		if sel!=0 then (
			general.wheelsSteerable[sel] = val
			steeringWheels.items = for i in general.wheelsSteerable collect (i as string)
		)
	)
	on steeringWheels selected i do (
		if i!=0 then (
			steeringWheelRef.range.z = general.wheelsSteerable[i]
		)
	)
)
--createdialog groovyFunkRefSetup width height