--creating the export txt file. If not undefined continue the export. If undefined, quit the export
txt_name = GetSaveFileName caption:"Choose an exportname" types:"Txt(*.txt)|*.txt"
if txt_name != undefined do
(
	txt_file = createfile txt_name
	--try (
		-- here follows the literal txt file text, all in order
		format "VERSION 1\n\n" to:txt_file
		--GLOBAL LIGHTING DATA
		writeLine #((rootnode.main_directional_light_source.r as integer),(rootnode.main_directional_light_source.g as integer),(rootnode.main_directional_light_source.b as integer)) "//Lighting colour\n" txt_file
		writeLine #(rootnode.ambient_ambient_0,rootnode.ambient_diffuse_0) "// Lighting when Ambient set to 0\n" txt_file
		writeLine #(rootnode.ambient_ambient_1,rootnode.ambient_diffuse_1) "// Lighting when Ambient set to 1\n" txt_file
		writeLine #(rootnode.ambient_ambient_2,rootnode.ambient_diffuse_2) "// Lighting when Ambient set to 2\n\n" txt_file

		--STARTING GRID
		if rootnode.startg != undefined then (
			writeLine #((round rootnode.startg.pos.x),(round rootnode.startg.pos.z),(round -rootnode.startg.pos.y)) "// Starting grid position\n" txt_file
			writeLine #((rootnode.startg.rotation.z_rotation)) "// Starting grid rotation\n\n" txt_file
		)
		else (
			writeLine #(0,0,0) "// Starting grid position\n" txt_file
			writeLine #(0) "// Starting grid rotation\n\n" txt_file
		)
		--CHECKPOINTS
		writeLine #(rootnode.checkp.count) "// Number of checkpoints\n\n" txt_file
		if rootnode.checkp.count != 0 then
		(
			for checkp in rootnode.checkp do
			(
				if isvalidnode checkp then
				(
					pointcount = getnumverts (snapshotasmesh checkp)
					writeLine #(checkp.bonus_1,checkp.bonus_2,checkp.bonus_3) "// Timer increment for each skill level (ped mode)\n" txt_file
					writeLine #(1) "// Number of quads\n" txt_file
					pointindex1 = getvert (snapshotasmesh checkp) 1
					pointindex2 = getvert (snapshotasmesh checkp) 2
					pointindex3 = getvert (snapshotasmesh checkp) 3
					pointindex4 = getvert (snapshotasmesh checkp) 4
					writeLine #((round pointindex1.x),(round pointindex1.z),(round -pointindex1.y)) "// Point #0\n" txt_file
					writeLine #((round pointindex2.x),(round pointindex2.z),(round -pointindex2.y)) "// Point #1\n" txt_file
					writeLine #((round pointindex3.x),(round pointindex3.z),(round -pointindex3.y)) "// Point #2\n" txt_file
					writeLine #((round pointindex4.x),(round pointindex4.z),(round -pointindex4.y)) "// Point #3\n\n" txt_file
				)
				else 
				(
					writeLine #(0,0,0) "// Timer increment for each skill level (ped mode)\n" txt_file
					writeLine #(1) "// Number of quads\n" txt_file
					writeLine #(0,0,0) "Point #0\n" txt_file
					writeLine #(0,0,0) "Point #1\n" txt_file
					writeLine #(0,0,0) "Point #2\n" txt_file
					writeLine #(0,0,0) "Point #3\n\n" txt_file
				)
			)
		)
		
		--Smashable
		smashables = rootnode.smashables
		writeLine #(smashables.count) "// Number of Smashables\n\n" txt_file
		
		if smashables.count != 0 do
		(
			for smash in smashables do
			(
				format"// Start of %\n\n" smash.name to:txt_file
				writeline #(smash.flags) "// Flags\n" txt_file
				smashType = smash.type
				if smashType == 1 then (
					writeline #(smash.triggerName) "// Name of trigger &model\n" txt_file
				)
				if smashType == 2 then (
					writeline #(smash.triggerName) "// Name of trigger material\n" txt_file
				)
				smashMode = smash.mode
				if smashMode == 1 do
				(
					writeline #("Nochange") "// Mode\n" txt_file
					writeline #(smash.threshold) "// Removal threshold\n" txt_file
					writeconnotations smash.connotations txt_file
					
				)
				if smashtype == 1 and smashMode==2 do
				(
					writeline #("Replacemodel") "// Mode\n" txt_file
					writeline #(smash.threshold) "// Removal threshold\n" txt_file
					writeconnotations smash.connotations txt_file
					
					try (
						writeline #(smash.replacemodel.name) "// new model\n" txt_file
					)
					catch (
						writeline #("none") "// new model\n" txt_file
					)
					writeline #(smash.firechance) "// chance of fire/smoke\n" txt_file
					writeline #(smash.firecollumns) "// number of fire/smoke collumns\n" txt_file
					writeline #(smash.firemin,smash.firemax) "// min/max smokeyness\n" txt_file
					
					--format "\n0	// reserved 1 \n0	// reserved 2 \n0	// reserved 3 \n0	// reserved 4 \n\n" to:txt_file
				)
				if smashMode==3 do
				(
					writeline #("Remove") "// Mode\n" txt_file
					writeline #(smash.threshold) "// Removal threshold\n" txt_file
					writeconnotations smash.connotations txt_file
					--format "\n0	// reserved 1 \n0	// reserved 2 \n0	// reserved 3 \n0	// reserved 4 \n\n" to:txt_file
				)
				if smashtype == 2 and smashMode==2 do
				(
					writeline #("Texturechange") "// Mode\n" txt_file
					writeline #((getfilenamefile smash.startBitmap)) "// Intact pixelmap\n" txt_file
					writeline #((smash.levels.count as string)) "// Number of levels\n\n" txt_file
					for lvl in smash.levels do
					(
						writeline #(lvl.threshold) "// trigger threshhold\n" txt_file
						writeline #(lvl.flags) "// flags\n" txt_file
						collision_types = #("solid","edges","passthrough")
						writeline #(collision_types[lvl.coltype]) "// collision type\n\n" txt_file
						writeconnotations lvl.connotations txt_file
						--format "\n" to:txt_file
						writeline #(1) "// number of pixelmaps\n" txt_file
						writeline #((getfilenamefile lvl.lvl_bitmap)) "// pixemap\n" txt_file
						--format "\n" to:txt_file
					)
					--format "\n0	// reserved 1 \n0	// reserved 2 \n0	// reserved 3 \n0	// reserved 4 \n\n" to:txt_file
				)
				writeline #(0) "// reserved 1\n" txt_file
				writeline #(0) "// reserved 2\n" txt_file
				writeline #(0) "// reserved 3\n" txt_file
				writeline #(0) "// reserved 4\n\n" txt_file
			)
		)
		
		--PEDESTRIAN SETTINGS
		if rootnode.pedSpawn_check == true then
		(
			if rootnode.pedSpawn_mats.count != 0 then
			(
				writeLine #(rootnode.pedSpawn_mats.count) "// number of Ped Spawn Materials\n\n" txt_file
				for mat in rootnode.pedSpawn_mats do
				(
					writeLine #(mat.name) "// ped spawn material\n" txt_file
					writeLine #(mat.movement_index) "// movement index\n" txt_file
					writeLine #(mat.group_index) "// group index\n" txt_file
					writeLine #(mat.density) "// density\n" txt_file
					writeLine #(mat.exclusion1.count) "// number of exclusion materials\n" txt_file
					for i=1 to mat.exclusion1.count do (
						exclusion = filterstring mat.exclusion1[i] ","
						writeLine #(exclusion[2]) "// material flag\n" txt_file
						writeLine #(exclusion[1]) "// material name\n" txt_file
					)
					writeLine #(mat.exclusion2) "// exception material \n\n" txt_file
				)
			)
			else writeLine #(0) "// number of Ped Spawn Materials\n\n" txt_file
		)
		else writeLine #(0) "// number of Ped Spawn Materials\n\n" txt_file

		writeline #("TRACKX.ACT") "// Addional Actor\n\n" txt_file

		--Horizon and environment settings
		horizon_file = rootnode.horizon_bitmap_file
		writeline #((getfilenamefile horizon_file)) "// Name of sky texture pixelmap\n" txt_file
		writeline #(rootnode.horizon_hor_repetitions) "// Horizontal repetitions of sky texture\n" txt_file
		writeline #(rootnode.horizon_ver_angle) "// Vertical size of sky texture (degrees)\n" txt_file
		writeline #(rootnode.horizon_position) "// Position of horizon (pixels below top)\n" txt_file
		if rootnode.horizon_depth_cue_mode == 1 do writeline #("None") "// Depth cue mode\n" txt_file
		if rootnode.horizon_depth_cue_mode == 2 do writeline #("Dark") "// Depth cue mode\n" txt_file
		if rootnode.horizon_depth_cue_mode == 3 do writeline #("Fog") "// Depth cue mode\n" txt_file
		if rootnode.horizon_depth_cue_mode == 4 do writeline #("Colour") "// Depth cue mode\n" txt_file
		writeline #(rootnode.horizon_fognear,rootnode.horizon_fogfar) "// Degree of fog/darkness\n" txt_file
		writeline #((rootnode.horizon_depth_cue_color.r as integer),(rootnode.horizon_depth_cue_color.g as integer),(rootnode.horizon_depth_cue_color.b as integer)) "// Depth cue colour (red, green, blue )\n\n" txt_file
		
		--DEFAULT ENGINE NOISE
		writeline #(0) "// Default engine noise\n\n" txt_file
		
		--SPECIAL EFFECTS VOLUMES
		writeline #(rootnode.sev.count) "// number of special effects volumes\n\n" txt_file
		if rootnode.sev.count != 0 then
		(
			for sev in rootnode.sev do
			(
				writeline #("box") ("// "+ sev.name +"\n") txt_file
				writeline #((((sev.max.x * 2)-(sev.center.x * 2))/ 2),0,0) "// offset from center on X axis\n" txt_file
				writeline #(0,(((sev.max.z * 2)-(sev.center.z * 2))/ 2),0) "// offset from center on Z axis\n" txt_file
				writeline #(0,0,(((sev.max.y * 2)-(sev.center.y * 2))/ 2)) "// offset from center on Y axis\n" txt_file
				writeline #(sev.pos.x,sev.pos.z,-sev.pos.y) "// center point of the box in the world\n" txt_file
				writeline #(sev.ev_gravity) "// gravity multiplier\n" txt_file
				writeline #(sev.viscosity) "// viscosity multiplier\n" txt_file
				writeline #(0) "// car damage per millisecond\n" txt_file
				writeline #(0) "// ped damage per millisecond\n" txt_file
				writeline #(sev.cameff) "// camera effect\n" txt_file
				writeline #(sev.skycol) "// sky colour\n" txt_file
				writeline #("none") "// windscreen texture to use (no effect)\n" txt_file
				writeline #(sev.entsnd) "// enter sound id\n" txt_file
				writeline #(sev.exitsnd) "// exit sound id\n" txt_file
				writeline #(sev.engsnd) "// engine sound index\n" txt_file
				writeline #(sev.matindx) "// material index\n" txt_file
				if sev.sndtype == 1 do writeline #("none") "// sound type\n" txt_file
				if sev.sndtype != 1 do
				(
					if sev.sndtype == 2 do writeline #("scattered") "// sound type\n" txt_file
					if sev.sndtype == 3 do writeline #("saturated") "// sound type\n" txt_file
					if sev.snddelay ==1 do
					(
						writeline #("random") "// sound delay\n" txt_file
						writeline #(sev.minint,sev.maxint) "// min/max delay between sounds\n" txt_file
						writeline #(1) "// ?\n" txt_file
						writeline #(sev.sounds.count) "// number of sounds\n" txt_file
						for id in sev.sounds do writeline #(id) "// sound id\n" txt_file
					)
					if sev.snddelay ==2 do
					(
						writeline #("continuous") "// sound delay\n" txt_file
						writeline #(sev.sounds[1]) "// sound id\n" txt_file
					)
				)
				format "\n" to:txt_file
			)
		)
		
		--SOUND GENERATORS
		writeline #(0) "// Number of sound generators\n\n" txt_file
		
		--REFLECTIVE WINDSCREEN SPECIFICATIONS
		writeline #("DRKSCRN.MAT") "// Material to use for default screens\n" txt_file
		writeline #("DRKSCRN.MAT") "// Material to use for default screens during darkness\n" txt_file
		writeline #("FOGSCRN.MAT") "// Material to use for default screens during fog\n" txt_file
		writeline #(0) "// (ignore) # areas with different screens\n\n" txt_file
		
		--MAP DETAILS
		writeline #(getfilenamefile rootnode.track_general_attributes.minimapbitmap) "// minimap filename \n" txt_file
		minimaptm = rootnode.track_general_attributes.miniMaptm
		writeline #((round miniMaptm[1]),(round miniMaptm[2]),(round miniMaptm[3])) "// transformation matrix row 1\n" txt_file
		writeline #((round miniMaptm[4]),(round miniMaptm[5]),(round miniMaptm[6])) "// transformation matrix row 2\n" txt_file
		writeline #((round miniMaptm[7]),(round miniMaptm[8]),(round miniMaptm[9])) "// transformation matrix row 3\n" txt_file
		writeline #((round miniMaptm[10]),(round miniMaptm[11]),(round miniMaptm[12])) "// transformation matrix row 4\n\n" txt_file
		
		--FUNK MATERIALS
		format "START OF FUNK\n\n" to:txt_file
		if rootnode.funks.count != 0 do
		(
			for i=1 to  rootnode.funks.count do
			(
				mat = rootnode.funks[i]
				writeline #(mat.name) "// Material name\n" txt_file
				funk_distance_strings = #("distance", "constant","lastlap","otherlaps")
				writeline #(funk_distance_strings[mat.distance]) "// Distance\n" txt_file indent:1
				funk_animation_strings = #("none", "roll", "slither", "throb", "rock","spin")
				writeline #(funk_animation_strings[mat.animation_type]) "// Animation type\n" txt_file indent:1
				if mat.animation_type != 1 do
				(
					funk_animation_mode_strings = #("harmonic", "linear", "continuous","controlled") 
					writeline #(funk_animation_mode_strings[mat.animation_mode]) "// Animation mode\n" txt_file indent:2
				)
				if mat.animation_type != 1 and mat.animation_type != 5 do writeline #(mat.animation_speed_x,mat.animation_speed_y) "// Animation speed\n" txt_file indent:2
				if mat.animation_type == 3 do writeline #(mat.animation_extent_x,mat.animation_extent_y) "// Animation extent\n" txt_file indent:2
				if mat.animation_type == 4 do
				(
					writeline #(mat.animation_extent_x,mat.animation_extent_y) "// Animation extent\n" txt_file indent:2
					writeline #(mat.animation_centre_x,mat.animation_centre_y) "// Animation centre\n" txt_file indent:2
				)
				if mat.animation_type == 5 do
				(
					writeline #(mat.animation_period) "// Animation period\n" txt_file indent:2
					writeline #(mat.animation_angle) "// Animation angle\n" txt_file indent:2
					writeline #(mat.animation_centre_x,mat.animation_centre_y) "// Animation centre\n" txt_file indent:2
				)
				if mat.animation_type == 6 do
				(
					writeline #(mat.animation_period) "// Animation period\n" txt_file indent:2
				)
				writeline #("none") "// Lighting\n" txt_file indent:1
				funk_sequence_strings = #("none","frames")
				writeline #(funk_sequence_strings[mat.sequence_type]) "//sequence\n" txt_file indent:1
				if mat.sequence_type == 2 do
				(
					funk_playback_strings = #("approximate","accurate")
					writeline #(funk_playback_strings[mat.sequence_playback]) "// Playback\n" txt_file indent:2
					funk_sequence_type_stings = #("continuous","linear","harmonic","flash","texturebits")
					writeline #(funk_sequence_type_stings[mat.sequence_mode]) "// Sequence type\n" txt_file indent:2
					if mat.sequence_mode == 5 then (
						textureBitTypes = #("B","BV","V","VB")
						writeLine #(textureBitTypes[funk.sequence_textureBits])
					)
					else (
						writeline #(mat.sequence_framerate) "// framerate\n" txt_file indent:2
					)
					writeline #(mat.frames_list.count) "// frame count\n" txt_file indent:2
					for j=1 to mat.frames_list.count do
					(
						frame = mat.frames_list[j]
						if mat!=undefined then (
							writeline #(frame) "// frame name\n" txt_file indent:2
							if mat.frames_xCounts[j] > 1 or mat.frames_yCounts[j] > 1  then
							( 
								writeline #(mat.frames_xCounts[j],mat.frames_xIndexes[j],mat.frames_yCounts[j],mat.frames_yIndexes[j]) "// frame values\n" txt_file indent:2
							)
							else format "\n" to:txt_file
						)
					)
				)
				format "\n" to:txt_file
				if i != rootnode.funks.count do format "NEXT FUNK\n\n" to:txt_file
			)
		)
		format "END OF FUNK\n\n" to:txt_file
		
		--GROOVE OBJECTS
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
					writeLine #(groove.path_speed) "// Speed\n" txt_file
					if groove.path_type  == 2 do
					(
						writeLine #(groove.path_extent.x,groove.path_extent.z,-groove.path_extent.y) "// Extent\n" txt_file
					)
					if groove.path_type  == 3 do
					(
						writeLine #(groove.path_radius) "// Radius\n" txt_file
						path_axiss = #("x","y","z")
						writeLine #(path_axiss[groove.path_axis]) "// Axis\n" txt_file
					)
				)
				animation_types = #("None","Spin","Rock","Shear","Throb")
				animation_modes = #("Linear","Harmonic","Flash","Continuous","Absolute","Controlled")
				animation_axis = #("x","y","z")
				writeLine #(animation_types[groove.animation_type]) "// Animation Type\n" txt_file
				if groove.animation_type != 1 do
				(
					writeLine #(animation_modes[groove.animation_mode]) "// Animation Mode\n" txt_file
					if groove.animation_type  == 2 do 
					(
						writeLine #(groove.animation_speed) "// Speed\n" txt_file
						writeLine #(groove.animation_centre.x,groove.animation_centre.z,-groove.animation_centre.y) "// Centre\n" txt_file
						writeLine #(animation_axis[groove.animation_axis]) "// Axis\n" txt_file
					)
					if groove.animation_type  == 3 do 
					(
						writeLine #(groove.animation_speed) "// Speed\n" txt_file
						writeLine #(groove.animation_centre.x,groove.animation_centre.z,-groove.animation_centre.y) "// Centre\n" txt_file
						writeLine #(animation_axis[groove.animation_axis]) "// Axis\n" txt_file
						writeLine #(groove.animation_angle) "// Angle\n" txt_file
					)
					if groove.animation_type  == 4 or groove.animation_type == 5 do 
					(
						writeLine #(groove.animation_speed,groove.animation_speed,groove.animation_speed) "// Speed\n" txt_file
						writeLine #(groove.animation_centre.x,groove.animation_centre.z,-groove.animation_centre.y) "// Centre\n" txt_file
						writeLine #(groove.animation_extent.x,groove.animation_extent.z,-groove.animation_extent.y) "// Extent\n" txt_file
					)
				)
				if i != rootnode.grooves.count do
				(
					format "\nNEXT GROOVE\n" to:txt_file
				)
			)
		)
		format "\nEND OF GROOVE\n\n" to:txt_file
		--OPPONENT PATHS
		format "START OF OPPONENT PATHS\n\n" to:txt_file
		
		if rootnode.oppPath_object != undefined then
		(
			opponentpath = rootnode.track_general_attributes.oppPath_object
			knotindex = 0
			opp_path_knots = #()
			opp_path_nodes = #()
			opp_path_segments = #()
			for i = 1 to numsplines opponentpath do
			(
				for j = 1 to numknots opponentpath i do
				(
					nodecoord = getKnotPoint opponentpath i j
					if (finditem opp_path_nodes nodecoord) == 0 then
					(
						knotindex = knotindex + 1
						append opp_path_nodes nodecoord
						append opp_path_knots knotindex
						--format "added knot %\n" knotindex to:txt_file
					)
					else
					(
						--knotindex = knotindex + 1
						append opp_path_knots (finditem opp_path_nodes nodecoord)
						--format "did not add knot %\n" knotindex to:txt_file
					)
				)
			)
			append opp_path_nodes ([0,0,500])
			append opp_path_knots (knotindex+1)
			
			--format "%\n\n" opp_path_knots.count to:txt_file
			--format "%\n\n" opp_path_nodes.count to:txt_file
			knotindex = 0
			for i = 1 to numsplines opponentpath do
			(	
				numknots_subspline = numknots opponentpath i
				for j = 1 to numknots_subspline do
				(
					knotindex = knotindex + 1
					currentknot = opp_path_knots[knotindex]
					if j == numknots_subspline then
					(
						if (isclosed opponentpath i) == true then
						(
							nextknot = 1
						)
						else
						(
							nextknot = undefined
						)
					)
					else
					(
						nextknot = opp_path_knots[knotindex+1]
					)
					if nextknot != undefined do
					(
						segment = [(currentknot-1),(nextknot-1)]
						append opp_path_segments segment
					)
				)
			)
			append opp_path_segments [0,(opp_path_nodes.count-1)]
			
			writeLine #(opp_path_nodes.count) "// number of path nodes\n\n" txt_file
			for i = 1 to opp_path_nodes.count do
			(
				writeLine #(opp_path_nodes[i].x,opp_path_nodes[i].z,-opp_path_nodes[i].y) ("// node "+((i-1) as string)+"\n") txt_file
			)
			format "\n" to:txt_file
			writeLine #(opp_path_segments.count) "// number of path segments\n\n" txt_file
			for i = 1 to opp_path_segments.count do
			(
				writeLine #((opp_path_segments[i].x as integer),(opp_path_segments[i].y as integer),0,255,0,255,1.0,0) ("// segment "+ ((i) as string) + "\n") txt_file
			)
			format "\n" to:txt_file
			writeLine #(0) "//number of cop startpoints\n\n" txt_file
			format "END OF OPPONENT PATHS\n\n" to:txt_file
		)
		else
		(
			writeLine #(0) "//number of path nodes\n\n" txt_file
			writeLine #(0) "//number of path segments\n\n" txt_file
			writeLine #(0) "//number of cop startpoints\n\n" txt_file
			format "END OF OPPONENT PATHS\n\n" to:txt_file
		)
		--DRONE PATHS
		
		format "START OF DRONE PATHS\n\n" to:txt_file
		
		
		format "2 // Version\n" to:txt_file
		if rootnode.dronePath_object != undefined then
		(
			dronepath = rootnode.dronePath_object
			knotindex = 0 --we start at zero
			drone_knots = #() --all the knots of the spline, referring to the drone_nodes indexes, including duplicate once.
			drone_nodes = #() --the coordinates of all the unique nodes.
			drone_nodes_next = # () --the arrays per node that contain the next possible nodes.
			for i = 1 to numsplines dronepath do
			(
				for j = 1 to numknots dronepath i do
				(
					nodecoord = getKnotPoint dronepath i j
					
					--first we determine whether the node is already stored.
					--if not, we add the new node and knot and link the previous knot to it. if we are at the end of the main loop, we link to knot 1
					if (finditem drone_nodes nodecoord) == 0 then
					(
						knotindex = knotindex + 1
						append drone_nodes nodecoord
						append drone_knots knotindex
					)
					--if the node already exists, we determine whether it is the end or beginning of a new section, connnecing to the main loop.
					else
					(
						--first we add the knot index based on the already existing node
						append drone_knots (finditem drone_nodes nodecoord)
						--locate the next node in the split up section from the already existing node in the main loop.
						--end of split up section. find the next node in the main loop which we link to. The previous knot will link to this found knot
					)
				)
			)
			
			
			knotindex = 0 --we start at zero
			--we create the array for the next nodes
			for i = 1 to drone_nodes.count do
			(
				append drone_nodes_next #()
			)
			--we fill the array for the next nodes with data
			for i = 1 to numsplines dronepath do
			(
				for j = 1 to numknots dronepath i do
				(
					knotindex = knotindex + 1
					if (knotindex) == (numknots dronepath i) and (isclosed dronepath i) == true then
					(
						drone_nodes_next[knotindex] = #(1)
					)
					else
					(
						currentknot = drone_knots[knotindex]
						nextknot = drone_knots[knotindex + 1]
						if nextknot != undefined do
						(
							append drone_nodes_next[currentknot] nextknot
						)
					)
				)
			)
			writeLine #(drone_nodes.count) "//number of drone path nodes\n\n" txt_file
			for i=1 to drone_nodes.count do 
			(
				writeLine #(drone_nodes[i].x,drone_nodes[i].z,-drone_nodes[i].y) ("// node "+((i-1) as integer) + "\n\n") txt_file
				writeLine #("none") "// spawned drone\n\n" txt_file
				writeLine #(0) "// unknown\n\n" txt_file
				writeLine #(drone_nodes_next[i].count) "// number of next nodes\n" txt_file
				nextdrones = drone_nodes_next[i]
				for j = 1 to nextdrones.count do
				(
					writeLine #((nextdrones[j]-1),0,0,0) "// next drone\n\n" txt_file
					format "%, 0, 0, 0\n" (nextdrones[j]-1) to:txt_file
				)
				format "\n" to:txt_file
			)
		)
		else writeLine #(0) "//number of drone path nodes\n\n" txt_file

		format "END OF DRONE PATHS\n\n" to:txt_file
		--DRIVING SURFACE TYPES
		
		writeLine #(rootnode.matMods.count) "// number of Material Modifiers\n\n" txt_file
		for mat in rootnode.matMods do
		(
			writeLine #(mat.car_wall_friction) "// car wall friction\n" txt_file
			writeLine #(mat.tyre_road_friction) "// tyre road friction\n" txt_file
			writeLine #(mat.downforce) "// downforce\n" txt_file
			writeLine #(mat.bumpiness) "// bumpiness\n" txt_file
			writeLine #(mat.tyre_snd_ind) "// tyre sound index\n" txt_file
			writeLine #(mat.crash_snd_ind) "// crash sound index\n" txt_file
			writeLine #(mat.scrape_snd_ind) "// scrape sound index\n" txt_file
			writeLine #(mat.sparkyness) "// sparkyness\n" txt_file
			writeLine #(mat.expansionroom) "// room for expansion\n" txt_file
			skidmarks = #("SKIDMARK.MAT","DESKID.MAT","GIBSMEAR.MAT","MUD1.MAT","OILSMEAR.MAT","SNOWSKID.MAT")
			writeLine #(skidmarks[mat.skidmark]) "// skidmark\n" txt_file
			format "\n" to:txt_file
		)
		--NONCARS
		noncars = rootnode.track_general_attributes.noncars_list
		if noncars.count != 0 and noncars[1] != undefined then
		(
			writeLine #(noncars.count) "// Number of noncars\n\n" txt_file
			for i=1 to noncars.count do
			(
				noncar_string = noncars[i]
				format "%\n" noncar_string to:txt_file
			)
			format "\n" to:txt_file
		)
		else
		(
			writeLine #(0) "// Number of noncars\n\n" txt_file
		)
		
		--TYRE DUST TYPES
		writeLine #(rootnode.dustTypes.count) "// Number of Tyre Dust Tables\n\n" txt_file
		if rootnode.dustTypes.count > 0 do
		(
			for mat in rootnode.dustTypes do
			(
				writeLine #((mat.dcolor.r as integer),(mat.dcolor.g as integer),(mat.dcolor.b as integer)) "// RGB values\n" txt_file
				writeLine #(mat.qstrength,mat.hstrength,mat.tqstrength) "// Strength values\n\n" txt_file
			)
		)
		--NETWORK STARTPOINTS
		writeLine #(rootnode.mstartp.count) "// Number of Network Startpoints\n\n" txt_file
		for mstartp in rootnode.mstartp do
		(
			if isvalidnode mstartp then
			(
				writeLine #((round mstartp.pos.x),(round mstartp.pos.z),(round -mstartp.pos.y)) "// Position\n" txt_file
				writeLine #(mstartp.rotation.z_rotation) "// Rotation\n" txt_file
			)
			else 
			(
				writeLine #(0,0,0) "// Position\n" txt_file
				writeLine #(0) "// Rotation\n" txt_file
			)
		)
		--SPLASH PIX FILES
		writeLine #(1) "// Number of splash files\n" txt_file
		writeLine #("CASPLASH.PIX") "// Name of pixelmap files for splashes\n\n" txt_file
		
		--TRACK FILE NAME
		writeLine #(1) "// Number of Track files included\n" txt_file
		writeLine #((getfilenamefile txt_name + ".txt")) "// Track File Name\n" txt_file
		--end of txt_file
		close txt_file
	--)
	--catch (
	--	close txt_file
	--	print (getcurrentexception())
	--)
)
