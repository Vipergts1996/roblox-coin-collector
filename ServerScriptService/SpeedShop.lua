local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpeedShop = {}

local speedUpgradeEvent = Instance.new("RemoteEvent")
speedUpgradeEvent.Name = "PurchaseSpeedUpgrade"
speedUpgradeEvent.Parent = ReplicatedStorage

local jumpUpgradeEvent = Instance.new("RemoteEvent")
jumpUpgradeEvent.Name = "PurchaseJumpUpgrade"
jumpUpgradeEvent.Parent = ReplicatedStorage

function SpeedShop.onPlayerAdded(player)
    local leaderstats = player:WaitForChild("leaderstats")
    
    local speedLevel = Instance.new("IntValue")
    speedLevel.Name = "SpeedLevel"
    speedLevel.Value = 1
    speedLevel.Parent = leaderstats
    
    local jumpLevel = Instance.new("IntValue")
    jumpLevel.Name = "JumpLevel"
    jumpLevel.Value = 1
    jumpLevel.Parent = leaderstats
    
    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        SpeedShop.updatePlayerStats(player, humanoid)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

function SpeedShop.updatePlayerStats(player, humanoid)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local speedLevel = leaderstats:FindFirstChild("SpeedLevel")
    local jumpLevel = leaderstats:FindFirstChild("JumpLevel")
    if not speedLevel or not jumpLevel then return end
    
    local newSpeed = 16 + ((speedLevel.Value - 1) * 4)
    local newJumpPower = 50 + ((jumpLevel.Value - 1) * 5)
    
    humanoid.WalkSpeed = newSpeed
    humanoid.JumpPower = newJumpPower
    
    print(player.Name .. " stats updated - Speed: " .. newSpeed .. ", Jump: " .. newJumpPower)
end

function SpeedShop.purchaseSpeedUpgrade(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local coins = leaderstats:FindFirstChild("Coins")
    local speedLevel = leaderstats:FindFirstChild("SpeedLevel")
    
    if not coins or not speedLevel then return end
    
    local cost = 10 + ((speedLevel.Value - 1) * 5)
    
    if coins.Value >= cost then
        coins.Value = coins.Value - cost
        speedLevel.Value = speedLevel.Value + 1
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            SpeedShop.updatePlayerStats(player, player.Character.Humanoid)
        end
        
        print(player.Name .. " purchased speed upgrade! New level: " .. speedLevel.Value)
    else
        print(player.Name .. " doesn't have enough coins for speed upgrade")
    end
end

function SpeedShop.purchaseJumpUpgrade(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local coins = leaderstats:FindFirstChild("Coins")
    local jumpLevel = leaderstats:FindFirstChild("JumpLevel")
    
    if not coins or not jumpLevel then return end
    
    local cost = 15 + ((jumpLevel.Value - 1) * 8)
    
    if coins.Value >= cost then
        coins.Value = coins.Value - cost
        jumpLevel.Value = jumpLevel.Value + 1
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            SpeedShop.updatePlayerStats(player, player.Character.Humanoid)
        end
        
        print(player.Name .. " purchased jump upgrade! New level: " .. jumpLevel.Value)
    else
        print(player.Name .. " doesn't have enough coins for jump upgrade")
    end
end

function SpeedShop.start()
    Players.PlayerAdded:Connect(SpeedShop.onPlayerAdded)
    
    for _, player in pairs(Players:GetPlayers()) do
        SpeedShop.onPlayerAdded(player)
    end
    
    speedUpgradeEvent.OnServerEvent:Connect(function(player)
        SpeedShop.purchaseSpeedUpgrade(player)
    end)
    
    jumpUpgradeEvent.OnServerEvent:Connect(function(player)
        SpeedShop.purchaseJumpUpgrade(player)
    end)
    
    print("Speed shop system started!")
end

return SpeedShop