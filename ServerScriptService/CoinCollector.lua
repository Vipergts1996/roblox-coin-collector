local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local CoinCollector = {}

function CoinCollector.onCoinTouched(hit, hitbox)
    print("Coin touched by:", hit.Name, "Parent:", hit.Parent.Name)
    
    -- Ignore touches from the coin's own parts
    if hit.Parent == hitbox or hit == hitbox then
        print("Ignoring self-touch")
        return
    end
    
    -- Find the character by searching up the parent hierarchy
    local character = hit.Parent
    local humanoid = character:FindFirstChild("Humanoid")
    
    -- If no humanoid found, try going up one more level (for accessories like hair)
    if not humanoid and character.Parent then
        character = character.Parent
        humanoid = character:FindFirstChild("Humanoid")
    end
    
    if not humanoid then 
        print("No humanoid found")
        return 
    end
    
    local player = Players:GetPlayerFromCharacter(character)
    if not player then 
        print("No player found")
        return 
    end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then 
        print("No leaderstats found")
        return 
    end
    
    local coinsValue = leaderstats:FindFirstChild("Coins")
    if not coinsValue then 
        print("No coins value found")
        return 
    end
    
    local coinValueData = hitbox:FindFirstChild("CoinValue")
    local coinWorth = 1
    if coinValueData then
        coinWorth = coinValueData.Value
    end
    
    coinsValue.Value = coinsValue.Value + coinWorth
    
    local collectSound = Instance.new("Sound")
    collectSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
    collectSound.Volume = 0.5
    collectSound.Parent = hitbox
    collectSound:Play()
    
    collectSound.Ended:Connect(function()
        collectSound:Destroy()
    end)
    
    hitbox:Destroy()
    
    print(player.Name .. " collected a " .. coinWorth .. " coin! Total: " .. coinsValue.Value)
end

function CoinCollector.setupCoin(hitbox)
    local connection
    connection = hitbox.Touched:Connect(function(hit)
        CoinCollector.onCoinTouched(hit, hitbox)
        connection:Disconnect()
    end)
end

return CoinCollector