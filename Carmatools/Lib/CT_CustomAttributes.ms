--global variables

--script links for loading external scripts
LibDir =  scriptspath+"\\Carma_tools\\Lib\\"

filein (libDir + "CT_UIValues.ms")

--load functions
filein (libDir + "CT_Functions.ms")

filein (libDir + "CT_FunkSetup.ms")
filein (libDir + "CT_GrooveSetup.ms")

--smashable setup scripts
filein (libDir + "CT_SmashConnotationSetup.ms")
filein (libDir + "CT_SmashConnotationsEdit.ms")
filein (libDir + "CT_SmashShrapnelSetup.ms")
filein (libDir + "CT_SmashExplosionSetup.ms")
filein (libDir + "CT_SmashSideEffectsSetup.ms")
filein (libDir + "CT_SmashNoncarActivationSetup.ms")
filein (libDir + "CT_TrackSmashableSetup.ms")
filein (libDir + "CT_SmashConnotationSetup.ms")
filein (libDir + "CT_SmashConnotationsEdit.ms")

global actorAttributes = attributes actorProperties
attribID:#(0xaf709ca, 0x84ff0730)
(
	parameters actorParameters rollout:actorPropertiesRollout
	(
		renderMode type:#integer ui:renderMode default:4
		modelName type:#string ui:modelName default:"" autodisplay:true
		materialName type:#string ui:materialName default:"" autodisplay:true
	)
	rollout actorPropertiesRollout "Actor Properties:"
	(
		dropdownlist renderMode "Actor render mode:" items:#("invisible","vertices","wireframe","normal","bbox vertices","bbox edges","bbox") selection:4 align:#right label:false tooltip:"Change the mode of the animation."
		label modelNameLabel "Actor model name:"
		edittext modelName ""
		label materialNameLabel "Actor material name:"
		edittext materialName ""
	)
	fn getrollout = actorPropertiesRollout
)

