Struct modelClass (
	modelName, 
	vertices = #(),
	mapVertices = #(),
	faces = #(),
	smoothingGroups = #(),
	edgeVis = #(),
	materialNames = #(),
	faceIds = #(),
	object
)

function parseDAT datFileName = (
	CT_importer.impProg.text = "Progress: Parsing DAT file(s)"
	models = #()
	if (datFileName!=undefined)do
	(
		f = fopen datFileName "rb"
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
			
			--read model entries
			while (ftell f < filesize) do (
				identifier = freadlong f
				blocklength = freadlong f
				
				if identifier == 54 then (
					model = modelClass()
					attribute1 = freadbyte f
					attribute2 = freadbyte f
					--modelName = freadstring f
					--model.modelName = (filterstring modelName ".")[1]
					model.modelName = freadstring f
					
					
					--print model.modelName
				)
				if identifier == 23 then (
					numVerts = freadlong f
					vertices = #()
					for i=1 to numVerts do (
						x = freadfloat f
						y = freadfloat f
						z = freadfloat f
						append vertices [x,-z,y]
					)
					model.vertices = vertices
				)
				if identifier == 24 then (
					numMapVerts = freadlong f
					mapVertices = #()
					for i=1 to numMapVerts do (
						u = freadfloat f
						v = freadfloat f
						append mapVertices [u,-v,0]
					)
					model.mapVertices = mapVertices
				)
				if identifier == 53 then (
					numFaces = freadlong f
					faces = #()
					smoothingGroups = #()
					edgeVis = #()
					for i=1 to numFaces do (
						v1 = freadshort f
						v2 = freadshort f
						v3 = freadshort f
						sm = freadshort f
						ev = freadbyte f
						append faces [v1+1,v2+1,v3+1]
						append smoothingGroups sm
						append edgeVis ev
					)
					model.faces = faces
					model.smoothingGroups = smoothingGroups
					model.edgeVis = edgeVis
				)
				if identifier == 22 then (
					numMaterialNames = freadlong f
					materialNames = #()
					for i=1 to numMaterialNames do (
						mname = freadstring f
						append materialNames mname
					)
					model.materialNames = materialNames
				)
				if identifier == 26 then (
					numFaces = freadlong f
					unknown = freadlong f --00.00.00.02
					faceIds = #()
					for i=1 to numFaces do (
						id = freadshort f
						append faceIds (id)
					)
					model.faceIds = faceIds
				)
				if identifier == 0 then (
					if model!=undefined then (
						append models model
					)
				)
			)
		)
		catch (
			fclose f
			print (getCurrentException())
		)
	)
	models
)

function getMatByName matMaterials materialName = (
	mat = undefined
	for m in matMaterials do (
		if m.materialName == materialName then (
			if m.material == undefined then (
				m.material = buildMaterial m
			)
			mat = m.material
		)
	)
	mat
)

function getSceneMatByName materials materialName = (
	mat = undefined
	for m in materials do (
		if m.name == materialName then (
			mat = m
			exit
		)
	)
	mat
)

function buildModel model matMaterials = (
	--CT_importer.impProg.text = "Progress: Building Models"
	--build models from data
	obj = undefined
	if model.modelName != undefined then (
		faces = model.faces
		faceIds = model.faceIds
		
		obj = mesh vertices:model.vertices faces:faces name:model.modelName tverts:model.mapVertices --materialids:faceIds 
		mmesh = obj.mesh
		--have to rebuild tv faces because of a 3ds max bug
		try (
			buildTVFaces mmesh 
			for i = 1 to mmesh.numfaces do (setTVFace mmesh i (getFace mmesh i))
		)
		catch()
		
		--build material ids, smoothing groups and quads
		if faceIds == undefined or faceIds.count != faces.count then (
			faceIds = for i=1 to faces.count collect 1
		)
		smoothingGroups = model.smoothingGroups
		edgeVis = model.edgeVis
		for i=1 to faces.count do (
			setfacematid obj i faceIds[i]
			setfacesmoothgroup obj i model.smoothingGroups[i]
			--print model.smoothingGroups[i]
			vis = edgeVis[i]
			case of
			(
				(vis == 1): setedgevis obj i 1 false
				(vis == 2): setedgevis obj i 2 false
				(vis == 3): (
					setedgevis obj i 1 false
					setedgevis obj i 2 false
				)
				(vis == 4): setedgevis obj i 3 false
				(vis == 5): (
					setedgevis obj i 1 false
					setedgevis obj i 3 false
				)
				(vis == 6): (
					setedgevis obj i 2 false
					setedgevis obj i 3 false
				)
				(vis == 7): (
					setedgevis obj i 1 false
					setedgevis obj i 2 false
					setedgevis obj i 3 false
				)
			)
		)
		
		--build material
		materialNames = model.materialNames
		if materialNames != undefined then (
			materialNamesCount = materialNames.count
			materials = #()
			for i=1 to materialNamesCount do (
				materialName = materialNames[i]
				matMaterial = getMatByName matMaterials materialName
				
				if matMaterial == undefined then (
					materialLookup = true
					while materialLookup == true do (
						externalFile = getOpenFileName caption:("Please locate a MAT file cointaining material: " + materialName) types:"MAT files (*.mat)|*.mat"
						if externalFile != undefined then (
							newMaterials = parseMat externalFile
							matMaterials = join matMaterials newMaterials
							
							matMaterial = getMatByName matMaterials materialName
							if matMaterial != undefined then (
								materialLookup = false
							)
						)
						if externalFile == undefined then (
							materialLookup = false
						)
					)
				)
				materials[i] = matMaterial
			)
			if materials.count > 1 then (
				objectMaterial = multimaterial numsubs:materials.count
				for j=1 to materials.count do (
					objectMaterial[j] = materials[j]
				)
			)
			else (
				objectMaterial = materials[1]
			)
			obj.material = objectMaterial
		)
		update obj
	)
	model.object = obj
	obj
)

