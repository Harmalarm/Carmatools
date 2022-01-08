if noncar!=undefined do
(
	txt_name = GetSaveFileName caption:"Choose an exportname" types:"Txt(*.txt)|*.txt"
	if txt_name != undefined then
	(
		txt_file = createfile txt_name
		
		writeLine #(101) "// Version number\n" txt_file
		writeLine #(noncar.index) "// Noncar number\n\n" txt_file
		
		writeLine #(noncar.dc_x,noncar.dc_z,-noncar.dc_y) "// Centre point\n" txt_file
		writeLine #(noncar.ac_x,noncar.ac_z,-noncar.ac_y) "// Centre point when attached\n\n" txt_file
		
		writeBoundingShapes noncar.bounding_shapes txt_file
		
		writeLine #(noncar.mass_a, noncar.mass_d) "// Mass unattached/attached\n" txt_file
		
		noncar_width = noncar.max.x - noncar.min.x
		noncar_length =noncar.max.y - noncar.min.y
		noncar_height =noncar.max.z - noncar.min.z
		writeLine #((roundTo noncar_width 3),(roundTo noncar_height 3),(roundTo noncar_length 3)) "// Total width, height and length\n" txt_file
		writeLine #(noncar.bend_angle) "// Bend angle\n" txt_file
		writeLine #(noncar.torque) "// Torque needed to move noncar\n" txt_file
		writeLine #(1) "// Materials for shrapnel\n" txt_file
		writeLine #("M14.MAT") "\n\n" txt_file

		writeLine #("// Start of Keyword data") "\n\n" txt_file
		
		
		
		if noncar.infinite_i do writeLine #("INFINITE_I") "\n" txt_file
		if noncar.driveable_on do format "DRIVABLE_ON\n" to:txt_file
		if noncar.sparky do format "SPARKY\n" to:txt_file
		if noncar.block_cam do format "BLOCK_CAMERA\n" to:txt_file
		if noncar.tumble do
		(
			format "TUMBLE\n" to:txt_file
			writeLine #(noncar.tumble_factor) "// Tumble factor\n" txt_file
			writeLine #(noncar.tumble_threshold) "// Tumble threshhold\n" txt_file
		)
		if noncar.world_friction do
		(
			format "WORLD_FRICTION\n" to:txt_file
			writeLine #(noncar.wf_amount) "// Amount of friction\n" txt_file
		)
		if noncar.object_friction do
		(
			format "OBJECT_FRICTION\n" to:txt_file
			writeLine #(noncar.of_amount) "// Amount of friction\n" txt_file
		)
		joint_type = noncar.joint_type
		if joint_type > 1 then (
			if joint_type == 2 do
			(
				format "WORLD_BALL_JOINT\n" to:txt_file
				writeLine #(noncar.joint_c1_x,noncar.joint_c1_z,-noncar.joint_c1_y) "// Joint center point\n" txt_file
				writeLine #(noncar.joint_friction) "// Friction\n" txt_file
				writeLine #(noncar.joint_limits) "// Num limits\n" txt_file
			)
			if joint_type == 3 do
			(
				format "WORLD_HINGE_JOINT\n" to:txt_file
				writeLine #(noncar.joint_c1_x,noncar.joint_c1_z,-noncar.joint_c1_y) "// Joint point a\n" txt_file
				writeLine #(noncar.joint_c2_x,noncar.joint_c2_z,-noncar.joint_c2_y) "// Joint point b\n" txt_file
				writeLine #(noncar.joint_friction) "// Friction\n" txt_file
				writeLine #(noncar.joint_limits) "// Num limits\n" txt_file
			)
			if joint_type == 4 do
			(
				format "WORLD_TRANSLATION_JOINT\n" to:txt_file
				writeLine #(0,0,0) "// Joint center point\n" txt_file
				writeLine #(noncar.joint_c1_x,noncar.joint_c1_z,-noncar.joint_c1_y) "// Translation axis\n" txt_file
				writeLine #(noncar.joint_distance) "// Translation distance\n" txt_file
				writeLine #(noncar.joint_fa) "// Forward acceleration\n" txt_file
				writeLine #(noncar.joint_ra) "// Reverse acceleration\n" txt_file
				writeLine #(noncar.joint_fr) "// Forward resistance\n" txt_file
				writeLine #(noncar.joint_rr) "// Reverse resistance\n" txt_file
				writeLine #(noncar.joint_pauze) "// Pauze at end\n" txt_file
				if noncar.joint_ign_wc do format "IGNORE_WORLD_COLLISIONS\n" to:txt_file
				if noncar.joint_rise_on == 1 do format "RISE_WHEN_DRIVEN_ON\n" to:txt_file
				if noncar.joint_rise_on == 2 do format "RISE_WHEN_HIT\n" to:txt_file
				format "NUMBER_OF_PUSHES\n" to:txt_file
				writeLine #(noncar.joint_pushes) "// Number of pushes\n" txt_file
			)
		)
		format "\nEND" to:txt_file
		close txt_file
	)
)