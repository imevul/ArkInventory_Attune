local rule = ArkInventoryRules:NewModule( 'ArkInventoryRules_Misc' )
local VANILLA_MIN_ITEMID = 1
local TBC_MIN_ITEMID = 23329
local WOTLK_MIN_ITEMID = 35570
local MYTHIC_MIN_ITEMID = 52203

local function strSplit(inputStr, sep)
	if sep == nil then
		sep = '%s'
	end

	local t = {}
	for str in string.gmatch(inputStr, '([^'..sep..']+)') do
		table.insert(t, str)
	end

	return t
end

local function getInternalId()
	local internalId = ArkInventory.ObjectIDInternal( ArkInventoryRules.Object.h )
	return internalId
end

local function getItemId()
	local internalId = getInternalId()
	local itemId = select(2, unpack(strSplit(internalId, ':')))
	return tonumber(itemId)
end

function rule:OnEnable( )
	ArkInventoryRules.Register( self, 'VANILLA', rule.vanilla )
	ArkInventoryRules.Register( self, 'TBC', rule.tbc )
	ArkInventoryRules.Register( self, 'WOTLK', rule.wotlk )
	ArkInventoryRules.Register( self, 'MYTHIC', rule.mythic )
	ArkInventoryRules.Register( self, 'EMPTY', rule.empty )
end

function rule.empty( ... )
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'EMPTY'

	local itemId = getItemId()
	return itemId == 0
end

function rule.vanilla( ... )
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'VANILLA'

	local itemId = getItemId()
	return itemId >= VANILLA_MIN_ITEMID and itemId < TBC_MIN_ITEMID
end

function rule.tbc( ... )
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'TBC'

	local itemId = getItemId()
	return itemId >= TBC_MIN_ITEMID and itemId < WOTLK_MIN_ITEMID
end

function rule.wotlk( ... )
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'WOTLK'

	local itemId = getItemId()
	return itemId >= WOTLK_MIN_ITEMID
end

function rule.mythic( ... )
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'MYTHIC'

	local itemId = getItemId()
	return itemId >= MYTHIC_MIN_ITEMID
end