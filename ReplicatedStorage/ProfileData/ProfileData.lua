local Players = game:GetService("Players")
local cachedProfiles = {}
local ProfileService = require(script.ProfileService)
local PlayerData = require(script:WaitForChild("PlayerData"))
local MarketService = game:GetService("MarketplaceService")
local GameData = require(script.Parent:WaitForChild("GameData"))

local Stats = PlayerData

local PlayerProfileStore = ProfileService.GetProfileStore("PlayerData[1]", Stats)

local function PlayerDataLoaded(player)
	print("Data loaded!")
	local profile = cachedProfiles[player]
	
	local folder = Instance.new("Folder")
	folder.Name = "leaderstats"
	folder.Parent = player
	
	local Power = Instance.new("IntValue")
	Power.Name = "Power"
	Power.Value = profile.Data.Power
	Power.Parent = folder
	
	local Eggs = Instance.new("IntValue")
	Eggs.Name = "Eggs"
	Eggs.Value = profile.Data.OpenEggs
	Eggs.Parent = folder
	
	local StoragePets = Instance.new("IntValue")
	StoragePets.Name = "StoragePets"
	StoragePets.Value = profile.Data.StoragePets
	StoragePets.Parent = player

	local MaxStorage = Instance.new("IntValue")
	MaxStorage.Name = "MaxStorage"
	MaxStorage.Value = profile.Data.MaxStorage
	MaxStorage.Parent = player

	local EquipPets = Instance.new("IntValue")
	EquipPets.Name = "EquipPets"
	EquipPets.Value = profile.Data.EquipPets
	EquipPets.Parent = player

	local MaxEquipped = Instance.new("IntValue")
	MaxEquipped.Name = "MaxEquipped"
	MaxEquipped.Value = profile.Data.MaxEquipped
	MaxEquipped.Parent = player

	local Settings = Instance.new("Folder")
	Settings.Name = "Settings"
	Settings.Parent = player

	local AutoEgg = Instance.new("BoolValue")
	AutoEgg.Name = "AutoEgg"
	AutoEgg.Value = profile.Data.Gamepass.AutoEgg
	AutoEgg.Parent = Settings

	local TripleEgg = Instance.new("BoolValue")
	TripleEgg.Name = "TripleEgg"
	TripleEgg.Value = profile.Data.Gamepass.TripleEgg
	TripleEgg.Parent = Settings

	local Lucky = Instance.new("BoolValue")
	Lucky.Name = "Lucky"
	Lucky.Value = profile.Data.Gamepass.Lucky
	Lucky.Parent = Settings
	
	for i,v in pairs(GameData.Gamepass) do
		if MarketService:UserOwnsGamePassAsync(player.UserId, i) then
			profile.Data.Gamepass[v] = true
			if v == "AddPets" or  v == "AddPets2" then
				profile.Data.Gamepass.AddPets = true
				local start = 3
				if profile.Data.Gamepass.AddPets then
					start += 1
				end
				if profile.Data.Gamepass.AddPets2 then
					start += 2
				end
				profile.Data.MaxEquipped = start
			elseif v == "AddStorage" or  v == "AddStorage2" then
				profile.Data.Gamepass.AddStorage = true
				local start = 25
				if profile.Data.Gamepass.AddStorage == true then
					start += 25
				end
				if profile.Data.Gamepass.AddStorage2 == true then
					start += 100
				end
				profile.Data.MaxStorage = start
			elseif v == "Bomba" then
				if not table.find(profile.Data.Bombs, "Atomic Bomb") then
					table.insert(profile.Data.Bombs, "Atomic Bomb")
				elseif v == "Dominus" then
					--PetHandler:AddPet(player, "Green Dragon", false)
					game.ReplicatedStorage:WaitForChild("AddGui"):FireClient(player, "Pet", "Dominus")
				end
			end
		end
	end

	if MarketService:UserOwnsGamePassAsync(player.UserId, 806195737) then
		profile.Data.Gamepass.TripleEgg = true

	elseif MarketService:UserOwnsGamePassAsync(player.UserId, 806848752) then
		profile.Data.Gamepass.Lucky = true
		
	elseif MarketService:UserOwnsGamePassAsync(player.UserId, 807342731) then
		profile.Data.Gamepass.AddPets = true
		local start = 3
		if profile.Data.Gamepass.AddPets then
			start += 1
		end
		if profile.Data.Gamepass.AddPets2 then
			start += 2
		end
		profile.Data.MaxEquipped = start

	elseif MarketService:UserOwnsGamePassAsync(player.UserId, 809315352) then
		profile.Data.Gamepass.AddPets2 = true
		local start = 3
		if profile.Data.Gamepass.AddPets then
			start += 1
		end
		if profile.Data.Gamepass.AddPets2 then
			start += 2
		end
		profile.Data.MaxEquipped = start

	elseif MarketService:UserOwnsGamePassAsync(player.UserId, 806734789) then
		profile.Data.Gamepass.AddStorage = true
		local start = 25
		if profile.Data.Gamepass.AddStorage == true then
			start += 25
		end
		if profile.Data.Gamepass.AddStorage2 == true then
			start += 100
		end
		profile.Data.MaxStorage = start

	elseif MarketService:UserOwnsGamePassAsync(player.UserId, 806389768) then
		profile.Data.Gamepass.AddStorage2 = true
		local start = 25
		if profile.Data.Gamepass.AddStorage == true then
			start += 25
		end
		if profile.Data.Gamepass.AddStorage2 == true then
			start += 100
		end
		profile.Data.MaxStorage = start
		
	end
	
	local folder = game.ReplicatedStorage:WaitForChild("Settings"):WaitForChild("PlayerTemplate"):Clone()
	folder.Name = player.Name
	folder.Parent = game.ReplicatedStorage.Players

	local newfolder = Instance.new("Folder")
	newfolder.Name = player.Name
	newfolder.Parent = workspace:WaitForChild("Pets"):WaitForChild("ServerPets")

	local newfolder2 = Instance.new("Folder")
	newfolder2.Name = player.Name
	newfolder2.Parent = workspace:WaitForChild("Pets"):WaitForChild("ClientPets")	

	local debounce = game.ReplicatedStorage:WaitForChild("Settings"):WaitForChild("DebouncePlr"):Clone()
	debounce.Name = player.Name
	debounce.Parent = game:GetService("ServerStorage"):WaitForChild("Debounce")
	
	task.spawn(function()
		while true do
			local profile = cachedProfiles[player]
			
			if profile ~= nil then
				task.spawn(function()
						Power.Value = profile.Data.Power
						Eggs.Value = profile.Data.OpenEggs
						MaxStorage.Value = profile.Data.MaxStorage
						StoragePets.Value = profile.Data.StoragePets
						AutoEgg.Value = profile.Data.Gamepass.AutoEgg
						TripleEgg.Value = profile.Data.Gamepass.TripleEgg
						EquipPets.Value = profile.Data.EquipPets
						MaxEquipped.Value = profile.Data.MaxEquipped
						Lucky.Value = profile.Data.Gamepass.Lucky
					end)
					
					folder.AutoDelete.Common.Value = profile.Data.AutoRarity.Common
					folder.AutoDelete.Rare.Value = profile.Data.AutoRarity.Rare
					folder.AutoDelete.Epic.Value = profile.Data.AutoRarity.Epic
					folder.AutoDelete.Legendary.Value = profile.Data.AutoRarity.Legendary
					
			else
				break
			end
			
			task.wait(0.1)
		end
	end)
	 
end

local function PlayerAdded(player)
	local profile = PlayerProfileStore:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")
	
	if profile ~= nil then
		profile:ListenToRelease(function()
			cachedProfiles[player] = nil
			player:Kick("Your profile has been loaded remotely. Please rejoin.")
		end)
		
		if player:IsDescendantOf(Players) then
			cachedProfiles[player] = profile
			PlayerDataLoaded(player)
		else
			profile:Release()
		end
	else
		player:Kick("Unable to load saved data. Please rejoin.")
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	spawn(function()
		PlayerAdded(player)
	end)
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(function(player)
	local profile = cachedProfiles[player]
	if profile ~= nil then
		profile:Release()
	end
end)

return cachedProfiles
