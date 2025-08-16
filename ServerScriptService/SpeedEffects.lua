local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local TrailManager = require(script.Parent.TrailManager)

local SpeedEffects = {}

local playerEffects = {}

function SpeedEffects.createSpeedTrail(character, player)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    -- Get player's equipped trail info
    local trailInfo = TrailManager.getEquippedTrailInfo(player)
    
    -- Create attachments for ground fire trail
    local attachment0 = Instance.new("Attachment")
    attachment0.Name = "SpeedTrailAttachment0"
    attachment0.Position = Vector3.new(-0.5, -2.9, 0) -- Ground level, left side
    attachment0.Parent = rootPart
    
    local attachment1 = Instance.new("Attachment")
    attachment1.Name = "SpeedTrailAttachment1"
    attachment1.Position = Vector3.new(0.5, -2.9, 0) -- Ground level, right side
    attachment1.Parent = rootPart
    
    -- Create continuous ground fire trail
    local trail = Instance.new("Trail")
    trail.Name = "SpeedTrail"
    trail.Attachment0 = attachment0
    trail.Attachment1 = attachment1
    trail.Lifetime = 2.0 -- Much longer lasting ground fire
    trail.MinLength = 2 -- Minimum segment length to prevent gaps
    trail.LightEmission = 1 -- Full glow like fire
    trail.LightInfluence = 0 -- Ignore environmental lighting
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),  -- Very visible fire
        NumberSequenceKeypoint.new(0.4, 0.3), -- Stay bright
        NumberSequenceKeypoint.new(0.8, 0.7), -- Fade to embers
        NumberSequenceKeypoint.new(1, 1)     -- Disappear
    })
    
    -- Use trail colors from TrailManager
    trail.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, trailInfo.color1),   -- Primary color
        ColorSequenceKeypoint.new(0.5, trailInfo.color2), -- Secondary color
        ColorSequenceKeypoint.new(1, trailInfo.color2:lerp(Color3.fromRGB(0, 0, 0), 0.5)) -- Darker fade
    })
    
    trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.0),   -- Consistent width
        NumberSequenceKeypoint.new(1, 0.8)    -- Slight taper to embers
    })
    trail.Enabled = false
    trail.Parent = rootPart
    
    return trail
end

function SpeedEffects.createBackTrail(character, player)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    -- Get player's equipped trail info
    local trailInfo = TrailManager.getEquippedTrailInfo(player)
    
    -- Create attachments for back trail (wrapping around behind the character)
    local backAttachment0 = Instance.new("Attachment")
    backAttachment0.Name = "BackTrailAttachment0"
    backAttachment0.Position = Vector3.new(0, -1, -1) -- Front of character
    backAttachment0.Parent = rootPart
    
    local backAttachment1 = Instance.new("Attachment")
    backAttachment1.Name = "BackTrailAttachment1"
    backAttachment1.Position = Vector3.new(0, -1, 3) -- Behind character
    backAttachment1.Parent = rootPart
    
    -- Create back trail
    local backTrail = Instance.new("Trail")
    backTrail.Name = "BackTrail"
    backTrail.Attachment0 = backAttachment0
    backTrail.Attachment1 = backAttachment1
    backTrail.Lifetime = 1.8 -- Slightly shorter than ground trail
    backTrail.MinLength = 1.5
    backTrail.LightEmission = 1
    backTrail.LightInfluence = 0
    backTrail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),  -- Start slightly more transparent
        NumberSequenceKeypoint.new(0.5, 0.4),
        NumberSequenceKeypoint.new(0.8, 0.8),
        NumberSequenceKeypoint.new(1, 1)
    })
    
    -- Use same colors as ground trail
    backTrail.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, trailInfo.color1),
        ColorSequenceKeypoint.new(0.5, trailInfo.color2),
        ColorSequenceKeypoint.new(1, trailInfo.color2:lerp(Color3.fromRGB(0, 0, 0), 0.5))
    })
    
    backTrail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),   -- Slightly narrower than ground trail
        NumberSequenceKeypoint.new(1, 0.6)
    })
    backTrail.Enabled = false
    backTrail.Parent = rootPart
    
    return backTrail
end

