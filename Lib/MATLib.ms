Struct materialClass (
	materialName, 
	rgbf,
	ambLight,
	dirLight,
	specLight,
	specPower,
	flags,
	flaglight,
	flagsmooth,
	matrix,
	bitmapName,
	blendtable = "",
	shadetable = "",
	material
)

function parseMat matFileName = (
	CT_importer.impProg.text = "Progress: Parsing MAT file(s)"
	--read mat file and build classes
	materials = #()
	if (matFileName!=undefined)do
	(
		f = fopen matFileName "rb"
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
				
				if identifier == 60 or identifier == 4 then (
					mat = materialClass()
					--read rgb
					r = freadbyte f
					g = freadbyte f
					b = freadbyte f
					unknown = freadbyte f
					mat.rgbf = (color r g b)
					
					mat.amblight = freadfloat f
					mat.dirLight = freadfloat f
					mat.specLight = freadfloat f
					mat.specPower = freadfloat f
					
					--read flags
					if identifier == 60 then (
						mat.flags = freadlong f
					)
					if identifier == 4 then (
						mat.flaglight = freadbyte f
						mat.flagsmooth = freadbyte f
					)
					--read mtm
					x1 = freadfloat f
					x2 = freadfloat f
					y1 = freadfloat f
					y2 = freadfloat f
					t1 = freadfloat f
					t2 = freadfloat f
					mat.matrix = (matrix3 [x1,x2,0] [y1,y2,0] [0,0,0] [t1,t2,0])
					
					if identifier == 60 then (
						unknown = freadlong f
						
						for i=1 to 13 do (
							readbyte f #unsigned
						)
						--someflag = freadbyte f
					)
					if identifier == 4 then (
						freadbyte f
						someflag = freadbyte f
					)
					
					--read materialname
					mat.materialName = freadstring f
				)
				
				--read bitmapname
				if identifier == 28 then (
					mat.bitmapName = freadstring f
				)
				
				--read blend table
				if identifier == 30 then (
					mat.blendtable = freadstring f
				)
				
				--read shade table
				if identifier == 31 then (
					mat.shadetable = freadstring f
				)
				
				if identifier == 0 then (
					append materials mat
				)
			)
		)
		catch (
			fclose f
			print (getCurrentException())
		)
	)
	materials
)

function buildMaterial mat = (
	m=undefined
	if mat != undefined then (
		m = standard()
		m.diffuse = mat.rgbf
		ambLight = mat.ambLight*255
		m.ambient = color ambLight ambLight ambLight
		specLight = mat.specLight*255
		m.specular = color specLight specLight specLight
		m.specularLevel = mat.specPower
		m.name = mat.materialName
		
		if mat.bitmapName != undefined do (
			--print ("the bitmapname = ") + mat.bitmapName
			bitmapName = filterstring mat.bitmapName "."
			bitmapFileName = bitmapName[1] + ".tif"
			m.diffusemap = bitmaptexture filename:bitmapFileName
			
			addDirCheck = true
			try (
				m.diffusemap.bitmap.hasAlpha
			)
			catch (
				if addDirCheck == true then (
					Addedpath = getOpenFileName caption:("Please locate texture: " + (getfilenamefile bitmapfilename)) filename:bitmapFilename
					if Addedpath != undefined then (
						if doesFileExist Addedpath then (
							filePath = getfilenamePath Addedpath
							sessionPaths.add #map filePath
						)
					)
				)
				addDirCheck = false
			)
				
			try (
				if m.diffuseMap.bitmap.hasAlpha then (
					m.opacityMap = bitmaptexture filename:bitmapFilename monoOutput:1
					m.opacity = 99
				)
				
				matrix = mat.matrix
				m.diffusemap.coords.u_tiling = matrix.scalepart[1]
				m.diffusemap.coords.v_tiling = matrix.scalepart[2]
				m.diffusemap.coords.U_Angle = (matrix as EulerAngles).x
				m.diffusemap.coords.V_Angle = (matrix as EulerAngles).y
				m.diffusemap.coords.W_Angle = (matrix as EulerAngles).z
				m.diffusemap.coords.u_offset = matrix.translationpart[1]
				m.diffusemap.coords.u_offset = matrix.translationpart[2]
				showTextureMap m m.diffuseMap on
			)
			catch (
				print ("bitmap not found - " + bitmapFilename)
			)
				
			m.showInViewport = true
		)
		
		--add custom attributes
		custattributes.add m mat_CA
		--set mat flags
		if mat.flags != undefined then (
			flagVal = mat.flags
			flags = #(false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false)
			for i=0 to 21 do
			(
				if (flagVal - (2^(21-i))) > -1 do
				(
					flagVal = flagVal - (2^(21-i))
					flags[(22-i)] = true
				)
			)
			m.mat_flags = flags
		)
		m.mat_ambient = mat.ambLight
		m.mat_directional = mat.dirLight
		m.mat_specular = mat.specLight
		m.mat_power = mat.specPower
		
		m.mat_shadetable = mat.shadetable
	)
	mat.material = m
	m
)

