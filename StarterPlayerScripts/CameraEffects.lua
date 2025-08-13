local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local CameraEffects = {}

-- Camera settings
local BASE_ZOOM_DISTANCE = 12 -- Default camera distance when not moving
local SHAKE_INTENSITY = 0.25  -- Screen shake strength at max speed (50% reduced)
local SHAKE_FREQUENCY = 15    -- How fast the shake oscillates

-- Custom zoom distances for each gear level (when at max speed for that gear)
local function getMaxZoomForGear(gearLevel)
    -- Progressive zoom that scales with gear level
    -- Gear 1: 15, Gear 10: 25, Gear 50: 50, Gear 101: 75
    local minZoom = 15  -- Gear 1 max zoom
    local maxZoom = 75  -- Gear 101 max zoom
    local gearProgress = math.min((gearLevel - 1) / 100, 1) -- 0 to 1 scale for gears 1-101
    return minZoom + (gearProgress * (maxZoom - minZoom))
end

-- State tracking
local currentZoomDistance = BASE_ZOOM_DISTANCE
local shakeOffset = Vector3.new(0, 0, 0)
local originalCameraType = nil
local connections = {}

function CameraEffects.setupCamera()
    -- Store original camera type
    originalCameraType = camera.CameraType
    
    -- Keep camera as Follow but modify the subject distance
    camera.CameraType = Enum.CameraType.Follow
    
    -- Start the camera update loop
    CameraEffects.startCameraLoop()
end

function CameraEffects.startCameraLoop()
    -- Clean up any existing connection
    if connections.cameraUpdate then
        connections.cameraUpdate:Disconnect()
    end
    
    connections.cameraUpdate = RunService.Heartbeat:Connect(function()
        CameraEffects.updateCamera()
    end)
end

function CameraEffects.updateCamera()
    if not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Calculate current speed
    local velocity = rootPart.Velocity
    local currentSpeed = math.sqrt(velocity.X^2 + velocity.Z^2)
    
    -- Get max speed and gear level from leaderstats
    local maxSpeed = 16 -- Default
    local gearLevel = 1 -- Default
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("SpeedLevel") then
        gearLevel = leaderstats.SpeedLevel.Value
        maxSpeed = 16 + ((gearLevel - 1) * 4)
    end
    
    -- Get the maximum zoom distance for this gear level
    local maxZoomForThisGear = getMaxZoomForGear(gearLevel)
    
    -- Calculate speed percentage (more aggressive scaling)
    local speedPercent = math.min(currentSpeed / maxSpeed, 1)
    speedPercent = speedPercent * speedPercent -- Square it for more dramatic zoom at higher speeds
    
    -- Apply zoom to camera distance based on gear-specific max zoom
    local zoomAmount = speedPercent * (maxZoomForThisGear - BASE_ZOOM_DISTANCE)
    humanoid.CameraOffset = Vector3.new(0, 0, zoomAmount)
    
    -- Screen shake at high speeds (80%+ of max speed)
    if speedPercent >= 0.64 then -- 0.8^2 = 0.64 (since we squared speedPercent)
        local shakePercent = (speedPercent - 0.64) / 0.36 -- 0 to 1 scale above 80%
        local shakeAmount = shakePercent * SHAKE_INTENSITY
        
        -- Create oscillating shake offset
        local time = tick() * SHAKE_FREQUENCY
        local shakeOffset = Vector3.new(
            math.sin(time) * shakeAmount,
            math.sin(time * 1.3) * shakeAmount * 0.7,
            0 -- No Z shake for CameraOffset
        )
        
        -- Apply shake to camera offset
        humanoid.CameraOffset = humanoid.CameraOffset + shakeOffset
    end
end

function CameraEffects.cleanup()
    -- Restore original camera type
    if originalCameraType then
        camera.CameraType = originalCameraType
    end
    
    -- Disconnect all connections
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    connections = {}
end

-- Handle player respawning
local function onCharacterAdded(character)
    -- Wait a moment for character to load
    wait(1)
    CameraEffects.setupCamera()
end

local function onCharacterRemoving()
    CameraEffects.cleanup()
end

-- Connect events
player.CharacterAdded:Connect(onCharacterAdded)
player.CharacterRemoving:Connect(onCharacterRemoving)

-- Setup camera if character already exists
if player.Character then
    onCharacterAdded(player.Character)
end

-- Cleanup when script is removed
game:GetService("Players").PlayerRemoving:Connect(function(removingPlayer)
    if removingPlayer == player then
        CameraEffects.cleanup()
    end
end)

return CameraEffects