function SpeedEffects.createSpeedParticles(character, player)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    -- Get player's equipped trail info
    local trailInfo = TrailManager.getEquippedTrailInfo(player)
    
    -- Create attachment for particles
    local attachment = Instance.new("Attachment")
    attachment.Name = "SpeedParticleAttachment"
    attachment.Position = Vector3.new(0, -1, 0)
    attachment.Parent = rootPart
    
    -- Create particles based on trail type
    local particles = Instance.new("ParticleEmitter")
    particles.Name = "SpeedParticles"
    
    if trailInfo.particle == "Sparkles" then
        particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    else
        particles.Texture = "rbxasset://textures/particles/fire_main.dds" -- Use fire texture for most trails
    end
    
    particles.Lifetime = NumberRange.new(0.4, 0.8)
    particles.Rate = 25 -- Fewer particles
    particles.SpreadAngle = Vector2.new(30, 15) -- More directional
    particles.Speed = NumberRange.new(10, 20) -- Slower, more realistic
    particles.Acceleration = Vector3.new(0, -5, 0) -- Gentle fall
    
    -- Use trail colors for particles
    particles.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, trailInfo.color1),
        ColorSequenceKeypoint.new(1, trailInfo.color2)
    })
    
    particles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6), -- Start quite transparent
        NumberSequenceKeypoint.new(0.7, 0.9),
        NumberSequenceKeypoint.new(1, 1)
    })
    particles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3), -- Smaller particles
        NumberSequenceKeypoint.new(0.5, 0.8),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    particles.Enabled = false
    particles.Parent = attachment
    
    return particles
end

function SpeedEffects.createSmokeTrail(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    -- Create attachment for smoke trail behind player
    local attachment = Instance.new("Attachment")
    attachment.Name = "SmokeTrailAttachment"
    attachment.Position = Vector3.new(0, -1, 2) -- Behind the player
    attachment.Parent = rootPart
    
    -- Create smoke trail particle effect
    local smokeTrail = Instance.new("ParticleEmitter")
    smokeTrail.Name = "SmokeTrail"
    smokeTrail.Texture = "rbxasset://textures/particles/smoke_main.dds"
    smokeTrail.Lifetime = NumberRange.new(1.0, 1.5)
    smokeTrail.Rate = 30
    smokeTrail.SpreadAngle = Vector2.new(20, 20)
    smokeTrail.Speed = NumberRange.new(2, 5)
    smokeTrail.Acceleration = Vector3.new(0, 3, 0) -- Slightly upward
    
    -- White/gray smoke that fades out
    smokeTrail.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)), -- Light gray
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 150, 150)), -- Medium gray
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))   -- Dark gray
    })
    
    smokeTrail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),  -- Start visible
        NumberSequenceKeypoint.new(0.7, 0.8), -- Fade out
        NumberSequenceKeypoint.new(1, 1)     -- Completely transparent
    })
    
    smokeTrail.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),    -- Start small
        NumberSequenceKeypoint.new(0.5, 2),  -- Grow bigger
        NumberSequenceKeypoint.new(1, 3)     -- End big
    })
    
    smokeTrail.Enabled = false
    smokeTrail.Parent = attachment
    
    return smokeTrail
end

