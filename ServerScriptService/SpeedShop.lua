local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpeedShop = {}

local remoteEvent = Instance.new("RemoteEvent")
remoteEvent.Name = "PurchaseSpeedUpgrade"
remoteEvent.Parent = ReplicatedStorage

function SpeedShop.onPlayerAdded(player)
    local leaderstats = player:WaitForChild("leaderstats")
    
    local speedLevel = Instance.new("IntValue")
    speedLevel.Name = "SpeedLevel"
    speedLevel.Value = 0
    speedLevel.Parent = leaderstats
    
    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        SpeedShop.updatePlayerSpeed(player, humanoid)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

function SpeedShop.updatePlayerSpeed(player, humanoid)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local speedLevel = leaderstats:FindFirstChild("SpeedLevel")
    if not speedLevel then return end
    
    local newSpeed = 16 + (speedLevel.Value * 4)
    humanoid.WalkSpeed = newSpeed
    
    print(player.Name .. " speed updated to: " .. newSpeed)
end

function SpeedShop.purchaseSpeedUpgrade(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local coins = leaderstats:FindFirstChild("Coins")
    local speedLevel = leaderstats:FindFirstChild("SpeedLevel")
    
    if not coins or not speedLevel then return end
    
    local cost = 10 + (speedLevel.Value * 5)
    
    if coins.Value >= cost then
        coins.Value = coins.Value - cost
        speedLevel.Value = speedLevel.Value + 1
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            SpeedShop.updatePlayerSpeed(player, player.Character.Humanoid)
        end
        
        print(player.Name .. " purchased speed upgrade! New level: " .. speedLevel.Value)
    else
        print(player.Name .. " doesn't have enough coins for speed upgrade")
    end
end

function SpeedShop.start()
    Players.PlayerAdded:Connect(SpeedShop.onPlayerAdded)
    
    for _, player in pairs(Players:GetPlayers()) do
        SpeedShop.onPlayerAdded(player)
    end
    
    remoteEvent.OnServerEvent:Connect(function(player)
        SpeedShop.purchaseSpeedUpgrade(player)
    end)
    
    print("Speed shop system started!")
end

return SpeedShop