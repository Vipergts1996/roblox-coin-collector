local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local TrailData = require(script.Parent.TrailData)

local TrailManager = {}

print("TrailManager: Module loaded!")

-- Data storage
local trailDataStore = DataStoreService:GetDataStore("TrailData")
local playerTrailData = {}

-- Remote Events
local purchaseTrailEvent = Instance.new("RemoteEvent")
purchaseTrailEvent.Name = "PurchaseTrail"
purchaseTrailEvent.Parent = ReplicatedStorage
print("TrailManager: Created PurchaseTrail RemoteEvent")

local equipTrailEvent = Instance.new("RemoteEvent")
equipTrailEvent.Name = "EquipTrail"
equipTrailEvent.Parent = ReplicatedStorage
print("TrailManager: Created EquipTrail RemoteEvent")

local getTrailDataEvent = Instance.new("RemoteEvent")
getTrailDataEvent.Name = "GetTrailData"
getTrailDataEvent.Parent = ReplicatedStorage
print("TrailManager: Created GetTrailData RemoteEvent")

function TrailManager.loadPlayerData(player)
    local success, data = pcall(function()
        return trailDataStore:GetAsync("Player_" .. player.UserId)
    end)
    
    if success and data then
        playerTrailData[player] = data
        -- Migrate old data if needed
        if not data.coinMultiplier and data.equipped then
            local trailInfo = TrailData.Trails[data.equipped]
            data.coinMultiplier = trailInfo and trailInfo.coinMultiplier or 1.0
        end
    else
        -- Default data for new players
        playerTrailData[player] = {
            trails = {["Orange Fire"] = true}, -- Default trail unlocked
            equipped = "Orange Fire",
            coinMultiplier = 1.0
        }
    end
    
    -- Apply coin multiplier from equipped trail
    TrailManager.applyCoinMultiplier(player)
end

function TrailManager.savePlayerData(player)
    if not playerTrailData[player] then return end
    
    local success, err = pcall(function()
        trailDataStore:SetAsync("Player_" .. player.UserId, playerTrailData[player])
    end)
    
    if not success then
        warn("Failed to save trail data for " .. player.Name .. ": " .. err)
    end
end