function SpeedEffects.createSpeedBoostSound(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    local speedSound = Instance.new("Sound")
    speedSound.Name = "SpeedBoostSound"
    speedSound.SoundId = "rbxasset://sounds/electronicpingshort.wav" -- Placeholder
    speedSound.Volume = 0.3
    speedSound.Pitch = 1.5
    speedSound.Looped = true
    speedSound.Parent = rootPart
    
    return speedSound
end

function SpeedEffects.setupPlayerEffects(player)
    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        -- Create all speed effects (removed sound and particles)
        local effects = {
            trail = SpeedEffects.createSpeedTrail(character, player),
            backTrail = SpeedEffects.createBackTrail(character, player),
            -- particles = SpeedEffects.createSpeedParticles(character, player), -- Disabled
            -- smokeTrail = SpeedEffects.createSmokeTrail(character), -- Disabled
            isActive = false,
            lastSpeed = 0
        }
        
        playerEffects[player] = effects
        
        -- Start effect monitoring
        SpeedEffects.startEffectLoop(player)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    player.CharacterRemoving:Connect(function()
        if playerEffects[player] then
            SpeedEffects.stopAllEffects(player)
            playerEffects[player] = nil
        end
    end)
end

function SpeedEffects.startEffectLoop(player)
    local effects = playerEffects[player]
    if not effects then return end
    
    -- Disconnect any existing connection
    if effects.effectConnection then
        effects.effectConnection:Disconnect()
    end
    
    effects.effectConnection = RunService.Heartbeat:Connect(function()
        SpeedEffects.updatePlayerEffects(player)
    end)
end

function SpeedEffects.updatePlayerEffects(player)
    local effects = playerEffects[player]
    if not effects or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Get player's current speed
    local velocity = rootPart.Velocity
    local currentSpeed = math.sqrt(velocity.X^2 + velocity.Z^2)
    
    -- Get max speed from leaderstats + trail boost
    local maxSpeed = 16 -- Default
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("SpeedLevel") then
        local speedLevel = leaderstats.SpeedLevel.Value
        maxSpeed = 16 + ((speedLevel - 1) * 4)
    end
    
    -- Trail system now provides coin multipliers instead of speed boosts
    
    -- Calculate speed percentage - lower threshold for higher gears
    local speedPercent = currentSpeed / maxSpeed
    -- Use 60% threshold for gear 1, scaling down to 40% for higher gears
    local speedLevel = 1
    if leaderstats and leaderstats:FindFirstChild("SpeedLevel") then
        speedLevel = leaderstats.SpeedLevel.Value
    end
    
    local threshold = math.max(0.4, 0.8 - (speedLevel - 1) * 0.05) -- 80% down to 40%
    local shouldActivate = speedPercent >= threshold and currentSpeed > 8
    
    if shouldActivate and not effects.isActive then
        -- Activate speed boost effects
        SpeedEffects.activateEffects(player)
    elseif not shouldActivate and effects.isActive then
        -- Deactivate speed boost effects
        SpeedEffects.deactivateEffects(player)
    end
    
    -- Update effect intensity based on speed
    if effects.isActive then
        local threshold = math.max(0.4, 0.8 - (speedLevel - 1) * 0.05)
        SpeedEffects.updateEffectIntensity(player, speedPercent, threshold)
    end
    
    effects.lastSpeed = currentSpeed
end

function SpeedEffects.activateEffects(player)
    local effects = playerEffects[player]
    if not effects then return end
    
    effects.isActive = true
    
    -- Enable trail
    if effects.trail then
        effects.trail.Enabled = true
    end
    
    -- Enable back trail
    if effects.backTrail then
        effects.backTrail.Enabled = true
    end
    
    -- Enable particles
    if effects.particles then
        effects.particles.Enabled = true
    end
    
    -- Enable smoke trail
    if effects.smokeTrail then
        effects.smokeTrail.Enabled = true
    end
    
    print(player.Name .. " activated speed boost effects!")
end

function SpeedEffects.deactivateEffects(player)
    local effects = playerEffects[player]
    if not effects then return end
    
    effects.isActive = false
    
    -- Disable trail
    if effects.trail then
        effects.trail.Enabled = false
    end
    
    -- Disable back trail
    if effects.backTrail then
        effects.backTrail.Enabled = false
    end
    
    -- Disable particles
    if effects.particles then
        effects.particles.Enabled = false
    end
    
    -- Disable smoke trail
    if effects.smokeTrail then
        effects.smokeTrail.Enabled = false
    end
end

function SpeedEffects.updateEffectIntensity(player, speedPercent, threshold)
    local effects = playerEffects[player]
    if not effects then return end
    
    -- Scale effects based on speed percentage above threshold
    local remainingRange = 1.0 - threshold
    local intensity = math.min((speedPercent - threshold) / remainingRange, 1) -- 0 to 1 scale
    
    -- Update particle rate
    if effects.particles then
        effects.particles.Rate = 50 + (intensity * 100) -- 50 to 150 particles
    end
    
    -- Update smoke trail intensity
    if effects.smokeTrail then
        effects.smokeTrail.Rate = 30 + (intensity * 50) -- 30 to 80 smoke particles
    end
end

function SpeedEffects.updateTrailColors(player)
    local effects = playerEffects[player]
    if not effects or not player.Character then return end
    
    local trailInfo = TrailManager.getEquippedTrailInfo(player)
    
    -- Update trail colors
    if effects.trail then
        effects.trail.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, trailInfo.color1),   -- Primary color
            ColorSequenceKeypoint.new(0.5, trailInfo.color2), -- Secondary color
            ColorSequenceKeypoint.new(1, trailInfo.color2:lerp(Color3.fromRGB(0, 0, 0), 0.5)) -- Darker fade
        })
    end
    
    -- Update back trail colors
    if effects.backTrail then
        effects.backTrail.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, trailInfo.color1),
            ColorSequenceKeypoint.new(0.5, trailInfo.color2),
            ColorSequenceKeypoint.new(1, trailInfo.color2:lerp(Color3.fromRGB(0, 0, 0), 0.5))
        })
    end
    
    -- Update particle colors
    if effects.particles then
        effects.particles.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, trailInfo.color1),
            ColorSequenceKeypoint.new(1, trailInfo.color2)
        })
        
        -- Update particle texture based on trail type
        if trailInfo.particle == "Sparkles" then
            effects.particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        else
            effects.particles.Texture = "rbxasset://textures/particles/fire_main.dds"
        end
    end
    
    print("SpeedEffects: Updated trail colors for", player.Name, "to", trailInfo.color1, trailInfo.color2)
end

function SpeedEffects.stopAllEffects(player)
    local effects = playerEffects[player]
    if not effects then return end
    
    -- Disconnect update loop
    if effects.effectConnection then
        effects.effectConnection:Disconnect()
    end
    
    -- Clean up effects
    SpeedEffects.deactivateEffects(player)
end

function SpeedEffects.onPlayerAdded(player)
    SpeedEffects.setupPlayerEffects(player)
end

function SpeedEffects.start()
    Players.PlayerAdded:Connect(SpeedEffects.onPlayerAdded)
    
    for _, player in pairs(Players:GetPlayers()) do
        SpeedEffects.onPlayerAdded(player)
    end
    
    print("Speed Effects system started!")
end

return SpeedEffects