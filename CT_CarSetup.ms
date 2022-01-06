--global variables

--script links for loading external scripts
scriptDir =  scriptspath+"\\Carma_tools\\"
--scriptDir =  "C:\\Users\\harms\\Google Drive\\Carmatools 2020\\Carma_Tools\\"
--scriptDir =  "C:\\Users\\909754\\Google Drive\\Carmatools 2020\\Carma_Tools\\"
LibDir = scriptDir+"Lib\\"

filein (libDir + "CT_UIValues.ms")

--load functions
filein (libDir + "CT_Functions.ms")

--load custom Attributes
filein (libDir + "CT_customAttributes.ms")
filein (libDir + "CT_carCustomAttributes.ms")
custAttributes.add rootnode carGeneralAttributes

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

--car setup scripts
filein (libDir + "CT_carGlobalSetup.ms")
filein (libDir + "CT_carGroovyFunkRefSetup.ms")
filein (libDir + "CT_carMechanicsSetup.ms")
filein (libDir + "CT_carDamageInfo.ms")
filein (libDir + "CT_carWamSetup.ms")
filein (libDir + "CT_carQuickSetup.ms")

(	
	global carSetup 
	try(destroyDialog carSetup )catch()

	local LastSubRollout = 1
	
	testTabs_Rollouts = #(
		"Car Globals",
		"Mechanics",
		"GroovyFunkRef",
		"Grooves",
		"Funks",
		"Damage Info",
		"Wam Setup",
		"Quick Setup"
	)

	rollout carSetup "Carmatools - Car Setup"
	(
		local bmargin = 100
		dotNetControl dn_tabs "System.Windows.Forms.TabControl" height:48 width:(carSetup.width-8) offset:[-10,0]--align:#center 
		subRollout theSubRollout width:(carSetup.width - 20) height:(carSetup.height - 100) align:#center
		button export_wamtxt "Export WAM file" width:widthB height:30 pos:(theSubRollout.pos + [140,(theSubRollout.height + 6)])
		button export_cartxt "Export TXT file" width:widthB height:30 pos:(theSubRollout.pos + [260,(theSubRollout.height + 6)])
		
		on export_cartxt pressed do (
			fileIn (libDir + "CT_CarTXT.ms") quiet:true
		)
		on export_wamTxt pressed do (
			filein (libDir + "CT_carWAM.ms") quiet:true
		)			
		on dn_tabs Selected itm do (
			if LastSubRollout != (itm.TabPageIndex+1) do (
				LastSubRollout = itm.TabPageIndex+1
				rollouts = #()
				for subroll in theSubRollout.rollouts do (
					removeSubRollout theSubRollout subroll
					if (itm.TabPageIndex+1)==1 then rollouts = #(#(carGlobalSetup,false))
					if (itm.TabPageIndex+1)==2 then rollouts = #(#(MechanicsSetup,false))
					if (itm.TabPageIndex+1)==3 then rollouts = #(#(groovyFunkRefSetup,false))
					if (itm.TabPageIndex+1)==4 then rollouts = #(#(GrooveSetup,false))
					if (itm.TabPageIndex+1)==5 then rollouts = #(#(FunkSetup,false))
					if (itm.TabPageIndex+1)==6 then rollouts = #(#(damageInfo,false))
					if (itm.TabPageIndex+1)==7 then rollouts = #(#(carWamSetup,false)) 
					if (itm.TabPageIndex+1)==8 then rollouts = #(#(carQuickSetup,false)) 
				)
				for subroll in rollouts do (
					addSubRollout theSubRollout subroll[1] rolledup:subroll[2]
				)
			) 
		)
		on carSetup open do (
			dn_tabs.Multiline = true
			dn_tabs.SizeMode = (dotNetclass "System.Windows.Forms.TabSizeMode").FillToRight
			dn_tabs.ItemSize = dotNetObject "System.Drawing.Size" ((dn_tabs.width-3)/4) 20
			for aTab in testTabs_Rollouts do (
				dn_tabs.TabPages.add aTab
			)
			rollouts = #(#(carGlobalSetup,false))
			for subroll in rollouts do (
				addSubRollout theSubRollout subroll[1] rolledup:subroll[2]
			)			
		)
		on carSetup resized size do (
			theSubRollout.height = (size.y-bmargin)
			export_wamtxt.pos =theSubRollout.pos + [140,(theSubRollout.height + 6)]
			export_cartxt.pos =  theSubRollout.pos + [260,(theSubRollout.height + 6)]
		)
	)
	createDialog carSetup superWidth height style:#(#style_titlebar, #style_border,#style_sysmenu, #style_resizing,#style_minimizebox) lockWidth:true
)