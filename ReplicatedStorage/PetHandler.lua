local RS = game:GetService("ReplicatedStorage")
local Assets = RS:WaitForChild("Models")
local Pets = Assets:WaitForChild("Pets")
local Data = require(RS:WaitForChild("GameData"))
local ProfileService = require(RS:WaitForChild("ProfileData"))
local CreateTable = require(RS:WaitForChild("CreateTable"))
local TweenService = game:GetService("TweenService")
local RemoteEvents = RS

local ServerPets = workspace:WaitForChild("Pets"):WaitForChild("ServerPets")
local ClientPets = workspace:WaitForChild("Pets"):WaitForChild("ClientPets")

local PetHandler = {}

local function SetPet(char,id)
	for _,v in pairs(char:GetChildren()) do
		if v:IsA("Model") then
			if v:GetAttribute("Id") == id then
				return v
			end
		end
	end
end

local function SetWeid(petmodel)
	local primarypart = petmodel.PrimaryPart
	for i,v in pairs(petmodel:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
			v.Anchored = false
			if v ~= primarypart then
				local weid = Instance.new("WeldConstraint", primarypart)
				weid.Part0 = v
				weid.Part1 = primarypart
			end
		end
	end
end

function PetHandler:AddPet(plr, pet, chat)
	local profile = ProfileService[plr]
	profile.Data.StoragePets += 1
	profile.Data.idpet += 1
	local petinfo = Data.Pets[pet]
	if chat then
		RemoteEvents:WaitForChild("ChatMend"):FireAllClients( "Egg", {Rarity = petinfo.Rarity, PetName = pet, Player = plr.Name} )
	end
	local PetData = CreateTable:PetTable(pet, profile.Data.idpet, false, false, Data.Pets[pet].Craft)

	table.insert(profile.Data.Pets, PetData)

	if not table.find(profile.Data.Index, pet) then
		table.insert(profile.Data.Index, pet)
		profile.Data.Index[pet] = true
	end

	RemoteEvents:WaitForChild("AddPetTemplate"):FireClient(plr, pet, (profile.Data.idpet), Data.Pets[pet].Craft)
end

function PetHandler:EquipPet(player, pet, petID)
	local character = player.Character

	if pet ~= nil and character ~= nil then
		local petName = pet
		
		if not RS:WaitForChild("Models"):WaitForChild("Pets"):FindFirstChild(petName) then return end
		
		local petFol = Instance.new("Folder") petFol.Name = petID

		local petNameVal = Instance.new("StringValue")
		petNameVal.Name = "PetName" petNameVal.Value = tostring(petName)
		petNameVal.Parent = petFol

		local petIDVal = Instance.new("StringValue")
		petIDVal.Name = "PetID" petIDVal.Value = petID
		petIDVal.Parent = petFol

		local PetFolder = ServerPets:FindFirstChild(player.Name)
		petFol.Parent = PetFolder
		return petFol
	end
end

function PetHandler:UnequipPet(plr, id)
	if plr ~= nil then
		if ServerPets[plr.Name]:FindFirstChild(id) then
			ServerPets[plr.Name]:FindFirstChild(id):Destroy()
		end
	end
end

return PetHandler
