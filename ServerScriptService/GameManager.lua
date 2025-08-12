local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameManager = {}

function GameManager.onPlayerAdded(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats
    
    print(player.Name .. " joined the game!")
end

function GameManager.onPlayerRemoving(player)
    print(player.Name .. " left the game!")
end

function GameManager.start()
    Players.PlayerAdded:Connect(GameManager.onPlayerAdded)
    Players.PlayerRemoving:Connect(GameManager.onPlayerRemoving)
    
    for _, player in pairs(Players:GetPlayers()) do
        GameManager.onPlayerAdded(player)
    end
end

return GameManager