if mat_CA == undefined do
(
	global Mat_CA = attributes mat_data
	attribID:#(0x3304c755, 0x6a003698)
	(
		parameters mat_data rollout:mat_props
		(
			mat_flags type:#booltab tabsize:22 ui:(mat_lit,mat_prelit,mat_smooth,mat_env_mapped_inf,mat_env_mapped_loc,mat_cor_persp,mat_decal,mat_IfromU,mat_IfromV,mat_UfromI,mat_VfromI,mat_allvisib,mat_twosid,mat_forcef,mat_dither,mat_dummy,mat_antialias,mat_mapinterp,mat_mipinterp,mat_fogloc,mat_subdiv,mat_ztransp) autodisplay:true
			mat_ambient type:#float default:0.1 --ui:mat_ambient
			mat_directional type:#float default:0.7 --ui:mat_directional
			mat_specular type:#float default:0 --ui:mat_specular
			mat_power type:#float default:20
			mat_blendtable type:#string default:""
			mat_shadetable type:#string default:""
		)
		rollout mat_props "Carmageddon material properties"
		(
			group "Flags"
			(
				checkbox mat_lit "Lit" checked:true across:3 align:#left
				checkbox mat_prelit "Pre-lit"checked:false
				checkbox mat_smooth "Smooth" checked:true
				checkbox mat_env_mapped_inf "Env map (inf)"checked:false across:3
				checkbox mat_env_mapped_loc "Env map (loc)"checked:false
				checkbox mat_cor_persp "Correct persp" checked:true
				checkbox mat_decal "Decal" checked:false across:3
				checkbox mat_allvisib "Always visible" checked:false
				checkbox mat_twosid "Two sided" checked:false
				checkbox mat_forcef "Force front" checked:false across:3
				checkbox mat_dither "Dither" checked:false
				checkbox mat_dummy "" checked:false enabled:false visible:false
				checkbox mat_antialias "Map aa" checked:false across:3
				checkbox mat_mapinterp "Map interp" checked:false 
				checkbox mat_mipinterp "Mip interp" checked:false 
				checkbox mat_subdiv "Subdivide" checked:false across:3
				checkbox mat_fogloc "Fog local" checked:false 
				checkbox mat_ztransp "Z transp" checked:false
				label mat_lab_2 ""
				checkbox mat_IfromU "I from U" checked:false across:4
				checkbox mat_IfromV "I from V" checked:false
				checkbox mat_UfromI "U from I" checked:false --across:2
				checkbox mat_VfromI "V from I" checked:false
			)
			group "Lighting"
			(
				label mat_label1 "Ambient" across:4 align:#right offset:[-5,10] ticks:10
				--spinner mat_ambient "Ambient" range:[-9999,9999,0.1] fieldwidth:50 type:#float width:150 scale:0.1 align:#right
				--slider mat_ambient range:[-1,1,0.1] type:#float orient:#horizontal width:150 scale:0.1
				edittext mat_ambient_entry width:70 offset:[-5,10] text:(mat_ambient as string) align:#right
				
				label mat_label2 "Directional" align:#right offset:[0,10]
				--spinner mat_directional "Directional" range:[-9999,9999,0.1] fieldwidth:50 type:#float width:150 scale:0.1 align:#right
				--slider mat_directional range:[-1,1,0.1] type:#float orient:#horizontal width:150 scale:0.1
				edittext mat_directional_entry width:70 offset:[0,10] text:(mat_directional as string) align:#right
				
				label mat_label3 "Specular" across:4 align:#right offset:[-5,10]
				--spinner mat_specular "Specular" range:[-9999,9999,0.1] fieldwidth:50 type:#float width:150 scale:0.1 align:#right
				--slider mat_specular range:[-1,1,0.1] type:#float orient:#horizontal width:150 scale:0.1
				edittext mat_specular_entry width:70 offset:[-5,10] text:(mat_specular as string) align:#right
				
				label mat_label4 "Specular Power" align:#right offset:[0,10]
				edittext mat_specularpower width:70 offset:[0,10] align:#right text:(mat_power as string)
			)
			group "Colour"
			(
				edittext mat_shadetable_ui "Shade Table" fieldwidth:150 across:2 align:#right offset:[80,2] readonly:true
				button mat_shadetable_browse "Browse..." align:#right
				edittext mat_blendtable_ui "Blend Table" fieldwidth:150 across:2 align:#right offset:[80,2] readonly:true
				button mat_blendtable_browse "Browse..." align:#right
				edittext mat_fogtable_ui "Fog Table" fieldwidth:150 across:2 align:#right offset:[80,2] readonly:true
				button mat_fogtable_browse "Browse..." align:#right
				spinner mat_fog_min "fog min:"range:[0,1,0.1] type:#float fieldwidth:50 scale:0.1 align:#right across:2
				spinner mat_fog_max "fog max:" range:[0,1,0.1] type:#float fieldwidth:50 scale:0.1  --align:#right  offset:[-80,2]
				colorpicker mat_fog_color "fog color: "color:(color 128 128 128) align:#right
			)
			
			--on mat_ambient changed val do mat_ambient_entry.text = val as string
			--on mat_directional changed val do mat_directional_entry.text = val as string
			--on mat_specular changed val do mat_specular_entry.text = val as string
			on mat_ambient_entry changed val do try mat_ambient = val as float catch 0.1
			on mat_directional_entry changed val do try mat_directional = val as float catch 0.7
			on mat_specular_entry changed val do try mat_specular = val as float catch 0
			on mat_specularpower changed val do try mat_power = val as float catch 20
				
			on mat_shadetable_browse pressed do (
				tabFile = getopenfilename types:"TAB files (*.tab)|*.tab"
				if tabFile != undefined then (
					mat_shadetable_ui.text = filenamefrompath tabFile
					mat_shadetable = filenamefrompath tabFile
				)
			)
			on mat_blendtable_browse pressed do (
				tabFile = getopenfilename types:"TAB files (*.tab)|*.tab"
				if tabFile != undefined then (
					mat_blendtable_ui.text = filenamefrompath tabFile
					mat_blendtable = filenamefrompath tabFile
				)
			)
			on mat_props open do (
				if mat_blendtable != undefined do mat_blendtable_ui.text = mat_blendtable
				if mat_shadetable != undefined do mat_shadetable_ui.text = mat_shadetable
			)
		)
	)
)

textureChange_lvl_CA = attributes textureChange_lvl_data
attribid:#(0x188614ba, 0x4790f476)
(
	parameters textureChange_lvl_params
	(
		lvl_bitmap type:#string default:"level bitmap" 
		threshold type:#float default:0.2
		coltype type:#integer default:1
		flags type:#integer default:0
		connotations type:#material
	)
)

