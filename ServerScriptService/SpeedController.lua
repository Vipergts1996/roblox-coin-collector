local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local SpeedController = {}

local playerSpeedData = {}

-- Speed acceleration settings
local ACCELERATION_TIME = 1.2  -- Time to reach max speed (1.2 seconds for first gear, 20% slower)
local DECELERATION_TIME = 0.3  -- Time to slow down when stopping
local UPDATE_RATE = 0.05       -- How often to update speed (20 FPS)

function SpeedController.setupPlayer(player)
    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Initialize player speed data
        playerSpeedData[player] = {
            character = character,
            humanoid = humanoid,
            rootPart = rootPart,
            maxSpeed = 16, -- Will be updated from leaderstats
            currentSpeed = 0,
            targetSpeed = 0,
            isMoving = false,
            lastMoveTime = 0,
            accelerationMultiplier = 1
        }
        
        -- Update max speed from leaderstats
        SpeedController.updateMaxSpeed(player)
        
        -- Start the speed update loop for this player
        SpeedController.startSpeedLoop(player)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    player.CharacterRemoving:Connect(function()
        if playerSpeedData[player] then
            -- Clean up any running connections
            if playerSpeedData[player].speedConnection then
                playerSpeedData[player].speedConnection:Disconnect()
            end
            playerSpeedData[player] = nil
        end
    end)
end

function SpeedController.updateMaxSpeed(player)
    if not playerSpeedData[player] then return end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local speedLevel = leaderstats:FindFirstChild("SpeedLevel")
    if not speedLevel then return end
    
    -- Calculate max speed based on level (same formula as before)
    local newMaxSpeed = 16 + ((speedLevel.Value - 1) * 4)
    playerSpeedData[player].maxSpeed = newMaxSpeed
    
    -- Adjust acceleration time based on speed level (higher levels take slightly longer)
    local levelMultiplier = 1 + (speedLevel.Value - 1) * 0.1  -- +0.1 seconds per level
    playerSpeedData[player].accelerationMultiplier = levelMultiplier
    
    print(player.Name .. " max speed updated to: " .. newMaxSpeed .. " (Level " .. speedLevel.Value .. ")")
end

function SpeedController.startSpeedLoop(player)
    local data = playerSpeedData[player]
    if not data then return end
    
    -- Disconnect any existing connection
    if data.speedConnection then
        data.speedConnection:Disconnect()
    end
    
    data.speedConnection = RunService.Heartbeat:Connect(function()
        SpeedController.updatePlayerSpeed(player)
    end)
end

function SpeedController.updatePlayerSpeed(player)
    local data = playerSpeedData[player]
    if not data or not data.character or not data.character.Parent then return end
    
    local humanoid = data.humanoid
    local rootPart = data.rootPart
    
    if not humanoid or not rootPart then return end
    
    -- Check if player is trying to move
    local moveVector = humanoid.MoveDirection
    local isTryingToMove = moveVector.Magnitude > 0
    
    local currentTime = tick()
    
    if isTryingToMove then
        -- Player is trying to move
        if not data.isMoving then
            data.isMoving = true
            data.lastMoveTime = currentTime
        end
        
        -- Calculate how long we've been accelerating
        local accelerationTime = currentTime - data.lastMoveTime
        local adjustedAccelTime = ACCELERATION_TIME * data.accelerationMultiplier
        
        -- Progressive speed buildup (ease-out curve for smooth feel)
        local speedProgress = math.min(accelerationTime / adjustedAccelTime, 1)
        speedProgress = 1 - math.pow(1 - speedProgress, 3) -- Ease-out cubic for Flash-like acceleration
        
        -- Check for nitro multiplier
        local nitroMultiplier = 1
        local nitroMultiplierValue = data.character:FindFirstChild("NitroMultiplier")
        if nitroMultiplierValue then
            nitroMultiplier = nitroMultiplierValue.Value
        end
        
        data.targetSpeed = data.maxSpeed * speedProgress * nitroMultiplier
    else
        -- Player stopped trying to move - decelerate
        if data.isMoving then
            data.isMoving = false
            data.lastMoveTime = currentTime
        end
        
        -- Quick deceleration
        local decelerationTime = currentTime - data.lastMoveTime
        local decelerationProgress = math.min(decelerationTime / DECELERATION_TIME, 1)
        decelerationProgress = math.pow(decelerationProgress, 2) -- Ease-in for quick stop
        
        data.targetSpeed = data.currentSpeed * (1 - decelerationProgress)
        
        if data.targetSpeed < 0.1 then
            data.targetSpeed = 0
        end
    end
    
    -- Smooth interpolation to target speed
    local speedDifference = data.targetSpeed - data.currentSpeed
    data.currentSpeed = data.currentSpeed + (speedDifference * 0.3) -- Smooth lerp
    
    -- Apply the speed to humanoid
    humanoid.WalkSpeed = data.currentSpeed
end

function SpeedController.onPlayerAdded(player)
    SpeedController.setupPlayer(player)
end

function SpeedController.start()
    Players.PlayerAdded:Connect(SpeedController.onPlayerAdded)
    
    for _, player in pairs(Players:GetPlayers()) do
        SpeedController.onPlayerAdded(player)
    end
    
    print("Progressive Speed Controller started!")
end

return SpeedController