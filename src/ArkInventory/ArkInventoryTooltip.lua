function ArkInventory.TooltipInit( name )
	
	local tooltip = _G[name]
	assert( tooltip, "XML Frame [" .. name .. "] not found" )
	
	return tooltip
	
end

function ArkInventory.TooltipNumLines( tooltip )
	
	return tooltip:NumLines( ) or 0
	
end

function ArkInventory.TooltipSetHyperlink( tooltip, h )
	
	tooltip:ClearLines( )
	
	local class = ArkInventory.ObjectStringDecode( h )
	
	if h and ( class == "item" or class == "spell" ) then
		tooltip:SetHyperlink( h )
	end
	
end

function ArkInventory.TooltipSetBagItem( tooltip, bag_id, slot_id )
	
	tooltip:ClearLines( )
	
	tooltip:SetBagItem( bag_id, slot_id )
	
end

function ArkInventory.TooltipSetInventoryItem( tooltip, slot )
	
	tooltip:ClearLines( )
	
	tooltip:SetInventoryItem( "player", slot )
	
end

function ArkInventory.TooltipSetGuildBankItem( tooltip, tab, slot )
	
	tooltip:ClearLines( )
	
	tooltip:SetGuildBankItem( tab, slot )
	
end

function ArkInventory.TooltipSetItem( tooltip, bag_id, slot_id )
	
	-- not for offline mode, only direct online scanning of the current player
	
	if bag_id == BANK_CONTAINER then
		
		ArkInventory.TooltipSetInventoryItem( tooltip, BankButtonIDToInvSlotID( slot_id ) )
		
	elseif bag_id == KEYRING_CONTAINER then
		
		ArkInventory.TooltipSetInventoryItem( tooltip, KeyRingButtonIDToInvSlotID( slot_id ) )
		
	else
		
		ArkInventory.TooltipSetBagItem( tooltip, bag_id, slot_id )
		
	end
	
end

function ArkInventory.TooltipGetMoneyFrame( tooltip )
	
	return _G[tooltip:GetName( ) .. "MoneyFrame1"]
	
end

function ArkInventory.TooltipGetItem( tooltip )
	
	local itemName, ItemLink = tooltip:GetItem( )
	return itemName, ItemLink
	
end
	
function ArkInventory.TooltipFind( tooltip, TextToFind, IgnoreLeft, IgnoreRight, CaseSensitive )
	
	if not TextToFind or strtrim( TextToFind ) == "" then
		return false
	end
	
	local IgnoreLeft = IgnoreLeft or false
	local IgnoreRight = IgnoreRight or false
	local CaseSensitive = CaseSensitive or false
	
	local obj, txt
	
	for i = 2, ArkInventory.TooltipNumLines( tooltip ) do
	
		if not IgnoreLeft then
			obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextLeft", i )]
			if obj and obj:IsShown( ) then
				txt = obj:GetText( )
				if txt then
				
					--ArkInventory.Output( "L[", i, "] = [", txt, "]" )
					
					if not CaseSensitive then
						txt = string.lower( txt )
						TextToFind = string.lower( TextToFind )
					end
					if string.find( txt, TextToFind ) then
						return string.find( txt, TextToFind )
					end
				end
			end
		end
		
		if not IgnoreRight then
			obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextRight", i )]
			if obj and obj:IsShown( ) then
				txt = obj:GetText( )
				if txt then
				
					--ArkInventory.Output( "R[", i, "] = [", txt, "]" )
					
					if not CaseSensitive then
						txt = string.lower( txt )
						TextToFind = string.lower( TextToFind )
					end
					if string.find( txt, TextToFind ) then
						return string.find( txt, TextToFind )
					end
				end
			end
		end

	end

	return
	
end

function ArkInventory.TooltipGetLine( tooltip, i )

	if not i or i < 1 or i > ArkInventory.TooltipNumLines( tooltip ) then
		return
	end
	
	local obj, txt1, txt2
	
	obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextLeft", i )]
	if obj and obj:IsShown( ) then
		txt1 = obj:GetText( )
	end
	
	obj = _G[string.format( "%s%s%s", tooltip:GetName( ), "TextRight", i )]
	if obj and obj:IsShown( ) then
		txt2 = obj:GetText( )
	end

	return txt1 or "", txt2 or ""
	