function exportDAT models datFileName = (
	--collections of all materials and materialnames used by the export models
	modelMaterials = #()
	modelMaterialNames = #()
	
	standardMaterials = (getclassinstances standard)
	
	--create modelClasses
	modelClasses = #()
	for obj in models do (
		model = modelClass()
		
		--get model name and actor material name if present
		modelName = obj.name
		if hasAttribute obj "actorProperties" then (
			if obj.modelName != "" then (
				modelName = obj.modelName
				model.modelName = modelName
			)
			actorMaterialName = obj.materialName
			if actorMaterialName != undefined and actorMaterialName != "" then (
				if finditem modelMaterialNames actorMaterialName == 0 then (
					actorMaterial = getSceneMatByName standardMaterials actorMaterialName
					if actorMaterial == undefined then (
						--print actorMaterialName
					)
					else (
						append modelMaterialNames actorMaterialName
						append modelMaterials actorMaterial
					)
				)
			)
		)
		--if modelName[1] == "&" then (
		--	modelName = trimright modelName "0123456789"
		--)
		model.modelName = modelName
		
		--prepare line models (build vertices and face lists)
		if classof obj == line then (
			tvert_count = 0
			spline_count = numsplines obj
			spline_knots = #()
			for i=1 to spline_count do (
				spline_knots[i] = #()
				for j=1 to (numknots obj i) do (
					knot_coord = in coordsys obj.transform getknotpoint obj i j
					append spline_knots[i] knot_coord
					append model.vertices knot_coord
				)
			)
			for i=1 to spline_knots.count do (
				k = 1
				for j=1 to spline_knots[i].count do (
					if j == spline_knots[i].count then (
						if isClosed model i == true then (
							append model.faces #([k,k,((k-spline_knots[i].count)+1)],1,0)
							append model.faceIds (getMaterialID obj i j)
						)
						else ()
					)
					else (
						append model.faces #([k,k,(k+1)],1,0)
						append model.faceIds (getMaterialID obj i j)
					)
					k = k + 1
				)
			)
		)
		
		--build validMaterialNames list
		validMaterialNames = #()
		mainMaterial = obj.material
		if classof mainMaterial == multimaterial then (
			for subMaterial in mainMaterial do (
				if subMaterial != undefined then (
					appendifunique validMaterialNames subMaterial.name
				)
			)
		)
		
		if canconvertto obj editable_mesh then (
			modelMesh = snapshotasmesh obj
			
			--print obj.name
			
			--build mesh data arrays
			faceCount = getNumFaces modelMesh
			mapVertCount = getnumtverts modelMesh
			vertstrings=#()
			
			--textured and mapped models
			if mapVertCount != 0 then (
				for i=1 to faceCount do (
					faceverts = getFace modelMesh i
					faceuvs = gettvface modelMesh i
					newface = [1,1,1]
					for j=1 to 3 do (
						vert = (getvert modelMesh faceverts[j]) * inverse obj.transform
						uv = gettvert modelMesh faceuvs[j]
						vertstring = (#(vert,uv) as string)
						vertcheck = finditem vertstrings vertstring
						if vertcheck == 0 then (
							append model.vertices vert
							append model.mapVertices uv
							newface[j] = model.vertices.count
							append vertstrings vertstring
						)
						else newface[j] = vertcheck
					)
					sgroup = getFaceSmoothGroup modelMesh i
					invisibleedges = 0
					if (getedgevis modelMesh i 1) == false do invisibleedges+=1
					if (getedgevis modelMesh i 2) == false do invisibleedges+=2
					if (getedgevis modelMesh i 3) == false do invisibleedges+=4
					append model.faces newFace
					append model.smoothingGroups sgroup
					append model.edgeVis invisibleedges
					
					--add faceId to the list and 
					faceId = getfacematId modelMesh i
					if faceId == 65536 then (
						faceIds = 0
					)
					else (
						if classof obj.material == multimaterial then (
							faceMaterial = obj.material[faceId]
							materialNameIndex = finditem model.materialNames faceMaterial.name
							if materialNameIndex != 0 then (
								faceId = materialNameIndex
							)
							else (
								append model.materialNames faceMaterial.name
								faceId = model.materialNames.count
							)
						)
					)
					append model.faceIds faceId
				)
			)
			--untextured and models without uv's
			else (
				model.vertices = for i=1 to modelMesh.numverts collect (getvert modelMesh i)
				for i=1 to modelMesh.numfaces do (
					vertindices = getface modelMesh i
					sgroup = getFaceSmoothGroup modelMesh i
					invisibleedges = 0
					if (getedgevis modelMesh i 1) == false do invisibleedges+=1
					if (getedgevis modelMesh i 2) == false do invisibleedges+=2
					if (getedgevis modelMesh i 3) == false do invisibleedges+=4
					append model.faces vertindices
					append model.smoothingGroups sgroup
					append model.edgeVis invisibleedges
					append model.faceIds (getfacematid modelMesh i)
				)
			)
		)
		
		--add standard material name
		if classof obj.material == standardmaterial then (
			model.materialNames = #(obj.material.Name)
		)
		
		--append modelMaterials list with new model materials
		for materialName in model.materialNames do (
			if finditem modelMaterialNames materialName == 0 then (
				mat = getSceneMatByName standardMaterials materialName
				if mat != undefined then (
					append modelMaterialNames materialName
					append modelMaterials mat
				)
			)
		)
		
		--store class in modelclasses
		append modelClasses model
	)
	
	datFile = createfile datFileName
	close datFile
			
	if doesfileexist datFileName then (
		--exp_prog_lab.text = "status: Exporting ACT file..."
		f = fopen datFileName "wb"
		
		--write header
		fwritelong f 18
		fwritelong f 8
		fwritelong f 64206
		fwritelong f 2
		
		for model in modelClasses do (
			
			--write model name
			fwritelong f 54
			fwritelong f 0
			writebyte f 1
			writebyte f 21
			writestring f model.modelName
			
			--write vertices
			fwritelong f 23
			fwritelong f 0
			fwritelong f model.vertices.count
			for vert in model.vertices do (
				fwritefloat f vert.x
				fwritefloat f vert.z
				fwritefloat f -vert.y
			)
			
			--write mapping vertices
			fwritelong f 24
			fwritelong f 0
			fwritelong f model.mapVertices.count
			for mapVert in model.mapVertices do (
				fwriteFloat f mapVert.x
				fwriteFloat f -mapVert.y
			)
			
			--write face data
			fwritelong f 53
			fwritelong f 0
			fwritelong f model.faces.count
			for i=1 to model.faces.count do (
				faceVerts = model.faces[i]
				fwriteshort f (faceVerts.x-1)
				fwriteshort f (faceVerts.y-1)
				fwriteshort f (faceVerts.z-1)
				fwriteShort f model.smoothingGroups[i]
				writeByte f model.edgeVis[i]
			)
			
			--write material names
			if model.materialNames.count > 0 then (
				fwritelong f 22
				fwritelong f 0
				materialNames = model.materialNames
				fwritelong f materialNames.count
				for materialName in materialNames do (
					writestring f materialName
				)
			)
			
			--write face material ids
			if model.materialNames.count > 0 then (
				if model.faceIds.count > 0 then (
					fwritelong f 26
					fwritelong f 0
					faceIds = model.faceIds
					fwritelong f faceIds.count
					fwritelong f 2
					for id in faceIds do (
						fwriteshort f id
					)
				)
			)
			
			--end of model entry
			fwritelong f 0
			fwritelong f 0
		)
		
		fclose f
	)
	modelMaterials
)
