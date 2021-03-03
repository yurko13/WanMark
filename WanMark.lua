BINDING_HEADER_WANMARK = "WanMark"
_G["BINDING_NAME_CLICK WanMark:Mark"] = "To Mark Group"
_G["BINDING_NAME_CLICK WanMark:Mode"] = "To Change Mode"
_G["BINDING_NAME_CLICK WanMark:DeMark"] = "To Remove Marks"

local ADDON_NAME, namespace = ... 	--localization
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local addoninfo = 'v'..version
local WanMark, gdbprivate = ...

local MARKS = {}
MARKS[0] = "none"
MARKS[1] = "star"
MARKS[2] = "circle"
MARKS[3] = "diamond"
MARKS[4] = "triangle"
MARKS[5] = "moon"
MARKS[6] = "square"
MARKS[7] = "cross"
MARKS[8] = "skull"

-- variable LINE used for test purposes
local LINE = {}
LINE[0] = "" 													-- none
LINE[1] = "Homika Ziri Jeena Juliemao Lileh Foxsiona Foxight" 		    -- star
LINE[2] = "" 													-- circle
LINE[3] = "Lonarwen Valtheria Kalrendis Xeena Nicat"			-- diamond
LINE[4] = "Wan Wandal Wandead Wanbah Wanshoo Wanhun Wand Wan Wanlee Wantro"	-- triangle
LINE[5] = "Braemyr Aoth Kordannon Rommus Chubble Aonar Orieon Ehryndar" -- moon
LINE[6] = "Dilute Fajanature Wurshipdis Dakarai Sun Quartz Quasit"		-- square
LINE[7] = "Xhunta Xshadowlock Xdrud Xfuzzbow Xfuzzshock Xmage Xfuzzcharge Xwingchun" -- cross
LINE[8] = "" 													-- skull

gdbprivate.gdbdefaults = {}
gdbprivate.gdbdefaults.gdbdefaults = {}

----------------------------
-- Saved Variables Loader --
----------------------------
local loader = CreateFrame("Frame")
	loader:RegisterEvent("ADDON_LOADED")
	loader:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == "WanMark" then
			local function initDB(gdb, gdbdefaults)
				if type(gdb) ~= "table" then gdb = {} end
				if type(gdbdefaults) ~= "table" then return gdb end
				for k, v in pairs(gdbdefaults) do
					if type(v) == "table" then
						gdb[k] = initDB(gdb[k], v)
					elseif type(v) ~= type(gdb[k]) then
						gdb[k] = v
					end
				end
				return gdb
			end
			WanMarkDB = initDB(WanMarkDB, gdbprivate.gdbdefaults) --the first per account saved variable.
			gdbprivate.gdb = WanMarkDB --fast access for checkbox states
			if (WanMarkDB.WanMarkMode == nil)then WanMarkDB.WanMarkMode = "public" end
			if (WanMarkDB.WanMarkActive == nil)then WanMarkDB.WanMarkActive = "off" end
			if (WanMarkDB.LINE == nil)then  WanMarkDB.LINE = {} end
			if (WanMarkDB.TANK == nil)then WanMarkDB.TANK = "4" end
			if (WanMarkDB.HEALER == nil)then WanMarkDB.HEALER = "1" end
			if (WanMarkDB.WanMarkRaid == nil)then WanMarkDB.WanMarkRaid = "off" end
			if (WanMarkDB.WanMarkSelf == nil)then WanMarkDB.WanMarkSelf = "off" end
			for i=0,8 do
				--WanMarkDB.LINE[i] = ""
				if (WanMarkDB.LINE[i] == nil)then WanMarkDB.LINE[i] = "" end;
				--#### if (WanMarkDB.LINE[i] == "")then WanMarkDB.LINE[i] = string.lower(LINE[i]) end;
			end
			self:UnregisterEvent("ADDON_LOADED")
			--
			--print("WanMark started, mode: "..WanMarkDB.WanMarkMode..", automark "..WanMarkDB.WanMarkActive..".")
			--
		end
	end)

--local WanMark, private = ...

--private.defaults = {}
--private.defaults.dcsdefaults = {}

WanMark = {};

----------------------------
-- Saved Variables Loader --
----------------------------
-- local loader = CreateFrame("Frame")
--	loader:RegisterEvent("ADDON_LOADED")
--		loader:SetScript("OnEvent", function(self, event, arg1)
--			if event == "ADDON_LOADED" and arg1 == "WanMark" then
--				local function initDB(db, defaults)
--					if type(db) ~= "table" then db = {} end
--					if type(defaults) ~= "table" then return db end
--					for k, v in pairs(defaults) do
--						if type(v) == "table" then
--							db[k] = initDB(db[k], v)
--						elseif type(v) ~= type(db[k]) then
--							db[k] = v
--						end
--					end
--					return db
--				end
--				WanMarkDBPC = initDB(WanMarkDBPC, private.defaults) --saved variable per character, currently not used.
--				private.db = WanMarkDBPC
--				self:UnregisterEvent("ADDON_LOADED")
--			end
--		end)

------------------
-- WanMark Show
------------------
function WMARK_Show()
	-- |cFFDC143C red
	-- |cFF00FF00 green |r uncolored
	print("|cFF00FF00WanMark ("..addoninfo..") mode: "..WanMarkDB.WanMarkMode..", automark:"..WanMarkDB.WanMarkActive.." (raid:"..WanMarkDB.WanMarkRaid..", self:"..WanMarkDB.WanMarkSelf..").")
end

----------------------------------
-- WanMark: Public, Private, Main
----------------------------------

