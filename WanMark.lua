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
LINE[1] = "Homika Ziri Jeena Juliemao Lileh Fuzzy" 				-- star
LINE[2] = "" 													-- circle
LINE[3] = "Lonarwen Valtherion Valtheria" 						-- diamond
LINE[4] = "Wan Wandal Wandead Wanbah Wanshoo Wanhun" 			-- triangle
LINE[5] = "Braemyr Aoth Kordannon Rommus Chubble Aonar" 		-- moon
LINE[6] = "" 													-- square
LINE[7] = "Xhunta Xshadowlock Xdrud Xfuzzbow Xfuzzshock Xmage" 	-- cross
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

local WanMark, private = ...

private.defaults = {}
private.defaults.dcsdefaults = {}

WanMark = {};

----------------------------
-- Saved Variables Loader --
----------------------------
local loader = CreateFrame("Frame")
	loader:RegisterEvent("ADDON_LOADED")
	loader:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == "WanMark" then
			local function initDB(db, defaults)
				if type(db) ~= "table" then db = {} end
				if type(defaults) ~= "table" then return db end
				for k, v in pairs(defaults) do
					if type(v) == "table" then
						db[k] = initDB(db[k], v)
					elseif type(v) ~= type(db[k]) then
						db[k] = v
					end
				end
				return db
			end
			WanMarkDBPC = initDB(WanMarkDBPC, private.defaults) --saved variable per character, currently not used.
			private.db = WanMarkDBPC
			self:UnregisterEvent("ADDON_LOADED")
		end
	end)

----------------------------------
-- WanMark: Public, Private, Main
----------------------------------

local function WMARK_Mark_Public()
	--local ROLEMARKS={["TANK"]=4,["HEALER"]=1}
	local ROLEMARKS={}
	ROLEMARKS["TANK"]=tostring(WanMarkDB.TANK)
	ROLEMARKS["HEALER"]=tostring(WanMarkDB.HEALER)
	--####
	local currentSpecID, currentSpecName = GetSpecializationInfo(GetSpecialization())
	--print("Your current spec:", currentSpecName)
	--print("Your current spec ID:", currentSpecID)
	local roleToken = GetSpecializationRoleByID(currentSpecID)
	--print(roleToken)
	if ROLEMARKS[roleToken]then SetRaidTarget("player", ROLEMARKS[roleToken]) end
	--####
	local members = GetNumGroupMembers()-1;
	for i=1,members do 
		local role=UnitGroupRolesAssigned("party"..i)
		if ROLEMARKS[role]then 
			SetRaidTarget("party"..i,ROLEMARKS[role])
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
	if (PMARKS[playerName])then SetRaidTarget("player",PMARKS[playerName]) end
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
				SetRaidTarget("party"..i,PMARKS[pName])
			end
		end
	end
end

local function WMARK_Mark()
	if IsInGroup() then
		if (WanMarkDB.WanMarkMode == "private") then
			--print ("marking private")
			WMARK_Mark_Private()
		else
			--print ("marking public")
			WMARK_Mark_Public()
		end
	end
end	

------------------
-- WanMark DeMark
------------------

local function WMARK_DeMark()
	if IsInRaid() then 
		return
	elseif IsInGroup() then
		SetRaidTarget("player", 0)
		local members = GetNumGroupMembers()-1;
		for i=1,members do 
			SetRaidTarget("party"..i,0)
		end
		print("WanMark removed party marks (mode: "..WanMarkDB.WanMarkMode..", automark "..WanMarkDB.WanMarkActive..").")
	else
		print("WanMark: not in group or raid (mode: "..WanMarkDB.WanMarkMode..", automark "..WanMarkDB.WanMarkActive..").")
	end
end

local WanMarkFrame = CreateFrame("Frame", "WanMarkFrame", UIParent)

WanMarkFrame:SetScript("OnEvent", function(self, event, ...)
	if IsInGroup() then
		--print ("WMARK_Mark on event "..event)		
		WMARK_Mark()
	end
end)

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
	print("WanMark mode: "..WanMarkDB.WanMarkMode..", automark:"..WanMarkDB.WanMarkActive..".")
end

function WMARK_On()
	--print ("Wanmark: PLAYER_ENTERING_WORLD")
	WanMarkFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	--print ("Wanmark: GROUP_ROSTER_UPDATE")
	WanMarkFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
	--print ("Wanmark: INSPECT_READY")
	WanMarkFrame:RegisterEvent("INSPECT_READY")
	print("WanMark mode: "..WanMarkDB.WanMarkMode..", automark:"..WanMarkDB.WanMarkActive..".")
end

