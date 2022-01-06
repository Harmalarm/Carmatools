carGeneralAttributes = attributes carGeneralData attribID:#(0x4355c32d, 0x76c6fa01) (
	parameters carGeneralParameters (
		versionType type:#integer default:2
		isFemale type:#boolean default:false
		carName type:#string default:""
		
		softnessFactor type:#float default:0.7
		headPos type:#point3 default:[0,0,0]
		headAngles type:#point3 default:[80,-80,0]
		mirrorPos type:#point3 default:[0,0,0]
		mirrorAngle type:#float default:45.0
		pratCamBorders type:#stringTab tabsize:0 tabsizeVariable:true
		engineSoundNormal type:#integer default:5300
		engineSoundTunnel type:#integer default:5301
		engineSoundUnderwater type:#integer default:5302
		stealWorthyness type:#integer default:1
		
		damageInfo type:#materialTab tabsize:6 tabsizeVariable:false
		
		gridImages type:#stringTab tabsize:0 tabsizeVariable:true
		extraLevelsOfDetail type:#inttab tabsize:0 tabsizeVariable:true
		
		lodCount type:#integer default:0
		minDistanceSquared type:#integer default:8
		
		wamFile type:#string
		
		ReflectiveScreenMaterial type:#string
		TransparencyOfWindscreen type:#integer default:100
		
		wheelsSteerable type:#inttab tabsize:0 tabsizevariable:true default:-1
		suspensionFL type:#inttab tabsize:4 tabsizevariable:false default:-1
		suspensionFR type:#inttab tabsize:4 tabsizevariable:false default:-1
		suspensionRL type:#inttab tabsize:2 tabsizevariable:false default:-1
		suspensionRR type:#inttab tabsize:2 tabsizevariable:false default:-1
		
		wheelsDriven type:#inttab tabsize:4 tabsizevariable:false default:-1
		wheelsNonDriven type:#inttab tabsize:4 tabsizevariable:false default:-1
		
		wheelDiameterDriven type:#float default:0.14
		wheelDiameterNonDriven type:#float default:0.14
		
		funks type:#materialtab tabsize:0 tabSizeVariable:true
		grooves type:#nodetab tabsize:0 tabSizeVariable:true
		
		
		turningCircle type:#float default:0.5
		brakeMultiplier type:#float default:1.0
		strengthMultiplier type:#float default:1.0
		gearsNumber type:#integer default:6
		topSpeed type:#integer default:200
		acceleration type:#float default:5.0
		
		actorName type:#string default:"*.ACT"
		gravityCenter type:#point3 default:[0,0,0]
		angularMomentum type:#point3 default:[0,0,0]
		mass type:#float default:1.5
		downForce type:#float default:50
		
		wheelActors type:#nodeTab tabsize:0 tabsizevariable:true
		
		boundingShapes type:#nodetab tabsize:0 tabsizevariable:true
		
		shrapnelColors type:#stringtab tabsize:0 tabsizevariable:true 
		
		firePoints type:#intTab tabsize:12 tabsizevariable:false
		
		cameraPosBumper type:#point3 default:[0,0,0]
		cameraPosCockpit type:#point3 default:[0,0,0]
		
		cameraTurnOffMats type:#materialTab tabsize:0 tabsizevariable:true
		
		wamCrushLimits type:#floattab tabsize:12 default:0
		xMins type:#floattab tabsize:2 tabsizevariable:true default:0
		xMaxs type:#floattab tabsize:2 tabsizevariable:true default:0
		yMins type:#floattab tabsize:2 tabsizevariable:true default:0
		yMaxs type:#floattab tabsize:2 tabsizevariable:true default:0
		zMins type:#floattab tabsize:2 tabsizevariable:true default:0
		zMaxs type:#floattab tabsize:2 tabsizevariable:true default:0
		
		bendabillityFactor type:#float default:1
		bendPointZmin type:#float default:-0.05
		bendPointZmax type:#float default:0.1
		snappabillityFactor type:#float default:1
		ySplitPosition type:#float default:0
		driverPos type:#point3 default:[0.0,0.0,0.0]
		
		wamEntries type:#nodetab tabsize:0 tabsizevariable:true
		current_connotations type:#material
	) 
)

wamEntryAttributes = attributes wamEntryData attribID:#(0x6478c3cd, 0x76c6fa01) (
	parameters wamEntryParamters (
		softness type:#integer default:1
		crushType type:#integer default:1
		shape type:#integer default:1
		detachEase type:#integer default:1
		detachType type:#integer default:1
		flapEase type:#integer default:1
		flapHingePoint1 type:#integer default:0
		flapHingePoint2 type:#integer default:0
		flapHingePoint3 type:#integer default:0
		flapOpenable type:#boolean default:false
		smashEntries type:#materialTab tabsize:0 tabsizeVariable:true
	)
)

wheelAttributes = attributes wheelData attribID:#(0x7b20ad9, 0x41357701) (
	parameters wheelParameters (
		jointType type:#integer default:0
		wheelPos type:#point3 default:[0,0,0]
		actorName type:#string default:""
		identifier type:#integer default:1
		steerable type:#boolean default:false
		driven type:#boolean default:false
		suspensionGive type:#float default:0.01
		dampingFactor type:#float default:1
		frictionReduction type:#float default:1
		frictionAngle1 type:#float default:79.5
		frictionAngle2 type:#float default:80.5
		tractionMultiplier type:#float default:2
		rollingResistance type:#float default:0.05
	)
)

wamGeneralAttributes = attributes wamGeneralData attribID:#(0x7d18bd8, 0x188118fb) (
	parameters wamGeneralParamters (
		wam_lims type:#floattab tabsize:12 default:0
		bendabillity_factor type:#float default:1
		bend_point_zmin type:#float default:-0.05
		bend_point_zmax type:#float default:0.1
		snappabillity_factor type:#float default:1
		y_split_position type:#float default:0
		driver_pos_x type:#float default:0.05
		driver_pos_y type:#float default:0.0
		driver_pos_z type:#float default:0.1
		
		wams type:#nodetab tabsize:0 tabsizevariable:true
	)
)

boundingShapeAttributes = attributes boundingShapeData attribID:#(0x4601d78, 0x21adb7eb) (
	parameters boundingShapeParamters (
		boundingShapeType type:#integer default:1
	)
)

cameraTurnOffMatAttributes = attributes cameraTurnOffMatData attribID:#(0x2556b84a, 0x4cdceabb) (
	parameters cameraTurnOffMatParameters (
		cameraTurnOffBitmaps type:#stringTab tabsize:0 tabsizevariable:true
	)
)

damageInfoImpactAttributes = attributes damageInfoImpactData attribID:#(0x7c59823, 0x46060c78) (
	parameters damageInfoImpactParameters (
		damageClauses type:#materialtab tabsize:0 tabsizevariable:true
	)
)

damageInfoClauseAttributes = attributes damageInfoClauseData attribID:#(0x7c59823, 0x42060c78) (
	parameters damageInfoClauseParameters (
		damageIds type:#inttab tabsize:0 tabsizevariable:true
		damageValues type:#floattab tabsize:0 tabsizevariable:true
	)
)