local function WMARK_Mark_Public()
	--local ROLEMARKS={["TANK"]=4,["HEALER"]=1}
	local ROLEMARKS={}
	--####
	if IsInRaid() then
		--####
		ROLEMARKS[1]=WanMarkDB.TANK
		local index=2
		for i=1,7 do
			if (i ~= WanMarkDB.TANK)then
				ROLEMARKS[index]=i
				index=index+1
			end
		end
		--####
		--for i=1,7 do
		--	print ("  #--"..i..": "..ROLEMARKS[i])
		--end
		--####
		index=1
		local currentSpecID, currentSpecName = GetSpecializationInfo(GetSpecialization())
		local roleToken = GetSpecializationRoleByID(currentSpecID)
		--print ("roletoken for player = "..roleToken)
		if (roleToken == "TANK") then
			--print ("player is tank yes and mark is "..ROLEMARKS[index])
			local CurrentMark = GetRaidTargetIndex("player");
			if (CurrentMark == nil) then CurrentMark=0 end
			if (CurrentMark ~= ROLEMARKS[index]) then
				SetRaidTarget("player", ROLEMARKS[index])
			end
			index=index+1
		--else
			--print ("player is not tank")
		end
		--####
		local members = GetNumGroupMembers()-1;
		for i=1,members do 
			local role=UnitGroupRolesAssigned("party"..i)
			if (role == "TANK") then 
				local CurrentMark = GetRaidTargetIndex("party"..i);
				if (CurrentMark == nil) then CurrentMark=0 end
				if ( CurrentMark ~= ROLEMARKS[index]) then
					SetRaidTarget("party"..i,ROLEMARKS[index])
				end
				--print ("party "..i.. " mark "..ROLEMARKS[index].." index "..index)
				index=index+1
				if (index == 8)then
					return
				end
			end
		end
		--####
		return
	end
	--####
	ROLEMARKS["TANK"]=tostring(WanMarkDB.TANK)
	--if IsInRaid() then
	--end
	ROLEMARKS["HEALER"]=tostring(WanMarkDB.HEALER)
	--####
	local currentSpecID, currentSpecName = GetSpecializationInfo(GetSpecialization())
	--print("Your current spec:", currentSpecName)
	--print("Your current spec ID:", currentSpecID)
	local roleToken = GetSpecializationRoleByID(currentSpecID)
	--print(roleToken)
	if ROLEMARKS[roleToken]then
		local CurrentMark = GetRaidTargetIndex("player");
		if (CurrentMark == nil) then CurrentMark=0 end
		if (CurrentMark ~= ROLEMARKS[roleToken]) then
			SetRaidTarget("player", ROLEMARKS[roleToken])
		end
	end
	--####
	local members = GetNumGroupMembers()-1;
	for i=1,members do 
		local role=UnitGroupRolesAssigned("party"..i)
		if ROLEMARKS[role]then 
			local CurrentMark = GetRaidTargetIndex("party"..i);
			if (CurrentMark == nil) then CurrentMark=0 end
			if ( CurrentMark ~= ROLEMARKS[role]) then
				SetRaidTarget("party"..i,ROLEMARKS[role])
			end
			--print(i, role)
		end 
	end
end

local function WMARK_Mark_Private()
	local PMARKS={}
	for k=0,8 do
		for i in WanMarkDB.LINE[k]:gmatch("%w+") do
			--print ("i="..i)
			PMARKS[i]=k
		end
	end
	local playerName = string.lower(UnitName("player"));
	--print ("["..UnitName("player").."]");
	--print (playerName)
	if (PMARKS[playerName])then
		local CurrentMark = GetRaidTargetIndex("player");
		if (CurrentMark == nil) then CurrentMark=0 end
		--print ("Current player mark is "..CurrentMark)
		if (CurrentMark ~= PMARKS[playerName]) then
			SetRaidTarget("player",PMARKS[playerName])
		end
	end
	--
	local members = GetNumGroupMembers()-1;
	--print ("PartyMembers: ", PartyMembers)
	--
	for i=1,members do
		local pName=string.lower(UnitName("party"..i))
		if (PMARKS[pName])then
			if (pName == playerName)then
				-- test
			else
				--print ("party"..i, "Name=[",pName , "] Num=", PMARKS[pName] )
				local CurrentMark = GetRaidTargetIndex("party"..i);
				if (CurrentMark == nil) then CurrentMark=0 end
				if (CurrentMark ~= PMARKS[pName]) then
					SetRaidTarget("party"..i,PMARKS[pName])
				end
			end
		end
	end
end

local function WMARK_Mark_Self()
	local PMARKS={}
	for k=0,8 do
		for i in WanMarkDB.LINE[k]:gmatch("%w+") do
			--print ("i="..i)
			PMARKS[i]=k
		end
	end
	local playerName = string.lower(UnitName("player"));
	--print ("["..UnitName("player").."]");
	--print (playerName)
	local PlayerMark
	if (PMARKS[playerName])then
		PlayerMark=PMARKS[playerName]
	else
		PlayerMark=1
	end
	local CurrentMark = GetRaidTargetIndex("player");
	if (CurrentMark == nil) then CurrentMark=0 end
	--print ("Current player mark is "..CurrentMark)
	if (PlayerMark ~= CurrentMark) then
		--print ("marking self ("..playerName..") with "..PlayerMark)
		--SetRaidTarget("player",0)
		SetRaidTarget("player",PlayerMark)
	--else
		--print ("player already marked with "..PlayerMark)
	end
end

------------------
local function WMARK_Mark()
	if IsInRaid() then 
		if (WanMarkDB.WanMarkRaid == "off")then
			return
		end
	end
	if IsInGroup() then
		if (WanMarkDB.WanMarkMode == "private") then
			--print ("marking private")
			WMARK_Mark_Private()
		else
			--print ("marking public")
			WMARK_Mark_Public()
		end
		gdbprivate.gdb.gdbdefaults = gdbprivate.gdbdefaults.gdbdefaults
	else
		if (WanMarkDB.WanMarkSelf == "on") then
			--print ("marking self")
			WMARK_Mark_Self()
		end
	end
	--WMARK_Show()
end	

------------------
-- WanMark DeMark
------------------

local function WMARK_DeMark()
	if IsInRaid() then 
		if (WanMarkDB.WanMarkRaid == "off")then
			print ("WanMark: disabled in raid, to enable run '/wanmark raid on'")
			return
		end
	end
	if IsInGroup() then
		SetRaidTarget("player", 0)
		local members = GetNumGroupMembers()-1;
		for i=1,members do 
			SetRaidTarget("party"..i,0)
		end
		print("WanMark: party marks removed.")
	else
		SetRaidTarget("player", 0)
		--print("WanMark: self-mark removed.")
	end
	--WMARK_Show()
