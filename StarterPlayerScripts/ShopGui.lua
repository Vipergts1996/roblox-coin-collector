local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UpgradeButtons"
screenGui.Parent = playerGui

-- Realistic tachometer at top of screen
local speedometer = Instance.new("Frame")
speedometer.Name = "Speedometer"
speedometer.Size = UDim2.new(0, 280, 0, 280)
speedometer.Position = UDim2.new(0.5, -140, 0, -10)
speedometer.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Dark metallic outer ring
speedometer.BorderSizePixel = 3
speedometer.BorderColor3 = Color3.fromRGB(100, 100, 100) -- Metallic silver border
speedometer.Parent = screenGui

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
        numberLabel.Size = UDim2.new(0, 30, 0, 30)
        numberLabel.BackgroundTransparency = 1
        numberLabel.Text = tostring(math.floor(speedValue))
        numberLabel.TextColor3 = Color3.fromRGB(30, 30, 30)
        numberLabel.TextScaled = true
        numberLabel.Font = Enum.Font.GothamBold
        numberLabel.TextStrokeTransparency = 0.9
        numberLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        numberLabel.Parent = speedometerInner
        
        -- Position numbers around the circle
        local numberAngle = math.rad(i * 30 - 230)
        local radius = 0.35
        local x = 0.5 + math.cos(numberAngle) * radius
        local y = 0.5 + math.sin(numberAngle) * radius
        numberLabel.Position = UDim2.new(x, -15, y, -15)
        
        table.insert(speedNumbers, numberLabel)
    end
end

-- Create clean tick marks that don't overlap numbers
for i = 0, 9 do
    local numberAngle = math.rad(i * 30 - 230)
    
    -- Major tick marks - shorter and positioned away from numbers
    local majorTick = Instance.new("Frame")
    majorTick.Size = UDim2.new(0, 2, 0, 8) -- Much shorter
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
            minorTick.Size = UDim2.new(0, 1, 0, 4) -- Very short minor ticks
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

-- Realistic speed needle (keeping original positioning)
local needle = Instance.new("Frame")
needle.Name = "SpeedNeedle"
needle.Size = UDim2.new(0, 3, 0, 105) -- Thinner, more elegant needle
needle.Position = UDim2.new(0.5, 0, 0.5, 0) -- Same center position
needle.BackgroundTransparency = 1
needle.BorderSizePixel = 0
needle.AnchorPoint = Vector2.new(0.5, 0.5)
needle.ZIndex = 3
needle.Rotation = -320 -- Same starting angle
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

-- Realistic center hub
local centerHub = Instance.new("Frame")
centerHub.Size = UDim2.new(0, 14, 0, 14)
centerHub.Position = UDim2.new(0.5, -7, 0.5, -7)
centerHub.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Metallic center
centerHub.BorderSizePixel = 2
centerHub.BorderColor3 = Color3.fromRGB(120, 120, 120)
centerHub.ZIndex = 4
centerHub.Parent = speedometerInner

local centerHubCorner = Instance.new("UICorner")
centerHubCorner.CornerRadius = UDim.new(0.5, 0)
centerHubCorner.Parent = centerHub

-- Inner center dot
local centerDot = Instance.new("Frame")
centerDot.Size = UDim2.new(0, 6, 0, 6)
centerDot.Position = UDim2.new(0.5, -3, 0.5, -3)
centerDot.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
centerDot.BorderSizePixel = 0
centerDot.ZIndex = 5
centerDot.Parent = speedometerInner

local centerDotCorner = Instance.new("UICorner")
centerDotCorner.CornerRadius = UDim.new(0.5, 0)
centerDotCorner.Parent = centerDot


-- Gear display (7-segment style)
local gearFrame = Instance.new("Frame")
gearFrame.Size = UDim2.new(0, 68, 0, 51)
gearFrame.Position = UDim2.new(0.5, -34, 0.7, 0)
gearFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
gearFrame.BorderSizePixel = 2
gearFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
gearFrame.Parent = speedometerInner

local gearCorner = Instance.new("UICorner")
gearCorner.CornerRadius = UDim.new(0, 5)
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

-- Speed Upgrade Button
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Size = UDim2.new(0, 150, 0, 60)
speedButton.Position = UDim2.new(0.5, -160, 1, -80)
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

-- Jump Upgrade Button
local jumpButton = Instance.new("TextButton")
jumpButton.Name = "JumpButton"
jumpButton.Size = UDim2.new(0, 150, 0, 60)
jumpButton.Position = UDim2.new(0.5, 10, 1, -80)
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


