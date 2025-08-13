local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UpgradeButtons"
screenGui.Parent = playerGui

-- Speedometer at top of screen
local speedometer = Instance.new("Frame")
speedometer.Name = "Speedometer"
speedometer.Size = UDim2.new(0, 255, 0, 255)
speedometer.Position = UDim2.new(0.5, -127.5, 0, -10)
speedometer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedometer.BorderSizePixel = 0
speedometer.Parent = screenGui

local speedometerCorner = Instance.new("UICorner")
speedometerCorner.CornerRadius = UDim.new(0.5, 0)
speedometerCorner.Parent = speedometer

-- Inner speedometer circle (darker)
local speedometerInner = Instance.new("Frame")
speedometerInner.Size = UDim2.new(0.85, 0, 0.85, 0)
speedometerInner.Position = UDim2.new(0.075, 0, 0.075, 0)
speedometerInner.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
speedometerInner.BorderSizePixel = 0
speedometerInner.Parent = speedometer

local speedometerInnerCorner = Instance.new("UICorner")
speedometerInnerCorner.CornerRadius = UDim.new(0.5, 0)
speedometerInnerCorner.Parent = speedometerInner

-- Speed numbers only (from 8pm to 6pm position, avoiding gear area)
for i = 0, 9 do
    -- Add numbers every marking (0, 10, 20, 30, 40, 50, 60, 70, 80, 90)
    local speedValue = (i / 9) * 90
    local numberLabel = Instance.new("TextLabel")
    numberLabel.Size = UDim2.new(0, 30, 0, 30)
    numberLabel.BackgroundTransparency = 1
    numberLabel.Text = tostring(math.floor(speedValue))
    numberLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    numberLabel.TextScaled = true
    numberLabel.Font = Enum.Font.GothamBold
    numberLabel.Parent = speedometerInner
    
    -- Position numbers around the circle (rotated 10 degrees clockwise from previous position)
    local numberAngle = math.rad(i * 30 - 230) -- Start from -230 degrees (8pm position)
    local radius = 0.35
    local x = 0.5 + math.cos(numberAngle) * radius
    local y = 0.5 + math.sin(numberAngle) * radius
    numberLabel.Position = UDim2.new(x, -15, y, -15)
end

-- Speed needle with hidden bottom half - CENTERED ON GAUGE
local needle = Instance.new("Frame")
needle.Name = "SpeedNeedle"
needle.Size = UDim2.new(0, 4, 0, 110) -- Make needle even longer
needle.Position = UDim2.new(0.5, 0, 0.5, 0) -- Exactly center on speedometerInner
needle.BackgroundTransparency = 1 -- Make container transparent
needle.BorderSizePixel = 0
needle.AnchorPoint = Vector2.new(0.5, 0.5) -- Anchor at center so it rotates around center
needle.ZIndex = 3
needle.Rotation = -320 -- Adjust starting angle to point at 0
needle.Parent = speedometerInner

-- Yellow top half of needle (hidden part that goes backward)
local needleTop = Instance.new("Frame")
needleTop.Size = UDim2.new(1, 0, 0.4, 0) -- Smaller yellow part
needleTop.Position = UDim2.new(0, 0, 0, 0)
needleTop.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Match speedometer yellow (hidden)
needleTop.BorderSizePixel = 0
needleTop.Parent = needle

-- Red bottom half of needle (visible part that points to numbers)
local needleBottom = Instance.new("Frame")
needleBottom.Size = UDim2.new(1, 0, 0.6, 0) -- Larger red part (extends further)
needleBottom.Position = UDim2.new(0, 0, 0.4, 0)
needleBottom.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red visible part
needleBottom.BorderSizePixel = 0
needleBottom.Parent = needle

-- Center dot
local centerDot = Instance.new("Frame")
centerDot.Size = UDim2.new(0, 10, 0, 10)
centerDot.Position = UDim2.new(0.5, -5, 0.5, -5)
centerDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
centerDot.BorderSizePixel = 0
centerDot.ZIndex = 4
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
        
        -- Map actual speed to gauge positions (gauge shows 0-90, we use speed 0-20)
        local maxDisplaySpeed = 90  -- Max on the gauge
        local speedProgress = math.min(actualSpeed / maxDisplaySpeed, 1)
        
        -- Calculate needle angle to match the gauge numbers
        -- The gauge spans 270 degrees from 0 to 90
        -- Speed 0 should point at "0", speed 16 should point at "10" area  
        local startAngle = -320  -- Adjust to point at actual 0 position
        local sweepRange = 270   -- Total degrees to sweep (0 to 90 on gauge)
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