end

local WanMarkFrame = CreateFrame("Frame", "WanMarkFrame", UIParent)

WanMarkFrame:SetScript("OnEvent", function(self, event, ...)
	-- if IsInGroup() then
		--print ("WMARK_Mark on event "..event)		
	WMARK_Mark()
	--end
end)

------------------
-- WanMark On/Off
------------------

function WMARK_On()
	WanMarkDB.WanMarkActive="on"
	--print ("Wanmark: PLAYER_ENTERING_WORLD")
	WanMarkFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	--print ("Wanmark: GROUP_ROSTER_UPDATE")
	WanMarkFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	--print ("Wanmark: INSPECT_READY")
	WanMarkFrame:RegisterEvent("INSPECT_READY")
	--print("WanMark mode: "..WanMarkDB.WanMarkMode..", automark:"..WanMarkDB.WanMarkActive..".")
	WMARK_Show()
	-- if IsInGroup() then
	--WMARK_Mark()
	-- end
end

function WMARK_Off()
	WanMarkDB.WanMarkActive="off"
	WanMarkFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	WanMarkFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
	WanMarkFrame:UnregisterEvent("INSPECT_READY")
	--print("WanMark mode: "..WanMarkDB.WanMarkMode..", automark:"..WanMarkDB.WanMarkActive..".")
	WMARK_Show()
	gdbprivate.gdb.gdbdefaults = gdbprivate.gdbdefaults.gdbdefaults
end

function WMARK_OnOff()
	if (WanMarkDB.WanMarkActive == "on")then
		WMARK_Off()
	elseif (WanMarkDB.WanMarkActive == "off")then
		WMARK_On()
		WMARK_Mark()
	else
		WMARK_Off()
	end
end

function WMARK_Raid()
	if (WanMarkDB.WanMarkRaid == "on")then
		WanMarkDB.WanMarkRaid="off"
	elseif (WanMarkDB.WanMarkRaid == "off")then
		WanMarkDB.WanMarkRaid="on"
		WMARK_Mark()
	else
		WanMarkDB.WanMarkRaid="off"
	end
	WMARK_Show()
end

function WMARK_Self()
	if (WanMarkDB.WanMarkSelf == "on")then
		WanMarkDB.WanMarkSelf="off"
	elseif (WanMarkDB.WanMarkSelf == "off")then
		WanMarkDB.WanMarkSelf="on"
		WMARK_Mark()
	else
		WanMarkDB.WanMarkSelf="off"
	end
	WMARK_Show()
end
----------------
-- WanMark Mode
----------------

local function WMARK_Mode()
	if (WanMarkDB.WanMarkMode == "private") then
		WanMarkDB.WanMarkMode = "public"
	else
		WanMarkDB.WanMarkMode = "private"
	end
	-- print("WanMark Mode changed to", WanMarkDB.WanMarkMode)
	--print("WanMark mode: "..WanMarkDB.WanMarkMode..", automark:"..WanMarkDB.WanMarkActive..".")
	if (WanMarkDB.WanMarkActive == "on")then
		WMARK_Mark()
	end
	WMARK_Show()
end

-----------------------
-- WanEditTank
-----------------------
function WanEditRoleMark(str)
	local role=string.lower(str)
	local oldText = WanMarkDB.TANK
	local welcomeText = "Enter mark number for TANK"
	if (role == "healer")then
		oldText=WanMarkDB.HEALER
		welcomeText = "Enter mark number for HEALER"
	else
		role="tank"
	end
	--print ("Before ("..role.."): ["..oldText .."]")
	--
	StaticPopupDialogs.WanPopupRole = {
    	text = welcomeText,
    	button1 = "Save",
    	button2 = "Cancel",
		OnShow = function (self, data)
			self.editBox:SetText(oldText)
			self.button1:Disable();
			self.button2:Enable();
			self.editBox:SetFocus();
		end,
		EditBoxOnTextChanged = function (self, data)
			self:GetParent().button1:Enable()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
			ClearCursor();
		end,
    	OnAccept = function(self)
			local newText = self.editBox:GetText()
			if (newText == "1" or newText == "2" or newText == "3" or newText == "4" or newText == "5" or newText == "6" or newText == "7")then
				if (str == 'healer' and newText == WanMarkDB.TANK)then
					newText=oldText
				elseif (str == 'tank' and newText == WanMarkDB.HEALER)then
					newText=oldText
				end
			else
				newText=oldText
			end
			--print ("After ("..str.."): ["..newText.."]")
			if (newText == oldText)then
				print ("WanMark: no "..str.." mark changes made")
			else
				print ("WanMark: "..str.." mark changed from "..oldText.." ("..MARKS[tonumber(oldText)]..") to "..newText.." ("..MARKS[tonumber(newText)]..")")
				if (str == 'tank')then 
					WanMarkDB.TANK=string.lower(newText)
				else 
					WanMarkDB.HEALER=string.lower(newText)
				end
			end
			WanMark.ShowHelp()
		end,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 1,
		hasEditBox = true,
	}
	WanMark.ShowHelp()
	StaticPopup_Show("WanPopupRole")
	--
end
------------------
-- WanEditCharsLine
------------------
function WanEditCharsLine(str)
	local num=tonumber(str)
	local oldText=WanMarkDB.LINE[num]
	local newText
	local welcomeText="Enter/Edit character names for mark "..str.." ("..MARKS[num]..")"
	--print ("Before ("..str.."): "..oldText)
	--
	StaticPopupDialogs.WanPopupLine = {
    	text = welcomeText,
    	button1 = "Save",
    	button2 = "Cancel",
		OnShow = function (self, data)
			self.editBox:SetText(oldText)
			self.button1:Disable();
			self.button2:Enable();
			self.editBox:SetFocus();
		end,
		--EditBoxOnEnterPressed = function(self)
		--		DeleteCursorItem();
		--		self:GetParent():Hide();
		--	end
		--end,
		EditBoxOnTextChanged = function (self, data)
			self:GetParent().button1:Enable()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
			ClearCursor();
		end,
    	OnAccept = function(self)
			newText = self.editBox:GetText()
	    	-- print(newText)
			--print ("Mark ("..str.."): ["..newText.."]")
			print ("WanMark set for "..str.." ("..MARKS[tonumber(str)].."): ["..newText.."]")
			WanMarkDB.LINE[num]=string.lower(newText)
			WMARK_Mark()
			WanMark.ShowHelp()
		end,
		-- timeout = 0,
		-- exclusdive = true,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 1,
		hasEditBox = true,
	}
	--/run StaticPopup_Show("WanPopupLine")
	--
	--
	WanMark.ShowHelp()
	StaticPopup_Show("WanPopupLine")
	--dialog.editBox:SetText(oldText)
	--dialog.text=welcomeText
