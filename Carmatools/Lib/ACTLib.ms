Struct actorClass (
	actorName, 
	modelName,
	materialName,
	matrix,
	parent,
	rendermode1,
	rendermode2,
	bbox,
	object,
	children,
	startHierarchy = false
)

function parseACT actFileName = (
	CT_importer.impProg.text = "Progress: Parsing ACT file(s)"
	actors = #()
	if (actFileName!=undefined)do
	(
		f = fopen actFileName "rb"
		try (
			--determine filesize
			fseek f 0 #seek_end
			filesize = ftell f 
			fseek f 0 #seek_set
			
			--read header and check
			header1 = freadlong f
			header2 = freadlong f
			header3 = freadlong f
			header4 = freadlong f
			
			--define local empty parent
			local parent = undefined
			
			--read actor entries
			while (ftell f < filesize) do (
				identifier = freadlong f
				blocklength = freadlong f
				
				if identifier == 35 then (
					actor = actorClass()
					actor.parent = parent
					parent = actor
					append actors actor
					
					actor.rendermode1 = freadbyte f
					actor.rendermode2 = freadbyte f
					actor.actorName = readstring f
				)
				if identifier == 43 then (
					x1 = freadfloat f
					x2 = freadfloat f
					x3 = freadfloat f
					y1 = freadfloat f
					y2 = freadfloat f
					y3 = freadfloat f
					z1 = freadfloat f
					z2 = freadfloat f
					z3 = freadfloat f
					t1 = freadfloat f
					t2 = freadfloat f
					t3 = freadfloat f
					
					matrix = (matrix3 [x1,x2,x3] [y1,y2,y3] [z1,z2,z3] [t1,t2,t3])
					actor.matrix = matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0] * matrix * inverse(matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0])
					
				)
				if identifier == 37 then (
					--unknown data values
				)
				if identifier == 38 then (
					actor.materialName = readstring f
				)
				if identifier == 36 then (
					--modelName = readstring f
					--actor.modelName = (filterstring modelName ".")[1]
					actor.modelName = readstring f
				)
				if identifier == 50 then (
					xmin = freadfloat f
					ymax = freadfloat f
					zmin = freadfloat f
					xmax = freadfloat f
					ymin = freadfloat f
					zmax = freadfloat f
					
					actor.bbox = #([xmin, -zmin, ymin], [xmax, -zmax, ymax])
				)
				if identifier == 41 then (
					--start hierarchy level
				)
				if identifier == 42 then (
					--end hierarchy level
					if parent != undefined then (
						parent = parent.parent
					)
				)
				if identifier == 0 then (
					--end of file
				)
			)
		)
		catch (
			fclose f
			print (getCurrentException())
		)
	)
	--basically a return function but without the wait
	actors
)

function getModelByName datModels matMaterials modelName = (
	sceneModel = undefined
	if modelName != undefined then (
		for m in datModels where (m != undefined) do (
			if m.modelName == modelName then (
				if m.object == undefined then (
					m.object = buildModel m matMaterials
				)
				sceneModel = m.object
			)
		)
	)
	sceneModel
)
	
fn FindModelByName modelName datModels = (
	local lookupKey = modelClass modelname:modelName
	bsearch lookupKey datModels compareModelNames
)

