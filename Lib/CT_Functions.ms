/*
All functions belonging to the Carmatools 2020 update
Changelog:
2019-12-16
- first separated global functions test

2020-09-13
- cleanup of entire script directory. All shared functions are now collected here
*/

--global functions
fn round f = (((f * 1000000) as integer) as float / 1000000)

fn roundTo val n = (
	local mult = 10.0 ^ n
	(floor ((val * mult) + 0.5)) / mult
)

fn pathFilt o = (getuserprop o "CLASS" == "PATHNODE")
fn droneFilt o = (getuserprop o "CLASS" == "DRONENODE")

fn checkMissingAttribute rootnode attribute = (
	custAttribute = try custAttributes.get rootnode attribute catch ( undefined )
	if custAttribute == undefined then custAttributes.add rootnode attribute
)

--attribute functions
fn hasAttribute o ca = (
	query = false
	try (
		attribCount = custattributes.count o
		for i=1 to attribCount do 
		(
			attrib = custAttributes.get o i
			attribDef = custAttributes.getdef attrib
			if attribDef == ca then query = true
		)
	)
	catch query = false
	return query
)

--color functions and globals
fn dnColor c:[0,0,0] a:255 = ((dotnetclass "system.drawing.color").FromArgb a c.x c.y c.z)

dnColorWindow = dnColor c:((colorman.getcolor #window)*255) a:255
dnColorBackground = dnColor c:((colorman.getcolor #background)*255) a:255
dnColorText = dnColor c:((colorman.getcolor #text)*255) a:255



--string functions
fn compareNames str1 str2 = stricmp str1.name str2.name
	
fn compareModelNames model1 model2 = stricmp model1.modelname model2.modelName

fn newString oldText Message = (
	theObj = dotNetObject "MaxCustomControls.RenameInstanceDialog" oldText
	theobj.text = Message
	DialogResult = theObj.Showmodal()

	--test if the ok button was pressed
	dotnet.compareenums TheObj.DialogResult ((dotnetclass "System.Windows.Forms.DialogResult").OK)
	--get the new text string
	NewStringEntered = theobj.InstanceName 
)


--listview functions
fn addColumns lv columns = (
	for col in columns do lv.columns.add col[1] ((lv.width-20)*col[2])
)
fn initListView lv columns =
(
	lv.View = (dotnetclass "system.windows.forms.view").details
	lv.gridLines = false
	lv.fullRowSelect = true
	lv.multiSelect = false
	lv.headerstyle = (dotnetclass "system.windows.forms.ColumnHeaderStyle").Nonclickable
	lv.borderstyle = (dotnetclass "system.windows.forms.Borderstyle").Fixed3D --fixedSingle
	lv.backColor = dnColorWindow
	addColumns lv columns
)
fn updateListViewColors lv = (
	itemCount = lv.Items.count
	for i=0 to (itemCount-1) do (
		li = lv.items.item[i]
		li.BackColor = if ((mod i 2) == 0.0) then dnColorWindow else dnColorBackground
	)
)
fn setListViewSelection lv index = (
	if index == 0 or lv.items.count == 0 then (
		lv.selectedItems.Clear()
	)
	else (
		lv.HideSelection = false
		lv.items.item[index-1].Selected = true
		lv.items.item[index-1].Focused = true
		lv.EnsureVisible[index-1]
	)
)
fn getListViewSelectedItem lv = (
	o = try (lv.selecteditems.item[0].tag.value) catch(undefined)
)
fn deleteListViewItem lv = (
	lv.selecteditems.item[0].remove()
	lv.update()
)
fn addListItem lv o sub= (
	itemCount = lv.Items.count
	items = #()
	if o!=undefined then (
		li = dotNetObject "System.Windows.Forms.ListViewItem" o.name
		li.tag = dotNetMxsValue o
		li.BackColor = if ((mod itemCount 2) == 0.0) then dnColorWindow else dnColorBackground
		li.UseItemStyleForSubItems=true
		for i=1 to sub.count do (
			li.subitems.add sub[i]
		)
		li.ForeColor = dnColorText
		append items li
		appendifunique lv.tag.value o
	)
	lv.items.addRange items
)
fn updateListSubItems item sub = (
	if item != undefined then (
		o = item.tag.value
		item.subitems.item[0].text = o.name
		for i=1 to sub.count do (
			item.subitems.item[i].text = sub[i]
		)
	)
)

--bitmap preview functions
fn updatePreviewBitmap button bitMapName x y = (
	bm = openbitmap bitMapName
	if bm != undefined then (
		bitMapPreview = bitmap x y
		copy bm bitMapPreview
		button.images = #(bitMapPreview,undefined,1,1,1,1,1)
	)
	else (
		button.images = undefined
	)
)

fn setPreviewBitmap button x y = (
	bitMapName = getopenfilename()
	if bitMapName != undefined then (
		updatePreviewBitmap button bitMapName x y
	)
	return bitMapName
)

--txt file output functions
fn writeLine values description txt_file indent:0 = (
	buildString = ""
	for i=1 to values.count do (
		v = values[i]
		if v == 0.0 then (
			v = v as integer
		)
		buildString += (v as string)
		if values.count > 1 and i!= values.count then (
			buildString += ","
		)
	)
	
	stringcount = buildstring.count
	if indent!=0 then (
		for i=1 to indent do (
			buildstring = "	" + buildstring
			stringcount += 8
		)
	)
	
	tabCount = ceil ((32 - stringcount)/8.)
	for i=1 to tabCount do (
		buildString += "	"
	)
	buildString += description
	format buildString to:txt_file
)

fn writeconnotations conn txt_file = 
(
	if conn != undefined do
	(
		--sounds
		writeLine #(conn.sounds.count) "// number of possible sounds\n" txt_file indent:1
		for snd_id in conn.sounds do (
			writeLine #(snd_id) "// sound id\n" txt_file indent:2
			format "\n" to:txt_file
		)
		
		--shrapnels
		writeLine #(conn.shrapnels.count) "// number of shrapnels\n" txt_file indent:1
		for shr in conn.shrapnels do
		(
			--if conn.shrapnels[1]!=shr then format "\n" to:txt_file
			shrapnel_types = #("shards","noncars","ghostparts")
			writeLine #(shrapnel_types[shr.type]) "// shrapnel type\n" txt_file indent:2
			writeLine #(shr.min_tocar,shr.max_tocar) "// min/max toward you speed\n" txt_file indent:2
			writeLine #(shr.imp_velo) "// impact velocity factor\n" txt_file indent:2
			writeLine #(shr.rand_velo) "// random velocity\n" txt_file indent:2
			writeLine #(shr.randup_velo) "// random up velocity\n" txt_file indent:2
			writeLine #(shr.norm_velo) "// random normal velocity\n" txt_file indent:2
			writeLine #(shr.spinrate) "// random spin rate\n" txt_file indent:2
			if shr.type == 1 do
			(
				writeLine #(shr.min_time,shr.max_time) "// min/max time before vanishing\n" txt_file indent:2
				writeLine #(shr.cutlength) "// min cut length\n" txt_file indent:2
				writeLine #(shr.flag) "// flags\n" txt_file indent:2
				writeLine #(shr.shardsmat) "// shrapnel mat file\n" txt_file indent:2
			)
			if shr.type == 2 do
			(
				shrapnel_placements = #("actorbased","sphereclumped","boxclumped")
				writeLine #(shrapnel_placements[shr.placement]) "// shrapnel placement\n" txt_file indent:2
				if shr.placement == 2 do
				(
					writeLine #(shr.radius) "// sphere radius\n" txt_file indent:2
					clumping_centres = #("impact","model")
					writeLine #(clumping_centres[shr.centre]) "// clumping centre\n" txt_file indent:2
				)
				if shr.placement == 3 do
				(
					writeLine #(shr.width) "// box length\n" txt_file indent:2
					writeLine #(shr.height) "// box height\n" txt_file indent:2
					clumping_centres = #("impact","model")
					writeLine #(clumping_centres[shr.centre]) "// clumping centre\n" txt_file indent:2
				)
				writeLine #(shr.bits_min,shr.bits_max) "// min/max bits to use\n" txt_file indent:2
				writeLine #(shr.firechance) "// chance of fire/smoke\n" txt_file indent:2
				if shr.firechance != 0 then (
					writeLine #(shr.firecollumns) "// number of fire/smoke collumns\n" txt_file indent:2
					writeLine #(shr.firemin,shr.firemax) "// min/max smokeyness\n" txt_file indent:2
				)
				writeLine #(shr.model) "// shrapnel actor in tracks folder\n" txt_file indent:2
				writeLine #(shr.actornumber) "// number of seperate actors in file\n" txt_file indent:2
				writeLine #(shr.actor) "// actor name\n" txt_file indent:2
				writeLine #(shr.noncartxt) "// noncar txt file to be used\n" txt_file indent:2
			)
			if shr.type == 3 do
			(
				shrapnel_placements = #("actorbased","sphereclumped","boxclumped")
				writeLine #(shrapnel_placements[shr.placement]) "// shrapnel placement\n" txt_file indent:2
				if shr.placement == 2 do
				(
					writeLine #(shr.radius) "// sphere radius\n" txt_file indent:2
					clumping_centres = #("impact","model")
					writeLine #(clumping_centres[shr.centre]) "// clumping centre\n" txt_file indent:2
				)
				if shr.placement == 3 do
				(
					writeLine #(shr.width) "// box length\n" txt_file indent:2
					writeLine #(shr.height) "// box height\n" txt_file indent:2
					clumping_centres = #("impact","model")
					writeLine #(clumping_centres[shr.centre]) "// clumping centre\n" txt_file indent:2
				)
				writeLine #(shr.min_time,shr.max_time) "// min/max time before vanishing\n" txt_file indent:2
				writeLine #(shr.bits_min) "// min bits used\n" txt_file indent:2
				writeLine #(shr.bits_max) "// max bits used\n" txt_file indent:2
				writeLine #(filenamefrompath shr.ghostpartActor) "// shrapnel actor file\n" txt_file indent:2
			)
			format "\n" to:txt_file
		)
		
		--explosion groups
		writeLine #(conn.explosions.count) "// number of explosion groups\n" txt_file indent:1
		for expl in conn.explosions do
		(
			--if conn.explosions[1]!=expl then format "\n" to:txt_file
			writeLine #(expl.min_expl,expl.max_expl) "// min/max explosions clouds\n" txt_file indent:2
			writeLine #(expl.min_delay,expl.max_delay) "// min/max start delay\n" txt_file indent:2
			writeLine #(expl.offset_x,expl.offset_z,expl.offset_y) "// offset\n" txt_file indent:2
			writeLine #(expl.min_xfactor,expl.max_xfactor) "// min/max x factor\n" txt_file indent:2
			writeLine #(expl.min_zfactor,expl.max_zfactor) "// min/max y factor\n" txt_file indent:2
			writeLine #(expl.min_yfactor,expl.max_yfactor) "// min/max z factor\n" txt_file indent:2
			writeLine #(expl.min_framerate,expl.max_framerate) "// min/max frame rate\n" txt_file indent:2
			writeLine #(expl.min_scalefactor,expl.max_scalefactor) "// min/max scaling factor\n" txt_file indent:2
			rotation_modes = #("randomrotate","norotate")
			writeLine #(rotation_modes[expl.rotmode]) "// rotations mode\n" txt_file indent:2
			writeLine #(expl.frames.count) "// number of frames\n" txt_file indent:2
			for i =1 to expl.frames.count do
			(
				frameNameBits = filterstring expl.frames[i] ","
				writeLine #(frameNameBits[2]) "// opacity\n" txt_file indent:3
				writeLine #(frameNameBits[1]) "// frame pix name\n" txt_file indent:3
			)
			format "\n" to:txt_file
		)
		
		--slick material
		writeLine #(getfilenamefile conn.slick) "// slick material\n" txt_file indent:1
		if conn.slick != "none" then (
			writeLine #(conn.slick_x,conn.slick_z,conn.slick_y) "// ?\n" txt_file indent:2
			writeLine #(conn.slick_width,conn.slick_height,conn.slick_length) "// width/height/length \n" txt_file indent:2
			writeLine #(conn.min_skidduration,conn.max_skidduration) "// min/max skidmark duration\n" txt_file indent:2
			writeLine #(conn.min_skidfriction,conn.max_skidfriction) "// min/max skidmark friction\n" txt_file indent:2
			skidmark_materials = #("SKIDMARK.MAT","DESKID.MAT","GIBSMEAR.MAT","MUD1.MAT","OILSMEAR.MAT","SNOWSKID.MAT") indent:2
			writeLine #(skidmark_materials[conn.skidmaterial]) "// skidmark material\n" txt_file indent:2
			format "\n" to:txt_file
		)
		
		--Noncars activated
		writeLine #(conn.noncars.count) "// Number of noncars activated\n" txt_file indent:1
		for nonc in conn.noncars do
		(
			--if conn.noncars[1]!=nonc then format "\n" to:txt_file
			writeLine #(nonc.min_delay,nonc.max_delay) "// min/max start delay\n" txt_file indent:2
			activation_positions = #("absolute","relative")
			writeLine #(activation_positions[nonc.activation]) "// activation position\n" txt_file indent:2
			writeLine #(nonc.index) "// index of noncar to be activated\n" txt_file indent:2
			writeLine #(nonc.min_x,nonc.min_z,-nonc.min_y) "// 1st activation area corner\n" txt_file indent:2
			writeLine #(nonc.max_x,nonc.max_z,-nonc.max_y) "// 2nd activation area corner\n" txt_file indent:2
			writeLine #(nonc.min_tocar,nonc.max_tocar) "// min/max toward you speed\n" txt_file indent:2
			writeLine #(nonc.imp_velo) "// impact velocity factor\n" txt_file indent:2
			writeLine #(nonc.rand_velo) "// random velocity\n" txt_file indent:2
			writeLine #(nonc.randup_velo) "// random up velocity\n" txt_file indent:2
			writeLine #(nonc.norm_velo) "// random normal velocity\n" txt_file indent:2
			writeLine #(nonc.spinrate) "// random spin rate\n" txt_file indent:2
			format "\n" to:txt_file
		)
		
		--Number of side-effect smashes
		writeLine #(conn.sideeffects.count) "// Number of side-effect smashes\n" txt_file indent:1
		for seff in conn.sideeffects do
		(
			--if conn.sideeffects[1]!=seff then format "\n" to:txt_file
			writeLine #(seff.min_seff_delay,seff.max_seff_delay) "// min/max start delay\n" txt_file indent:2
			writeLine #(seff.seff_name) "// ?\n" txt_file indent:2
			activation_positions = #("absolute","relative")
			writeLine #(activation_positions[seff.activation]) "// activation position\n" txt_file indent:2
			writeLine #(seff.seff_min_x,seff.seff_min_z,-seff.seff_min_y) "// 1st activation area corner\n" txt_file indent:2
			writeLine #(seff.seff_max_x,seff.seff_max_z,-seff.seff_max_y) "// 2nd activation area corner\n" txt_file indent:2
			activation_directions = #("toward","away")
			writeLine #(activation_directions[seff.seff_direction]) "// activation direction\n" txt_file indent:2
			writeLine #(seff.seff_force) "// created force\n" txt_file indent:2
			format "\n" to:txt_file
		)
		--extension flags (missions)
		writeLine #(conn.extensionFlag) "// extension flags? \n" txt_file indent:1
		--powerup given
		writeLine #(conn.powerup) "// powerups given \n" txt_file indent:1
		--awardcodes
		if conn.awardcode==1 then writeLine #("none") "// award code \n" txt_file indent:1
		else 
		(
			handling = #("none","singleshot","repeated","doitregardless")
			writeLine #(handling[conn.awardcode]) "// award code \n" txt_file indent:2
			writeLine #(conn.credits) "// credits \n" txt_file indent:2
			writeLine #(conn.timebonus) "// time bonus \n" txt_file indent:2
			writeLine #(conn.textmessage) "// txt message \n" txt_file indent:2
			writeLine #(conn.scrollermessage) "// scroller message \n" txt_file indent:2
			format "\n" to:txt_file
		)
		--runtime variables
		writeLine #(conn.runtimevars.count) "// run time variable changes \n" txt_file indent:1
		for rtv in conn.runtimevars do
		(
			writeLine #(rtv) "// min/max var changes \n" txt_file indent:2
			format "\n" to:txt_file
		)
	)
)

fn writeBoundingShapes boundingShapes txt_file = (
	writeLine #(boundingShapes.count) "// Number of 'Bounding shapes' entries.\n\n" txt_file
	for i=1 to boundingShapes.count do (
		shape = boundingShapes[i]
		format ("// Bounding shapes entry #"+(i as string)+"\n") to:txt_file
		boundingShapeTypes = #("Polyhedron","Box", "Sphere","Wire frame")
		shapeType = shape.boundingShapeType
		writeLine #(boundingShapeTypes[shapeType]) "// Type\n" txt_file
		--polyhedron export
		if shapeType == 1 then (
			polyhedron = snapshotasmesh shape
			pointCount = getnumverts polyhedron
			if pointcount != 0 and pointcount < 32 then
			(
				writeLine #(pointCount) "// Number of points\n" txt_file
				for j=1 to pointCount do
				(
					pointPosition = getvert polyhedron j
					format "% ,% ,% \n"  (roundTo pointPosition.x 3) (roundTo pointPosition.z 3) (roundTo -pointPosition.y 3) to:txt_file
				)
				format "\n" to:txt_file
			)
			else format "Polyhedron	//type\n1\n\n0,0,0	//sorry but the shape cannot have more than 32 points\n\n" to:txt_file
		)
		--box export
		if shapeType == 2 then (
			format "% ,% ,% \n"  (roundTo shape.min.x 3) (roundTo shape.min.z 3) (roundTo -shape.max.y 3) to:txt_file
			format "% ,% ,% \n\n"  (roundTo shape.max.x 3) (roundTo shape.max.z 3) (roundTo -shape.min.y 3) to:txt_file
		)

		--sphere export
		if shapeType == 3 then (
			radius = (shape.max).x - (shape.center).x
			writeLine #(roundTo radius 3) "// Radius\n" txt_file
			format "%,%,% \n\n" (roundTo shape.center.x 3) (roundTo shape.center.z 3) (roundTo -shape.center.y 3) to:txt_file
		)

		--wireframe export
		if shapeType == 4 do
		(
			if (classof shape) == line then
			(
				numberofnodes = numknots shape
				writeLine #(numberOfNodes) "// Number of points\n" txt_file
				for k = 1 to (numknots shape) do
				(
					pointCoord = getKnotPoint shape 1 k
					format "% ,% ,% \n" (roundTo pointCoord.x 3) (roundTo pointCoord.z 3) (roundTo -pointCoord.y 3) to:txt_file
				)
				writeLine #(numsegments shape 1) "// Number of segments\n" txt_file
				knotnr = 0
				for k = 1 to (numsegments shape 1) do
				(
					format "%,%  \n" knotnr (knotnr + 1) to:txt_file
					knotnr = (knotnr + 1)
				)
				format "\n" to:txt_file
			)
			else
			(
				format ("// " + shape.name + " is not a line object, a dummy will be used as bounding shape\n") to:txt_file
				writeLine #(2) "// Number of points\n" txt_file
				format "0,0,0\n0.1,0.1,0.1\n" to:txt_file
				writeLine #(1) "// Number of segments\n" txt_file
				format "0,1\n\n" to:txt_file
			)
		)
	)
)

fn buildcarmaindicesarray m = (
	indices = #()
	verts=#()
	t_verts=#()
	vertstrings=#()
	
	model = snapshotasmesh m
	mfaces = getNumFaces model
	tvcount = getnumtverts model
	if tvcount != 0 then
	(
		for i=1 to mfaces do (--build verts list
			faceverts = getFace model i
			faceuvs = gettvface model i
			newface = [1,1,1]
			for j=1 to 3 do (
				vert = getvert model faceverts[j]
				uv = gettvert model faceuvs[j]
				index = faceverts[j]
				vertstring = (#(vert,uv) as string)
				vertcheck = finditem vertstrings vertstring
				if vertcheck == 0 then (
					append verts vert
					append t_verts uv
					append indices index
					append vertstrings vertstring
				)
			)
		)
	)
	return indices
)

fn setCarmaVertex o = (
	vertSelection = #()
	if classof o == editable_poly then (
		if subobjectLevel == 1 then (
			vertSelection = polyop.getvertselection o as array
		)
	)
	if classof o == editable_mesh then (
		if subobjectLevel == 1 then (
			vertSelection = getvertselection o as array
		)
	)
	returnVert = 1
	if vertSelection.count > 0 then (
		returnVert = vertSelection[1]
		carmaIndices = buildCarmaIndicesArray o
		returnVert = ((finditem carmaIndices returnVert)-1)
	)

	returnVert
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

fn readNextLine f = (
	nextLine = undefined
	do (
		l = trimright (readline f) "	 "
		l = trimleft l "	 "
		if l == "" then (
			--continue
		)
		else (
			commentPos = findString l "//"
			if commentPos == 1 then (
				--continue
			)
			else (
				if commentPos != undefined then (
					l = trimright (substring l 1 commentPos) "	 //"
					l = trimleft l "	 "
				)
				nextLine = l
			)
		)
	)while nextLine == undefined
	nextLine
)

fn peekNextLine f = (
	pos = filePos f
	l = readNextLine f
	seek f pos
	l
)

fn readNextInteger f = (
	l = readNextLine f
	i = l as integer
	i
)

fn readNextFloat f = (
	l = readNextLine f
	i = l as float
	i
)

fn readNextIntegers f = (
	l = filterString (readNextLine f) ",	 "
	ints = for i in l collect ((trimright i "	 ") as integer)
	ints
)

fn readNextFloats f = (
	l = filterString (readNextLine f) ",	 "
	floats = for i in l collect ((trimright i " 	") as float)
	floats
)

fn readNextVector2 f = (
	l = filterString (readNextLine f) ",	 "
	l[1] = trimright l[1] " "
	l[2] = trimright l[2] " "
	v2 = [l[1] as float,l[2] as float, 0]
	v2
)

fn readNextVector3 f = (
	l = filterString (readNextLine f) ",	 "
	l[1] = trimright l[1] " "
	l[2] = trimright l[2] " "
	l[3] = trimright l[3] " "
	v3 = [l[1] as float,-l[3] as float, (l[2] as float)]
	v3
)
fn readNextVector4 f = (
	l = filterString (readNextLine f) ",	 "
	l[1] = trimright l[1] " "
	l[2] = trimright l[2] " "
	l[3] = trimright l[3] " "
	l[4] = trimright l[4] " "
	v4 = [l[1] as float,l[2] as float, l[3] as float, l[4] as float]
	v4
)
fn readNextStrings f = (
	l = filterString (readNextLine f) ",	"
	l
)
fn readNextBoolean f = (
	boolean = false
	l = readNextLine f
	if l == "1" then (
		boolean = true
	)
	boolean
)

fn filterValues l = (
	values = #()
	strings = filterstring l ",	 "
	for i=1 to strings.count do (
		append values (strings[i] as float)
	)
	values
)

fn readDamageImpact f infoName = (
	
	impact = standard name:infoName
	custAttributes.add impact damageInfoImpactAttributes
	
	damageClauseCount = readNextInteger f
	for i=1 to damageClauseCount do (
		clause = standard name:(readNextLine f)
		custAttributes.add clause damageInfoClauseAttributes
		
		damageEffectsCount = readNextInteger f
		for j=1 to damageEffectsCount do (
			effectValues = filterString (readNextLine f) ","
			effectId = effectValues[1]
			effectAmount = (effectValues[2] as float)
			
			idTypes = #("engine","transmission","driver","steering","lf_wheel","rf_wheel","lr_wheel","rr_wheel","lf_brake","rf_brake","lr_brake","rr_brake")
			effectIndex = finditem idTypes (tolower effectId)
			if effectIndex == undefined then effectIndex = 1
			
			append clause.damageIds effectIndex
			append clause.damageValues effectAmount
		)
		append impact.damageClauses clause
	)
	impact
)

fn findIndex strings l = (
	index = finditem strings (tolower l)
	if index == 0 then (
		index = 1
	)
	index
)

fn computeConvexHull theNode maxVerts:64 pushAmt:0.0 cleanup:true = (
    with redraw off (
        local rb = MassFX_RBody()
        select theNode
        local cmdMode = getCommandPanelTaskMode()        -- store previous mode
        setCommandPanelTaskMode #modify
        addModifier theNode rb
        rb.meshVerticesLimit  = maxVerts
        rb.meshType = 4          -- 3 = capsule, 4 = convex
        rb.meshInflation = pushAmt
        rb.RBMeshRegenerate 1
        hull = rb.RBMeshConvertToCustomMesh 1
        if isValidNode hull then (
            hull.name += ""
        -- RBMeshCustomNodeExtract 
        )
        if cleanup then (
            deleteModifier theNode 1
            setCommandPanelTaskMode cmdMode        -- restore previous mode
        )
    )
    hull
)

fn readConnotations f n = (
	conn = standard name:n
	custAttributes.add conn connotations_CA
	soundsCount = readNextInteger f
	if soundsCount > 0 then (
		for i=1 to soundsCount do (
			append conn.sounds (readNextLine f)
		)
	)
	shrapnelCount = readNextInteger f
	if shrapnelCount > 0 then (
		for i=1 to shrapnelCount do (
			shr = standard name:(n + "_shrapnel " + (i as string))
			custAttributes.add shr shrapnel_CA
			shr.type = findIndex #("shards","noncars","ghostparts") (readNextLine f)
			toCarSpeeds = readNextFloats f
			shr.min_tocar = toCarSpeeds[1]
			shr.max_tocar = toCarSpeeds[2]
			shr.imp_velo = readNextFloat f
			shr.rand_velo = readNextFloat f
			shr.randup_velo = readNextFloat f
			shr.norm_velo = readNextFloat f
			shr.spinrate = readNextFloat f
			if shr.type != 1 then (
				shr.placement = findIndex #("actorbased","sphereclumped","boxclumped") (readNextLine f)
				if shr.placement == 2 then (
					shr.radius = readNextFloat f
					shr.centre = findIndex #("impact","model") (readNextLine f)
				)
				if shr.placement == 3 then (
					shr.width = readNextFloat f
					shr.height = readNextFloat f
					shr.centre = findIndex #("impact","model") (readNextLine f)
				)
			)
			if shr.type != 2 then (
				minMaxTime = readNextFloats f
				shr.min_time = minMaxTime[1]
				shr.max_time = minMaxTime[2]
			)
			if shr.type == 1 then (
				shr.cutLength = readNextFloat f
				shr.flag = readNextInteger f
				shr.shardsMat = readNextLine f
			)
			if shr.type == 2 then (
				minMaxBits = readNextIntegers f
				shr.bits_min = minMaxBits[1]
				shr.bits_max = minMaxBits[2]
				
				shr.firechance = readNextInteger f
				if shr.firechance > 0 then (
					shr.firecollumns = readNextInteger f
					fireMinMax = readNextFloats f
					shr.fireMin = fireMinMax[1]
					shr.fireMax = fireMinMax[2]
				)
				shr.model = readNextLine f
				shr.actornumber = readNextInteger f
				shr.actor = readNextLine f
				shr.noncarTxt = readNextLine f
			)
			if shr.type == 3 then (
				shr.bits_min = readNextInteger f
				shr.bits_max = readNextInteger f
				shr.ghostPartActor = readNextLine f
			)
			
			append conn.shrapnels shr
		)
	)
	explosionCount = readNextInteger f
	if explosionCount > 0 then (
		for i=1 to explosionCount do (
			expl = standard name:(n + "_explosion " + (i as string))
			custAttribute.add expl explosion_CA
			
			explMinMax = readNextIntegers f
			expl.min_expl = explMinMax[1]
			expl.max_expl = explMinMax[2]
			delayMinMax = readNextFloats f
			expl.min_delay = delayMinMax[1]
			expl.max_delay = delayMinMax[2]
			explOffset = readNextVector3 f
			expl.offset_x = explOffset.x
			expl.offset_y = explOffset.y
			expl.offset_z = explOffset.z
			xFactorMinMax = readNextFloats f
			expl.min_xfactor = xFactorMinMax[1]
			expl.max_xfactor = xFactorMinMax[2]
			yFactorMinMax = readNextFloats f
			expl.min_zfactor = yFactorMinMax[1]
			expl.max_zfactor = yFactorMinMax[2]
			zFactorMinMax = readNextFloats f
			expl.min_yfactor = zFactorMinMax[1]
			expl.max_yfactor = zFactorMinMax[2]
			framerateMinMax = readNextFloats f
			expl.min_framerate = frameRateMinMax[1]
			expl.max_framerate = frameRateMinMax[2]
			scaleFactorMinMax = readNextFloats f
			expl.min_scaleFactor = scaleFactorMinMax[1]
			expl.max_scaleFactor = scaleFactorMinMax[2]
			expl.rotmode = findIndex #("randomrotate","norotate") (readNextLine f)
			frameCount = readNextInteger f
			for j=1 to frameCount do (
				frameOpacity = readNextInteger f
				frameName = readNextLine f
				append expl.frames (frameName + "," + (frameOpacity as string))
			)
			
			append conn.explosions expl
		)
	)
	conn.slick = readNextLine f
	if (tolower conn.slick) != "none" then (
		slickScales = readNextVector3 f
		conn.slick_x = slickScales.x
		conn.slick_y = -slickScales.z
		conn.slick_z = slickScales.y
		slickSizes = readNextVector3 f
		conn.slick_x = slickSizes.x
		conn.slick_y = -slickSizes.z
		conn.slick_z = slickSizes.y
		skidDurationMinMax = readNextFloats f
		conn.min_skidDuration = skidDurationMinMax[1]
		conn.max_skidDuration = skidDurationMinMax[2]
		skidFrictionMinMax = readNextFloats f
		conn.min_skidFriction = skidFrictionMinMax[1]
		conn.max_skidFriction = skidFrictionMinMax[2]
		conn.skidMaterial = findIndex #("skidmark.mat","deskid.mat","gibsmear.mat","mud1.mat","oilsmear.mat","snowskid.mat") (readNextLine f)
	)
	noncarCuboidsCount = readNextInteger f
	if noncarCuboidsCount > 0 then (
		for i=1 to noncarCuboidsCount do (
			nonc = standard name:(n + "_noncarCuboid " + (i as string))
			custAttributes.add nonc noncar_activation_CA
			
			delayMinMax = readNextFloats f
			nonc.min_delay = delayMinMax[1]
			nonc.max_delay = delayMinMax[2]
			nonc.activation = findIndex #("absolute","relative") (readNextLine f)
			nonc.index = readNextInteger f
			nMin = readNextVector3 f
			nonc.min_x = nMin.x
			nonc.min_y = nMin.y
			nonc.min_z = nMin.z
			nMax = readNextVector3 f
			nonc.max_x = nMax.x
			nonc.max_y = nMax.y
			nonc.max_z = nMax.z
			toCarMinMax = readNextFloats f
			nonc.min_tocar = toCarMinMax[1]
			nonc.max_tocar = toCarMinMax[2]
			noncar.nonc.imp_velo = readNextFloat f
			noncar.nonc.rand_velo = readNextFloat f
			noncar.nonc.randup_velo = readNextFloat f
			noncar.nonc.norm_velo = readNextFloat f
			noncar.nonc.spinrate = readNextFloat f
			
			append conn.noncars nonc
		)
	)
	smashCuboidsCount = readNextInteger f
	if smashCuboidsCount > 0 then (
		for i=1 to smashCuboidsCount do (
			seff = standard name:(n + "_smashCuboid " + (i as string))
			custAttributes.add seff sideEffect_CA
				
			delayMinMax = readNextFloats f
			seff.min_delay = delayMinMax[1]
			seff.max_delay = delayMinMax[2]
			seff.activation = findIndex #("absolute","relative") (readNextLine f)
			sMin = readNextVector3 f
			seff.seff_min_x = sMin.x 
			seff.seff_min_y = sMin.y 
			seff.seff_min_z = sMin.z 
			sMax = readNextVector3 f
			seff.seff_max_x = sMax.x 
			seff.seff_max_y = sMax.y 
			seff.seff_max_z = sMax.z
			seff.seff_direction = findIndex #("toward","away")
			activation_directions = #("toward","away") (readNextLine f)
			seff.seff_force = readNextFloat f
				
			append conn.sideEffects seff
		)
	)
	conn.extensionFlag = readNextInteger f
	conn.powerup = readNextInteger f
	conn.awardCode = findIndex #("none","singleshot","repeated","doitregardless") (readNextLine f)
	if conn.awardCode != 1 then (
		conn.credits = readNextInteger f
		conn.timeBonus = readNextInteger f
		conn.textMessage = readNextInteger f
		conn.scrollerMessage = readNextInteger f
	)
	runTimeVarcount = readNextInteger f
	if runTimeVarCount > 0 then (
		for i=1 to runTimeVarCount do (
			append conn.runtimeVars (readNextLine f)
		)
	)
	conn
)
