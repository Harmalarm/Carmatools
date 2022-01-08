--try destroydialog environmentSetup  catch()
rollout environmentSetup "Environment Setup" (
	local placementPos = 24
	group "Global Lighting Data:" (
		colorpicker main_directional_light_source "Light color:" color:[255,255,255] modal:false fieldWidth:50 pos:[colE+4,placementPos]
		label ambient_ambient_0_label "When Ambient 0 - " width:widthB pos:[colA,placementPos+=26] enabled:false
		spinner ambient_ambient_0 "Ambient:" type:#float range:[0,99,0.1] scale: 0.1 fieldWidth:40 width:widthB pos:[colC,placementPos] enabled:false
		spinner ambient_diffuse_0 "Diffuse:" type:#float range:[0,99,1.0] scale: 0.1 fieldWidth:40 width:widthB pos:[colE,placementPos] enabled:false
		label ambient_ambient_1_label "When Ambient 1 - " enabled:false  width:widthB pos:[colA,placementPos+=21] enabled:false
		spinner ambient_ambient_1 "Ambient:" type:#float range:[0,99,0.1] scale: 0.1 fieldWidth:40 width:widthB pos:[colC,placementPos] enabled:false
		spinner ambient_diffuse_1 "Diffuse:" type:#float range:[0,99,1.0] scale: 0.1 fieldWidth:40 width:widthB pos:[colE,placementPos] enabled:false
		label ambient_ambient_2_label "Ambient / Diffuse - "   width:widthB pos:[colA,placementPos+=21]
		spinner ambient_ambient_2 "Ambient:" type:#float range:[0,99,0.1] scale: 0.1 fieldWidth:40 width:widthB pos:[colC,placementPos]
		spinner ambient_diffuse_2 "Diffuse:" type:#float range:[0,99,1.0] scale: 0.1 fieldWidth:40 width:widthB pos:[colE,placementPos]
	)
	
	fn updatelightingControlValues = (
		main_directional_light_source.color = rootnode.main_directional_light_source
		ambient_ambient_0.range.z = rootnode.ambient_ambient_0
		ambient_diffuse_0.range.z = rootnode.ambient_diffuse_0
		ambient_ambient_1.range.z = rootnode.ambient_ambient_1
		ambient_diffuse_1.range.z = rootnode.ambient_diffuse_1
		ambient_ambient_2.range.z = rootnode.ambient_ambient_2
		ambient_diffuse_2.range.z = rootnode.ambient_diffuse_2
	)
	
	on main_directional_light_source changed color do rootnode.main_directional_light_source = color
	on ambient_ambient_0 changed val do rootnode.ambient_ambient_0 = val
	on ambient_diffuse_0 changed val do rootnode.ambient_diffuse_0 = val
	on ambient_ambient_1 changed val do rootnode.ambient_ambient_1 = val
	on ambient_diffuse_1 changed val do rootnode.ambient_diffuse_1 = val
	on ambient_ambient_2 changed val do rootnode.ambient_ambient_2 = val
	on ambient_diffuse_2 changed val do rootnode.ambient_diffuse_2 = val
	
	group "Horizon Settings:" (
		--label horizon_bitmap_label "Horizon texture:" across:2 align:#left offset:[0,3] 
		button horizon_bitmap_file "None" width:widthC height:widthC pos:[colD,placementPos+=46] tooltip:"Browse for a texture to use as horizon texture. Rightclick to remove" --autodisplay:true
		spinner horizontal_repetitions "Repetitions:" type:#integer range:[0,99,4] fieldWidth:40 width:widthC pos:[colA,placementPos]
		spinner vertical_angle "Angle:" type:#integer range:[0,180,60] fieldWidth:40 width:widthC pos:[colA,placementPos+=21]
		spinner horizon_position "px. from top:" type:#integer range:[0,256,200] fieldWidth:40 width:widthC pos:[colA,placementPos+=21] tooltip:"The position of the horizon as in number of pixels from the top of the texture"
		dropdownlist horizon_depth_cue items:#("NONE","DARK","FOG","COLOUR") selection:4 width:widthB pos:[colB,placementPos+=21]
		label horizon_depth_cue_label "Mode:" pos:[colA+20,placementPos+4]
		colorpicker horizon_depth_cue_color "Color:" color:[255,255,255] modal:false fieldwidth:50 pos:[colB+26,placementPos+=26]
		spinner horizon_fognear_degree "Degree of fog Near:" type:#integer range:[0,16,4] fieldWidth:40 width:widthB pos:[colB,placementPos+=26]
		spinner horizon_fogfar_degree "Degree of fog Far:" type:#integer range:[0,16,0] fieldWidth:40 width:widthB pos:[colB,placementPos+=21]
		label horizon_end "" pos:[colA,placementPos+=17]
	)
	fn updateHorizonControlValues = (
		updatePreviewBitmap horizon_bitmap_file rootnode.track_general_attributes.horizon_bitmap_file widthC widthC
		horizontal_repetitions.range.z = rootnode.horizon_hor_repetitions
		vertical_angle.range.z = rootnode.horizon_ver_angle
		horizon_position.range.z = rootnode.horizon_position
		horizon_depth_cue.selection = rootnode.horizon_depth_cue_mode
		horizon_depth_cue_color.color = rootnode.horizon_depth_cue_color
		horizon_fognear_degree.range.z = rootnode.horizon_fognear
		horizon_fogfar_degree.range.z = rootnode.horizon_fogfar
	)
	
	
	on horizon_bitmap_file pressed do
	(
		rootnode.track_general_attributes.horizon_bitmap_file = setPreviewBitmap horizon_bitmap_file widthC widthC
	)
	on horizon_bitmap_file rightclick do
	(
		rootnode.track_general_attributes.horizon_bitmap_file = "None"
		updatePreviewBitmap horizon_bitmap_file "None" widthC widthC
	)
	on horizontal_repetitions changed val do rootnode.horizon_hor_repetitions = val
	on vertical_angle changed val do rootnode.horizon_ver_angle = val
	on horizon_position changed val do rootnode.horizon_position = val
	on horizon_depth_cue selected i do rootnode.horizon_depth_cue_mode = i
	on horizon_depth_cue_color changed color do rootnode.horizon_depth_cue_color = color
	on horizon_fognear_degree changed val do rootnode.horizon_fognear = val
	on horizon_fogfar_degree changed val do rootnode.horizon_fogfar = val

	on environmentSetup open do (
		environmentSetup.height = 316
		updatelightingControlValues()
		updateHorizonControlValues()
	)
)
--createdialog environmentSetup width height