function buildActor actor datModels matMaterials = (
	realActor = undefined
	if actor != undefined then (
		--set empty actor incase the model does not exist
		if actor.modelName == undefined then (
			realActor = dummy boxsize:[0.1,0.1,0.1] wirecolor:(color 135 59 8)
			setGroupHead realActor on
			setGroupOpen realActor true
			realActor.name = actor.actorName
			CenterPivot realActor
		)
		--set actor model when modelname is present
		modelName = actor.modelName
		if modelName != undefined then (
			--try regular modelname and instanced modelname to lookup the model
			st = timestamp()
			datModel = FindModelByName modelName datModels
			if datModel.object == undefined then (
				datModel.object = buildModel datModel matMaterials
			)
			model = datModel.object
			--format "QSort Time: %ms, modelname = %\n" (timestamp()-st) (try model.name catch())
			st = timestamp()
			model = getModelByName datModels matMaterials modelName
			--format "regular search Time: %ms, modelname = %\n" (timestamp()-st) (try model.name catch())
			if model == undefined then (
				model = getModelByName datModels matMaterials (filterstring modelName ".")[1]
			)
			--if model is not present in the scene, try to find it via external files
			if model == undefined then (
				modelLookup = true
				while modelLookup == true do (
					externalFile = getOpenFileName caption:("Please locate DAT file containing model: " + modelName) types:"DAT files (*.dat)|*.dat"
					if externalFile != undefined then (
						newModels = parseDat externalFile
						datModels = join datModels newModels
						
						model = getModelByName datModels matMaterials modelName
						if model != undefined then (
							modelLookup = false
						)
					)
					if externalFile == undefined then (
						modelLookup = false
					)
				)
			)
			if model != undefined then (
				realActor = instance model
				--print realActor.name
			)
		)
		
		if realActor == undefined then (
			realActor = dummy boxsize:[0.1,0.1,0.1] wirecolor:(color 255 0 0)
			realActor.name = "missing model: " + actor.modelName
		)
		
		--adjust object name for empty actors
		if actor.actorName == "" then (
			actor.actorName = "NO_IDENTIFIER"
		)
		realActor.name = actor.actorName
		
		--set parent
		if actor.parent != undefined then (
			realActor.parent = actor.parent.object
			if isgrouphead realActor.parent then (
				setgroupmember realActor true
			)
		)
		--set transform
		if actor.parent != undefined then (
			realActor.transform = actor.matrix * realActor.parent.transform
		)
		else (
			realActor.transform = actor.matrix
		)
		
		--set actor bounding box
		if actor.bbox != undefined then (
			/*
			bbox = actor.bbox
			bmin = bbox[1]
			bmax = bbox[2]
			size = bmax-bmin
			center = (bmin + bmax) / 2
			w = abs size.x
			h = abs size.y
			l = abs size.z
			realActor.boxsize = [w,h,l]
			realActor.pos = center
			*/
		)
		
		--set actor material if present
		if actor.materialName != undefined then (
			--find actor material
			--print matMaterials
			actorMat = getMatByName matMaterials actor.materialName
			
			if realActor.material == undefined then (
				realActor.material = actorMat
			)
			else (
				if classof realActor.material == standard then (
					material = multimaterial()
					material.numsubs = 2
					material.materiallist[1] = realActor.material
					material.materiallist[2] = actorMat
					realActor.material = material
				)
				else (
					if classof realActor.material == multimaterial then (
						material = realActor.material
						material.numsubs = (material.numsubs + 1)
						material[material.numsubs] = actorMat
						realActor.material = material
					)
				)
			)
			custattributes.add realActor actorAttributes
			realActor.materialName = actor.materialName
		)
		
		--set actor attribute incase modelname != actorname
		if actor.modelName != undefined and actor.modelName != "" then (
			if actor.modelName != actor.actorName then (
				custattributes.add realActor actorAttributes
				realActor.modelName = actor.modelName
			)
		)
	)
	actor.object = realActor
	realActor
)

fn getChildrenBBox node tm: = (
	if tm == unsupplied do tm = node.transform
	local minx = #(), miny = #(), minz = #(), maxx = #(), maxy = #(), maxz = #() 
	for c in node.children do (
		bb = nodeGetBoundingBox c tm
		append minx bb[1].x
		append miny bb[1].y
		append minz bb[1].z
		append maxx bb[2].x
		append maxy bb[2].y
		append maxz bb[2].z
	)
	minx = amin minx 
	miny = amin miny 
	minz = amin minz 
	maxx = amax maxx 
	maxy = amax maxy 
	maxz = amax maxz
	
	#(abs(maxx-minx),abs(maxy-miny),abs(maxz-minz))
)