function WMARK_Off()
	WanMarkFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	WanMarkFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
	WanMarkFrame:UnregisterEvent("INSPECT_READY")
	print("WanMark mode: "..WanMarkDB.WanMarkMode..", automark:"..WanMarkDB.WanMarkActive..".")
	gdbprivate.gdb.gdbdefaults = gdbprivate.gdbdefaults.gdbdefaults
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

function WanMark.ShowHelp()
	print(addoninfo)
	print("WanMark Slash commands (/wmark):")
	print("  /wmark on: Enables WanMark automatic mode.")
	print("  /wmark off: Disables WanMark automatic mode.")
	print("  /wmark mark: Marks the targets regardless of automatic mode status.")
	print("  /wmark demark: Removes any party members marks.")
	print("  /wmark private: Enables private (default) marking mode (Revelation).")
	print("  /wmark public: Enables public marking mode (Tank/Healer).")
	print("  /wmark mode: Switches marking mode between private and public.")
end

function WanMark.SlashCmdHandler(msg, editbox)
	--msg = string.lower(msg)
	--print("command is " .. msg .. "\n")
	--if (string.lower(msg) == L["config"]) then --I think string.lowermight not work for Russian letters
	msg=msg:lower(msg:gsub("\t+"," "))
	local help="no"
	if (msg == nil or msg == "" or msg == "help")then help="yes" end
	local words = {}
	words[1], words[2] = msg:match("(%w+)%s*(.-)%s*$")
	--print ("msg=[" .. msg .. "]")
	--print ("words[1]=[" .. words[1] .. "]")
	--print ("words[2]=[" .. words[2] .. "]")
	if (help == "no" and words[2] == "")then
		if (msg == "on") then
			WanMarkDB.WanMarkActive="on"
			WMARK_On()
			if IsInGroup() then
				WMARK_Mark()
				gdbprivate.gdb.gdbdefaults = gdbprivate.gdbdefaults.gdbdefaults
			end
		elseif (msg == "off") then
			WanMarkDB.WanMarkActive="off"
			WMARK_Off()
		elseif (msg == "mark") then
			if IsInGroup() then
				WMARK_Mark()
				gdbprivate.gdb.gdbdefaults = gdbprivate.gdbdefaults.gdbdefaults
			else
				print("WanMark: not in group or raid (mode: "..WanMarkDB.WanMarkMode..", automark "..WanMarkDB.WanMarkActive..").")
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
			print("WanMark mode: "..WanMarkDB.WanMarkMode..", automark "..WanMarkDB.WanMarkActive..".")
			if (WanMarkDB.WanMarkMode == "public")then
				print ("WanMark public mode marks:")
				print (" Tank mark is "..MARKS[tonumber(WanMarkDB.TANK)].." ["..WanMarkDB.TANK.."]")
				print (" Healer mark is "..MARKS[tonumber(WanMarkDB.HEALER)].." ["..WanMarkDB.HEALER.."]")
			elseif (WanMarkDB.WanMarkMode == "private")then
				print ("WanMark private mode marks:")
				for i=0,8 do
					print (" " .. i .. " [" .. MARKS[i] .. "]: " .. WanMarkDB.LINE[i])
				end
			end
		else
			help="yes"
		end
	else
		local changed="no"
		if (words[1] == "tank" or words[1] == "healer")then
			--print "tank or healer"
			for i=0,8 do
				if (words[2] == tostring(i) or words[2] == MARKS[i]) then
					print ("command found: ",words[2]," ["..i.."/"..MARKS[i].."]")
					if (words[1] == "tank")then
						if (WanMarkDB.HEALER == tostring(i))then
							print ("WanMark: mark "..i.."["..MARKS[i].."] already used to mark healer")
						else
							WanMarkDB.TANK=tostring(i)
							print ("WanMark: tank mark set to "..MARKS[i].."["..i.."]")
							changed="yes"
						end
					else
						if (WanMarkDB.TANK == tostring(i))then
							print ("WanMark: mark "..i.."["..MARKS[i].."] already used to mark tank")
						else
							WanMarkDB.HEALER=tostring(i)
							print ("WanMark: healer mark set to "..MARKS[i].."["..i.."]")
							changed="yes"
						end
					end
				end
			end
			if (changed ~= "yes")then print ("WanMark: not the right mark ["..word[2].."]") end
		else
			--print "more than 1 word, but no tank or healer"
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
			if IsInGroup() then
				WMARK_Mark()
				gdbprivate.gdb.gdbdefaults = gdbprivate.gdbdefaults.gdbdefaults
			end
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
				WMARK_Mark()
			else
				print("WanMark: not in group or raid (mode: "..WanMarkDB.WanMarkMode..", automark "..WanMarkDB.WanMarkActive..").")
			end
		elseif (button == "Mode")then
			WMARK_Mode()
		elseif (button == "DeMark")then
			WMARK_DeMark()
		end
	end)

