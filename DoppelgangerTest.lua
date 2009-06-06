
local LibDoppelganger = LibStub('LibDoppelganger-1.0')

-- Ace3 test
local NAME = 'DoppelgangerTest'
local ace3 = CreateFrame("Frame", NAME)
local db

local spy = setmetatable({}, {__index = function(t,k)
	local prefix = NAME..':'..k..'():'
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
	
	db = LibStub('AceDB-3.0'):New('DoppelgangerTestAce3DB')
	DoppelgangerTest.db = db
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
	
	LibDoppelganger:EnhanceAceDB3(db)
	LibDoppelganger:EnhanceAceDBOptions3(options, db)
	
	print(NAME, 'loaded')
end)

-- Ace2 test
local Waterfall = AceLibrary:HasInstance("Waterfall-1.0") and AceLibrary("Waterfall-1.0")
local ace2 = AceLibrary('AceAddon-2.0'):new("AceDB-2.0", "AceConsole-2.0")
_G.DoppelgangerTestAce2 = ace2

ace2:RegisterDB("DoppelgangerTestAce2DB")

ace2.options = {
	name = NAME,
	type = 'group',
	args = {
		config = {
			name = 'Config',
			desc = 'Bla !',
			type = 'execute',
			guiHidden = true,
			func = function()
				if Waterfall:IsOpen(NAME) then
					Waterfall:Close(NAME)
				else
					Waterfall:Open(NAME)
				end
			end
		}
	},	
}

function ace2:OnInitialize()
	LibDoppelganger:EnhanceAceDB2(self)
	
	local pOptions = AceLibrary('AceDB-2.0'):GetAceOptionsDataTable(self) 
	self.pOptions = pOptions 
	LibDoppelganger:EnhanceAceDBOptions2(pOptions, self)		
	for k,v in pairs(pOptions) do
		self.options[k] = v
	end
	
	Waterfall:Register(NAME, 'aceOptions', self.options, 'title', NAME)
	self:RegisterChatCommand({'/dpgt'}, self.options) 
end

function ace2:OnEnable()
--	self:PrintLiteral(self.pOptions.profile.args)
end

function ace2:OnProfileDisable(...)
	self:Print("OnProfileDisable", ...)
end

function ace2:OnProfileEnable(...)
	self:Print("OnProfileEnable", ...)
end


