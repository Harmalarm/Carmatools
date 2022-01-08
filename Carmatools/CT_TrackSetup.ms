--global variables
global renameNode = undefined

--script links for loading external scripts
LibDir =  scriptspath+"\\Carma_tools\\Lib\\"

--load custom Attributes
filein (libDir + "CT_customAttributes.ms")
fileIn (libDir + "CT_trackCustomAttributes.ms")

--track setup scripts
filein (libDir + "CT_TrackEnvironmentSetup.ms")
fileIn (libDir + "CT_TrackMinimapSetup.ms")
fileIn (libDir + "CT_TrackGeneralSetup.ms")
fileIn (libDir + "CT_TrackNoncarLoadingSetup.ms")
fileIn (libDir + "CT_TrackSpecialEffectsVolumeSetup.ms")
fileIn (libDir + "CT_TrackMaterialModifierSetup.ms")
fileIn (libDir + "CT_TrackgameSetup.ms")

custAttributes.add rootnode track_general_CA

(	
	global trackSetup 
	try(destroyDialog trackSetup )catch()

	local LastSubRollout = 1

	testTabs_Rollouts = #(
		"Environment",
		"General",
		"Map Details",
		"Funks",
		"Grooves",
		"Noncars",
		"Smashables",
		"Special Effect Volumes",
		"Material Behaviour",
		"Game Settings"
	)

	rollout trackSetup "Carmatools - Track Setup"
	(
		local bmargin = 100
		
		dotNetControl dn_tabs "System.Windows.Forms.TabControl" height:48 width:(trackSetup.width-8) offset:[-10,0]--align:#center 
		subRollout theSubRollout width:(trackSetup.width - 20) height:(trackSetup.height - 100) align:#center
		
		button export_tracktxt "Export / Update TXT" width:160 height:30 pos:(theSubRollout.pos + [170,(theSubRollout.height + 9)])
		on export_tracktxt pressed do
		(
			fileIn (libDir + "CT_TrackTXT.ms") quiet:true
		)
		
		on dn_tabs Selected itm do (
			if LastSubRollout != (itm.TabPageIndex+1) do (
				LastSubRollout = itm.TabPageIndex+1
				rollouts = #()
				for subroll in theSubRollout.rollouts do (
					removeSubRollout theSubRollout subroll
					if (itm.TabPageIndex+1)==1 then rollouts = #(#(environmentSetup,false))
					if (itm.TabPageIndex+1)==2 then rollouts = #(#(generalTrackSetup,false))
					if (itm.TabPageIndex+1)==3 then rollouts = #(#(minimapSetup,false))
					if (itm.TabPageIndex+1)==4 then rollouts = #(#(funkSetup,false))
					if (itm.TabPageIndex+1)==5 then rollouts = #(#(grooveSetup,false))
					if (itm.TabPageIndex+1)==6 then rollouts = #(#(noncarLoadingSetup,false))
					if (itm.TabPageIndex+1)==7 then rollouts = #(#(smashableSetup,false))
					if (itm.TabPageIndex+1)==8 then rollouts = #(#(SpecialEffectsVolumeSetup,false))
					if (itm.TabPageIndex+1)==9 then rollouts = #(#(materialModifierSetup,false))
					if (itm.TabPageIndex+1)==10 then rollouts = #(#(gameSetup,false))
				)
				for subroll in rollouts do (
					addSubRollout theSubRollout subroll[1] rolledup:subroll[2]
				)
			) 
		)	
		on trackSetup open do (
			dn_tabs.Multiline = true
			dn_tabs.SizeMode = (dotNetclass "System.Windows.Forms.TabSizeMode").FillToRight
			dn_tabs.ItemSize = dotNetObject "System.Drawing.Size" ((dn_tabs.width-3)/4) 20
			for aTab in testTabs_Rollouts do (
				dn_tabs.TabPages.add aTab
			)
			rollouts = #(#(environmentSetup,false))
			for subroll in rollouts do (
				addSubRollout theSubRollout subroll[1] rolledup:subroll[2]
			)			
		)
		on trackSetup resized size do (
			theSubRollout.height = (size.y-bmargin)
			export_tracktxt.pos = theSubRollout.pos + [170,(theSubRollout.height + 9)]
		)
	)
	createDialog trackSetup superWidth height style:#(#style_titlebar, #style_border,#style_sysmenu, #style_resizing,#style_minimizebox) lockWidth:true
)