function TrailManager.getPlayerCoins(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Coins") then
        return leaderstats.Coins.Value
    end
    return 0
end

function TrailManager.deductPlayerCoins(player, amount)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Coins") then
        if leaderstats.Coins.Value >= amount then
            leaderstats.Coins.Value = leaderstats.Coins.Value - amount
            return true
        end
    end
    return false
end

function TrailManager.getNextTrailInSequence(player)
    local playerData = playerTrailData[player]
    if not playerData then return nil end
    
    local sortedTrails = TrailData.getTrailsSorted()
    
    for _, trail in ipairs(sortedTrails) do
        if not playerData.trails[trail.name] then
            return trail.name
        end
    end
    
    return nil -- All trails unlocked
end

function TrailManager.canPurchaseTrail(player, trailName)
    local trailInfo = TrailData.Trails[trailName]
    if not trailInfo then return false, "Trail does not exist" end
    
    local playerData = playerTrailData[player]
    if not playerData then return false, "Player data not loaded" end
    
    -- Check if already owned
    if playerData.trails[trailName] then
        return false, "Trail already owned"
    end
    
    -- Check if it's the next in sequence
    local nextTrail = TrailManager.getNextTrailInSequence(player)
    if nextTrail ~= trailName then
        return false, "Must purchase trails in order"
    end
    
    -- Check if player has enough coins
    local playerCoins = TrailManager.getPlayerCoins(player)
    if playerCoins < trailInfo.price then
        return false, "Not enough coins"
    end
    
    return true, "Can purchase"
end

function TrailManager.purchaseTrail(player, trailName)
    local canPurchase, reason = TrailManager.canPurchaseTrail(player, trailName)
    if not canPurchase then
        return false, reason
    end
    
    local trailInfo = TrailData.Trails[trailName]
    local playerData = playerTrailData[player]
    
    -- Deduct coins
    if not TrailManager.deductPlayerCoins(player, trailInfo.price) then
        return false, "Failed to deduct coins"
    end
    
    -- Add trail to player's collection
    playerData.trails[trailName] = true
    
    -- Auto-equip the new trail
    playerData.equipped = trailName
    playerData.coinMultiplier = trailInfo.coinMultiplier
    
    -- Apply coin multiplier
    TrailManager.applyCoinMultiplier(player)
    
    -- Update trail visual effects
    TrailManager.updatePlayerTrailEffects(player)
    
    -- Save data
    TrailManager.savePlayerData(player)
    
    print(player.Name .. " purchased and equipped " .. trailName)
    return true, "Trail purchased successfully"
end

function TrailManager.equipTrail(player, trailName)
    local playerData = playerTrailData[player]
    if not playerData then return false, "Player data not loaded" end
    
    local trailInfo = TrailData.Trails[trailName]
    if not trailInfo then return false, "Trail does not exist" end
    
    -- Check if player owns the trail
    if not playerData.trails[trailName] then
        return false, "Trail not owned"
    end
    
    -- Equip the trail
    playerData.equipped = trailName
    playerData.coinMultiplier = trailInfo.coinMultiplier
    
    -- Apply coin multiplier
    TrailManager.applyCoinMultiplier(player)
    
    -- Update trail visual effects
    TrailManager.updatePlayerTrailEffects(player)
    
    -- Save data
    TrailManager.savePlayerData(player)
    
    print(player.Name .. " equipped " .. trailName)
    return true, "Trail equipped successfully"
end

function TrailManager.applyCoinMultiplier(player)
    local playerData = playerTrailData[player]
    if not playerData then return end
    
    local character = player.Character
    if not character then return end
    
    -- Store coin multiplier for other systems to use
    if not character:FindFirstChild("TrailCoinMultiplier") then
        local coinMultiplier = Instance.new("NumberValue")
        coinMultiplier.Name = "TrailCoinMultiplier"
        coinMultiplier.Parent = character
    end
    -- Handle migration from old speedBoost system to new coinMultiplier system
    local multiplier = playerData.coinMultiplier
    if not multiplier then
        -- Migrate old data or set default
        if playerData.equipped then
            local trailInfo = TrailData.Trails[playerData.equipped]
            multiplier = trailInfo and trailInfo.coinMultiplier or 1.0
            playerData.coinMultiplier = multiplier -- Update player data
        else
            multiplier = 1.0
            playerData.coinMultiplier = 1.0
        end
    end
    character.TrailCoinMultiplier.Value = multiplier
end

function TrailManager.getPlayerTrailData(player)
    local playerData = playerTrailData[player]
    if not playerData then return nil end
    
    return {
        trails = playerData.trails,
        equipped = playerData.equipped,
        coins = TrailManager.getPlayerCoins(player)
    }
end

function TrailManager.updatePlayerTrailEffects(player)
    -- Update visual trail effects when a new trail is equipped
    -- This requires SpeedEffects to have an updateTrailColors function
    local SpeedEffects = require(script.Parent.SpeedEffects)
    if SpeedEffects.updateTrailColors then
        SpeedEffects.updateTrailColors(player)
    end
end

function TrailManager.getEquippedTrailInfo(player)
    local playerData = playerTrailData[player]
    if not playerData then return TrailData.Trails["Orange Fire"] end
    
    return TrailData.Trails[playerData.equipped] or TrailData.Trails["Orange Fire"]
end

-- Event handlers
purchaseTrailEvent.OnServerEvent:Connect(function(player, trailName)
    local success, message = TrailManager.purchaseTrail(player, trailName)
    purchaseTrailEvent:FireClient(player, success, message)
end)

equipTrailEvent.OnServerEvent:Connect(function(player, trailName)
    local success, message = TrailManager.equipTrail(player, trailName)
    equipTrailEvent:FireClient(player, success, trailName)
end)

getTrailDataEvent.OnServerEvent:Connect(function(player)
    print("TrailManager: Received request from", player.Name)
    local sortedTrails = TrailData.getTrailsSorted()
    local playerData = TrailManager.getPlayerTrailData(player)
    print("TrailManager: Sending", #sortedTrails, "trails to", player.Name)
    print("TrailManager: Player data:", playerData)
    getTrailDataEvent:FireClient(player, sortedTrails, playerData)
end)

-- Player management
Players.PlayerAdded:Connect(function(player)
    TrailManager.loadPlayerData(player)
    
    player.CharacterAdded:Connect(function(character)
        -- Wait a bit for leaderstats to load
        wait(1)
        TrailManager.applyCoinMultiplier(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    TrailManager.savePlayerData(player)
    playerTrailData[player] = nil
end)

-- Auto-save every 30 seconds
spawn(function()
    while true do
        wait(30)
        for player, _ in pairs(playerTrailData) do
            if player.Parent then -- Check if player is still in game
                TrailManager.savePlayerData(player)
            end
        end
    end
end)

TrailManager.loadPlayerData = TrailManager.loadPlayerData
TrailManager.getEquippedTrailInfo = TrailManager.getEquippedTrailInfo
TrailManager.applyCoinMultiplier = TrailManager.applyCoinMultiplier

return TrailManager