end
	
function ArkInventory.TooltipContains( tooltip, TextToFind, IgnoreLeft, IgnoreRight, CaseSensitive )

	if ArkInventory.TooltipFind( tooltip, TextToFind, IgnoreLeft, IgnoreRight, CaseSensitive ) then
		return true
	else
		return false
	end

end
	
function ArkInventory.TooltipCanUse( tooltip )

	local l = { "TextLeft", "TextRight" }
	
	for i = 2, ArkInventory.TooltipNumLines( tooltip ) do
		for _, v in pairs( l ) do
			local obj = _G[string.format( "%s%s%s", tooltip:GetName( ), v, i )]
			if obj and obj:IsShown( ) then
				local txt = obj:GetText( )
				local r, g, b = obj:GetTextColor( )
				local c = string.format( "%02x%02x%02x", r * 255, g * 255, b * 255 )
				if c == "fe1f1f" then
					--ArkInventory.Output( "line[", i, "]=[", txt, "]" )
					if txt ~= ITEM_DISENCHANT_NOT_DISENCHANTABLE then
						return false
					end
				end
			end
		end
	end

	return true
	
end


function ArkInventory.TooltipAdd( tooltip, arg1, arg2, arg3 )
	
	if not tooltip or ArkInventory.Global.Mode.Combat then return end
	
	if not tooltip:IsVisible( ) then
		-- dont add stuff to tooltips until after they become visible for the first time
		return
	end
	
	--ArkInventory.Output( arg1, " - ", arg2, " - ", arg3 )
	local h = nil
	
	if not h and tooltip["GetItem"] then
		h = select( 2, tooltip:GetItem( ) )
	end
	
	if not h and tooltip["GetSpell"] then
		h = select( 3, tooltip:GetSpell( ) )
		if h then
			h = GetSpellLink( h )
		end
	end
	
	if not h and arg1 then
		h = select( 2, ArkInventory.ObjectInfo( arg1 ) )
	end

	if not h then return end
	
	--ArkInventory.Output( "tooltip = ", tooltip:GetName( ), ", item = ", h )

	if ArkInventory.db.global.option.tooltip.add.count then
		ArkInventory.TooltipAddItemCount( tooltip, h )
	end
	
	--ArkInventory.TooltipAddItemAge( tooltip, h, arg1, arg2 )
	
	tooltip:Show( )
	
end

function ArkInventory.TooltipAddEmptyLine( tooltip )
	
	if ArkInventory.db.global.option.tooltip.add.empty then
		tooltip:AddLine( " ", 1, 1, 1, 0 )
	end
	
end

function ArkInventory.TooltipAddItemCount( tooltip, h )
	
	local tt = ArkInventory.TooltipObjectCountGet( h )
	if tt then
		local tc = ArkInventory.db.global.option.tooltip.colour.count
		ArkInventory.TooltipAddEmptyLine( tooltip )
		tooltip:AddLine( tt, tc.r, tc.g, tc.b, 0 )
	end

end

function ArkInventory.TooltipAddItemLevel_old( tooltip, h )
	
	local tt = select( 6, ArkInventory.ObjectInfo( h ) )
	if tt then
		ArkInventory.TooltipAddEmptyLine( tooltip )
		tt = string.format( ArkInventory.Localise["TOOLTIP_ITEMLEVEL"], tt )
		tooltip:AddLine( tt, 1, 1, 1, 0 )
	end

end

function ArkInventory.TooltipAddItemAge( tooltip, h, blizzard_id, slot_id )
	
	if type( blizzard_id ) == "number" and type( slot_id ) == "number" then
		ArkInventory.TooltipAddEmptyLine( tooltip )
		local bag_id = ArkInventory.BagID_Internal( blizzard_id )
		tooltip:AddLine( tt, 1, 1, 1, 0 )
	end

end

