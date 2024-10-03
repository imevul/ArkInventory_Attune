local rule = ArkInventoryRules:NewModule('ArkInventoryRules_Attunables')
local debug = false

--@type SynastriaCoreLib
local SynastriaCoreLib = LibStub('SynastriaCoreLib-1.0')

local function strSplit(inputStr, sep)
	if sep == nil then
		sep = '%s'
	end

	local t = {}
	for str in string.gmatch(inputStr, '([^' .. sep .. ']+)') do
		table.insert(t, str)
	end

	return t
end
-- ItemLink = GetContainerItemLink(bagID, slotID)
local GetContainerItemLink = GetContainerItemLink or (C_Container and C_Container.GetContainerItemLink)

-- icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID, isBound = GetContainerItemInfo(bagID, slot)
local GetContainerItemInfo = GetContainerItemInfo or (C_Container and C_Container.GetContainerItemInfo)

local function getInternalId()
	local internalId = ArkInventory.ObjectIDInternal(ArkInventoryRules.Object.h)
	return internalId
end

local function getItemId()
	local internalId = getInternalId()
	local itemId = select(2, unpack(strSplit(internalId, ':')))
	return tonumber(itemId)
end

function rule:OnEnable()
	ArkInventoryRules.Register(self, 'ISVALID', rule.isvalid)
	ArkInventoryRules.Register(self, 'ATTUNABLE', rule.attunable)
	ArkInventoryRules.Register(self, 'ATTUNABLEBYME', rule.attunablebyme)
	ArkInventoryRules.Register(self, 'ATTUNABLEATALL', rule.attunableatall)
	ArkInventoryRules.Register(self, 'ATTUNED', rule.attuned)
	ArkInventoryRules.Register(self, 'PARTIALLYATTUNED', rule.partiallyattuned)
	ArkInventoryRules.Register(self, 'FULLYATTUNED', rule.fullyattuned)
	ArkInventoryRules.Register(self, 'ATTUNEPROGRESS', rule.attuneprogress)
end

-- Is the item able to be attuned by me
function rule.isvalid(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ISVALID'

	return SynastriaCoreLib.IsItemValid(getItemId())
end

-- Is the item able to be attuned, and is this particular variant not already attuned by me
function rule.attunable(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNABLE'

	return SynastriaCoreLib.IsAttunableBySomeone(getItemId()) and SynastriaCoreLib.IsAttunable(getItemId())
end

-- Is the item able to be attuned, and has at least one variant (affix and/or forging) been attuned, but not all of them
function rule.partiallyattuned(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNABLE'

	return SynastriaCoreLib.IsAttunableBySomeone(getItemId()) and SynastriaCoreLib.HasAttunedAnyVariant(getItemId()) and not SynastriaCoreLib.HasAttunedAllVariants(getItemId())
end

-- Is the item able to be attuned, and has all variants (affix and forging) been attuned
function rule.fullyattuned(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNABLE'

	return SynastriaCoreLib.IsAttunableBySomeone(getItemId()) and SynastriaCoreLib.HasAttunedAllVariants(getItemId())
end

-- Is the item able to be attuned, and is this particular variant not already attuned by me (same as 'attunable')
function rule.attunablebyme(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNABLEBYME'

	return SynastriaCoreLib.IsAttunableBySomeone(getItemId()) and SynastriaCoreLib.IsAttunable(getItemId())
end

-- Is the item able to be attuned at all
function rule.attunableatall(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNABLEATALL'

	return SynastriaCoreLib.IsAttunableBySomeone(getItemId())
end

-- Is the item able to be attuned, and the current variant has been attuned
function rule.attuned(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNED'

	return SynastriaCoreLib.IsAttunableBySomeone(getItemId()) and SynastriaCoreLib.IsAttuned(getInternalId())
end

-- Is the item able to be attuned, and does the current variant have progress towards attunement (> 0) but is not yet attuned
function rule.attuneprogress(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNEPROGRESS'

	return SynastriaCoreLib.IsAttunableBySomeone(getItemId()) and SynastriaCoreLib.HasAttuneProgress(getInternalId())
end
