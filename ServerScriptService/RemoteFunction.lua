local RS = game:GetService("ReplicatedStorage")
local MarketService = game:GetService("MarketplaceService")
local Modules = RS
local RemoteEvents = RS
local RemoteFunction = RS

local ProfileService = require(Modules:WaitForChild("ProfileData"))
local GameData = require(Modules:WaitForChild("GameData"))
local LoadGame = require(Modules:WaitForChild("ProfileData"):WaitForChild("LoadData"))
local CreateTable = require(Modules:WaitForChild("CreateTable"))

local PetHandler = require(Modules:WaitForChild("PetHandler"))

local function CheckStorage(plr)
	local profile = ProfileService[plr]
	if profile then
		local start = 25
		if profile.Data.Upgrades.StoragePets > 0 then
			start += profile.Data.Upgrades.StoragePets
		end
		if profile.Data.Gamepass.AddStorage then
			start += 30
		end
		if profile.Data.Gamepass.AddStorage2 then
			start += 100
		end
		return start
	end
end

RemoteFunction:WaitForChild("Data").OnServerInvoke = function(plr, value2)
	if value2 == "SEcrEt" then
		local profile = ProfileService[plr]
		return profile.Data
	else
		plr:Kick()
	end
end

RemoteFunction:WaitForChild("AutoRarity").OnServerInvoke = function(plr, rarity)
	local profile = ProfileService[plr]
	if profile then
		if profile.Data.AutoRarity[rarity] == false then
			profile.Data.AutoRarity[rarity] = true
			return true
		else
			profile.Data.AutoRarity[rarity] = false
			return false
		end
	end
end
