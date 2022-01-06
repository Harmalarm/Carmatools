--try destroydialog minimapSetup catch()
rollout minimapSetup "Map details:" (
	local placementPos = 24
	group "Minimap Settings:"(
		
		button miniMap_generate "Generate bitmap" width:widthC pos:[colA,placementPos] tooltip:"Generate a bitmap of the current track scene OR the selection" 
		label map_rotation_label "Rotation:" pos:[colE+8,placementPos+4]
		dropdownlist map_rotation  items:#("0","90","180","270") selection:1 width:widthA pos:[colF,placementPos]
		button miniMap_pick "Pick bitmap" width:widthC pos:[colA,placementPos+=26] tooltip:"Pick a bitmap from disk or rightclick to reset the miniMap slot"
		label minimap_file_label "Map File Preview: (320x240)" width:widthC pos:[colA,placementPos+=26]
		button miniMap_preview "" width:320 height:240
		
		spinner tm_x1 "x1" fieldwidth:40 width:widthB pos:[colA,placementPos+=263]
		spinner tm_y1 "y1" fieldwidth:40 width:widthB pos:[colC,placementPos]
		spinner tm_z1 "z1" fieldwidth:40 width:widthB pos:[colE,placementPos]
		spinner tm_x2 "x2" fieldwidth:40 width:widthB pos:[colA,placementPos+=21]
		spinner tm_y2 "y2" fieldwidth:40 width:widthB pos:[colC,placementPos]
		spinner tm_z2 "z2" fieldwidth:40 width:widthB pos:[colE,placementPos]
		spinner tm_x3 "x3" fieldwidth:40 width:widthB pos:[colA,placementPos+=21]
		spinner tm_y3 "y3" fieldwidth:40 width:widthB pos:[colC,placementPos]
		spinner tm_z3 "z3" fieldwidth:40 width:widthB pos:[colE,placementPos]
		spinner tm_x4 "x4" fieldwidth:40 width:widthB pos:[colA,placementPos+=21]
		spinner tm_y4 "y4" fieldwidth:40 width:widthB pos:[colC,placementPos]
		spinner tm_z4 "z4" fieldwidth:40 width:widthB pos:[colE,placementPos]
	)
	
	fn updateMinimapControlValues = (
		updatePreviewBitmap minimap_preview rootnode.minimapBitmap 320 240
		map_rotation.selection = rootnode.minimapRotation
		tm = rootnode.minimapTm
		tm_x1.range.z = tm[1]
		tm_y1.range.z = tm[2]
		tm_z1.range.z = tm[3]
		tm_x2.range.z = tm[4]
		tm_y2.range.z = tm[5]
		tm_z2.range.z = tm[6]
		tm_x3.range.z = tm[7]
		tm_y3.range.z = tm[8]
		tm_z3.range.z = tm[9]
		tm_x4.range.z = tm[10]
		tm_y4.range.z = tm[11]
		tm_z4.range.z = tm[12]
	)
	
	on minimapSetup open do (
		minimapSetup.height = 428
		updateMinimapControlValues()
	)
	on minimap_pick pressed do (
		try rootnode.minimapBitmap = setPreviewBitmap minimap_preview 320 240
		catch rootnode.minimapBitmap = "None"
	)
	on minimap_pick rightclick do (
		rootnode.minimapBitmap = "None"
		updatePreviewBitmap minimap_preview rootnode.minimapBitmap 320 240
	)
	on miniMap_generate pressed do
	(
		--define locals
		local horBounds, vertBounds,horizontalFov, verticalFov, image_ratio = undefined
		
		minimap = BitMap 640 480 color:black filename:".tif"
		if selection[1] == undefined then renderobjects = objects
		else renderobjects = selection
		--create a camera
		orthoCamera = freecamera pos:[renderobjects.center.x,renderobjects.center.y,1] orthoProjection:true 
		orthoCamera.Target_Distance = 1.0f
		if map_rotation.selection == 1 or map_rotation.selection == 3 then
		(
			horBounds = renderobjects.max.x - renderobjects.min.x
			vertBounds =  renderobjects.max.y - renderobjects.min.y
		)
		else 
		(
			vertBounds = renderobjects.max.x - renderobjects.min.x
			horBounds =  renderobjects.max.y - renderobjects.min.y
		)
		r_aspect=(renderHeight as float)/renderwidth
		horizontalFov = 2.0 * (atan(horbounds/2))
		verticalFov = 2.0*atan(tan((2* (atan (vertbounds/2 )))/2.0)/r_aspect)
		
		--taking the vertical bounds as leading
		if horizontalFov < verticalFov or horizontalFov == verticalFov do
		(
			orthoCamera.fovtype = 2
			orthoCamera.fov = verticalFov
			image_ratio = 480 / (vertBounds)
		)
		--taking the horizontal bounds as leading
		if horizontalFov > verticalFov do
		(
			orthoCamera.fovtype = 1
			orthoCamera.fov = horizontalFov
			image_ratio = 640 / (horBounds)
		)
		orthocamera.rotation.z_rotation = (map_rotation.selected as integer)
		render camera:orthoCamera to:minimap progressbar:on vfb:off
		minimapfilename = GetSaveFileName caption:"Choose an exportname" types:"Tif(*.tif)"
		if minimapfilename != undefined do
		(
			minimap.filename = (minimapfilename)
			save minimap
			rootnode.track_general_attributes.minimapbitmap = minimapfilename
			if map_rotation.selection == 1 do minimaptm = #(image_ratio,0,0,0,0,0,0,image_ratio,0,(320 - (renderobjects.center.x * image_ratio)),(240 + (renderobjects.center.y * image_ratio)),0)
			if map_rotation.selection == 2 do minimaptm = #(0,image_ratio,0,0,0,0,-image_ratio,0,0,(320 - (renderobjects.center.y * image_ratio)),(240 - (renderobjects.center.x * image_ratio)),0)
			if map_rotation.selection == 3 do minimaptm = #(-image_ratio,0,0,0,0,0,0,-image_ratio,0,(320 + (renderobjects.center.x * image_ratio)),(240 - (renderobjects.center.y * image_ratio)),0)
			if map_rotation.selection == 4 do minimaptm = #(0,-image_ratio,0,0,0,0,image_ratio,0,0,(320 + (renderobjects.center.y * image_ratio)),(240 + (renderobjects.center.x * image_ratio)),0)
			rootnode.track_general_attributes.minimaptm = minimaptm
		)
		delete orthoCamera
		
		updatePreviewBitmap minimap_preview rootnode.minimapBitmap 320 240
	)
	on map_rotation selected i do rootnode.minimapRotation = i
	on tm_x1 changed val do rootnode.minimapTm[1] = val
	on tm_y1 changed val do rootnode.minimapTm[2] = val
	on tm_z1 changed val do rootnode.minimapTm[3] = val
	on tm_x2 changed val do rootnode.minimapTm[4] = val
	on tm_y2 changed val do rootnode.minimapTm[5] = val
	on tm_z2 changed val do rootnode.minimapTm[6] = val
	on tm_x3 changed val do rootnode.minimapTm[7] = val
	on tm_y3 changed val do rootnode.minimapTm[8] = val
	on tm_z3 changed val do rootnode.minimapTm[9] = val
	on tm_x4 changed val do rootnode.minimapTm[10] = val
	on tm_y4 changed val do rootnode.minimapTm[11] = val
	on tm_z4 changed val do rootnode.minimapTm[12] = val
)
--createdialog minimapSetup width height