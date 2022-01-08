txt_name = GetSaveFileName caption:"Choose an exportname" types:"Txt(*.txt)|*.txt"
if txt_name != undefined do
(
	txt_file = createfile txt_name
	--file and version info
	format "VERSION 2\n\n" to:txt_file
	writeLine #((getfileNameFile txt_name + ".txt")) "// Name of Car\n\n" txt_file
	writeLine #(rootnode.softnessFactor) "// Softness factor\n\n" txt_file
	
	--drivable stuff, mostly c1 stuff
	format "START OF DRIVABLE STUFF\n\n" to:txt_file
	writeLine #(rootnode.headPos.x,rootnode.headPos.z, -rootnode.headPos.y) "// Offset of driver's head in 3D space\n" txt_file
	writeLine #(rootnode.headAngles.x, rootnode.headAngles.y) "// Angles to turn to make head go left and right\n" txt_file
	writeLine #(rootnode.mirrorPos.x,rootnode.mirrorPos.z, -rootnode.mirrorPos.y, rootnode.mirrorAngle) "// Offset of 'mirror camera' in 3D space, viewing angle of mirror\n" txt_file
	writeLine #("none,none,PRATBDRT.PIX,PRATBDHZ.PIX") "// Pratcam border names (left, top, right, bottom)\n\n" txt_file
	format "END OF DRIVABLE STUFF\n\n" to:txt_file

	--engine noise and stealworthy
	writeLine #(rootnode.engineSoundNormal, rootnode.engineSoundTunnel, rootnode.engineSoundUnderwater) "// Engine noise (normal, enclosed space, underwater)\n\n" txt_file

	if rootnode.stealWorthyness == 1 then (
		writeLine #("stealworthy") "// Can be stolen\n\n" txt_file
	)
	else (
		writeLine #("stealunworthy") "// Can't be stolen\n\n" txt_file
	)
	
	--damage impacts
	systemCases = #("engine","transmission","driver","steering","lf_wheel","rf_wheel","lr_wheel","rr_wheel","lf_brake","rf_brake","lr_brake","rr_brake")
	for info in rootnode.damageInfo do (
		format ("// Damage info for " + info.name + " impacts\n") to:txt_file
		writeLine #(info.damageClauses.count) "// Number of clauses\n" txt_file
		for clause in info.damageClauses do (
			writeLine #(clause.name) "// Condition\n" txt_file indent:1
			systemsCount = clause.damageIds.count
			writeLine #(systemsCount) "// Systems count\n" txt_file indent:1
			for i=1 to systemsCount do (
				writeLine #(systemCases[(clause.damageIds[i])],clause.damageValues[i]) "// Damage\n" txt_file indent:2
			)
		)
		format "\n" to:txt_file
	)
	--grid images
	writeLine #("GEAGLEF.PIX","GEAGLEF.PIX","GEAGLEA.PIX") "// Grid image (opponent, frank, annie)\n\n" txt_file
	
	writeLine #(1) "// Number of extra levels of detail\n" txt_file
	writeLine #(8) "// Minimum distantance squared\n\n" txt_file

	writeLine #(getfileNameFile txt_name+ ".wam") "// crush data file (will be incorporated into this file)\n\n" txt_file

	writeLine #("CARWSCRN.PIX") "// Name of reflective screen material (or none if non-reflective)\n" txt_file
	writeLine #(100) "// Percentage transparency of windscreen\n\n" txt_file

	--steerable wheels
	writeLine #(rootnode.wheelsSteerable.count) "// Number of steerable wheels\n" txt_file
	for i=1 to rootnode.wheelsSteerable.count do (
		groovyFunkRef = rootnode.wheelsSteerable[i]
		writeLine #(groovyFunkRef) ("// GroovyFunkRef of steerable wheel " + (i as string) + "\n") txt_file
	)
	format "\n" to:txt_file

	--suspensions
	writeLine #(rootnode.suspensionFL[1],rootnode.suspensionFL[2],rootnode.suspensionFL[3],rootnode.suspensionFL[4]) "// Left-front suspension parts GroovyFunkRef\n" txt_file
	writeLine #(rootnode.suspensionFR[1],rootnode.suspensionFR[2],rootnode.suspensionFR[3],rootnode.suspensionFR[4]) "// Right-front suspension parts GroovyFunkRef\n" txt_file
	writeLine #(rootnode.suspensionRL[1],rootnode.suspensionRL[2]) "// Left-rear suspension parts GroovyFunkRef\n" txt_file
	writeLine #(rootnode.suspensionFL[1],rootnode.suspensionFL[2]) "// Right-rear suspension parts GroovyFunkRef\n\n" txt_file

	--wheels
	writeLine #(rootnode.wheelsDriven[1],rootnode.wheelsDriven[2],rootnode.wheelsDriven[3],rootnode.wheelsDriven[4]) "// Driven wheels GroovyFunkRefs (for spinning) - MUST BE 4 ITEMS\n" txt_file
	writeLine #(rootnode.wheelsNonDriven[1],rootnode.wheelsNonDriven[2],rootnode.wheelsNonDriven[3],rootnode.wheelsNonDriven[4]) "// Non-driven wheels GroovyFunkRefs (for spinning) - MUST BE 4 ITEMS\n\n" txt_file

	writeLine #(rootnode.wheelDiameterDriven) "// Driven wheels diameter\n" txt_file
	writeLine #(rootnode.wheelDiameterNonDriven) "// Non-driven wheels diameter\n\n" txt_file

	--funks
	format "START OF FUNK\n\n" to:txt_file
	funkCount = rootnode.funks.count
	if funkCount != 0 do
	(
		for i=1 to funkCount do
		(
			mat = rootnode.funks[i]
			writeline #(mat.name) "// Material name\n" txt_file
			funk_distance_strings = #("distance", "constant","lastlap","otherlaps")
			writeline #(funk_distance_strings[mat.distance]) "// Distance\n" txt_file
			
			funk_animation_strings = #("piss off", "roll", "slither", "throb", "rock")
			writeline #(funk_animation_strings[mat.animation_type]) "// Animation type\n" txt_file
			if mat.animation_type != 1 do
			(
				funk_animation_mode_strings = #("harmonic", "linear", "continuous","controlled") 
				writeline #(funk_animation_mode_strings[mat.animation_mode]) "// Animation mode\n" txt_file
			)
			if mat.animation_type != 1 and mat.animation_type != 5 do (
				if mat.animation_mode == 4 then (
					writeLine #(-1,mat.animation_grfu) "// Animation speed (by groovyFunkRef)"
				)
				else (
					writeline #(mat.animation_speed_x,mat.animation_speed_y) "// Animation speed\n" txt_file
				)
			)
			if mat.animation_type == 3 do writeline #(mat.animation_extent_x,mat.animation_extent_y) "// Animation extent\n" txt_file indent:2
			if mat.animation_type == 4 do
			(
				writeline #(mat.animation_extent_x,mat.animation_extent_y) "// Animation extent\n" txt_file
				writeline #(mat.animation_centre_x,mat.animation_centre_y) "// Animation centre\n" txt_file
			)
			if mat.animation_type == 5 do
			(
				writeline #(mat.animation_period) "// Animation period\n" txt_file
				writeline #(mat.animation_angle) "// Animation angle\n" txt_file
				writeline #(mat.animation_centre_x,mat.animation_centre_y) "// Animation centre\n" txt_file
			)
			writeline #("no fucking lighting") "// Lighting\n" txt_file
			funk_sequence_strings = #("none","frames")
			writeline #(funk_sequence_strings[mat.sequence_type]) "// Sequence\n" txt_file
			if mat.sequence_type == 2 do
			(
				funk_playback_strings = #("approximate","accurate")
				writeline #(funk_playback_strings[mat.sequence_playback]) "// Playback\n" txt_file
				funk_sequence_type_stings = #("continuous","linear","harmonic","flash","texturebits")
				writeline #(funk_sequence_type_stings[mat.sequence_mode]) "// Sequence type\n" txt_file
				if mat.sequence_mode == 5 then (
					textureBitTypes = #("B","BV","V","VB")
					writeLine #(textureBitTypes[mat.sequence_texturebits]) "// Control type\n" txt_file
				)
				else (
					writeline #(mat.sequence_framerate) "// framerate\n" txt_file
				)
				
				writeline #(mat.frames_list.count) "// frame count\n" txt_file
				for j=1 to mat.frames_list.count do
				(
					frame = mat.frames_list[j]
					if mat!=undefined then (
						if mat.sequence_mode == 5 then (
							if mat.frames_xCounts[j] > 1 or mat.frames_yCounts[j] > 1  then
							( 
								writeline #(frame,mat.frames_xCounts[j],mat.frames_xIndexes[j],mat.frames_yCounts[j],mat.frames_yIndexes[j]) "// frame texturebits\n" txt_file
							)
							else writeline #(frame) "// frame\n" txt_file
						)
						else (
							writeline #(frame) "// frame\n" txt_file
						)
					)
				)
			)
			format "\n" to:txt_file
			if i != rootnode.funks.count do format "NEXT FUNK\n\n" to:txt_file
		)
	)
	format "END OF FUNK\n\n" to:txt_file

	--grooves
	format "START OF GROOVE\n\n" to:txt_file
	if rootnode.grooves.count != 0 do
	(
		for i=1 to rootnode.grooves.count do
		(
			groove = rootnode.grooves[i]
			writeLine #(groove.name) "// Actor Name\n" txt_file
			lollipops=#("none","xlollipop","ylollipop","zlollipop")
			writeLine #(lollipops[groove.lollipop]) "// Lollipop\n" txt_file
			
			if groove.distance == 1 do writeLine #("Distance") "// Rendering distance\n" txt_file
			if groove.distance  == 2 do writeLine #("Constant") "// Rendering distance\n" txt_file
			
			path_types = #("No path","Straight","Circular")
			path_modes = #("Linear", "Harmonic", "Flash","Absolute")
			writeLine #(path_types[groove.path_type]) "// Path Type\n" txt_file
			if groove.path_type != 1 do
			(
				writeLine #(path_modes[groove.path_mode]) "// Path Mode\n" txt_file
				writeLine #(groove.path_centre.x,groove.path_centre.z,-groove.path_centre.y) "// Centre\n" txt_file
				if groove.path_mode == 4 then (
					writeLine #(groove.path_grfu) "// GroovyFunkRef\n" txt_file
				)
				else (
					writeLine #(groove.path_speed) "// Speed\n" txt_file
				)
				if groove.path_type  == 2 do
				(
					writeLine #(groove.path_extent.x,groove.path_extent.z,-groove.path_extent.y) "// Extent\n" txt_file
				)
				if groove.path_type  == 3 do
				(
					writeLine #(groove.path_radius) "// Radius\n" txt_file
					path_axiss = #("x","z","y")
					writeLine #(path_axiss[groove.path_axis]) "// Axis\n" txt_file
				)
			)
			animation_types = #("None","Spin","Rock","Shear","Throb")
			animation_modes = #("Linear","Harmonic","Flash","Continuous","Absolute","Controlled")
			animation_axis = #("x","z","y")
			writeLine #(animation_types[groove.animation_type]) "// Animation Type\n" txt_file
			if groove.animation_type != 1 do
			(
				writeLine #(animation_modes[groove.animation_mode]) "// Animation Mode\n" txt_file
				if groove.animation_type  == 2 do 
				(
					if groove.animation_mode == 6 then (
						writeLine #(groove.animation_grfu) "// GroovyFunkRef\n" txt_file
					)
					else (
						writeLine #(groove.animation_speed) "// Speed\n" txt_file
					)
					writeLine #(groove.animation_centre.x,groove.animation_centre.z,-groove.animation.centre_y) "// Centre\n" txt_file
					writeLine #(animation_axis[groove.animation_axis]) "// Axis\n" txt_file
				)
				if groove.animation_type  == 3 do 
				(
					if groove.animation_mode == 5 then (
						writeLine #(groove.animation_grfu) "// GroovyFunkRef\n" txt_file
					)
					else (
						writeLine #(groove.animation_speed) "// Speed\n" txt_file
					)
					writeLine #(groove.animation_centre.x,groove.animation.centre_z,-groove.animation.centre_y) "// Centre\n" txt_file
					writeLine #(animation_axis[groove.animation_axis]) "// Axis\n" txt_file
					writeLine #(groove.animation_angle) "// Angle\n" txt_file
				)
				if groove.animation_type  == 4 or groove.animation_type == 5 do 
				(
					writeLine #(groove.animation_speed,groove.animation_speed,groove.animation_speed) "// Speed\n" txt_file
					writeLine #(groove.animation_centre.x,groove.animation.centre_z,-groove.animation_centre.y) "// Centre\n" txt_file
					writeLine #(groove.animation_extent.x,groove.animation.extent_z,-groove.animation_extent.y) "// Extent\n" txt_file
				)
			)
			if i != rootnode.grooves.count do
			(
				format "\nNEXT GROOVE\n\n" to:txt_file
			)
		)
	)
	format "\nEND OF GROOVE\n\n" to:txt_file

	--mechanics stuff
	format "START OF MECHANICS STUFF version 1\n\n" to:txt_file
	writeLine #(rootnode.turningCircle) "// Minimum turning circle.\n" txt_file
	writeLine #(rootnode.brakeMultiplier) "// Brake multiplier.\n" txt_file
	writeLine #(rootnode.strengthMultiplier) "// Brake strength multiplier.\n" txt_file
	writeLine #(rootnode.gearsNumber) "// Number of gears.\n" txt_file
	writeLine #(rootnode.topSpeed) "// Speed at red line in highest gear.\n" txt_file
	writeLine #(rootnode.acceleration) "// Acceleration in highest gear (m/s^2) i.e. engine strength.\n\n" txt_file

	format "// Sub member: Root part\n" to:txt_file
	writeLine #("Normal") "// Type\n" txt_file
	writeLine #("None") "// Identifier\n" txt_file
	writeLine #(rootnode.actorName) "// Actor\n" txt_file
	format "// Sub member: Joint data\n" to:txt_file
	writeLine #("None") "// Type\n" txt_file
	writeLine #(rootnode.gravityCenter.x,rootnode.gravityCenter.z,-rootnode.gravityCenter.y) "// Centre of mass\n" txt_file
	writeLine #(rootnode.mass) "// Mass\n" txt_file
	writeLine #(rootnode.angularMomentum.x,rootnode.angularMomentum.z,-rootnode.angularMomentum.y) "// Angular momentum proportions\n" txt_file
	writeLine #(rootnode.downForce) "// Downforce-to-weight balance speed\n" txt_file

	writeLine #(rootnode.wheelActors.count) "// Number of 'Wheels' entries.\n" txt_file
	for i=1 to rootnode.wheelActors.count do (
		wheel = rootnode.wheelActors[i]
		format ("// Wheels entry #"+(i as string )+"\n") to:txt_file
		writeLine #(0) "// Type\n" txt_file
		identifiers = #("","left front","right front","left rear","right rear")
		writeLine #(identifiers[wheel.identifier]) "// Identifier\n" txt_file
		writeLine #(wheel.name) "// Actor\n" txt_file
		writeLine #(wheel.wheelPos.x,wheel.wheelPos.z,-wheel.wheelPos.y) "// Position\n" txt_file
		
		if wheel.steerable then writeLine #(1) "// Steerable flags\n" txt_file
		else writeLine #(0) "// Steerable flags\n" txt_file
		
		if wheel.driven then writeLine #(1) "// Driven flags\n" txt_file
		else writeLine #(0) "// Driven flags\n" txt_file
		
		writeLine #(wheel.suspensionGive) "// Suspension give\n" txt_file
		writeLine #(wheel.dampingFactor) "// Damping factor\n" txt_file
		writeLine #(wheel.frictionReduction) "// Fractional reduction in friction when slipping\n" txt_file
		writeLine #(wheel.frictionAngle1,wheel.frictionAngle2) "// Friction angles\n" txt_file
		writeLine #(wheel.tractionMultiplier) "// Traction fractional multiplier\n" txt_file
		writeLine #(wheel.rollingResistance) "// Rolling resistance\n" txt_file
	)
	format "\n" to:txt_file


	writeBoundingShapes rootnode.boundingShapes txt_file
	
	writeLine #(0) "// Number of sub-parts.\n\n" txt_file

	format "END OF MECHANICS STUFF\n\n" to:txt_file

	format "// Materials for shrapnel\n" to:txt_file
	writeLine #(rootnode.shrapnelColors.count) "// number of materials\n" txt_file
	for col in rootnode.shrapnelColors do (
		col = execute col
		writeLine #(col.r,col.g,col.b) "// Color values\n" txt_file
	)
	format "\n" to:txt_file

	format "// Damage vertices fire points\n" to:txt_file
	writeLine #(rootnode.firePoints[1]) "// Engine\n" txt_file
	writeLine #(rootnode.firePoints[2]) "// Transmission\n" txt_file
	writeLine #(rootnode.firePoints[3]) "// Driver\n" txt_file
	writeLine #(rootnode.firePoints[4]) "// Steering\n" txt_file
	writeLine #(rootnode.firePoints[5]) "// Left front brake\n" txt_file
	writeLine #(rootnode.firePoints[6]) "// Right front brake\n" txt_file
	writeLine #(rootnode.firePoints[7]) "// Left rear brake\n" txt_file
	writeLine #(rootnode.firePoints[8]) "// Right rear brake\n" txt_file
	writeLine #(rootnode.firePoints[9]) "// Left front wheel\n" txt_file
	writeLine #(rootnode.firePoints[10]) "// Right front wheel\n" txt_file
	writeLine #(rootnode.firePoints[11]) "// Left rear wheel\n" txt_file
	writeLine #(rootnode.firePoints[12]) "// Right rear wheel\n\n" txt_file

	format "// Start of keyword stuff\n\n" to:txt_file
	
	format "CAMERA_POSITIONS\n" to:txt_file
	writeLine #((roundTo rootnode.cameraPosBumper.x 3),(roundTo rootnode.cameraPosBumper.z 3),(roundTo -rootnode.cameraPosBumper.y 3)) "// Bumper position\n" txt_file
	writeLine #((roundTo rootnode.cameraPosCockpit.x 3),(roundTo rootnode.cameraPosCockpit.z 3),(roundTo -rootnode.cameraPosCockpit.y 3)) "// Cockpit position\n\n" txt_file

	if rootnode.cameraTurnOffMats.count > 0 then (
		format "CAMERA_TURN_OFF_MATERIALS\n" to:txt_file
		writeLine #(rootnode.cameraTurnOffMats.count) "// Material count\n" txt_file
		for mat in rootnode.cameraTurnOffMats do (
			writeLine #(mat.name) "// Material name\n" txt_file
			writeLine #(mat.cameraTurnOffBitmaps.count) "// Bitmap count\n\n" txt_file
			for bm in mat.cameraTurnOffBitmaps do (
				writeLine #(bm) "// Bitmap name\n\n" txt_file
			)
		)
	)

	format "// End of keyword stuff\n\n" to:txt_file

	format "END\n" to:txt_file

	close txt_file
)