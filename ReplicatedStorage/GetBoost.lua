local module = {}

local PlayerData = require(script.Parent:WaitForChild("ProfileData"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Settings = ReplicatedStorage:WaitForChild("Settings")
local Assets = ReplicatedStorage:WaitForChild("Models")
local RunService = game:GetService("RunService")
local GameData = require(script.Parent:WaitForChild("GameData"))
local Pets = Assets.Pets

function module:PetsPower(plr)
	local profile = PlayerData[plr]
	if profile then
		local boost = 0
		for i,v in pairs(profile.Data.EquippedPets) do
			local info = GameData.Pets[v.PetName]
			if info.PowerBoost > 1 then
				boost += info.PowerBoost
			end
		end
		if boost > 1 then
			return boost
		else
			return 1
		end
	end
end

return module
