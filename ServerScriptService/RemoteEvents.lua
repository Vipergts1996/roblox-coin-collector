local ProfileService = require(game.ReplicatedStorage:WaitForChild("ProfileData"))
local GameData = require(game.ReplicatedStorage:WaitForChild("GameData"))

game.ReplicatedStorage:WaitForChild("Power").OnServerEvent:Connect(function(plr, add, boostt) 
		local profile = ProfileService[plr]
		if profile then
			local clickboost = add
			local boost = ((boostt * clickboost))
			local profile = ProfileService[plr]
			profile.Data.Power += boost
			game.ReplicatedStorage:WaitForChild("AddGui"):FireClient(plr, "Power", boost)
	else
		plr:Kick()
	end
end)