function exportMAT materials matFileName version = (
	--create output file and open it
	if matFileName != undefined then (
		matFile = createfile matFileName
		close matFile
		
		if doesfileexist matFileName then (
			f = fopen matFileName "wb"
			
			--write header
			fwritelong f 18
			fwritelong f 8
			fwritelong f 5
			fwritelong f 2
			
			--write material entries
			materialCount = materials.count
			--print materials.count
			for i=1 to materialCount do (
				m = materials[i]
				atribCheck = hasattribute m "mat_data"
				
				materialName = m.name
				
				--start material entry
				if version == 1 then (
					fwritelong f 4
					fwritelong f (materialName.count + 46)
				)
				if version == 2 then (
					fwritelong f 60
					fwritelong f (materialName.count + 65)
				)
				
				--wrtite rgba
				rgba = m.diffuse
				writebyte f rgba.r
				writebyte f rgba.g
				writebyte f rgba.b
				writebyte f 255
				
				--write attribute values
				if atribCheck then (
					fwritefloat f m.mat_ambient
					fwritefloat f m.mat_directional
					fwritefloat f m.mat_specular
					fwritefloat f m.mat_power
					
					flags = 0
					matFlags = m.mat_flags
					for i=1 to 22 do (
						if matFlags[i]==true do (
							if i==1 do flags = flags+(1)
							if i!=1 do flags = flags+(2^(i-1))
						)
					)
					if version == 1 then (
						fwriteshort f flags
					)
					if version == 2 then (
						fwritelong f flags
					)
				)
				
				--write default values
				else (
					fwritefloat f 0.1
					fwritefloat f 0.7
					fwritefloat f 0
					fwritefloat f 20
					
					flags = 37
					if m.twosided then flags = flags + 4096
					if version == 1 then (
						fwriteshort f flags
					)
					if version == 2 then (
						fwritelong f flags
					)
				)
				
				--write material translation matrix
				if m.diffusemap != undefined then
				(
					matrix = matrix3 1
					mscale = [m.diffusemap.coords.u_tiling,m.diffusemap.coords.v_tiling,0]
					prescale matrix mscale
					mrot = (eulerAngles m.diffusemap.coords.U_Angle m.diffusemap.coords.V_Angle m.diffusemap.coords.W_Angle)
					prerotate matrix mrot
					mtrans = [m.diffusemap.coords.u_offset,m.diffusemap.coords.v_offset,0]
					pretranslate matrix mtrans
					
					fwritefloat f matrix.row1.x
					fwritefloat f matrix.row1.y
					fwritefloat f matrix.row2.x
					fwritefloat f matrix.row2.y
					fwritefloat f matrix.row4.x
					fwritefloat f matrix.row4.y
				)
				else
				(
					fwritefloat f 1
					fwritefloat f 0
					fwritefloat f 0
					fwritefloat f 1
					fwritefloat f 0
					fwritefloat f 0
				)
				
				--two unknown values
				writebyte f 10 --unknown 
				writebyte f 31 --unknown
				
				if version == 2 then (
					for i=1 to 15 do writebyte f 0 --15 empty bytes
				)
				
				--write material name
				writestring f m.name
				
				
				
				--write bitmap name if available
				dm = m.diffusemap
				if dm != undefined do (
					bitmapName = getfilenamefile m.diffusemap.filename
					if bitmapName != "" then (
						fwritelong f 28
						if version == 1 then (
							fwritelong f (bitmapName.count + 5)
							writestring f (bitmapName + ".pix")
						)
						if version == 2 then (
							fwritelong f (bitmapName.count + 1)
							writestring f bitmapName
						)
					)
				)
				
				if atribCheck then (
					--write blendtable if available
					blendtable = m.mat_blendtable
					if blendtable != "" then (
						fwritelong f 30
						fwritelong f (blendtable.count + 5)
						writestring f blendtable
					)
					
					--write shadetable if available
					shadetable = m.mat_shadetable
					if shadetable != "" then (
						fwritelong f 31
						fwritelong f (shadetable.count + 5)
						writestring f shadetable
					)
				)
				
				--write end of material entry
				fwritelong f 0
				fwritelong f 0
				
				--exp_prog.value = 100.*(i)/materials.count
				--keepprocessfocus()
			)
			fclose f
		)
	)
)
