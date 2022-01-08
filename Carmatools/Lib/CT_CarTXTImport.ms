--load custom Attributes
filein (libDir + "CT_carCustomAttributes.ms")

custAttributes.add rootnode carGeneralAttributes
fn parseCarTxtFile txtFile = (
--txtFile = getOpenFileName types:"Txt(*.txt)|*.txt" (
	if txtFile != undefined then
	(
		f = openfile txtFile
		
		version = readNextLine f
		if (findstring version "VERSION" == undefined) then (
			print "Not a valid Carmageddon 2 car .txt file"
			exit
		)
		
		rootnode.versionType = (substitutestring version "VERSION " "") as integer
		
		if (peekNextLine f) == "GIRL" then (
			rootnode.isFemale = true
			readNextLine f
		)

		rootnode.carName = readNextLine f
		rootnode.softnessFactor = readNextFloat f
		
		if (readNextLine f) != "START OF DRIVABLE STUFF" then (
			print "Expected \START OF DRIVABLE STUFF\, didn't get it.  Are you sure this is a Car.TXT file?"
		)
		
		rootnode.headPos = readNextVector3 f
		rootnode.headAngles = readNextVector2 f
		mirrorCamera = readNextVector4 f
		rootnode.mirrorPos = [mirrorCamera.x,mirrorCamera.y,mirrorCamera.z]
		rootnode.mirrorAngle = mirrorCamera[4]
		rootnode.pratCamBorders = readNextStrings f
		
		if (readNextLine f) != "END OF DRIVABLE STUFF" then (
			print "Expected \END OF DRIVABLE STUFF\, didn't get it.  Are you sure this is a Car.TXT file?"
		)
		
		engineValues = readNextIntegers f
		rootnode.engineSoundNormal = engineValues[1]
		rootnode.engineSoundTunnel = engineValues[2]
		rootnode.engineSoundUnderwater = engineValues[3]
		
		if (tolower (readNextLine f)) == "stealworthy" then (
			rootnode.stealWorthyness = 1
		)
		else (
			rootnode.stealWorthyness = 0
		)
		
		
		rootnode.damageInfo = #(undefined,undefined,undefined,undefined,undefined,undefined)
		damageInfoNames = #("Top","Bottom","Left","Right","Front","Rear")
		for i=1 to 6 do (
			rootnode.damageInfo[i] = readDamageImpact f damageInfoNames[i]
		)
		
		rootnode.gridImages = readNextStrings f
		
		extraLevelsOfDetail = readNextInteger f
		rootnode.extraLevelsOfDetail = #()
		for i=1 to extraLevelsOfDetail do (
			append rootnode.ExtraLevelsOfDetail (readNextInteger f)
		)
		
		rootnode.wamFile = readNextLine f
		
		rootnode.ReflectiveScreenMaterial = readNextLine f
		rootnode.TransparencyOfWindscreen = readNextInteger f
		
		steerableWheelsCount = readNextInteger f
		rootnode.wheelsSteerable = #()
		for i=1 to steerableWheelsCount do (
			append rootnode.wheelsSteerable (readNextInteger f)
		)
		
		rootnode.suspensionFL = readNextIntegers f
		rootnode.suspensionFR = readNextIntegers f
		rootnode.suspensionRL = readNextIntegers f
		rootnode.suspensionRR = readNextIntegers f
		
		rootnode.wheelsDriven = readNextIntegers f
		rootnode.wheelsNonDriven = readNextIntegers f
		
		rootnode.wheelDiameterDriven = readNextFloat f
		rootnode.wheelDiameterNonDriven = readNextFloat f
		
		if (readNextLine f) != "START OF FUNK" then (
			print "Expected \START OF FUNK\, didn't get it.  Are you sure this is a Car.TXT file?"
		)
		rootnode.Funks = #()
		while ((peekNextLine f) != "END OF FUNK") and not (eof f) do(
			triggerName = readNextLine f
			funk = getSceneMatByName (getClassInstances standard) triggerName
			if funk == undefined then (
				funk = standard name:triggerName
			)
			custAttributes.add funk funk_CA
			
			funk.distance = findIndex #("distance", "constant","lastlap","otherlaps") (readNextLine f)
			funk.animation_type = findIndex #("none", "roll", "slither", "throb","rock") (readNextLine f)
			--print funk.animation_type
			funk.lighting = findIndex #("None") (readNextLine f)
			if funk.animation_type != 1 then (
				funk.animation_mode = findIndex #("harmonic", "linear", "continuous") (readNextLine f)
				if 1 < funk.animation_type and funk.animation_type < 5 then (
					if funk.animation_mode == 3 then (
						funk.animation_grfu = readNextInt f
					)
					else (
						funk.animation_speed = readNextFloat f
					)
				)
				if funk.animation_type == 3 or funk.animation_type == 4 then (
					animationExtent = readNextVector2 f
					funk.animation_extent_x = animationExtent.x
					funk.animation_extent_y = animationExtent.y
				)
				if funk.animation_type == 4 then (
					animationCentre = readNextVector2 f
					funk.animation_centre_x = animationCentre.x
					funk.animation_centre_y = animationCentre.y
				)
				if funk.animation_type == 5 then (
					funk.animation_period = readNextFloat f
					funk.animation_angle = readNextFloat f
					animationCentre = readNextVector2 f
					funk.animation_centre_x = animationCentre.x
					funk.animation_centre_y = animationCentre.y
				)
			)
			funk.sequence_type = findIndex #("none","frames") (readNextLine f)
			if funk.sequence_type == 2 then (
				funk.sequence_playback = findIndex #("approximate","accurate") (readNextLine f)
				funk.sequence_mode = findIndex #("continuous","linear","harmonic","flash","texturebits") (readNextLine f)
				if funk.sequence_mode == 5 then (
					funk.sequence_texturebits = findIndex #("b","bv","v","vb") (readNextLine f)
				)
				else (
					funk.sequence_framerate = readNextFloat f
				)
				frameCount = readNextInteger f
				for i=1 to framecount do (
					frameDetails = readNextStrings f
					append funk.frames_list frameDetails[1]
					if funk.sequence_mode == 5 then (
						append funk.frames_xCounts (frameDetails[2] as integer)
						append funk.frames_xIndexes (frameDetails[3] as integer)
						append funk.frames_yCounts (frameDetails[4] as integer)
						append funk.frames_yIndexes (frameDetails[5] as integer)
					)
					else (
						append funk.frames_xCounts 1
						append funk.frames_xIndexes 1
						append funk.frames_yCounts 1
						append funk.frames_yIndexes 1
					)
				)
			)
			append rootnode.funks funk
			
			if (peekNextLine f) == "NEXT FUNK" then readNextLine f
			
		)
		
		if (readNextLine f) != "END OF FUNK" then (
			print "Expected \END OF FUNK\, didn't get it.  Are you sure this is a Car.TXT file?"
		)
		
		if (readNextLine f) != "START OF GROOVE" then (
			print "Expected \START OF GROOVE\, didn't get it.  Are you sure this is a Car.TXT file?"
		)
		rootnode.Grooves = #()
		while ((peekNextLine f) != "END OF GROOVE") and not (eof f) do (
			triggerName = readNextLine f
			groove = getNodeByName triggerName
			if groove == undefined then (
			)
			else (
				custAttributes.add groove groove_CA
				
				groove.lollipop = findIndex #("none", "xlollipop", "ylollipop", "zlollipop") (readNextLine f)
				groove.distance = findIndex #("distant", "constant") (readNextLine f)
				groove.path_type = findIndex #("no path", "straight", "circular") (readNextLine f)
				if groove.path_type  != 1 then (
					groove.path_mode = findIndex #("linear", "harmonic", "flash","absolute") (readNextLine f)
					pathCentre = readNextVector3 f
					groove.path_centre = pathCentre
					if groove.path_mode == 4 then (
						groove.path_grfu = readNextInteger f
					)
					else (
						groove.path_speed = readNextInteger f
					)
					if groove.path_type == 2 then (
						groove.path_extent = readNextVector3 f
					)
					if groove.path_type == 3 then (
						groove.path_radius = readNextFloat f
						groove.path_axis = findIndex #("x","z","y") (readNextLine f)
					)
				)
				groove.animation_type = findIndex #("none","spin","rock","shear","throb") (readNextLine f)
				if groove.animation_type != 1 then (
					groove.animation_mode = findIndex #("linear","harmonic","flash","continuous","absolute","controlled") (readNextLine f)
					if groove.animation_type == 2 then (
						if groove.animation_mode == 6 then (
							groove.animation_grfu = readNextInteger f
						)
						else (
							groove.animation_speed = readNextFloat f
						)
						groove.animation_centre = readNextVector3 f
						groove.animation_axis = findIndex #("x","z","y") (readNextLine f)
					)
					if groove.animation_type == 3 then (
						if groove.animation_mode == 5 then (
							groove.animation_grfu = readNextInteger f
						)
						else (
							groove.animation_speed = readNextFloat f
						)
						groove.animation_centre = readNextVector3 f
						groove.animation_axis = findIndex #("x","z","y") (readNextLine f)
						groove.animation_angle = readNextFloat f
					)
					if groove.animation_type == 4 or groove.animation_type == 5 then (
						groove.animation_speed = (readNextVector3 f).x
						groove.animation_centre = readNextVector3 f
						groove.animation_extent = readNextVector3 f
					)
				)
				if peekNextLine == "NEXT GROOVE" then readNextLine f
					
				append rootnode.Grooves groove
			)
			
		)
		if (readNextLine f) != "END OF GROOVE" then (
			print "Expected \END OF GROOVE\, didn't get it.  Are you sure this is a Car.TXT file?"
		)
		
		mechanicsVersion = (substitutestring (readNextLine f) "START OF MECHANICS STUFF version " "") as integer
		
		rootnode.turningCircle = readNextFloat f
		rootnode.brakeMultiplier = readNextFloat f
		rootnode.strengthMultiplier = readNextFloat f
		rootnode.gearsNumber = readNextInteger f
		rootnode.topSpeed = readNextInteger f
		rootnode.acceleration = readNextFloat f
		
		rootType = readNextLine f
		rootIdentifier = readNextLine f
		rootnode.actorName = readNextLine f
		
		jointType = readNextLine f
		rootnode.gravityCenter = readNextVector3 f
		rootnode.mass = readNextFloat f
		rootnode.angularMomentum = readNextVector3 f
		rootnode.downForce = readNextFloat f
		
		rootnode.wheelActors = #()
		
		wheelCount = readNextInteger f
		for i=1 to wheelCount do (
			wheelType = readNextInteger f
			wheelIdentifier = findIndex #("","left front", "right front", "left rear", "right rear") (readNextLine f)
			wheelActorName = readNextLine f
			
			wheel = getNodeByName wheelActorName
			if wheel != undefined then (
				custAttributes.add wheel wheelAttributes
				
				wheel.jointType = wheelType
				wheel.actorName = wheelActorName
				wheel.identifier = wheelIdentifier
				wheel.wheelPos = readNextVector3 f
				wheel.steerable = readNextBoolean f
				wheel.driven = readNextBoolean f
				
				wheel.suspensionGive = readNextFloat f
				wheel.dampingFactor = readNextFloat f
				wheel.frictionReduction = readNextFloat f
				frictionAngles = readNextVector2 f
				wheel.frictionAngle1 = frictionAngles[1]
				wheel.frictionAngle2 = frictionAngles[2]
				wheel.tractionMultiplier = readNextFloat f
				wheel.rollingResistance = readNextFloat f
				
				append rootnode.wheelActors wheel
			)
			else (
				for i=1 to 9 do readNextLine f
			)
		)
		
		rootnode.boundingShapes = #()
		boundingShapeCount = readNextInteger f
		for i=1 to boundingShapeCount do (
			boundingShape = undefined
			shapeType = findIndex #("polyhedron","box", "sphere","wire frame") (readNextLine f)
			if shapeType == 1 then (
				pointCount = readNextInteger f
				shapeVertices = #()
				print pointCount
				for j=1 to pointCount do (
					append shapeVertices (readNextVector3 f)
				)
				
				--build polyhedron
				shapeFaces = #()
				for j=1 to pointCount do (
					j1 = j
					j2 = j+1
					j3 = j+2
					
					if j==pointCount then (
						j2 = 1
						j3 = 2
					)
					if j2 == pointCount then (
						j3 = 1
					)
					append shapeFaces [j1,j2,j3]
				)
				dummyShape = mesh name:("boundingShape "+(i as string)) vertices:shapeVertices faces:shapeFaces
				boundingShape = computeConvexHull dummyShape maxVerts:64 pushAmt:0.0 cleanup:true
				delete dummyShape
			)
			if shapeType == 2 then (
				shapeMin = readNextVector3 f
				shapeMax = readNextVector3 f
				
				w = shapeMax.x - shapeMin.x
				l = -shapeMin.y - -shapeMax.y
				h = shapeMax.z - shapeMin.z
				
				boundingShape = box name:("boundingShape "+(i as string)) width:w length:l height:h
				boundingShape.pos = boundingShape.center - [0,0,h]
				centerPivot boundingShape
				convertto boundingShape editable_poly
			)
			if shapeType == 3 then (
				radius = readNextFloat f
				center = readNextVector3 f
				boundingShape = sphere radius:radius name:("boundingShape "+(i as string))
				centerPivot boundingShape
				boundingShape.pos = center
				convertto boundingShape editable_poly
			)
			if shapeType == 4 then (
				numberOfPoints = readNextInteger f
				Points = for i=1 to numberOfPoints collect readNextVector3 f
				numberOfSegments = readNextInteger f
				Segments = for i=1 to numberOfSegments collect readNextVector2 f
				
				
				boundingShape = SplineShape pos:[0,0,0] name:("boundingShape "+(i as string)) 
				addNewSpline boundingShape
				for i=1 to numberOfPoints do (
					addKnot boundingShape 1 #corner #line Points[i]
				)
				updateShape boundingShape
			)
			
			if boundingShape != undefined then (
				custAttributes.add boundingShape boundingShapeAttributes
				boundingShape.boundingShapeType = shapeType
				append rootnode.boundingShapes boundingShape
			)
		)
		
		numberOfSubParts = readNextInteger f
		
		if (readNextLine f) != "END OF MECHANICS STUFF" then (
			print "Expected \END OF MECHANICS STUFF\, didn't get it.  Are you sure this is a Car.TXT file?"
		)
		
		rootnode.shrapnelColors = #()
		numberOfShrapnelColors = readNextInteger f
		if numberOfShrapnelColors > 0 then (
			for i=1 to numberOfShrapnelColors do (
				shrapnel = peekNextLine f
				if (filterString shrapnel ",	 ").count > 1 then (
					colorValues = readNextIntegers f
					c = (color colorValues[1] colorvalues[2] colorvalues[3]) as string
					append rootnode.shrapnelColors c
				)
				else (
					append rootnode.shrapnelColors (readNextLine f)
				)
			)
		)
		
		for i=1 to 12 do (
			rootnode.firePoints[i] = readNextInteger f
		)
		
		do (
			l = readNextLine f
			if l == "CAMERA_POSITIONS" then (
				rootnode.cameraPosBumper = readNextVector3 f
				rootnode.cameraPosCockpit = readNextVector3 f
			)
			
			if l == "CAMERA_TURN_OFF_MATERIALS" then (
				rootnode.cameraTurnOffMats = #()
				
				numberOfMats = readNextInteger f
				for i=1 to numberOfMats do (
					turnOffMat = standard name:(readNextLine f)
					custAttributes.add turnOffMat cameraTurnOffMatAttributes
					numberOfBitmaps = readNextInteger f
					for j=1 to numberOfBitmaps do (
						append turnOffMat.cameraTurnOffBitmaps (readNextLine f)
					)
					append rootnode.cameraTurnOffMats turnOffMat
				)
			)
			
		)while ((peekNextLine f)!= "END")
		close f
	)
)