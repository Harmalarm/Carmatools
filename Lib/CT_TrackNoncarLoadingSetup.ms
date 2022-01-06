--try destroydialog noncarLoadingSetup catch()
rollout noncarLoadingSetup "Noncars loaded:" (
	local placementPos = 24
	Group "Noncars textfiles used by Track:" (
		listbox noncarsList "" width:widthF height:10 placement:[colA,placementPos]
		button noncarsAdd "Add noncar" width:widthC pos:[colA,placementPos+=noncarsList.height+4]
		button noncarsRemove "Remove noncar" width:widthC pos:[colD,placementPos]
	)
	Group "Noncar Setup tool:"
	(
		label noncarsLbl "The Noncar Setup is done with a seperate tool:" width:widthC height:50 pos:[colA,placementPos+=50]
		button noncarSetupLoad "Open noncar Setup Tool" width:widthC pos:[colD,placementPos]
		label noncarsEnd "" pos:[colA,placementPos+=14]
	)
	fn updateNoncarsList = (
		noncarsList.items = try rootnode.track_general_attributes.noncars_list as array catch (#())
		noncarsList.selection = noncarsList.items.count
	)
	
	on noncarLoadingSetup open do (
		noncarLoadingSetup.height = 252
		updateNoncarsList()
	)
	on noncarsAdd pressed do (
		--newFile = getopenfilename caption:"Open A Text File:" types:"TXT(*.txt)"
		theDialog = dotNetObject "System.Windows.Forms.OpenFileDialog"
		theDialog.title = "Please Select One Or More Files"
		theDialog.Multiselect = true
		theDialog.Filter = "TXT Files (*.txt)|*.txt"
		result = theDialog.showDialog()
		result.ToString()
		result.Equals result.OK
		result.Equals result.Cancel
		theFilenames = theDialog.fileNames
		
		if theFilenames.count > 0 then (
			for newFile in theFilenames do (
				dataDir = try rootnode.gameDir + "Data\\" catch ("")
				print newFile
				if dataDir != "" then (
					if (findstring newFile dataDir) != 0 then (
						newFile = substitutestring newFile dataDir "..\\"
					)
				)
				else (
					newfile = filenamefrompath newFile
				)
				if newFile != undefined then (
					append rootnode.track_general_attributes.noncars_list newFile
					updateNoncarsList()
				)
			)
		)
	)
	on noncarsRemove pressed do (
		sel = noncarsList.selection
		try deleteitem rootnode.track_general_attributes.noncars_list sel catch()
		updateNoncarsList()
	)
	on noncarSetupLoad pressed do (
		filein (scriptDir + "CT_NoncarSetup.ms")
	)
)
--createdialog noncarLoadingSetup width height