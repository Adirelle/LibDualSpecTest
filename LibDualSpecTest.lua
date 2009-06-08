
local LibDualSpec = LibStub('LibDualSpec-1.0')

-- Ace3 test
local NAME = 'LibDualSpecTest'
local ace3 = CreateFrame("Frame", NAME)
local db

local spy = setmetatable({}, {__index = function(t,k)
	local prefix = NAME..'-Ace3:'..k..'():'
	local f = function(_, ...)
		print(prefix, ...)
	end
	t[k] = f
	return f
end})

ace3:RegisterEvent('ADDON_LOADED')
ace3:SetScript('OnEvent', function(self, event, name)
	if name:lower() ~= NAME:lower() then return end
	self:UnregisterEvent('ADDON_LOADED')
	
	db = LibStub('AceDB-3.0'):New('LibDualSpecTestDB')
	self.db = db
	db.RegisterCallback(spy, 'OnNewProfile')
	db.RegisterCallback(spy, 'OnDatabaseShutdown')
	db.RegisterCallback(spy, 'OnProfileShutdown')
	db.RegisterCallback(spy, 'OnProfileChanged')
	db.RegisterCallback(spy, 'OnProfileDeleted')
	db.RegisterCallback(spy, 'OnProfileCopied')
	db.RegisterCallback(spy, 'OnProfileReset')
	db.RegisterCallback(spy, 'OnDatabaseReset')
	
	local options = LibStub('AceDBOptions-3.0'):GetOptionsTable(db)
	LibStub("AceConfig-3.0"):RegisterOptionsTable(NAME, options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(NAME, NAME)
	
	LibDualSpec:EnhanceDatabase(db, NAME)
	LibDualSpec:EnhanceOptions(options, db)
end)

