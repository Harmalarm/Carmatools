global track_general_CA = attributes track_general_attributes 
attribID:#(0x6355c32d, 0x76c6fa01)
(
	parameters game_parameters
	(
		gameDir type:#string default:""
	)
	parameters global_lighting_parameters
	(
		main_directional_light_source type:#color default:[255,255,255]
		ambient_ambient_0 type:#float default:0.1
		ambient_diffuse_0 type:#float default:1.0
		ambient_ambient_1 type:#float default:0.1
		ambient_diffuse_1 type:#float default:1.0
		ambient_ambient_2 type:#float default:0.4
		ambient_diffuse_2 type:#float default:0.8
	)
	parameters horizon_settings_parameters
	(
		horizon_bitmap_file type:#string default:"None"
		horizon_hor_repetitions type:#integer default:4
		horizon_ver_angle type:#integer default:60
		horizon_position type:#integer default:200
		horizon_depth_cue_mode type:#integer default:4
		horizon_depth_cue_color type:#color default:[255,255,255]
		horizon_fognear type:#integer default:4
		horizon_fogfar type:#integer default:0
	)
	parameters checkpoint_parameters
	(
		checkp type:#nodetab tabsize:0 tabSizeVariable:true
	)
	parameters startPos_parameters
	(
		startg  type:#node
		mstartp type:#nodetab tabsize:0 tabsizevariable:true
	)
	parameters matMods_parameters
	(
		matMods type:#materialtab tabsize:0 tabSizeVariable:true
	)
	parameters dustTypes_parameters
	(
		dustTypes type:#materialtab tabsize:0 tabSizevariable:true
	)
	parameters miniMap_parameters
	(	
		miniMapBitmap type:#string default:"none"
		minimapRotation type:#integer default:1
		miniMaptm type:#floattab tabsize:12 tabSizeVariable:true
	)
	parameters sev_parameters
	(
		sev type:#nodetab tabsize:0 tabSizevariable:true
	)
	parameters pedSpawn_parameters
	(
		pedSpawn_check type:#boolean default:false
		pedSpawn_mats type:#materialtab tabsize:0 tabSizeVariable:true
	)
	parameters funks_parameters
	(
		funks type:#materialtab tabsize:0 tabSizeVariable:true
		funks_rolledup type:#boolean default:true
	)
	parameters grooves_parameters
	(
		grooves type:#nodetab tabsize:0 tabSizeVariable:true
	)
	parameters aiPath_paramters
	(
		oppPath_object type:#node
		dronePath_object type:#node
	)
	parameters noncar_parameters
	(
		noncars_list type:#stringtab tabSizeVariable:true tabSize:0
	)
	parameters smash_paramters
	(
		smashables type:#materialtab tabsize:0 tabSizeVariable:true
		current_connotations type:#material
	)
	parameters track_general_parameters
	(
		smashable_check type:#boolean default:false
	)
)

checkp_CA = attributes checkp_data
attribID:#(0xaf724ca, 0x84ff0330)
(
	parameters checkp_params
	(
		bonus_1  type:#integer default:20
		bonus_2  type:#integer default:10
		bonus_3  type:#integer default:5
	)
)

starting_grid_CA = attributes starting_grid_attributes 
attribID:#(0xaf709ca, 0x84ff0330)
(
	parameters starting_grid_parameters
	(
		starting_grid_param type:#integer default:1
	) 
)

multiplayer_point_CA = attributes multiplayer_point_attributes 
attribID:#(0xaf709ca, 0x84de0330)
(
	parameters multiplayer_point_parameters 
	(
		multiplayer_point_param type:#integer default:1
	) 
)

pedSpawn_CA = attributes ped_data
attribID:	#(0x1bf81322, 0x39be7bd2)
(
	parameters pedSpawn_params
	(
		movement_index type:#integer default:0
		group_index type:#integer	default:1
		density type:#float default:1
		exclusion1 type:#stringtab tabsize:0 tabsizevariable:true
		exclusion2 type:#integer default:0
	)
)

matMod_CA = attributes matMod_data
attribID:#(0x74cbc30e, 0x645a07ba)
(
	parameters matMod_parameters
	(
		car_wall_friction type:#float default:1
		tyre_road_friction type:#float default:1
		downforce type:#float default:1
		bumpiness type:#float default:0
		tyre_snd_ind type:#integer default:0
		crash_snd_ind type:#integer default:0
		scrape_snd_ind type:#integer default:0
		sparkyness type:#integer default:1
		expansionroom type:#integer default:1
		skidmark type:#integer default:1
	)
)

dustType_CA = attributes dustType_data
attribID:#(0x6a6240b7, 0x6b76c2b0)
(
	parameters dustType_params
	(
		dcolor type:#color default:[155,155,155]
		qstrength type:#float default:.25
		hstrength type:#float default:.5
		tqstrength type:#float default:.75
	)
)

sev_CA = attributes sev_data
attribID:#(0x74cbc30e, 0x660a07ba)
(
	parameters sev_params
	(
		ev_gravity type:#float default:1
		viscosity type:#float default:1
		cameff type:#integer default:1
		skycol type:#integer default:-1
		cardam type:#integer default:0
		peddam type:#integer default:0
		entsnd type:#integer default:-1
		exitsnd type:#integer default:-1
		engsnd type:#integer default:1
		matindx type:#integer default:0
		sndtype type:#integer default:1
		snddelay type:#integer default:1
		minint type:#integer default:0
		maxint type:#integer default:0
		sounds type:#stringtab tabsize:0 tabsizevariable:true
	)
)