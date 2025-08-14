local DataStore = game:GetService("DataStoreService")
local MarketplaceService = game:GetService("MarketplaceService")
local MessagingService = game:GetService("MessagingService")
local RS = game:GetService("ReplicatedStorage")
local Modules = RS

local ProfileService = require(Modules:WaitForChild("ProfileData"))
local GameData = require(Modules:WaitForChild("GameData"))
local PetHandler = require(Modules:WaitForChild("PetHandler"))
local CreateTable = require(Modules:WaitForChild("CreateTable"))

local LimitedPetInfo = DataStore:GetDataStore("LimitedPets(1)");

local Info = {
	["Explosive Hydro"] = {
		ID = 1825577105;
		Max = 100;
		Count = 100;
	}
}
task.spawn(function()
	for i,v in pairs(workspace:WaitForChild("PetsLimited"):GetChildren()) do
		if v:IsA("Model") then
			local data = LimitedPetInfo:GetAsync(v.Name)
			if data == nil then
				for a,b in pairs(Info) do
					if v.Name == a then
						LimitedPetInfo:SetAsync(v.Name, Info[v.Name])
					end
				end
			end
			data = LimitedPetInfo:GetAsync(v.Name)
			local gui = v.Slots
			gui.TextLabel.Text = data.Count.."/"..data.Max.." SLOTS"
			
			if data.Count < 1 then
				v:SetAttribute("CanBuy", false)
				v.Slots.TextLabel.Text = "Out of stock"
			end
		end
	end
end)

MarketplaceService.ProcessReceipt = function(purchaseInfo)
	local plrPurchased = game.Players:GetPlayerByUserId(purchaseInfo.PlayerId)
	if not plrPurchased then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local id = purchaseInfo.ProductId 

	local profile = ProfileService[plrPurchased]

	if profile then
		if id == 1825577105 then
			for _,LimitedPet in pairs(workspace:WaitForChild("PetsLimited"):GetChildren()) do
				if LimitedPet:IsA("Model") then
					if LimitedPet.Name == "Explosive Hydro" then
						local data = LimitedPetInfo:GetAsync(LimitedPet.Name)
						data.Count -= 1
						RS:WaitForChild("AddGui"):FireClient(plrPurchased, "Pet", "Explosive Hydro")
						PetHandler:AddPet(plrPurchased, "Explosive Hydro", false)
						if data.Count < 1 then
							LimitedPet:SetAttribute("CanBuy", false)
							LimitedPet.Slots.TextLabel.Text = "Out of stock"
						end
						LimitedPetInfo:SetAsync(LimitedPet.Name, data);
					end
				end
			end
			MessagingService:PublishAsync("BuyPet", 1825577105);
			return Enum.ProductPurchaseDecision.PurchaseGranted
		end
	end
end

MessagingService:SubscribeAsync("BuyPet",function(ProductId)
	for a,Pet in pairs(Info) do
		if ProductId.Data == Pet.ID then
			task.wait(1)
			for _,LimitedPet in pairs(workspace:WaitForChild("PetsLimited"):GetChildren()) do
				if LimitedPet:IsA("Model") then
					task.wait(1)
					if LimitedPet.Name == a then
						task.wait(1)
						local data = LimitedPetInfo:GetAsync(LimitedPet.Name);
						local gui = LimitedPet.Slots
						gui.TextLabel.Text = data.Count.."/"..data.Max.." SLOTS"
						
						if data.Count < 1 then
							LimitedPet:SetAttribute("CanBuy", false)
							gui.TextLabel.Text = "Out of stock"
						end
					end
				end
			end
		end;
	end;
end)