end

-----------------------
-- WMARK Slash Setup --
-----------------------
local RegisteredEvents = {};
local wmarkslash = CreateFrame("Frame", "WanMarkSlash", UIParent)

wmarkslash:SetScript("OnEvent", function (self, event, ...) 
	if (RegisteredEvents[event]) then 
		return RegisteredEvents[event](self, event, ...) 
	end
end)

function RegisteredEvents:ADDON_LOADED(event, addon, ...)
	if (addon == "WanMark") then
		--SLASH_WANMARK1 = (L["/wmark"])
		SLASH_WANMARK1 = "/wmark"
		SlashCmdList["WANMARK"] = function (msg, editbox)
			WanMark.SlashCmdHandler(msg, editbox)	
		end
		if (WanMarkDB.WanMarkActive == "on")then WMARK_On() end
	--	DEFAULT_CHAT_FRAME:AddMessage("WanMark loaded successfully. For options: Esc>Interface>AddOns or type /wmark.",0,192,255)
	end
end

for k, v in pairs(RegisteredEvents) do
	wmarkslash:RegisterEvent(k)
end

-----------------------
-----------------------
------------------
-- Create frame
------------------
--
local WanMarkHelp1 = CreateFrame("Frame", "WanMarkHelp1", UIParent, BackdropTemplateMixin and "BackdropTemplate")
WanMarkHelp1:SetPoint("CENTER",0,0)
WanMarkHelp1:SetSize(900, 600)
WanMarkHelp1:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
	hideOnEscape = true,
})
--
WanMarkHelp1:SetBackdropColor(0.5, 0.5, 0.5, 0.4)
--WanMarkHelp1:SetMovable(true)
WanMarkHelp1:EnableMouse(true)
--
--WanMarkHelp1:RegisterForDrag("LeftButton")
--WanMarkHelp1:SetScript("OnDragStart", frame.StartMoving)
--WanMarkHelp1:SetScript("OnDragStop", frame.StopMovingOrSizing)
--
WanMarkHelp1:Hide()
tinsert(UISpecialFrames, "WanMarkHelp1")
--table.insert(UISpecialFrames, "WanMarkHelp1")
--
local WanMarkHelp2 = CreateFrame("Frame", "WanMarkHelp2", WanMarkHelp1, BackdropTemplateMixin and "BackdropTemplate")
WanMarkHelp2:SetPoint("CENTER", 0, 0)
WanMarkHelp2:SetSize(880, 580)
WanMarkHelp2:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 1,
	insets = { left = 1, right = 1, top = 1, bottom = 1 },
	hideOnEscape = true,
})
WanMarkHelp2:SetBackdropColor(0.5, 0.5, 0.5, 0.4)
--
local WanMarkHelpClose = CreateFrame("Button", "CloseButton", WanMarkHelp2, "UIPanelButtonTemplate")
WanMarkHelpClose:SetSize(100, 30) -- width, height
WanMarkHelpClose:SetText("Close")
WanMarkHelpClose:SetPoint("BOTTOM", WanMarkHelp2, "BOTTOM", 0, 7)
WanMarkHelpClose:SetScript("OnClick", function()
	--WanMarkHelp2:Hide()
	WanMarkHelp1:Hide()
end)
--
local WanMarkHelpVersion = WanMarkHelp2:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpVersion:SetPoint("TOP", 0, -2);
--WanMarkHelpVersion:SetAllPoints(true);
--WanMarkHelpVersion:SetJustifyV("TOP");
--WanMarkHelpVersion:SetJustifyH("CENTER");
WanMarkHelpVersion:SetText("|cFF00FF00WanMark|cffffffff "..addoninfo);
--
-- Block 1
--
local WanMarkBlock1Message = WanMarkHelp2:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkBlock1Message:SetPoint("TOPLEFT", 50, -15);
WanMarkBlock1Message:SetText("|cFFFFFF00 GENERAL OPTIONS |cffffffff");
--
local WanMarkBlock1 = CreateFrame("Frame", "WanMarkBlock1", WanMarkHelp2, BackdropTemplateMixin and "BackdropTemplate")
WanMarkBlock1:SetPoint("TOP", 0, -32)
WanMarkBlock1:SetSize(800, 135)
WanMarkBlock1:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 4,
	insets = { left = 2, right = 2, top = 2, bottom = 2 },
	hideOnEscape = true,
})
WanMarkBlock1:SetBackdropColor(0.5, 0.5, 0.5, 0.7)
--
local xxxx1 = 5
local yyyy1 = -12
local xxxx2 = 300
local yyyy2 = -2
local yyyyN = 33
local xnow=xxxx2
local ynow=yyyy2
--
local WanMarkHelpModeMessage = WanMarkBlock1:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpModeMessage:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpModeMessage:SetText("WanMark Mode (can be set to public or private)");
local WanMarkHelpMode = CreateFrame("Button", "ButtonMode", WanMarkBlock1, "UIPanelButtonTemplate")
WanMarkHelpMode:SetSize(150 ,30)
WanMarkHelpMode:SetText("Change Mode")
WanMarkHelpMode:SetPoint("TOPLEFT", WanMarkBlock1, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpMode:SetScript("OnClick", function()
	WMARK_Mode()
	WanMark.ShowHelp()
end)
--
yyyy1 = yyyy1 - yyyyN; yyyy2 = yyyy2 - yyyyN
local WanMarkHelpAutoMessage = WanMarkBlock1:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpAutoMessage:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpAutoMessage:SetText("WanMark Automark (can be on or off)");
local WanMarkHelpAuto = CreateFrame("Button", "ButtonAuto", WanMarkBlock1, "UIPanelButtonTemplate")
WanMarkHelpAuto:SetSize(150 ,30)
WanMarkHelpAuto:SetText("Change AutoMark")
WanMarkHelpAuto:SetPoint("TOPLEFT", WanMarkBlock1, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpAuto:SetScript("OnClick", function()
	WMARK_OnOff()
	WanMark.ShowHelp()
end)
--
yyyy1 = yyyy1 - yyyyN; yyyy2 = yyyy2 - yyyyN
local WanMarkHelpRaidMessage = WanMarkBlock1:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpRaidMessage:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpRaidMessage:SetText("WanMark in Raid (can be on or off)");
local WanMarkHelpRaid = CreateFrame("Button", "ButtonRaid", WanMarkBlock1, "UIPanelButtonTemplate")
WanMarkHelpRaid:SetSize(150 ,30)
WanMarkHelpRaid:SetText("Change AutoMark")
WanMarkHelpRaid:SetPoint("TOPLEFT", WanMarkBlock1, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpRaid:SetScript("OnClick", function()
	WMARK_Raid()
	WanMark.ShowHelp()
end)
--
yyyy1 = yyyy1 - yyyyN; yyyy2 = yyyy2 - yyyyN
local WanMarkHelpSelfMessage = WanMarkBlock1:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpSelfMessage:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpSelfMessage:SetText("WanMark SelfMark (can be on or off)");
local WanMarkHelpSelf = CreateFrame("Button", "ButtonSelf", WanMarkBlock1, "UIPanelButtonTemplate")
WanMarkHelpSelf:SetSize(150 ,30)
WanMarkHelpSelf:SetText("Change SelfMark")
WanMarkHelpSelf:SetPoint("TOPLEFT", WanMarkBlock1, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpSelf:SetScript("OnClick", function()
	WMARK_Self()
	WanMark.ShowHelp()
end)
--
-- Actions
--
xnow=xnow+250
ynow=ynow-15
local WanMarkMarkNow = CreateFrame("Button", "ButtonMarkNow", WanMarkBlock1, "UIPanelButtonTemplate")
WanMarkMarkNow:SetSize(180 ,40)
WanMarkMarkNow:SetText("Apply Marks Now")
WanMarkMarkNow:SetPoint("TOPLEFT", WanMarkBlock1, "TOPLEFT", xnow, ynow)
WanMarkMarkNow:SetScript("OnClick", function()
	WMARK_Mark()
	--WanMark.ShowHelp()
end)
--
ynow=ynow-55
local WanMarkDeMarkNow = CreateFrame("Button", "ButtonDeMarkNow", WanMarkBlock1, "UIPanelButtonTemplate")
WanMarkDeMarkNow:SetSize(180 ,40)
WanMarkDeMarkNow:SetText("Remove Marks Now")
WanMarkDeMarkNow:SetPoint("TOPLEFT", WanMarkBlock1, "TOPLEFT", xnow, ynow)
WanMarkDeMarkNow:SetScript("OnClick", function()
	WMARK_DeMark()
	--WanMark.ShowHelp()
end)
--
-- Block 2
--
local WanMarkBlock2Message = WanMarkHelp2:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkBlock2Message:SetPoint("TOPLEFT", 50, -183);
WanMarkBlock2Message:SetText("|cFFFFFF00 PUBLIC MODE MARKS |cffffffff");
--
local WanMarkBlock2 = CreateFrame("Frame", "WanMarkBlock2", WanMarkHelp2, BackdropTemplateMixin and "BackdropTemplate")
WanMarkBlock2:SetPoint("TOP", 0, -200)
WanMarkBlock2:SetSize(800, 69)
WanMarkBlock2:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 4,
	insets = { left = 2, right = 2, top = 2, bottom = 2 },
	hideOnEscape = true,
})
WanMarkBlock2:SetBackdropColor(0.5, 0.5, 0.5, 0.7)
--
local xxxx1 = 5
local yyyy1 = -12
local xxxx2 = 300
local yyyy2 = -2
local yyyyN = 33
--
local WanMarkHelpTankMessage = WanMarkBlock2:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpTankMessage:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpTankMessage:SetText("Mark chosen for TANK ");
local WanMarkHelpTank = CreateFrame("Button", "ButtonTank", WanMarkBlock2, "UIPanelButtonTemplate")
WanMarkHelpTank:SetSize(150 ,30)
WanMarkHelpTank:SetText("Change Tank Mark")
WanMarkHelpTank:SetPoint("TOPLEFT", WanMarkBlock2, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpTank:SetScript("OnClick", function()
	WanEditRoleMark("tank")
	WanMark.ShowHelp()
end)
--
yyyy1 = yyyy1 - yyyyN; yyyy2 = yyyy2 - yyyyN
local WanMarkHelpHealerMessage = WanMarkBlock2:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpHealerMessage:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpHealerMessage:SetText("Mark chosen for HEALER ");
local WanMarkHelpHealer = CreateFrame("Button", "ButtonHealer", WanMarkBlock2, "UIPanelButtonTemplate")
WanMarkHelpHealer:SetSize(150 ,30)
WanMarkHelpHealer:SetText("Change Healer Mark")
WanMarkHelpHealer:SetPoint("TOPLEFT", WanMarkBlock2, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpHealer:SetScript("OnClick", function()
	WanEditRoleMark("healer")
	WanMark.ShowHelp()
end)
--
-- Block 3
--
local WanMarkBlock3Message = WanMarkHelp2:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkBlock3Message:SetPoint("TOPLEFT", 50, -283);
WanMarkBlock3Message:SetText("|cFFFFFF00 PRIVATE MODE MARKS |cffffffff(space separated char names)");
--
local WanMarkBlock3 = CreateFrame("Frame", "WanMarkBlock3", WanMarkHelp2, BackdropTemplateMixin and "BackdropTemplate")
WanMarkBlock3:SetPoint("TOP", 0, -300)
WanMarkBlock3:SetSize(800, 234)
WanMarkBlock3:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 4,
	insets = { left = 2, right = 2, top = 2, bottom = 2 },
	hideOnEscape = true,
})
WanMarkBlock3:SetBackdropColor(0.5, 0.5, 0.5, 0.7)
--
local xxxx1 = 5
local yyyy1 = -12
local xxxx2 = 730
local yyyy2 = -2
local yyyyN = 33
local LINE=1
--
local WanMarkHelpSet1Message = WanMarkBlock3:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpSet1Message:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpSet1Message:SetText("Mark "..LINE.." ("..MARKS[LINE]..")");
local WanMarkHelpSet1 = CreateFrame("Button", "ButtonSet1", WanMarkBlock3, "UIPanelButtonTemplate")
WanMarkHelpSet1:SetSize(60 ,30)
WanMarkHelpSet1:SetText("Change")
WanMarkHelpSet1:SetPoint("TOPLEFT", WanMarkBlock3, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpSet1:SetScript("OnClick", function()
	WanEditCharsLine(1)
	WanMark.ShowHelp()
end)
--
yyyy1 = yyyy1 - yyyyN; yyyy2 = yyyy2 - yyyyN; LINE = LINE + 1
local WanMarkHelpSet2Message = WanMarkBlock3:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpSet2Message:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpSet2Message:SetText("Mark "..LINE.." ("..MARKS[LINE]..")");
local WanMarkHelpSet2 = CreateFrame("Button", "ButtonSet2", WanMarkBlock3, "UIPanelButtonTemplate")
WanMarkHelpSet2:SetSize(60 ,30)
WanMarkHelpSet2:SetText("Change")
WanMarkHelpSet2:SetPoint("TOPLEFT", WanMarkBlock3, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpSet2:SetScript("OnClick", function()
	WanEditCharsLine(2)
	WanMark.ShowHelp()
end)
--
yyyy1 = yyyy1 - yyyyN; yyyy2 = yyyy2 - yyyyN; LINE = LINE + 1
local WanMarkHelpSet3Message = WanMarkBlock3:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpSet3Message:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpSet3Message:SetText("Mark "..LINE.." ("..MARKS[LINE]..")");
local WanMarkHelpSet3 = CreateFrame("Button", "ButtonSet3", WanMarkBlock3, "UIPanelButtonTemplate")
WanMarkHelpSet3:SetSize(60 ,30)
WanMarkHelpSet3:SetText("Change")
WanMarkHelpSet3:SetPoint("TOPLEFT", WanMarkBlock3, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpSet3:SetScript("OnClick", function()
	WanEditCharsLine(3)
	WanMark.ShowHelp()
end)
--
yyyy1 = yyyy1 - yyyyN; yyyy2 = yyyy2 - yyyyN; LINE = LINE + 1
local WanMarkHelpSet4Message = WanMarkBlock3:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpSet4Message:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpSet4Message:SetText("Mark "..LINE.." ("..MARKS[LINE]..")");
local WanMarkHelpSet4 = CreateFrame("Button", "ButtonSet4", WanMarkBlock3, "UIPanelButtonTemplate")
WanMarkHelpSet4:SetSize(60 ,30)
WanMarkHelpSet4:SetText("Change")
WanMarkHelpSet4:SetPoint("TOPLEFT", WanMarkBlock3, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpSet4:SetScript("OnClick", function()
	WanEditCharsLine(4)
	WanMark.ShowHelp()
end)
--
--
yyyy1 = yyyy1 - yyyyN; yyyy2 = yyyy2 - yyyyN; LINE = LINE + 1
local WanMarkHelpSet5Message = WanMarkBlock3:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpSet5Message:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpSet5Message:SetText("Mark "..LINE.." ("..MARKS[LINE]..")");
local WanMarkHelpSet5 = CreateFrame("Button", "ButtonSet5", WanMarkBlock3, "UIPanelButtonTemplate")
WanMarkHelpSet5:SetSize(60 ,30)
WanMarkHelpSet5:SetText("Change")
WanMarkHelpSet5:SetPoint("TOPLEFT", WanMarkBlock3, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpSet5:SetScript("OnClick", function()
	WanEditCharsLine(5)
	WanMark.ShowHelp()
end)
--
yyyy1 = yyyy1 - yyyyN; yyyy2 = yyyy2 - yyyyN; LINE = LINE + 1
local WanMarkHelpSet6Message = WanMarkBlock3:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpSet6Message:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpSet6Message:SetText("Mark "..LINE.." ("..MARKS[LINE]..")");
local WanMarkHelpSet6 = CreateFrame("Button", "ButtonSet6", WanMarkBlock3, "UIPanelButtonTemplate")
WanMarkHelpSet6:SetSize(60 ,30)
WanMarkHelpSet6:SetText("Change")
WanMarkHelpSet6:SetPoint("TOPLEFT", WanMarkBlock3, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpSet6:SetScript("OnClick", function()
	WanEditCharsLine(6)
	WanMark.ShowHelp()
end)
--
yyyy1 = yyyy1 - yyyyN; yyyy2 = yyyy2 - yyyyN; LINE = LINE + 1 
local WanMarkHelpSet7Message = WanMarkBlock3:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
WanMarkHelpSet7Message:SetPoint("TOPLEFT", xxxx1, yyyy1);
WanMarkHelpSet7Message:SetText("Mark "..LINE.." ("..MARKS[LINE]..")");
local WanMarkHelpSet7 = CreateFrame("Button", "ButtonSet7", WanMarkBlock3, "UIPanelButtonTemplate")
WanMarkHelpSet7:SetSize(60 ,30)
WanMarkHelpSet7:SetText("Change")
WanMarkHelpSet7:SetPoint("TOPLEFT", WanMarkBlock3, "TOPLEFT", xxxx2, yyyy2)
WanMarkHelpSet7:SetScript("OnClick", function()
	WanEditCharsLine(7)
	WanMark.ShowHelp()
end)
--
-----------------------
-----------------------
function WanMark.WinUpdate()
	WanMarkHelpMode:SetText("Mode: |cFF00FF00"..WanMarkDB.WanMarkMode.."|cffffffff")
	WanMarkHelpAuto:SetText("Auto Mark: |cFF00FF00"..WanMarkDB.WanMarkActive.."|cffffffff")
	WanMarkHelpRaid:SetText("Raid Mark: |cFF00FF00"..WanMarkDB.WanMarkRaid.."|cffffffff")
	WanMarkHelpSelf:SetText("Self Mark: |cFF00FF00"..WanMarkDB.WanMarkSelf.."|cffffffff")
	WanMarkHelpTank:SetText("Tank Mark: |cFF00FF00"..WanMarkDB.TANK.."|cffffffff ("..MARKS[tonumber(WanMarkDB.TANK)]..")")
	WanMarkHelpHealer:SetText("Healer Mark: |cFF00FF00"..WanMarkDB.HEALER.."|cffffffff ("..MARKS[tonumber(WanMarkDB.HEALER)]..")")
	WanMarkHelpSet1Message:SetText("Mark 1 ("..MARKS[1].."): [|cFF00FF00"..WanMarkDB.LINE[1].."|cffffffff]")
	WanMarkHelpSet2Message:SetText("Mark 2 ("..MARKS[2].."): [|cFF00FF00"..WanMarkDB.LINE[2].."|cffffffff]")
	WanMarkHelpSet3Message:SetText("Mark 3 ("..MARKS[3].."): [|cFF00FF00"..WanMarkDB.LINE[3].."|cffffffff]")
	WanMarkHelpSet4Message:SetText("Mark 4 ("..MARKS[4].."): [|cFF00FF00"..WanMarkDB.LINE[4].."|cffffffff]")
	WanMarkHelpSet5Message:SetText("Mark 5 ("..MARKS[5].."): [|cFF00FF00"..WanMarkDB.LINE[5].."|cffffffff]")
	WanMarkHelpSet6Message:SetText("Mark 6 ("..MARKS[6].."): [|cFF00FF00"..WanMarkDB.LINE[6].."|cffffffff]")
	WanMarkHelpSet7Message:SetText("Mark 7 ("..MARKS[7].."): [|cFF00FF00"..WanMarkDB.LINE[7].."|cffffffff]")
end
-----------------------
-----------------------
function WanMark.ShowHelp()
	--print("|cFF00FF00WanMark "..addoninfo)
	--print("WanMark Slash commands (/wmark):")
	--print("  /wmark on: enables WanMark automatic mode.")
	--print("  /wmark off: disables WanMark automatic mode.")
	--print("  /wmark mark: marks the targets regardless of automatic mode status.")
	--print("  /wmark demark: removes any party members marks.")
	--print("  /wmark private: enables private (default) marking mode (Revelation).")
	--print("  /wmark public: enables public marking mode (Tank/Healer).")
	--print("  /wmark mode: switches marking mode between private and public.")
	--print("  /wmark show: prints assigned marks (different in private and public).")
	--print("  /wmark raid [on/off]: shows/enables/disables marking/demarking in raid group (experimental).")
	--print("  /wmark self [on/off]: shows/enables/disables for player without group (experimental).")
	WanMark.WinUpdate()
	WanMarkHelp1:Show()
end


-----------------------
-----------------------
function WanMark.SlashCmdHandler(msg, editbox)
	--msg = string.lower(msg)
	--print("command is " .. msg .. "\n")
	--if (string.lower(msg) == L["config"]) then --I think string.lowermight not work for Russian letters
	msg=msg:lower(msg:gsub("\t+"," "))
	local help="no"
	--if (msg == nil or msg == "" or msg == "help")then help="yes" end
	local words = {}
	words[1], words[2] = msg:match("(%w+)%s*(.-)%s*$")
	--print ("msg=[" .. msg .. "]")
	--print ("words[1]=[" .. words[1] .. "]")
	--print ("words[2]=[" .. words[2] .. "]")
	if (msg == nil or msg == "" or msg == "help")then
		help="yes"
	elseif (words[2] == "")then
		if (msg == "on") then
			if (WanMarkDB.WanMarkActive == "off")then
				WanMarkDB.WanMarkActive="on"
				WMARK_On()
				changed="yes"
			else
				WMARK_Show()
			end	
		elseif (msg == "off") then
			if (WanMarkDB.WanMarkActive == "on")then
				WanMarkDB.WanMarkActive="off"
				WMARK_Off()
				changed="yes"
			else
				WMARK_Show()
			end
		elseif (msg == "mark") then
			if IsInGroup() then
				if IsInRaid() then 
					if (WanMarkDB.WanMarkRaid == "off")then
						print ("WanMark: disabled in raid, to enable run '/wanmark raid on'")
					else
						WMARK_Mark()
					end
				else
					WMARK_Mark()
				end
			else
				if (WanMarkDB.WanMarkSelf == "off" )then
					print ("WanMark: not in group or raid, self-marking is off")
				end
				--print("WanMark: not in group or raid (mode: "..WanMarkDB.WanMarkMode..", automark "..WanMarkDB.WanMarkActive..").")
				WMARK_Mark()
			end
		elseif (msg == "demark") then
			WMARK_DeMark()
		elseif (msg == "private") then
			if (WanMarkDB.WanMarkMode == "public")then
				WMARK_Mode()
			end
		elseif (msg == "public") then
			if (WanMarkDB.WanMarkMode == "private")then
				WMARK_Mode()
			end
		elseif (msg == "mode") then
			WMARK_Mode()
		elseif (msg == "show") then
			--print("WanMark mode: "..WanMarkDB.WanMarkMode..", automark "..WanMarkDB.WanMarkActive..".")
			WMARK_Show()
			--if (WanMarkDB.WanMarkMode == "public")then
				-- print ("WanMark public mode marks:")
			--	print ("-WanMark tank mark is "..MARKS[tonumber(WanMarkDB.TANK)].." ["..WanMarkDB.TANK.."]")
			--	print ("-WanMark healer mark is "..MARKS[tonumber(WanMarkDB.HEALER)].." ["..WanMarkDB.HEALER.."]")
			--elseif (WanMarkDB.WanMarkMode == "private")then
				-- print ("WanMark private mode marks:")
			--	for i=0,8 do
			--		print ("-WanMark " .. i .. " [" .. MARKS[i] .. "]: " .. WanMarkDB.LINE[i])
			--	end
			--end
			WanMark.ShowHelp()
		elseif (msg == "raid") then
			print ("WanMark in raid: "..WanMarkDB.WanMarkRaid)
		--elseif (msg == "self") then
		--	print ("WanMark for player: "..WanMarkDB.WanMarkSelf)
		--elseif (msg == MARKS[0]) then
		--	WanEditCharsLine("0")
		--elseif (msg == MARKS[1]) then
		--	WanEditCharsLine("1")
		--elseif (msg == MARKS[2]) then
		--	WanEditCharsLine("2")
		--elseif (msg == MARKS[3]) then
		--	WanEditCharsLine("3")
		--elseif (msg == MARKS[4]) then
		--	WanEditCharsLine("4")
		--elseif (msg == MARKS[5]) then
		--	WanEditCharsLine("5")
		--elseif (msg == MARKS[6]) then
		--	WanEditCharsLine("6")
		--elseif (msg == MARKS[7]) then
		--	WanEditCharsLine("9")
		--elseif (msg == MARKS[8]) then
		--	WanEditCharsLine("8")
		elseif (msg == "0" or msg == "1" or msg == "2" or msg == "3" or msg == "4" or msg == "5" or msg == "6" or msg == "7" or msg == "8") then
			-- aaaaaaaa
			WanEditCharsLine(msg)
		else
			help="yes"
		end
		if (changed == "yes")then
			WMARK_Mark()
		end
	else
		local changed="no"
		--print("help=no and word2 is not empty")
		if (words[1] == "tank" or words[1] == "healer")then
			--print ("tank or healer")
			for i=0,8 do
				if (words[2] == tostring(i) or words[2] == MARKS[i]) then
					print ("command found: ",words[2]," ["..i.."/"..MARKS[i].."]")
					if (words[1] == "tank")then
						if (WanMarkDB.HEALER == tostring(i))then
							print ("WanMark: mark "..i.."["..MARKS[i].."] already used to mark healer")
						else
							WanMarkDB.TANK=tostring(i)
							print ("- WanMark: tank mark set to "..MARKS[i].." ["..i.."]")
							changed="yes"
						end
					else
						if (WanMarkDB.TANK == tostring(i))then
							print ("WanMark: mark "..i.."["..MARKS[i].."] already used to mark tank")
						else
							WanMarkDB.HEALER=tostring(i)
							print ("- WanMark: healer mark set to "..MARKS[i].." ["..i.."]")
							changed="yes"
						end
					end
				end
			end
			if (changed ~= "yes")then print ("WanMark: not the right mark ["..word[2].."]") end
		elseif (words[1] == "raid") then
			--print ("word 1 is raid")
			if (words[2] == "on"  and WanMarkDB.WanMarkRaid ~= "on" ) then
				WanMarkDB.WanMarkRaid="on"
				changed="yes"
			end
			if (words[2] == "off" and WanMarkDB.WanMarkRaid ~= "off") then
				WanMarkDB.WanMarkRaid="off"
				changed="yes"
			end
			if (changed ~= "yes")then print ("WanMark: not the right raid command ["..word[2].."]") end
			print ("WanMark in raid: "..WanMarkDB.WanMarkRaid)
		elseif (words[1] == "self") then
			--print ("word 1 is self")
			if (words[2] == "on"  and WanMarkDB.WanMarkSelf ~= "on" ) then
				WanMarkDB.WanMarkSelf="on"
				changed="yes"
			end
			if (words[2] == "off" and WanMarkDB.WanMarkSelf ~= "off") then
				WanMarkDB.WanMarkSelf="off"
				changed="yes"
			end
			if (changed ~= "yes")then print ("WanMark: not the right self command ["..word[2].."]") end
			print ("WanMark for player: "..WanMarkDB.WanMarkSelf)
		else
			--print ("more than 1 word, but no tank or healer")
			for i=0,8 do
				if (words[1] == tostring(i) or words[1] == MARKS[i]) then
					WanMarkDB.LINE[i]=words[2]
					if (WanMarkDB.LINE[i] == "none")then WanMarkDB.LINE[i]="" end
					print ("WanMark private marks changed:")
					print (" " .. i .. " [" .. MARKS[i] .. "]: " .. WanMarkDB.LINE[i])
					changed="yes"
				end
			end
			if (changed ~= "yes")then print ("WanMark: not the right command ["..word[1].."]") end
		end
	 	if (changed == "yes")then
			WMARK_Mark()
			WanMark.WinUpdate()
		else
			help="yes"
		end
	end
	if (help == "yes")then
		WanMark.ShowHelp()
	end
end
SlashCmdList["WANMARK"] = WanMark.SlashCmdHandler;

-- toggle frame, has no visible parts. exists as a place to accept a click run a snippet
local toggleframe = CreateFrame("Button","WanMark",UIParent,"SecureHandlerClickTemplate")
toggleframe:RegisterForClicks("AnyDown")
toggleframe:SetScript("OnClick", function (self, button, down)
	if (button == "Mark")then
		if IsInGroup() then
			if IsInRaid() then 
				if (WanMarkDB.WanMarkRaid == "off")then
					print ("WanMark: disabled in raid, to enable run '/wanmark raid on'")
				else
					WMARK_Mark()
				end
			else
				WMARK_Mark()
			end
		else
			WMARK_Mark()
			-- print("WanMark: not in group or raid (mode: "..WanMarkDB.WanMarkMode..", automark "..WanMarkDB.WanMarkActive..").")
			-- print ("WanMark: not in group or raid, self-marking is off")
		end
	elseif (button == "Mode")then
		WMARK_Mode()
	elseif (button == "DeMark")then
		WMARK_DeMark()
	end
end)