function exportACT actFileName = (
	--determine all valid actors and put them in an 'actorTree'
	validActors = #()
	helperAttributes = #("smashable_data","sev_data","starting_grid_attributes","starting_grid_attributes","checkp_data")
	for obj in objects where obj.ishidden == false do (
		if classof obj == editable_poly or classof obj == editable_mesh or classof obj == line or classof obj == polymeshobject then (
			isHelper = false
			for atrib in helperAttributes do (
				if hasAttribute obj atrib then isHelper = true
			)
			try (
				if obj == rootnode.oppPath_object or obj == rootnode.dronePath_object then (
					isHelper = true
				)
			)
			catch()
			if not isHelper then (
				append validActors obj
			)
		)
		if isgrouphead obj then (
			append validActors obj
		)
	)
	
	actors = #()
	actorMaterials = #()
	
	models = #()
	modelNames = #()
	mainParents = #()
	for obj in validActors do (
		actor = actorClass()
		actor.actorName = obj.name
		
		--specifics for dummy actors
		if isgrouphead obj then (
			if (obj.name == "NO_IDENTIFIER") or (substring obj.name 1 4 == "PP01") then (
				actor.renderMode1 = 5
				actor.renderMode2 = 0
				actor.matrix = matrix3 1
				actor.bbox = #(obj.min, obj.max)
			)
			else (
				actor.renderMode1 = 0
				actor.renderMode2 = 4
				if obj.parent != undefined then (
					actor.matrix = obj.transform * (inverse obj.parent.transform)
				)
				else actor.matrix = obj.transform
			)
			actor.startHierarchy = true
			if not isopengrouphead obj then setgroupopen obj true
		)
		
		--specifics for actors with geometry
		else (
			actor.renderMode1 = 1
			if classof obj == line then (
				actor.renderMode2 = 3
			)
			--get the model and material name from the custom attributes
			modelName = undefined
			if hasAttribute obj "actorProperties" then (
				if obj.modelName != "" then (
					modelName = obj.modelName
					actor.modelName = modelName
				)
				else (
					modelName = obj.name
					if modelName[1] == "&" then (
						modelName = trimright modelName "0123456789"
					)
					actor.modelName = modelName
					actor.renderMode2 = 4
				)
				--collect actor material if present
				if obj.materialName != "" then (
					materialName = obj.materialName
					actorMaterial = getSceneMatByName (getclassinstances standard) materialName
					if actorMaterial != undefined then (
						--custAttributes.add actorMaterial 
						append actorMaterials actorMaterial
						actor.materialName = actorMaterial.name
					)
				)
				--set actor rendermode2 if available
				actor.renderMode2 = obj.renderMode
			)
			
			--get the modelname from the actor representation in the scene
			else (
				modelName = obj.name
				--get instanced objects modelname
				if modelName[1] == "&" then (
					modelName = trimright modelName "0123456789"
				)
				actor.modelName = modelName
				actor.renderMode2 = 4
			)
			if finditem modelNames modelName == 0 then (
				append models obj
			)
			appendifunique modelNames modelName
			
			--get transforms
			if obj.parent != undefined then (
				actor.matrix = obj.transform * (inverse obj.parent.transform)
			)
			else (
				actor.matrix = obj.transform
			)
		)
		objectChildren = obj.children
		validChildren = #()
		for child in objectChildren do (
			if (finditem validActors child) != 0 then (
				append validChildren child
			)
		)
		actor.children = validChildren
		actor.parent = obj.parent
		actor.object = obj
		append actors actor
		
		--build a mainparent childrens list just in case
		if obj.parent == undefined then (
			append mainParents obj
		) 
	)
	--ACT files can only have 1 main parent. Build one if the scene contains more than one
	if mainParents.count > 1 do (
		actor = actorClass()
		actor.actorName = getfilenamefile actFileName
		actor.renderMode1 = 0
		actor.renderMode2 = 4
		actor.object = rootnode
		actor.children = mainParents
		actor.matrix = matrix3 1
		insertitem actor actors 1
	)

	--start writing file
	actFile = createfile actFileName
	close actFile
	--exp_prog_lab.text = "status: Exporting ACT file..."
	if doesfileexist actFilename then (
		f = fopen actFileName "wb"
		
		--write header
		fwritelong f 18
		fwritelong f 8
		fwritelong f 1
		fwritelong f 2
		
		actTree = #()
		for actor in actors do (
			--start actor entry
			actorName = actor.actorName
			blocklength = actorName.count + 3
			if actorName == "NO_IDENTIFIER" then (
				blocklength = 3
			)
			fwritelong f 35
			fwritelong f blocklength
			
			--write actor name and rendertype/mode
			
			writebyte f actor.renderMode1
			writebyte f actor.renderMode2
			if actor.actorName != "NO_IDENTIFIER" then (
				writestring f actor.actorName
			)
			else (
				writebyte f 0
			)
			
			--write transformation matrix
			fwritelong f 43
			fwritelong f 48
			matrix = matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0] * (actor.matrix) * inverse(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])
			fwritefloat f matrix.row1.x
			fwritefloat f matrix.row1.y
			fwritefloat f matrix.row1.z
			fwritefloat f matrix.row2.x
			fwritefloat f matrix.row2.y
			fwritefloat f matrix.row2.z
			fwritefloat f matrix.row3.x
			fwritefloat f matrix.row3.y
			fwritefloat f matrix.row3.z
			fwritefloat f matrix.row4.x
			fwritefloat f matrix.row4.y
			fwritefloat f matrix.row4.z
			
			--write unknown chunk needed
			fwritelong f 37
			fwritelong f 0
			
			--write bounding box
			if actor.bbox != undefined then (
				fwritelong f 50
				fwritelong f 24
				bbmin = actor.bbox[1]
				bbmax = actor.bbox[2]
				fwritefloat f bbmin.x
				fwritefloat f bbmin.z
				fwritefloat f -bbmax.y
				fwritefloat f bbmax.x
				fwritefloat f bbmax.z
				fwritefloat f -bbmin.y
			)
			
			--write hierarchy start
			if actor.actorName == "NO_IDENTIFIER" or (substring actor.actorName 1 4) == "PP01" then (
				fwritelong f 41
				fwritelong f 0
			)
			
			
			--write material name if present
			if actor.materialName != undefined and actor.materialName != "" then (
				materialName = actor.materialName
				blockLength = (materialName.count + 1)
				
				fwritelong f 38
				fwritelong f blocklength
				writestring f materialName
			)
			
			--write model name
			if actor.modelName != undefined then (
				modelName = actor.Modelname
				blocklength = (modelName.count + 1)
				fwritelong f 36
				fwritelong f blocklength
				writestring f modelName
			)
			
			--write end of hierarchy based on actorClasses
			append actTree actor
			if actor.children.count == 0 do (
				
				--end every actor without children first
				fwritelong f 42
				fwritelong f 0

				--continue if we are still somewhere down the hierarchy with a recursive search
				if actTree.count > 1 do (
					for i=2 to actTree.count do (
						cur = actTree[actTree.count]
						par = actTree[actTree.count-1]
						if par != actTree[1] do (
							if cur.object == par.children[par.children.count] then  (--if last child of parent
								--print (cur.actorName + " is the last child of " + par.actorName)
								fwritelong f 42
								fwritelong f 0
								deleteitem actTree actTree.count 
							)
						)
					)
				)
				deleteitem actTree actTree.count
			)
		)
		
		--eof
		fwritelong f 0
		fwritelong f 0
		
		fclose f
	)
	models
)




