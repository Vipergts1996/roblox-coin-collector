    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UpgradeButtons"
    screenGui.Parent = playerGui

    -- Realistic tachometer at bottom right of screen - now properly scaling
    local speedometer = Instance.new("Frame")
    speedometer.Name = "Speedometer"
    speedometer.Size = UDim2.new(0.25, 0, 0.25, 0) -- 25% of screen width and height
    speedometer.Position = UDim2.new(0.98, 0, 0.98, 0) -- Bottom right corner
    speedometer.AnchorPoint = Vector2.new(1, 1) -- Anchor to bottom right
    speedometer.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Dark metallic outer ring
    speedometer.BorderSizePixel = 0 -- Remove fixed border
    speedometer.BorderColor3 = Color3.fromRGB(100, 100, 100) -- Metallic silver border
    speedometer.Parent = screenGui
    
    -- Add UIAspectRatioConstraint like trail shop close button
    local speedometerAspect = Instance.new("UIAspectRatioConstraint")
    speedometerAspect.AspectRatio = 1.0 -- Perfect square
    speedometerAspect.Parent = speedometer
    
    -- Add size constraint to prevent speedometer from being too small on mobile
    local speedometerSizeConstraint = Instance.new("UISizeConstraint")
    speedometerSizeConstraint.MinSize = Vector2.new(150, 150) -- Minimum readable size
    speedometerSizeConstraint.MaxSize = Vector2.new(400, 400) -- Maximum size for large screens
    speedometerSizeConstraint.Parent = speedometer

    local speedometerCorner = Instance.new("UICorner")
    speedometerCorner.CornerRadius = UDim.new(0.5, 0)
    speedometerCorner.Parent = speedometer

    -- Middle bezel ring
    local speedometerBezel = Instance.new("Frame")
    speedometerBezel.Size = UDim2.new(0.94, 0, 0.94, 0)
    speedometerBezel.Position = UDim2.new(0.03, 0, 0.03, 0)
    speedometerBezel.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Darker bezel
    speedometerBezel.BorderSizePixel = 0
    speedometerBezel.Parent = speedometer

    local speedometerBezelCorner = Instance.new("UICorner")
    speedometerBezelCorner.CornerRadius = UDim.new(0.5, 0)
    speedometerBezelCorner.Parent = speedometerBezel

    -- Inner speedometer face (clean white)
    local speedometerInner = Instance.new("Frame")
    speedometerInner.Size = UDim2.new(0.88, 0, 0.88, 0)
    speedometerInner.Position = UDim2.new(0.06, 0, 0.06, 0)
    speedometerInner.BackgroundColor3 = Color3.fromRGB(250, 250, 250) -- Clean white face
    speedometerInner.BorderSizePixel = 1
    speedometerInner.BorderColor3 = Color3.fromRGB(180, 180, 180)
    speedometerInner.Parent = speedometerBezel

    local speedometerInnerCorner = Instance.new("UICorner")
    speedometerInnerCorner.CornerRadius = UDim.new(0.5, 0)
    speedometerInnerCorner.Parent = speedometerInner

    -- Dynamic tachometer numbers that scale with gear level
    local speedNumbers = {}
    local currentMaxSpeed = 90

    local function createSpeedNumbers(maxSpeed, minSpeed)
        minSpeed = minSpeed or 0 -- Default to 0 if not provided
        
        -- Clear existing numbers
        for _, numberLabel in pairs(speedNumbers) do
            if numberLabel and numberLabel.Parent then
                numberLabel:Destroy()
            end
        end
        speedNumbers = {}
        
        -- Create new numbers based on speed range
        local speedRange = maxSpeed - minSpeed
        for i = 0, 9 do
            local speedValue = minSpeed + (i / 9) * speedRange
            local numberLabel = Instance.new("TextLabel")
            numberLabel.Size = UDim2.new(0.12, 0, 0.12, 0) -- 12% of speedometer size
            numberLabel.BackgroundTransparency = 1
            numberLabel.Text = tostring(math.floor(speedValue))
            numberLabel.TextColor3 = Color3.fromRGB(30, 30, 30)
            numberLabel.TextScaled = true
            numberLabel.Font = Enum.Font.GothamBold
            numberLabel.TextStrokeTransparency = 0.9
            numberLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            numberLabel.Parent = speedometerInner
            
            -- Position numbers around the circle with proper anchoring
            local numberAngle = math.rad(i * 30 - 230)
            local radius = 0.35
            local x = 0.5 + math.cos(numberAngle) * radius
            local y = 0.5 + math.sin(numberAngle) * radius
            numberLabel.Position = UDim2.new(x, 0, y, 0)
            numberLabel.AnchorPoint = Vector2.new(0.5, 0.5) -- Center the labels
            
            table.insert(speedNumbers, numberLabel)
        end
    end

    -- Create clean tick marks that don't overlap numbers
    for i = 0, 9 do
        local numberAngle = math.rad(i * 30 - 230)
        
        -- Major tick marks - now scaling properly
        local majorTick = Instance.new("Frame")
        majorTick.Size = UDim2.new(0.01, 0, 0.04, 0) -- 1% width, 4% height of speedometer
        majorTick.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        majorTick.BorderSizePixel = 0
        majorTick.AnchorPoint = Vector2.new(0.5, 1)
        majorTick.Parent = speedometerInner
        
        -- Position closer to edge, away from numbers
        local tickRadius = 0.48
        local tickX = 0.5 + math.cos(numberAngle) * tickRadius
        local tickY = 0.5 + math.sin(numberAngle) * tickRadius
        majorTick.Position = UDim2.new(tickX, 0, tickY, 0)
        majorTick.Rotation = math.deg(numberAngle) + 90
        
        -- Minor tick marks between major ones
        if i < 9 then
            for j = 1, 2 do
                local minorAngle = math.rad(i * 30 + j * 10 - 230)
                
                local minorTick = Instance.new("Frame")
                minorTick.Size = UDim2.new(0.005, 0, 0.02, 0) -- 0.5% width, 2% height of speedometer
                minorTick.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                minorTick.BorderSizePixel = 0
                minorTick.AnchorPoint = Vector2.new(0.5, 1)
                minorTick.Parent = speedometerInner
                
                local minorTickRadius = 0.47
                local minorTickX = 0.5 + math.cos(minorAngle) * minorTickRadius
                local minorTickY = 0.5 + math.sin(minorAngle) * minorTickRadius
                minorTick.Position = UDim2.new(minorTickX, 0, minorTickY, 0)
                minorTick.Rotation = math.deg(minorAngle) + 90
            end
        end
    end

    -- Initialize with starting numbers
    createSpeedNumbers(90)

    -- Realistic speed needle - now scaling properly with correct length
    local needle = Instance.new("Frame")
    needle.Name = "SpeedNeedle"
    needle.Size = UDim2.new(0.015, 0, 0.45, 0) -- Proper width and shorter: 1.5% width, 45% height
    needle.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center position
    needle.BackgroundTransparency = 1
    needle.BorderSizePixel = 0
    needle.AnchorPoint = Vector2.new(0.5, 0.5)
    needle.ZIndex = 3
    needle.Rotation = -320 -- Starting angle
    needle.Parent = speedometerInner

    -- White pointing side (entire half that reads the numbers)
    local needleWhiteSide = Instance.new("Frame")
    needleWhiteSide.Size = UDim2.new(1, 0, 0.6, 0) -- Large white pointing section
    needleWhiteSide.Position = UDim2.new(0, 0, 0, 0)
    needleWhiteSide.BackgroundColor3 = Color3.fromRGB(250, 250, 250) -- Match gauge face exactly
    needleWhiteSide.BorderSizePixel = 0
    needleWhiteSide.Parent = needle

    -- Needle shaft (small dark center section)
    local needleShaft = Instance.new("Frame")
    needleShaft.Size = UDim2.new(1, 0, 0.25, 0) -- Smaller center section
    needleShaft.Position = UDim2.new(0, 0, 0.6, 0)
    needleShaft.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Dark metallic
    needleShaft.BorderSizePixel = 0
    needleShaft.Parent = needle

    -- Needle base (red back section)
    local needleBase = Instance.new("Frame")
    needleBase.Size = UDim2.new(1, 0, 0.15, 0)
    needleBase.Position = UDim2.new(0, 0, 0.85, 0)
    needleBase.BackgroundColor3 = Color3.fromRGB(220, 50, 50) -- Red base
    needleBase.BorderSizePixel = 0
    needleBase.Parent = needle

    -- Realistic center hub - now scaling properly
    local centerHub = Instance.new("Frame")
    centerHub.Size = UDim2.new(0.08, 0, 0.08, 0) -- 8% of speedometer size
    centerHub.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center position
    centerHub.AnchorPoint = Vector2.new(0.5, 0.5) -- Perfect center
    centerHub.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Metallic center
    centerHub.BorderSizePixel = 0 -- Remove fixed border
    centerHub.BorderColor3 = Color3.fromRGB(120, 120, 120)
    centerHub.ZIndex = 4
    centerHub.Parent = speedometerInner

    local centerHubCorner = Instance.new("UICorner")
    centerHubCorner.CornerRadius = UDim.new(0.5, 0)
    centerHubCorner.Parent = centerHub

    -- Inner center dot - now scaling properly
    local centerDot = Instance.new("Frame")
    centerDot.Size = UDim2.new(0.04, 0, 0.04, 0) -- 4% of speedometer size
    centerDot.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center position
    centerDot.AnchorPoint = Vector2.new(0.5, 0.5) -- Perfect center
    centerDot.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    centerDot.BorderSizePixel = 0
    centerDot.ZIndex = 5
    centerDot.Parent = speedometerInner

    local centerDotCorner = Instance.new("UICorner")
    centerDotCorner.CornerRadius = UDim.new(0.5, 0)
    centerDotCorner.Parent = centerDot


    -- Gear display - now scaling properly and shifted right to avoid number overlap
    local gearFrame = Instance.new("Frame")
    gearFrame.Size = UDim2.new(0.35, 0, 0.2, 0) -- 35% width, 20% height of speedometer
    gearFrame.Position = UDim2.new(0.52, 0, 0.7, 0) -- Shifted 2% right from center
    gearFrame.AnchorPoint = Vector2.new(0.5, 0) -- Center horizontally
    gearFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    gearFrame.BorderSizePixel = 0 -- Remove fixed border
    gearFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
    gearFrame.Parent = speedometerInner

    local gearCorner = Instance.new("UICorner")
    gearCorner.CornerRadius = UDim.new(0.1, 0) -- 10% radius for proportional corners
    gearCorner.Parent = gearFrame

    -- Gear label
    local gearLabel = Instance.new("TextLabel")
    gearLabel.Size = UDim2.new(1, 0, 0.3, 0)
    gearLabel.Position = UDim2.new(0, 0, 0, 0)
    gearLabel.BackgroundTransparency = 1
    gearLabel.Text = "GEAR"
    gearLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    gearLabel.TextScaled = true
    gearLabel.Font = Enum.Font.Gotham
    gearLabel.Parent = gearFrame

    -- Gear number display
    local gearNumber = Instance.new("TextLabel")
    gearNumber.Name = "GearNumber"
    gearNumber.Size = UDim2.new(1, 0, 0.7, 0)
    gearNumber.Position = UDim2.new(0, 0, 0.3, 0)
    gearNumber.BackgroundTransparency = 1
    gearNumber.Text = "1"
    gearNumber.TextColor3 = Color3.fromRGB(0, 255, 0)
    gearNumber.TextScaled = true
    gearNumber.Font = Enum.Font.Code
    gearNumber.Parent = gearFrame

    -- Nitro Bar - positioned above speedometer
    local nitroBarFrame = Instance.new("Frame")
    nitroBarFrame.Name = "NitroBarFrame"
    nitroBarFrame.Size = UDim2.new(0.3, 0, 0.05, 0) -- 30% width, 5% height
    nitroBarFrame.Position = UDim2.new(0.98, 0, 0.68, 0) -- Above speedometer
    nitroBarFrame.AnchorPoint = Vector2.new(1, 1)
    nitroBarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Dark background
    nitroBarFrame.BorderSizePixel = 0
    nitroBarFrame.Parent = screenGui
    
    local nitroBarCorner = Instance.new("UICorner")
    nitroBarCorner.CornerRadius = UDim.new(0.2, 0)
    nitroBarCorner.Parent = nitroBarFrame
    
    local nitroBarBorder = Instance.new("UIStroke")
    nitroBarBorder.Thickness = 2
    nitroBarBorder.Color = Color3.fromRGB(100, 100, 100)
    nitroBarBorder.Parent = nitroBarFrame
    
    -- Nitro fill bar
    local nitroFillBar = Instance.new("Frame")
    nitroFillBar.Name = "NitroFill"
    nitroFillBar.Size = UDim2.new(1, 0, 1, 0) -- Start full
    nitroFillBar.Position = UDim2.new(0, 0, 0, 0)
    nitroFillBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue nitro color
    nitroFillBar.BorderSizePixel = 0
    nitroFillBar.Parent = nitroBarFrame
    
    local nitroFillCorner = Instance.new("UICorner")
    nitroFillCorner.CornerRadius = UDim.new(0.2, 0)
    nitroFillCorner.Parent = nitroFillBar
    
    -- Nitro label
    local nitroLabel = Instance.new("TextLabel")
    nitroLabel.Size = UDim2.new(1, 0, 1, 0)
    nitroLabel.Position = UDim2.new(0, 0, 0, 0)
    nitroLabel.BackgroundTransparency = 1
    nitroLabel.Text = "NITRO"
    nitroLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nitroLabel.TextScaled = true
    nitroLabel.Font = Enum.Font.GothamBold
    nitroLabel.ZIndex = 2
    nitroLabel.Parent = nitroBarFrame
    
    -- Nitro instruction label
    local nitroInstructionLabel = Instance.new("TextLabel")
    nitroInstructionLabel.Size = UDim2.new(0.25, 0, 0.03, 0)
    nitroInstructionLabel.Position = UDim2.new(0.98, 0, 0.63, 0)
    nitroInstructionLabel.AnchorPoint = Vector2.new(1, 1)
    nitroInstructionLabel.BackgroundTransparency = 1
    nitroInstructionLabel.Text = "Hold SHIFT to boost"
    nitroInstructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    nitroInstructionLabel.TextScaled = true
    nitroInstructionLabel.Font = Enum.Font.Gotham
    nitroInstructionLabel.Parent = screenGui

    -- Speed Upgrade Button - now properly scaling and closer together
    local speedButton = Instance.new("TextButton")
    speedButton.Name = "SpeedButton"
    speedButton.Size = UDim2.new(0.18, 0, 0.08, 0) -- 18% width, 8% height like trail shop
    speedButton.Position = UDim2.new(0.4, 0, 0.92, 0) -- Moved closer to center
    speedButton.AnchorPoint = Vector2.new(0.5, 1) -- Center anchor like trail shop
    speedButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    speedButton.BorderSizePixel = 0
    speedButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    speedButton.TextScaled = true
    speedButton.Font = Enum.Font.FredokaOne
    speedButton.ZIndex = 1
    speedButton.Parent = screenGui

    -- Speed button text label (separate from button)
    local speedText = Instance.new("TextLabel")
    speedText.Size = UDim2.new(1, 0, 1, 0)
    speedText.Position = UDim2.new(0, 0, 0, 0)
    speedText.BackgroundTransparency = 1
    speedText.Text = "Speed Lv1\n10 Coins"
    speedText.TextColor3 = Color3.fromRGB(0, 0, 0)
    speedText.TextScaled = true
    speedText.Font = Enum.Font.FredokaOne
    speedText.ZIndex = 3
    speedText.Parent = speedButton
    speedButton.Text = ""

    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedButton

    -- Speed button fill bar
    local speedFill = Instance.new("Frame")
    speedFill.Name = "FillBar"
    speedFill.Size = UDim2.new(1, 0, 0, 0)
    speedFill.Position = UDim2.new(0, 0, 1, 0)
    speedFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    speedFill.BackgroundTransparency = 0.3
    speedFill.BorderSizePixel = 0
    speedFill.ZIndex = 2
    speedFill.Parent = speedButton

    local speedFillCorner = Instance.new("UICorner")
    speedFillCorner.CornerRadius = UDim.new(0, 8)
    speedFillCorner.Parent = speedFill

    -- Jump Upgrade Button - now properly scaling and closer together
    local jumpButton = Instance.new("TextButton")
    jumpButton.Name = "JumpButton"
    jumpButton.Size = UDim2.new(0.18, 0, 0.08, 0) -- 18% width, 8% height like trail shop
    jumpButton.Position = UDim2.new(0.6, 0, 0.92, 0) -- Moved closer to center
    jumpButton.AnchorPoint = Vector2.new(0.5, 1) -- Center anchor like trail shop
    jumpButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    jumpButton.BorderSizePixel = 0
    jumpButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    jumpButton.TextScaled = true
    jumpButton.Font = Enum.Font.FredokaOne
    jumpButton.ZIndex = 1
    jumpButton.Parent = screenGui

    -- Jump button text label (separate from button)
    local jumpText = Instance.new("TextLabel")
    jumpText.Size = UDim2.new(1, 0, 1, 0)
    jumpText.Position = UDim2.new(0, 0, 0, 0)
    jumpText.BackgroundTransparency = 1
    jumpText.Text = "Jump Lv1\n15 Coins"
    jumpText.TextColor3 = Color3.fromRGB(0, 0, 0)
    jumpText.TextScaled = true
    jumpText.Font = Enum.Font.FredokaOne
    jumpText.ZIndex = 3
    jumpText.Parent = jumpButton
    jumpButton.Text = ""

    -- NOW start the speedometer update loop (after all GUI is created)
    spawn(function()
        while true do
            wait(0.1) -- Update 10 times per second
            
            -- Update speedometer
            local actualSpeed = 0
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local velocity = rootPart.Velocity
                actualSpeed = math.sqrt(velocity.X^2 + velocity.Z^2)
                
                -- Round to avoid tiny fluctuations
                if actualSpeed < 0.5 then
                    actualSpeed = 0
                end
            end
            
            -- Get current gear level to determine tachometer scale
            local gearLevel = 1
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats and leaderstats:FindFirstChild("SpeedLevel") then
                gearLevel = leaderstats.SpeedLevel.Value
            end
            
            -- Calculate tachometer range based on gear level
            local playerMaxSpeed = 16 + ((gearLevel - 1) * 4) -- Player's actual max speed
            
            -- Every 20 gears, increase the minimum speed (first tick)
            local gearTier = math.floor((gearLevel - 1) / 20)
            local minDisplaySpeed = gearTier * playerMaxSpeed * 0.3 -- 30% of max speed as minimum
            minDisplaySpeed = math.floor(minDisplaySpeed / 10) * 10 -- Round down to nearest 10
            
            local maxDisplaySpeed = math.max(90, math.ceil(playerMaxSpeed / 10) * 10) -- Round up to nearest 10
            local speedRange = maxDisplaySpeed - minDisplaySpeed
            
            -- Update tachometer numbers if range changed
            if maxDisplaySpeed ~= currentMaxSpeed then
                currentMaxSpeed = maxDisplaySpeed
                createSpeedNumbers(maxDisplaySpeed, minDisplaySpeed)
            end
            
            -- Map actual speed to current gauge scale (considering minimum)
            local adjustedSpeed = math.max(0, actualSpeed - minDisplaySpeed)
            local speedProgress = math.min(adjustedSpeed / speedRange, 1)
            
            -- Calculate needle angle to match the current gauge numbers
            local startAngle = -320  -- Same starting position
            local sweepRange = 270   -- Same sweep range
            local needleAngle = startAngle + (speedProgress * sweepRange)
            
            -- Update needle with smooth tween animation
            local speedNeedle = speedometerInner:FindFirstChild("SpeedNeedle")
            if speedNeedle then
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local rotateTween = TweenService:Create(speedNeedle, tweenInfo, {Rotation = needleAngle})
                rotateTween:Play()
            end
        end
    end)

    -- Nitro system setup
    local nitroRemoteEvents = {
        useNitro = nil,
        nitroUpdate = nil
    }
    
    -- Function to safely get nitro remote events
    local function getNitroRemoteEvent(name)
        return ReplicatedStorage:FindFirstChild(name)
    end
    
    -- Function to update nitro bar display
    local function updateNitroBar(currentNitro, maxNitro, isActive)
        local nitroFill = nitroBarFrame:FindFirstChild("NitroFill")
        if not nitroFill then return end
        
        local fillPercentage = currentNitro / maxNitro
        local targetSize = UDim2.new(fillPercentage, 0, 1, 0)
        
        -- Change color based on state
        if isActive then
            nitroFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow when active
        elseif fillPercentage >= 1 then
            nitroFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green when full
        else
            nitroFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Blue when refilling
        end
        
        -- Smooth tween to new size
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local sizeTween = TweenService:Create(nitroFill, tweenInfo, {Size = targetSize})
        sizeTween:Play()
    end
    
    -- Input handling for nitro - hold to use
    local isShiftPressed = false
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if (input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift) and not isShiftPressed then
            isShiftPressed = true
            local startNitroEvent = getNitroRemoteEvent("StartNitro")
            if startNitroEvent then
                startNitroEvent:FireServer()
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
            isShiftPressed = false
            local stopNitroEvent = getNitroRemoteEvent("StopNitro")
            if stopNitroEvent then
                stopNitroEvent:FireServer()
            end
        end
    end)
    
    -- Listen for nitro updates from server
    spawn(function()
        local nitroUpdateEvent = ReplicatedStorage:WaitForChild("NitroUpdate", 10)
        if nitroUpdateEvent then
            nitroUpdateEvent.OnClientEvent:Connect(function(currentNitro, maxNitro, isActive)
                updateNitroBar(currentNitro, maxNitro, isActive)
            end)
        end
    end)
    
    -- Fire effect functions for speedometer
    local function addSpeedometerFireEffect()
        -- Add fire particles around the speedometer
        if speedometer then
            -- Create attachment points around the speedometer for fire particles
            local attachmentPositions = {
                {0.2, 0.2}, {0.8, 0.2}, {0.2, 0.8}, {0.8, 0.8}, -- Corners
                {0.5, 0.1}, {0.9, 0.5}, {0.5, 0.9}, {0.1, 0.5}  -- Mid-edges
            }
            
            for i, pos in ipairs(attachmentPositions) do
                local fireFrame = Instance.new("Frame")
                fireFrame.Name = "FireEffect" .. i
                fireFrame.Size = UDim2.new(0.05, 0, 0.05, 0) -- Small fire points
                fireFrame.Position = UDim2.new(pos[1], 0, pos[2], 0)
                fireFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                fireFrame.BackgroundTransparency = 1
                fireFrame.Parent = speedometer
                
                -- Create flame effect using multiple overlapping elements
                -- Base flame (red/orange)
                local baseFlame = Instance.new("Frame")
                baseFlame.Size = UDim2.new(2, 0, 6, 0)
                baseFlame.Position = UDim2.new(-0.5, 0, -3, 0)
                baseFlame.BackgroundColor3 = Color3.fromRGB(255, 60, 0) -- Red-orange
                baseFlame.BackgroundTransparency = 0.2
                baseFlame.BorderSizePixel = 0
                baseFlame.Rotation = math.random(-10, 10)
                baseFlame.Parent = fireFrame
                
                -- Flame shape - wider at bottom, pointed at top
                local flameShape = Instance.new("UICorner")
                flameShape.CornerRadius = UDim.new(0, 15)
                flameShape.Parent = baseFlame
                
                -- Middle flame layer (orange)
                local midFlame = Instance.new("Frame")
                midFlame.Size = UDim2.new(1.3, 0, 4, 0)
                midFlame.Position = UDim2.new(0.35, 0, -1.5, 0)
                midFlame.BackgroundColor3 = Color3.fromRGB(255, 120, 0) -- Orange
                midFlame.BackgroundTransparency = 0.3
                midFlame.BorderSizePixel = 0
                midFlame.Rotation = math.random(-5, 5)
                midFlame.Parent = fireFrame
                
                local midShape = Instance.new("UICorner")
                midShape.CornerRadius = UDim.new(0, 12)
                midShape.Parent = midFlame
                
                -- Inner flame core (yellow)
                local innerFlame = Instance.new("Frame")
                innerFlame.Size = UDim2.new(0.8, 0, 2.5, 0)
                innerFlame.Position = UDim2.new(0.6, 0, -0.5, 0)
                innerFlame.BackgroundColor3 = Color3.fromRGB(255, 255, 100) -- Yellow
                innerFlame.BackgroundTransparency = 0.4
                innerFlame.BorderSizePixel = 0
                innerFlame.Parent = fireFrame
                
                local innerShape = Instance.new("UICorner")
                innerShape.CornerRadius = UDim.new(0, 8)
                innerShape.Parent = innerFlame
                
                -- Animate realistic flame flickering
                spawn(function()
                    while fireFrame.Parent do
                        -- Base flame flicker (main body)
                        local baseTween = TweenService:Create(baseFlame, 
                            TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                            {
                                Size = UDim2.new(2, 0, math.random(5, 7), 0),
                                Rotation = math.random(-15, 15),
                                BackgroundTransparency = math.random(15, 35) / 100
                            }
                        )
                        
                        -- Mid flame flicker (medium layer)
                        local midTween = TweenService:Create(midFlame,
                            TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                            {
                                Size = UDim2.new(1.3, 0, math.random(3, 5), 0),
                                Rotation = math.random(-10, 10),
                                BackgroundTransparency = math.random(25, 45) / 100
                            }
                        )
                        
                        -- Inner flame flicker (hot core)
                        local innerTween = TweenService:Create(innerFlame,
                            TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                            {
                                Size = UDim2.new(0.8, 0, math.random(2, 3), 0),
                                BackgroundTransparency = math.random(30, 50) / 100
                            }
                        )
                        
                        baseTween:Play()
                        midTween:Play()
                        innerTween:Play()
                        wait(0.1)
                    end
                end)
            end
            
            -- Make speedometer face glow orange but keep it readable
            if speedometerInner then
                speedometerInner.BackgroundColor3 = Color3.fromRGB(255, 220, 180) -- Lighter warm glow so needle is visible
                
                -- Add orange glow border
                local glowBorder = speedometerInner:FindFirstChild("UIStroke")
                if not glowBorder then
                    glowBorder = Instance.new("UIStroke")
                    glowBorder.Name = "FireGlow"
                    glowBorder.Parent = speedometerInner
                end
                glowBorder.Thickness = 3
                glowBorder.Color = Color3.fromRGB(255, 100, 0)
                glowBorder.Transparency = 0.2
                
                -- Make needle more visible during nitro
                local needle = speedometerInner:FindFirstChild("SpeedNeedle")
                if needle then
                    local needleWhiteSide = needle:FindFirstChild("Frame") -- First frame is the white side
                    if needleWhiteSide then
                        needleWhiteSide.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Change to black for contrast
                        
                        -- Add white outline to make it stand out
                        local needleOutline = needleWhiteSide:FindFirstChild("UIStroke")
                        if not needleOutline then
                            needleOutline = Instance.new("UIStroke")
                            needleOutline.Name = "NeedleOutline"
                            needleOutline.Parent = needleWhiteSide
                        end
                        needleOutline.Thickness = 2
                        needleOutline.Color = Color3.fromRGB(255, 255, 255)
                        needleOutline.Transparency = 0
                    end
                end
                
                -- Pulsing glow effect
                spawn(function()
                    while speedometerInner:FindFirstChild("FireGlow") do
                        local pulseTween = TweenService:Create(glowBorder,
                            TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                            {Transparency = 0.8}
                        )
                        pulseTween:Play()
                        wait(0.5)
                    end
                end)
            end
        end
    end
    
    local function removeSpeedometerFireEffect()
        -- Remove fire particles
        if speedometer then
            for i = 1, 8 do
                local fireFrame = speedometer:FindFirstChild("FireEffect" .. i)
                if fireFrame then
                    fireFrame:Destroy()
                end
            end
            
            -- Reset speedometer appearance
            if speedometerInner then
                speedometerInner.BackgroundColor3 = Color3.fromRGB(250, 250, 250) -- Back to white
                
                -- Remove glow border
                local glowBorder = speedometerInner:FindFirstChild("FireGlow")
                if glowBorder then
                    glowBorder:Destroy()
                end
                
                -- Reset needle back to white
                local needle = speedometerInner:FindFirstChild("SpeedNeedle")
                if needle then
                    local needleWhiteSide = needle:FindFirstChild("Frame") -- First frame is the white side
                    if needleWhiteSide then
                        needleWhiteSide.BackgroundColor3 = Color3.fromRGB(250, 250, 250) -- Back to white
                        
                        -- Remove needle outline
                        local needleOutline = needleWhiteSide:FindFirstChild("NeedleOutline")
                        if needleOutline then
                            needleOutline:Destroy()
                        end
                    end
                end
            end
        end
    end
    
    -- Listen for speedometer fire effect from server
    spawn(function()
        local speedometerFireEvent = ReplicatedStorage:WaitForChild("SpeedometerFireEffect", 10)
        if speedometerFireEvent then
            speedometerFireEvent.OnClientEvent:Connect(function(enableFire)
                if enableFire then
                    addSpeedometerFireEffect()
                else
                    removeSpeedometerFireEffect()
                end
            end)
        end
    end)

    local jumpCorner = Instance.new("UICorner")
    jumpCorner.CornerRadius = UDim.new(0, 8)
    jumpCorner.Parent = jumpButton

    -- Jump button fill bar
    local jumpFill = Instance.new("Frame")
    jumpFill.Name = "FillBar"
    jumpFill.Size = UDim2.new(1, 0, 0, 0)
    jumpFill.Position = UDim2.new(0, 0, 1, 0)
    jumpFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    jumpFill.BackgroundTransparency = 0.3
    jumpFill.BorderSizePixel = 0
    jumpFill.ZIndex = 2
    jumpFill.Parent = jumpButton

    local jumpFillCorner = Instance.new("UICorner")
    jumpFillCorner.CornerRadius = UDim.new(0, 8)
    jumpFillCorner.Parent = jumpFill

    -- Fire Trail Shop Button - now properly scaling
    local trailButton = Instance.new("TextButton")
    trailButton.Name = "TrailButton"
    trailButton.Size = UDim2.new(0.15, 0, 0.06, 0) -- 15% width, 6% height like trail shop
    trailButton.Position = UDim2.new(0.02, 0, 0.92, 0) -- 2% from left, 8% from bottom
    trailButton.AnchorPoint = Vector2.new(0, 1) -- Left anchor like trail shop
    trailButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    trailButton.BorderSizePixel = 0
    trailButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    trailButton.TextScaled = true
    trailButton.Font = Enum.Font.FredokaOne
    trailButton.Text = "Trail Shop"
    trailButton.ZIndex = 1
    trailButton.Parent = screenGui

    local trailCorner = Instance.new("UICorner")
    trailCorner.CornerRadius = UDim.new(0, 8)
    trailCorner.Parent = trailButton

    local function updateButtonDisplay()
        local leaderstats = player:FindFirstChild("leaderstats")
        if not leaderstats then return end
        
        local coins = leaderstats:FindFirstChild("Coins")
        local speedLevel = leaderstats:FindFirstChild("SpeedLevel")
        local jumpLevel = leaderstats:FindFirstChild("JumpLevel")
        
        if coins and speedLevel and jumpLevel then
            -- Get actual player speed
            local actualSpeed = 0
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local velocity = rootPart.Velocity
                actualSpeed = math.sqrt(velocity.X^2 + velocity.Z^2)
                
                -- Round to avoid tiny fluctuations
                if actualSpeed < 0.5 then
                    actualSpeed = 0
                end
            end
            
            -- Map speed 0-30 to needle positions (since max walking speed is around 20)
            local maxDisplaySpeed = 30
            local speedProgress = math.min(actualSpeed / maxDisplaySpeed, 1)
            
            
            -- Update gear number (speed level)
            local gearDisplay = gearFrame:FindFirstChild("GearNumber")
            if gearDisplay then
                gearDisplay.Text = tostring(speedLevel.Value)
            end
            -- Speed button update
            local speedCost = 10 + ((speedLevel.Value - 1) * 5)
            local speedTextLabel = speedButton:FindFirstChild("TextLabel")
            if speedTextLabel then
                speedTextLabel.Text = "Speed Lv" .. speedLevel.Value .. "\n" .. speedCost .. " Coins"
            end
            
            -- Speed fill bar progress with tween
            local speedProgress = math.min(coins.Value / speedCost, 1)
            local speedFillBar = speedButton:FindFirstChild("FillBar")
            if speedFillBar then
                local targetSize = UDim2.new(1, 0, speedProgress, 0)
                local targetPosition = UDim2.new(0, 0, 1 - speedProgress, 0)
                
                local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local sizeTween = TweenService:Create(speedFillBar, tweenInfo, {Size = targetSize})
                local positionTween = TweenService:Create(speedFillBar, tweenInfo, {Position = targetPosition})
                
                sizeTween:Play()
                positionTween:Play()
            end
            
            
            -- Jump button update
            local jumpCost = 15 + ((jumpLevel.Value - 1) * 8)
            local jumpTextLabel = jumpButton:FindFirstChild("TextLabel")
            if jumpTextLabel then
                jumpTextLabel.Text = "Jump Lv" .. jumpLevel.Value .. "\n" .. jumpCost .. " Coins"
            end
            
            -- Jump fill bar progress with tween
            local jumpProgress = math.min(coins.Value / jumpCost, 1)
            local jumpFillBar = jumpButton:FindFirstChild("FillBar")
            if jumpFillBar then
                local targetSize = UDim2.new(1, 0, jumpProgress, 0)
                local targetPosition = UDim2.new(0, 0, 1 - jumpProgress, 0)
                
                local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local sizeTween = TweenService:Create(jumpFillBar, tweenInfo, {Size = targetSize})
                local positionTween = TweenService:Create(jumpFillBar, tweenInfo, {Position = targetPosition})
                
                sizeTween:Play()
                positionTween:Play()
            end
            
        end
    end

    speedButton.MouseButton1Click:Connect(function()
        local remoteEvent = ReplicatedStorage:WaitForChild("PurchaseSpeedUpgrade")
        remoteEvent:FireServer()
    end)

    jumpButton.MouseButton1Click:Connect(function()
        local remoteEvent = ReplicatedStorage:WaitForChild("PurchaseJumpUpgrade")
        remoteEvent:FireServer()
    end)

    trailButton.MouseButton1Click:Connect(function()
        -- Import and use TrailShop
        local TrailShop = require(script.Parent.TrailShop)
        TrailShop.toggleShop()
    end)

    player.ChildAdded:Connect(function(child)
        if child.Name == "leaderstats" then
            local coins = child:WaitForChild("Coins")
            local speedLevel = child:WaitForChild("SpeedLevel")
            local jumpLevel = child:WaitForChild("JumpLevel")
            coins.Changed:Connect(updateButtonDisplay)
            speedLevel.Changed:Connect(updateButtonDisplay)
            jumpLevel.Changed:Connect(updateButtonDisplay)
            updateButtonDisplay()
        end
    end)

    if player:FindFirstChild("leaderstats") then
        local leaderstats = player.leaderstats
        if leaderstats:FindFirstChild("Coins") and leaderstats:FindFirstChild("SpeedLevel") and leaderstats:FindFirstChild("JumpLevel") then
            leaderstats.Coins.Changed:Connect(updateButtonDisplay)
            leaderstats.SpeedLevel.Changed:Connect(updateButtonDisplay)
            leaderstats.JumpLevel.Changed:Connect(updateButtonDisplay)
            updateButtonDisplay()
        end
    end


