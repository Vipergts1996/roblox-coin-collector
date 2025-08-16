local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local NitroSystem = {}

-- Nitro configuration
local NITRO_CONSUMPTION_RATE = 33.33 -- Units per second (3 seconds to deplete 100 units)
local NITRO_REFILL_TIME = 8 -- seconds to fully refill
local NITRO_ACCELERATION_MULTIPLIER = 3 -- 3x acceleration boost
local NITRO_MAX = 100 -- Maximum nitro amount

-- Player nitro data
local playerNitroData = {}

-- Remote Events
local startNitroEvent = Instance.new("RemoteEvent")
startNitroEvent.Name = "StartNitro"
startNitroEvent.Parent = ReplicatedStorage

local stopNitroEvent = Instance.new("RemoteEvent")
stopNitroEvent.Name = "StopNitro"
stopNitroEvent.Parent = ReplicatedStorage

local nitroUpdateEvent = Instance.new("RemoteEvent")
nitroUpdateEvent.Name = "NitroUpdate"
nitroUpdateEvent.Parent = ReplicatedStorage

function NitroSystem.initializePlayer(player)
    playerNitroData[player] = {
        nitroAmount = NITRO_MAX, -- Start with full nitro
        isUsingNitro = false,
        lastUpdateTime = tick()
    }
    
    -- Send initial nitro amount to client
    nitroUpdateEvent:FireClient(player, NITRO_MAX, NITRO_MAX, false)
end

function NitroSystem.updatePlayerNitro(player)
    local data = playerNitroData[player]
    if not data then return end
    
    local currentTime = tick()
    local deltaTime = currentTime - data.lastUpdateTime
    data.lastUpdateTime = currentTime
    
    if data.isUsingNitro then
        -- Consume nitro while being used
        if data.nitroAmount > 0 then
            data.nitroAmount = math.max(0, data.nitroAmount - (NITRO_CONSUMPTION_RATE * deltaTime))
            
            -- Stop nitro if depleted
            if data.nitroAmount <= 0 then
                NitroSystem.stopNitro(player)
            else
                -- Send update to client
                nitroUpdateEvent:FireClient(player, data.nitroAmount, NITRO_MAX, true)
            end
        end
    else
        -- Refill nitro over time
        if data.nitroAmount < NITRO_MAX then
            local refillRate = NITRO_MAX / NITRO_REFILL_TIME -- Units per second
            data.nitroAmount = math.min(NITRO_MAX, data.nitroAmount + (refillRate * deltaTime))
            
            -- Send update to client
            nitroUpdateEvent:FireClient(player, data.nitroAmount, NITRO_MAX, false)
        end
    end
end

function NitroSystem.canStartNitro(player)
    local data = playerNitroData[player]
    if not data then return false end
    
    return data.nitroAmount > 0 and not data.isUsingNitro
end

function NitroSystem.startNitro(player)
    if not NitroSystem.canStartNitro(player) then
        return false
    end
    
    local data = playerNitroData[player]
    data.isUsingNitro = true
    
    -- Apply nitro effect to character
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        -- Create nitro multiplier value for SpeedController to use
        local nitroMultiplier = character:FindFirstChild("NitroMultiplier")
        if not nitroMultiplier then
            nitroMultiplier = Instance.new("NumberValue")
            nitroMultiplier.Name = "NitroMultiplier"
            nitroMultiplier.Parent = character
        end
        nitroMultiplier.Value = NITRO_ACCELERATION_MULTIPLIER
        
        -- Add visual nitro effect to speedometer
        NitroSystem.addSpeedometerFireEffect(player)
    end
    
    print(player.Name .. " started nitro!")
    return true
end

function NitroSystem.stopNitro(player)
    local data = playerNitroData[player]
    if not data then return end
    
    data.isUsingNitro = false
    
    -- Remove nitro effect from character
    local character = player.Character
    if character then
        local nitroMultiplier = character:FindFirstChild("NitroMultiplier")
        if nitroMultiplier then
            nitroMultiplier.Value = 1 -- Reset to normal
        end
        
        -- Remove speedometer fire effect
        NitroSystem.removeSpeedometerFireEffect(player)
    end
    
    -- Send update to client
    nitroUpdateEvent:FireClient(player, data.nitroAmount, NITRO_MAX, false)
    
    print(player.Name .. " nitro ended")
end

-- Remote Events for speedometer fire effect
local speedometerFireEvent = Instance.new("RemoteEvent")
speedometerFireEvent.Name = "SpeedometerFireEffect"
speedometerFireEvent.Parent = ReplicatedStorage

function NitroSystem.addSpeedometerFireEffect(player)
    -- Send fire effect signal to client
    speedometerFireEvent:FireClient(player, true)
end

function NitroSystem.removeSpeedometerFireEffect(player)
    -- Send fire effect removal signal to client
    speedometerFireEvent:FireClient(player, false)
end

function NitroSystem.getNitroData(player)
    return playerNitroData[player]
end

-- Event handlers
startNitroEvent.OnServerEvent:Connect(function(player)
    NitroSystem.startNitro(player)
end)

stopNitroEvent.OnServerEvent:Connect(function(player)
    NitroSystem.stopNitro(player)
end)

-- Player management
Players.PlayerAdded:Connect(function(player)
    NitroSystem.initializePlayer(player)
    
    player.CharacterAdded:Connect(function(character)
        -- Reset nitro multiplier when character spawns
        wait(1) -- Wait for character to fully load
        local nitroMultiplier = Instance.new("NumberValue")
        nitroMultiplier.Name = "NitroMultiplier"
        nitroMultiplier.Value = 1
        nitroMultiplier.Parent = character
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    playerNitroData[player] = nil
end)

-- Update loop
spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        for player, _ in pairs(playerNitroData) do
            if player.Parent then -- Check if player is still in game
                NitroSystem.updatePlayerNitro(player)
            end
        end
    end
end)

return NitroSystem