function ArkInventory.TooltipAddVendor_old( tooltip, h )

	if ArkInventory.Global.Mode.Merchant then
		return
	end
	
	local class, id = ArkInventory.ObjectStringDecode( h )
	
	if class ~= "item" then
		return
	end

	local price_per = select( 11, GetItemInfo( h ) )
	
	local tc = ArkInventory.db.global.option.tooltip.colour.vendor
	
	if price_per == nil then
	
		--tooltip:AddDoubleLine( ArkInventory.Localise["TOOLTIP_VENDOR"], ArkInventory.Localise["STATUS_NO_DATA"], tc.r, tc.g, tc.b, tc.r, tc.g, tc.b )
		return
		
	elseif price_per == 0 then
	
		if not ArkInventory.Global.Mode.Merchant then
			--tooltip:AddLine( ITEM_UNSELLABLE, tc.r, tc.g, tc.b )
			ArkInventory.TooltipAddEmptyLine( tooltip )
			ArkInventory.TooltipSetMoneyText( tooltip, 0, string.format( "%s:", ArkInventory.Localise["TOOLTIP_VENDOR"] ), tc.r, tc.g, tc.b )
		end
		
	elseif price_per > 0 then
	
		local count = 1
		
		if tooltip:GetOwner( ) and tooltip:GetOwner( ).count ~= nil then
			
			count = tonumber( tooltip:GetOwner( ).count )
			
			if type( count ) ~= "number" then
				count = 1
			end
			
			if count < 1 then
				count = 1
			end
			
		end
		
		local price = price_per * count
		
		if count == 1 then
			ArkInventory.TooltipAddEmptyLine( tooltip )
			ArkInventory.TooltipSetMoneyText( tooltip, price, string.format( "%s:", ArkInventory.Localise["TOOLTIP_VENDOR"], count ), tc.r, tc.g, tc.b )
		else
			ArkInventory.TooltipAddEmptyLine( tooltip )
			ArkInventory.TooltipSetMoneyText( tooltip, price, string.format( "%s: (%d @ %s)", ArkInventory.Localise["TOOLTIP_VENDOR"], count, ArkInventory.MoneyText( price_per ) ), tc.r, tc.g, tc.b )
		end
		
	else

		return
	
	end
	
end

function ArkInventory.TooltipObjectCountGet( search_id )
	
	local tc = ArkInventory.ObjectCountGet( search_id, ArkInventory.db.global.option.tooltip.me, not ArkInventory.db.global.option.tooltip.add.vault, ArkInventory.db.global.option.tooltip.faction )
	if tc == nil then
		--ArkInventory.OutputDebug("no count data")
		return nil
	end
	
	local paint = ArkInventory.db.global.option.tooltip.colour.class
	local colour = ""
	if paint then
		colour = "|cffffffff"
	end
	
	local n = UnitName( "player" )
	local f = UnitFactionGroup( "player" )
	
	local item_count_total = 0
	
	local character_count = 0
	local character_entries = { }
	
	local guild_count = 0
	local guild_entries = { }
	
	for pid, td in pairs( tc ) do
		
		local pd = ArkInventory.PlayerInfoGet( pid )
		
		local name = pd.info.name
		if paint then
			name = ArkInventory.DisplayName3( pd.info )
		end
		
		local item_count_character = 0
		local item_count_guild = 0
		
		local location_entries = { }
		
		local faction = ""
		if td.faction ~= f then
			faction = string.format( " |cff7f7f7f[%s]|r", td.faction )
		end
				
		if td.location then
			
			for l, lc in pairs( td.location ) do
				
				if lc > 0 then
					
					if td.vault then
						if ArkInventory.db.global.option.tooltip.add.tabs then
							table.insert( location_entries, string.format( "%s %s", ArkInventory.Localise["TOOLTIP_VAULT_TABS"], td.tabs ) )
						else
							table.insert( location_entries, string.format( "%s", ArkInventory.Global.Location[l].Name ) )
						end
						item_count_guild = item_count_guild + lc
					else
						table.insert( location_entries, string.format( "%s %s%s|r", ArkInventory.Global.Location[l].Name, colour, lc ) )
						item_count_character = item_count_character + lc
					end
					
				end
				
			end
			
			if item_count_character > 0 then
				
				local me = ""
				if cn == n then
					me = ArkInventory.Localise["TOOLTIP_COUNT_ME"]
				end
				
				table.insert( character_entries, string.format( "%s%s|r%s: %s%s|r (%s)", me, name, faction, colour, item_count_character, table.concat( location_entries, ", " ) ) )
				character_count = character_count + 1
				item_count_total = item_count_total + item_count_character
				
			end
			
			if item_count_guild > 0 then
				table.insert( guild_entries, string.format( "%s|r%s: %s%s|r (%s)", name, faction, colour, item_count_guild, table.concat( location_entries, ", " ) ) )
				guild_count = guild_count + 1
			end
			
		end
		
	end

	if item_count_total > 0 or guild_count > 0 then
		
		local c = ""
		
		if character_count > 1 then
			table.sort( character_entries )
			c = string.format( "%s\n%s: %s%s|r", table.concat( character_entries, "\n" ), ArkInventory.Localise["TOOLTIP_TOTAL"], colour, item_count_total )
		else
			c = table.concat( character_entries, "\n" )
		end
		
		local g = ""
		
		if ArkInventory.db.global.option.tooltip.add.vault and guild_count > 0 then
			
			if character_count > 0 then
				g = "\n\n"
			end
			
			table.sort( guild_entries )
			g = string.format( "%s%s", g, table.concat( guild_entries, "\n" ) )
			
		end
		
		return string.format( "%s%s", c, g )
		
	else
		
		return nil
		
	end
	
