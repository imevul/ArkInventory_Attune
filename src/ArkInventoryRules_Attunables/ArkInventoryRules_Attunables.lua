local rule = ArkInventoryRules:NewModule('ArkInventoryRules_Attunables')
local debug = false

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
	ArkInventoryRules.Register(self, 'ATTUNABLE', rule.attunable)
	ArkInventoryRules.Register(self, 'ATTUNABLEBYME', rule.attunablebyme)
	ArkInventoryRules.Register(self, 'ATTUNABLEATALL', rule.attunableatall)
	ArkInventoryRules.Register(self, 'ATTUNED', rule.attuned)
	ArkInventoryRules.Register(self, 'PARTIALLYATTUNED', rule.partiallyattuned)
	ArkInventoryRules.Register(self, 'FULLYATTUNED', rule.fullyattuned)
	ArkInventoryRules.Register(self, 'ATTUNEPROGRESS', rule.attuneprogress)
end

function rule.attunable(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNABLE'

	return SynastriaCoreLib.IsAttunable(getItemId())
end

function rule.partiallyattuned(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNABLE'

	return SynastriaCoreLib.HasAttunedAnyVariant(getItemId())
end

function rule.fullyattuned(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNABLE'

	return SynastriaCoreLib.HasAttunedAllVariants(getItemId())
end

function rule.attunablebyme(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNABLEBYME'

	return SynastriaCoreLib.IsAttunable(getItemId())
end

function rule.attunableatall(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNABLEATALL'

	return SynastriaCoreLib.IsAttunablebySomeone(getItemId())
end

function rule.attuned(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNED'

	return SynastriaCoreLib.IsAttuned(getInternalId())
end

function rule.attuneprogress(...)
	if not ArkInventoryRules.Object.h or ArkInventoryRules.Object.class ~= 'item' then return false end
	local fn = 'ATTUNEPROGRESS'

	return SynastriaCoreLib.HasAttuneProgress(getInternalId())
end
