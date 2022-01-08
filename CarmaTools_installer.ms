try destroydialog CarmaTools_installer catch()
rollout CarmaTools_installer "Carmatools installer" (
	label lbl1 "Make sure you are running \nthis in administrator mode" height:30 align:#left
	button install "Install" width:150 height:30 tooltip:"Install Macroscripts and Toolbar. Dock it and close max to finish the installation"
	on install pressed do
	(
		tempDir = pathConfig.GetDir #temp + "\\CarmaTools"
		
		scriptDir = pathConfig.GetDir #scripts + "\\Carma_Tools"
		makeDir scriptDir
		
		if doesfileexist scriptDir then (
			query = queryBox "This will remove the old installation, are you sure?" title:"Old installation detected" beep:false
			if query then (
				local absPath = scriptDir 
				dosCommand ( "rmdir " + absPath + "/S /Q" )
				
				
				makeDir scriptDir
				scriptFiles = getfiles ( tempDir + "\\Scripts\\Carma_Tools\\*.ms" )
				for f in scriptFiles do (
					newFileName = ( scriptDir + "\\" + filenamefromPath f )
					if doesfileExist newFileName then deleteFile newFileName
					copyFile f newFileName
				)
				
				--copy lib files
				libDir = scriptDir + "\\Lib"
				makeDir libDir
				libFiles = getfiles ( tempDir + "\\Scripts\\Carma_Tools\\Lib\\*.ms" )
				for f in libFiles do (
					newFileName = ( libDir + "\\" + filenamefromPath f )
					if doesfileExist newFileName then deleteFile newFileName
					copyFile f newFileName
				)
				
				--copy icons
				iconFiles = getfiles ( tempDir + "\\Icons\\*.bmp" )
				for ico in iconFiles do (
					newFileName = ( pathConfig.GetDir #userIcons + "\\" + filenamefrompath ico )
					if doesfileExist newFileName then deleteFile newFileName
					copyFile ico newFileName
				)
				
				for mcr in ( getFiles ( tempDir + "\\Scripts\\*.mcr" ) ) do (
					fileIn ( mcr ) 
				)
				colorman.reInitIcons()
				destroydialog CarmaTools_installer
				
				--create a new toolbar using the CUI config file
				dotNet.loadAssembly "system.xml"
				xmlDoc = dotNetObject "system.xml.xmlDocument"

				filename = cui.getConfigFile()
				clearlistener()
				xmlDoc.load filename

				rootElement = xmlDoc.documentElement
				CUIWindowsElement = rootElement.ChildNodes.itemOf[0]
				CUIWindows = CUIWindowsElement.ChildNodes
				checkExisting = false
				window = undefined
				--remove old Toolbar
				for i = 0 to CUIWindows.count -1 do (
					window = CUIWindows.itemOf[i]
					windowName = window.getAttribute "name"
					if ( tolower windowName ) == "carmatools" then (
						CUIWindowsElement.RemoveChild Window
						exit
					)
				)
				--Add new toolbar window
				newElement = xmlDoc.createElement "Window"
				newElement.setAttribute "name" "Carmatools"
				newElement.setAttribute "type" "T"
				newElement.setAttribute "rank" "0"
				newElement.setAttribute "subrank" "2"
				newElement.setAttribute "hidden" "0"
				newElement.setAttribute "dPanel" "1"
				newElement.setAttribute "tabbed" "0"
				newElement.setAttribute "curTab" "-1"
				newElement.setAttribute "cType" "1"
				newElement.setAttribute "toolbarRows" "1"
				newElement.setAttribute "toolbarType" "16"
				
				CUIWindowsElement.appendChild newElement
				FRect = xmlDoc.createElement "FRect"
				FRect.setAttribute "left" "26"
				FRect.setAttribute "top" "327"
				FRect.setAttribute "right" "290"
				FRect.setAttribute "bottom" "393"
				newElement.appendChild FRect
				DRect = xmlDoc.createElement "DRect"
				DRect.setAttribute "left" "1606"
				DRect.setAttribute "top" "53"
				DRect.setAttribute "right" "1875"
				DRect.setAttribute "bottom" "92"
				newElement.appendChild DRect
				DRectPref = xmlDoc.createElement "DRectPref"
				DRectPref.setAttribute "left" "2147483647"
				DRectPref.setAttribute "top" "2147483647"
				DRectPref.setAttribute "right" "-2147483648"
				DRectPref.setAttribute "bottom" "-2147483648"
				newElement.appendChild DrectPref
				CurPos = xmlDoc.createElement "CurPos"
				CurPos.setAttribute "left" "26"
				CurPos.setAttribute "top" "327"
				CurPos.setAttribute "right" "290"
				CurPos.setAttribute "bottom" "393"
				CurPos.setAttribute "floating" "1"
				CurPos.setAttribute "panelID" "16"
				newElement.appendChild CurPos
				Items = xmlDoc.createElement "Items"
				newElement.appendChild Items
				names = #( "Dat_importer", "Dat_exporter", "Car_setup", "Track_setup", "Preprocessing_setup", "Nonc_setup", "Act_props", "Mat_props" )
				tips = #( "Dat importer", "Dat exporter", "Car setup", "Track setup", "Preprocessing setup", "Noncar setup", "Actor properties", "Material properties" )
				for i = 1 to 8 do (
					Item = xmlDoc.createElement "Item"
					Item.setAttribute "typeID" "2"
					Item.setAttribute "type" "CTB_MACROBUTTON"
					Item.setAttribute "width" "0"
					Item.setAttribute "height" "0"
					Item.setAttribute "controlID" "0"
					Item.setAttribute "macroTypeID" "3"
					Item.setAttribute "macroType" "MB_TYPE_ACTION"
					Item.setAttribute "actionTableID" "647394"
					Item.setAttribute "imageID" "-1"
					Item.setAttribute "imageName" ""
					Item.setAttribute "actionID" ( names[i] + "`Carma_tools" )
					Item.setAttribute "tip" ( "CarmaTools - " + tips[i] )
					Item.setAttribute "label" ( "CarmaTools - " + tips[i] )
					Items.appendChild Item
				)
				xmlDoc.save filename
				cui.loadConfig filename
			)
		)
	)
)
createdialog Carmatools_installer height:80 width:160 style:#( #style_sysmenu, #style_toolwindow )