end

function ArkInventory.TooltipSetMoneyCoin( frame, amount, txt, r, g, b )
	
	if not frame or not amount then
		return
	end
	
	frame:AddDoubleLine( txt or " ", " ", r or 1, g or 1, b or 1 )
	
	local numLines = frame:NumLines( )
	if not frame.numMoneyFrames then
		frame.numMoneyFrames = 0
	end
	if not frame.shownMoneyFrames then
		frame.shownMoneyFrames = 0
	end
	
	local name = frame:GetName( ) .. "MoneyFrame" .. frame.shownMoneyFrames + 1
	local moneyFrame = _G[name]
	if not moneyFrame then
		frame.numMoneyFrames = frame.numMoneyFrames + 1
		moneyFrame = CreateFrame( "Frame", name, frame, "TooltipMoneyFrameTemplate" )
		name = moneyFrame:GetName( )
		ArkInventory.MoneyFrame_SetType( moneyFrame, "STATIC" )
	end
	
	moneyFrame:SetPoint( "RIGHT", frame:GetName( ) .. "TextRight" .. numLines, "RIGHT", 15, 0 )
	
	moneyFrame:Show( )
	
	if not frame.shownMoneyFrames then
		frame.shownMoneyFrames = 1
	else
		frame.shownMoneyFrames = frame.shownMoneyFrames + 1
	end
	
	MoneyFrame_Update( moneyFrame:GetName( ), amount )
	
	local leftFrame = _G[string.format( "%s%s%s", frame:GetName( ), "TextLeft", numLines )]
	local frameWidth = leftFrame:GetWidth( ) + moneyFrame:GetWidth( ) + 40
	
	if frame:GetMinimumWidth( ) < frameWidth then
		frame:SetMinimumWidth( frameWidth )
	end
	
	frame.hasMoney = 1

end

function ArkInventory.TooltipSetMoneyText( frame, money, txt, r, g, b )
	if not money then
		return
	elseif money == 0 then
		--frame:AddDoubleLine( txt or "missing text", ITEM_UNSELLABLE, r or 1, g or 1, b or 1, 1, 1, 1 )
		frame:AddDoubleLine( txt or "missing text", ArkInventory.MoneyText( money ), r or 1, g or 1, b or 1, 1, 1, 1 )
	else
		frame:AddDoubleLine( txt or "missing text", ArkInventory.MoneyText( money ), r or 1, g or 1, b or 1, 1, 1, 1 )
	end
end