Smash_CA = attributes Smash_data 
attribID:#(0x42779170, 0x7a1c1ad5)
(	
	parameters smash_params
	(
		type type:#integer default:1
		mode type:#integer default:1
		flags type:#integer default:0
		threshold type:#float default:1.0
		triggerName type:#string default:""
		model type:#node
		material type:#material
	
		firechance type:#integer default:100
		firecollumns type:#integer default:1
		firemin type:#integer default:0
		firemax type:#integer default:0
		replacemodel type:#node

		startbitmap type:#string default:"Initial bitmap"
		levels type:#materialtab tabsize:0 tabsizevariable:true
		
		connotations type:#material
	)
)

groove_CA = attributes groove_data
attribID:#(0x23a8c778, 0x4277f466)
(
	parameters groove_params
	(
		lollipop type:#integer default:1
		distance type:#integer default:1
		path_type type:#integer default:1
		path_mode type:#integer default:1
		path_grfu type:#integer default:0
		path_centre type:#point3 default:[0,0,0]
		path_extent type:#point3 default:[0,0,0]
		path_speed type:#float default:1.0
		path_radius type:#float default:0.0
		path_axis type:#integer default:1
		animation_type type:#integer default:1
		animation_mode type:#integer default:1
		animation_grfu type:#integer default:0
		animation_centre type:#point3 default:[0,0,0]
		animation_extent type:#point3 default:[0,0,0]
		animation_speed type:#float default:1.0
		animation_angle type:#float default:0
		animation_axis type:#integer default:1
	)
)

funk_CA = attributes funk_data
attribID:#(0xaf719ca, 0x64ff0330)
(
	parameters funk_params
	(
		distance type:#integer default:1
		lighting type:#integer default:1
		animation_type type:#integer default:1
		animation_mode type:#integer default:1
		animation_grfu type:#integer default:0
		animation_speed_x type:#float default:1.0
		animation_speed_y type:#float default:1.0
		animation_extent_x type:#float default:1.0
		animation_extent_y type:#float default:1.0
		animation_centre_x type:#float default:0.5
		animation_centre_y type:#float default:0.5
		animation_period type:#float default:2
		animation_angle type:#float default:25
		sequence_type type:#integer default:1
		sequence_mode type:#integer default:1
		sequence_texturebits type:#integer default:1
		sequence_playback type:#integer default:1
		sequence_framerate type:#integer default:1
		frames_list type:#stringtab tabsize:0 tabsizevariable:true
		frames_xCounts type:#inttab tabsize:0 tabsizevariable:true
		frames_xIndexes type:#inttab tabsize:0 tabsizevariable:true
		frames_yCounts type:#inttab tabsize:0 tabsizevariable:true
		frames_yIndexes type:#inttab tabsize:0 tabsizevariable:true
	)
)

connotations_CA = attributes connotations_data
attribid:#(0x67174092, 0x48fc38bb)
(
	parameters connotations_params
	(
		sounds type:#stringtab tabsize:0 tabsizevariable:true
		
		shrapnels type:#materialtab tabsize:0 tabsizevariable:true
		
		explosions type:#materialtab tabsize:0 tabsizevariable:true
		
		slick type:#string default:"none"
		slick_x type:#integer default:100
		slick_y type:#integer default:100
		slick_z type:#integer default:100
		slick_width type:#float default:0.2
		slick_height type:#float default:0.2
		slick_length type:#float default:0.2
		min_skidduration type:#float default:20
		max_skidduration  type:#float default:20
		min_skidfriction type:#float default:0.6
		max_skidfriction type:#float default:0.6
		skidmaterial type:#integer default:1
		
		noncars type:#materialtab tabsize:0 tabsizevariable:true
		
		sideEffects type:#materialtab tabsize:0 tabsizevariable:true
		
		extensionFlag type:#integer default:0
		powerup type:#integer default:0
		awardcode type:#integer default:1
		credits type:#integer default:0
		timebonus type:#integer default:0
		textmessage type:#integer default:0
		scrollermessage type:#integer default:0
		runtimevars type:#stringtab tabsize:0 tabsizevariable:true
	)
)