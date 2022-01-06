rollout connotationsEdit "Edit connotations" 
(
	local conn = try rootnode.current_connotations catch()
	local connRollouts = #(
		"   Main Connotations   ",
		"   Shrapnels   ",
		"   Explosions   ",
		"   Noncars   ",
		"   Side Effects   "
	)
	local LastSubRollout = 1
	
	dotNetControl connTabs "System.Windows.Forms.TabControl" height:40 width:(superWidth-8) align:#center
	subRollout connSubrollout width:(connotationsEdit.width - 8) height:672 align:#center
	button connOk "Ok" width:widthC pos:[colD+10,728]
	on connTabs Selected itm do
	(
		if LastSubRollout != (itm.TabPageIndex+1) do
		(
			LastSubRollout = itm.TabPageIndex+1
			for subroll in connSubRollout.rollouts do (
				removeSubRollout connSubRollout subroll
				subroll = undefined
				if (itm.TabPageIndex+1 == 1) then subroll = #(connotationsSetup)
				if (itm.TabPageIndex+1 == 2) then subroll = #(shrapnelSetup)
				if (itm.TabPageIndex+1 == 3) then subroll = #(explosionSetup)
				if (itm.TabPageIndex+1 == 4) then subroll = #(noncarActivationSetup)
				if (itm.TabPageIndex+1 == 5) then subroll = #(sideEffectSetup)
				addSubRollout connSubRollout subroll[1] rolledup:false
			)
		) 
	)
	on connotationsEdit open do
	(
		connTabs.Multiline = true
		connTabs.SizeMode = (dotNetclass "System.Windows.Forms.TabSizeMode").FillToRight
		connTabs.ItemSize = dotNetObject "System.Drawing.Size" ((connTabs.Width - 3) / 4) (connTabs.ItemSize.Height)
		
		for tab in connRollouts do (
			connTabs.TabPages.add tab
		)
		subroll = #(connotationsSetup)
		addSubRollout connSubrollout subroll[1] rolledup:false
	)
	on connOk pressed do (
		destroydialog connotationsEdit
	)
	on connotationsEdit resized size do (
		connSubrollout.height = (size.y-84)
		connOk.pos = [colD+10,(size.y-28)]
	)
)