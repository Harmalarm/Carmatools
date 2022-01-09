fn keepprocessfocus =
(
	--if (MaxVersion())[1] >= 12000 do windows.processPostedMessages() --works from max2011
	--if (MaxVersion())[1] >= 9000 and  (MaxVersion())[1] < 12000 do (dotnetClass "Application").doEvents() -- works from 9.0 to 2011
	--no focus function for lower max versions
	if ( MaxVersion())[1] >= 9000 do ( dotnetClass "Application" ).doEvents()
)

fn Resetpivotonly obj = 
(
	if isvalidnode obj do
	(
		WorldAlignPivot obj
		obj.pivot = [0, 0, 0]
	)
)

try destroydialog PreProcessor catch()
rollout PreProcessor "Carmageddon PreProcessor" (
	--ui functions
	
	
	--ui controls
	group "Track preprocessing"
	(
		spinner x_div "X rows:" range:[2, 32, 8] type:#integer scale:2 fieldwidth:30 across:3 tooltip:"currently, use the same amount of rows and collumns!"
		spinner y_div "Y cols:" range:[2, 32, 8] type:#integer scale:2 fieldwidth:30 tooltip:"currently, use the same amount of rows and collumns!" offset:[-25, 0]
		spinner sev_perc "severing %:" range:[0, 999, 120] type:#integer scale:1 fieldwidth:30 tooltip:"% relative to segment dimensions"
		checkbox c1_lollipops "carma1 lollipops mode" tooltip:"This will try to add extra collumns for C1 lollipops"
		button pp_go "Preprocess!" width:160 height:30 tooltip:"be wise: SAVE YOUR FILE FIRST"
	)
	group "progress"
	(
		progressbar pp_prog color:red
		label pp_prog_lab "status:" align:#left
		label pp_prog_it "item:" align:#left
	)
	
	--ui events
	on pp_go pressed do
	(
		actors = #( )
		statics = #( )
		lollipops = #( )
		instances = #( )
		xdiv = x_div.value
		ydiv = y_div.value
		pgttl = ( xdiv * ydiv )
		
		--filter all objects
		for object in objects do
		(
			if object.ishidden == true do continue
			if custattributes.get object sev_CA != undefined do continue
			if custattributes.get object starting_grid_CA != undefined do continue
			if custattributes.get object multiplayer_point_CA != undefined do continue
			if custattributes.get object checkp_CA != undefined do continue
			if classof object == editable_mesh do append actors object
			if classof object == editable_poly do append actors object
			if classof object == polymeshobject do append actors object
		)
		
		--filter instances and lollipops
		for actor in actors do
		(
			if actor.name[1] != "&" then append statics actor
			else append instances object
		)
		
		if statics.count != 0 then (
			
			--calculate scene bounds
			smax = objects.max
			smin = objects.min
			scenter = objects.center
			size = smax - smin
			yval = size.y * 1. / ydiv
			xval = size.x * 1. / xdiv
			
			--create a main static object for slicing
			convertto statics[1] editable_poly
			for i = 2 to statics.count do
			(
				obj = statics[i]
				
				obj_size = obj.max - obj.min
				if obj_size.x > ( xval * ( sev_perc.value / 100 ) ) or obj_size.y > ( xval * ( sev_perc.value / 100 ) ) do
				(
					polyop.attach statics[1] obj
				)
			)
			statics = #( statics[1] )
			
			--slice the main model
			setCommandPanelTaskMode #create
			pp_prog_lab.text = "status: severing models"
			for obj in statics do --slice the model
			(
				convertto obj editable_poly
				obj_size = obj.max - obj.min
				hide obj -- hide the original object
				xobj = #( )
				yobj = #( )
				pgvlu = 0
				for i = 1 to xdiv do --cut in x direction
				(
					pp_prog_it.text = obj.name + "-" + ( i as string ) + " 0"
					local tmp = copy obj
					polyop.slice tmp tmp.faces ( ray [smin.x + xval * ( i - 1 ), scenter.y, scenter.z] [1, 0, 0] ) -- slice bottom segment
					polyop.slice tmp tmp.faces ( ray [smin.x + xval * i, scenter.y, scenter.z] [1, 0, 0] ) -- slice top segment
					fces = for i in tmp.faces collect i.index -- collect the faces into an array
					dlfcs = #( )
					for f in fces do if ( polyop.getfacecenter tmp f ).x < ( smin.x + ( xval * ( i - 1 ) ) ) then append dlfcs f -- collect the faces below the slice
					for f in fces do if ( polyop.getfacecenter tmp f ).x > ( smin.x + ( xval * i ) ) then append dlfcs f -- collect the faces above the slice
					if dlfcs.count > 0 then polyop.deletefaces tmp ( dlfcs as bitarray ) delisoverts:true -- if the list isn't emply, delete the faces
					--polyop.capholesbyface tmp (tmp.faces as bitarray) -- cap holes! - this is using all faces! could be costly on large polys
					tmp.name = ( i - 1 ) as string
					append xobj tmp
					pgvlu += 1 -- increase the progress
					pp_prog.value = ( 100. / pgttl * pgvlu )
					keepprocessfocus()
				)
				for x in xobj do --cut in y direction
				(
					for i = 1 to ydiv do
					(
						pp_prog_it.text = obj.name + "-" + ( x.name as string ) + " " + ( i as string )
						local tmp = copy x
						polyop.slice tmp tmp.faces ( ray [scenter.x, smin.y + yval * ( i - 1 ), scenter.z] [0, 1, 0] ) -- slice bottom segment
						polyop.slice tmp tmp.faces ( ray [scenter.x, smin.y + yval * i, scenter.z] [0, 1, 0] ) -- slice top segment
						fces = for i in tmp.faces collect i.index -- collect the faces into an array
						dlfcs = #( )
						for f in fces do if ( polyop.getfacecenter tmp f ).y < ( smin.y + ( yval * ( i - 1 ) ) ) then append dlfcs f -- collect the faces below the slice
						for f in fces do if ( polyop.getfacecenter tmp f ).y > ( smin.y + ( yval * i ) ) then append dlfcs f -- collect the faces above the slice
						if dlfcs.count > 0 then polyop.deletefaces tmp ( dlfcs as bitarray ) delisoverts:true -- if the list isn't emply, delete the faces
						--polyop.capholesbyface tmp (tmp.faces as bitarray) -- cap holes! - this is using all faces! could be costly on large polys
						tmp.name = x.name + " " + ( ( ( xdiv ) - i ) as string )
						if tmp.numverts != 0 then append yobj tmp
						else delete tmp
						pgvlu += 1 -- increase the progress
						pp_prog.value = ( 100. / pgttl * pgvlu )
						keepprocessfocus()
					)
				)
				delete xobj
				delete obj
				for a in yobj do append actors a
			)
			
			--build the actor tree
			global acttree = #( )
			global statics = #( )
			for i = 1 to xdiv do 
			(
				acttree[i] = #( )
				statics[i] = #( )
				for j = 1 to ydiv do
				(
					acttree[i][j] = #( )
					statics[i][j] = undefined
				)
			)
			
			initc = pgttl
			groupc = initc
			do
			(
				initc = ( initc * .5 )
				groupc = groupc + initc
			) while initc != 1
			
			pp_prog_lab.text = "status: indexing models"
			pgvlu = 0
			
			--actors = for i=1 to actors.count where isvalidnode actors[i] == true collect actors[i]
			
			--indexing models into the actor tree
			actors = #( )
			for object in objects do
			(
				if object.ishidden == true do continue
				if custattributes.get object sev_CA != undefined do continue
				if custattributes.get object starting_grid_CA != undefined do continue
				if custattributes.get object multiplayer_point_CA != undefined do continue
				if custattributes.get object checkp_CA != undefined do continue
				if classof object == editable_mesh do append actors object
				if classof object == editable_poly do append actors object
				if classof object == polymeshobject do append actors object
			)
			for obj in actors do
			(
				convertto obj editable_poly
				pp_prog_it.text = "item: " + obj.name
				objc = obj.center
				for i = 1 to xdiv do
				(
					for j = 1 to ydiv do
					(	
						if obj != undefined do
						(
							segxmin = ( smin.x + ( xval * ( i - 1 ) ) )
							segxmax = ( smin.x + ( xval * i ) )
							segymin = ( smax.y - ( yval * ( j - 1 ) ) )
							segymax = ( smax.y - ( yval * j ) )
							if objc.x > segxmin and objc.x < segxmax and objc.y < segymin and objc.y > segymax do
							(
								if obj.name[1] != "&" then
								(
									if statics[i][j] == undefined then
									(
										statics[i][j] = obj
										append acttree[i][j] obj
										nb = ( ( i - 1 ) as string ) + " " + ( ( j - 1 ) as string )
										obj.name = nb
										Resetpivotonly obj
									)
									else polyop.attach statics[i][j] obj
								)
								else (
									if obj.name[2] == "%" then (
										
									)
									append acttree[i][j] obj
								)
							)
						)
					)
				)
				pgvlu += 1
				pp_prog.value = ( 100. / actors.count * pgvlu )
				keepprocessfocus()
			)
			
			--building the actor tree
			xstep = xdiv
			ystep = ydiv
			pgvlu = 0
			pp_prog_lab.text = "status: building actor tree"
			for i = 1 to xstep do --make initial groups with indexed names
			(
				for j = 1 to ystep do
				(
					pp_prog_it.text = "item: " + ( ( i - 1 ) as string ) + ( ( j - 1 ) as string )
					if acttree[i][j].count > 1 do
					(
						acttree[i][j] = group acttree[i][j] name:( ( ( i - 1 ) as string ) + " " + ( ( j - 1 ) as string ) )
						Resetpivotonly acttree[i][j]
					)
					pgvlu += 1
					pp_prog.value = ( 100. / groupc * pgvlu )
					keepprocessfocus()
				)
			)
			xstep = xdiv
			ystep = ydiv
			do
			(
				if xstep >= ystep do
				(
					if xstep != .5 do xstep = xstep / 2
					for i = 1 to xstep do --make secondary groups with no_identifiers
					(
						for j = 1 to ystep do
						(
							pp_prog_it.text = "item: bbox group " + ( ( pgvlu + 1 ) as string )
							newgroup = #( )
							cur = ( ( i * 2 ) - 1 )
							nex = ( i * 2 )
							try join newgroup acttree[cur][j] catch()
							try join newgroup acttree[nex][j] catch()
							acttree[i][j] = group newgroup name:"NO_IDENTIFIER"
							Resetpivotonly acttree[i][j]
							pgvlu += 1
							pp_prog.value = ( 100. / groupc * pgvlu )
							keepprocessfocus()
						)
					)
				)
				if ystep >= xstep do
				(
					if ystep != .5 do ystep = ystep / 2
					for i = 1 to xstep do --make initial groups
					(
						for j = 1 to ystep do
						(
							pp_prog_it.text = "item: bbox group " + ( ( pgvlu + 1 ) as string )
							newgroup = #( )
							cur = ( ( j * 2 ) - 1 )
							nex = ( j * 2 )
							try join newgroup acttree[i][cur] catch()
							try join newgroup acttree[i][nex] catch()
							acttree[i][j] = group newgroup name:"NO_IDENTIFIER"
							Resetpivotonly acttree[i][j]
							pgvlu += 1
							pp_prog.value = ( 100. / groupc * pgvlu )
							keepprocessfocus()
						)
					)
				)
			) while xstep != .5 and ystep != .5
			for obj in objects do if isgrouphead obj == true do setgroupopen obj true
			trackhier = acttree[1][1]
			trackhier.name = "PP01 " + ( xdiv as string ) + " " + ( ydiv as string ) + " 1.000 " + ( instances.count as string )
			actors = #( trackhier )
			
			if c1_lollipops.checked then (
				-- add groups for &% items
				for o in objects where superclassof o == GeometryClass do (
					if o.name[2] == "%" then (
						leaf = superleaf = leafname = superleafname = undefined
						lollipopgroups = #( )
						leaf = o.parent
						
						if leaf != undefined then (
							leafname = leaf.name
							superleaf = leaf.parent
							if superleaf != undefined then (
								superleafname = superleaf.name
							)
						)
						
						--find lollipopgroup
						if superleaf != undefined then (
							for i = 1 to superleaf.children.count do (
								child = superleaf.children[i]
								if isgrouphead child then (
									append lollipopgroups child
								)
							)
						)
						
						
						if isgrouphead leaf then (
							if leafname[1] != "%" then (
								print o.name
								detachNodesFromGroup o
								lollipopgroup = undefined
								for g in lollipopgroups do (
									if ( "%" + leafname ) == g.name then lollipopgroup = g
								)
								if isvalidnode lollipopgroup then (
									attachnodestogroup o lollipopgroup
								)
								else (
									lollipopgroup = group o name:( "%" + leafname )
									Resetpivotonly lollipopgroup
									setgroupopen lollipopgroup true
									attachnodestogroup lollipopgroup superleaf
								)
							)
						)
					)
				)
			)
			pp_prog_lab.text = "status: preprocessing done!"
			pp_prog_it.text = "item:"
		)
		else (
			pp_prog_lab.text = "status: no static map objects to preprocess"
			pp_prog_it.text = "item:"
		)
		
		
	)
)
createdialog PreProcessor 340 186