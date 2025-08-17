local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoinGui"
screenGui.Parent = playerGui

-- Car dashboard-style odometer display
local odometerFrame = Instance.new("Frame")
odometerFrame.Size = UDim2.new(0.22, 0, 0.06, 0) -- Car dashboard proportions
odometerFrame.Position = UDim2.new(0.5, 0, 0.78, 0) -- Higher up, centered above speed/jump buttons
odometerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
odometerFrame.BackgroundColor3 = Color3.fromRGB(40, 35, 30) -- Dark brown/black housing for rolling drums
odometerFrame.BorderSizePixel = 0
odometerFrame.Parent = screenGui

local odometerCorner = Instance.new("UICorner")
odometerCorner.CornerRadius = UDim.new(0.05, 0) -- Less rounded for car look
odometerCorner.Parent = odometerFrame

-- Car dashboard bezel effect
local odometerBorder = Instance.new("UIStroke")
odometerBorder.Thickness = 1
odometerBorder.Color = Color3.fromRGB(80, 80, 80) -- Subtle metallic
odometerBorder.Parent = odometerFrame

-- Inner housing for rolling drums
local shadowFrame = Instance.new("Frame")
shadowFrame.Size = UDim2.new(0.98, 0, 0.95, 0)
shadowFrame.Position = UDim2.new(0.01, 0, 0.025, 0)
shadowFrame.BackgroundColor3 = Color3.fromRGB(30, 25, 20) -- Darker housing for drum cavity
shadowFrame.BorderSizePixel = 0
shadowFrame.Parent = odometerFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0.05, 0)
shadowCorner.Parent = shadowFrame

-- Car-style label
local coinsLabel = Instance.new("TextLabel")
coinsLabel.Size = UDim2.new(0.25, 0, 0.4, 0)
coinsLabel.Position = UDim2.new(0.02, 0, 0.1, 0)
coinsLabel.BackgroundTransparency = 1
coinsLabel.Text = "COINS"
coinsLabel.TextColor3 = Color3.fromRGB(255, 140, 0) -- Amber car dashboard color
coinsLabel.TextScaled = true
coinsLabel.Font = Enum.Font.Highway -- More automotive font
coinsLabel.Parent = shadowFrame

-- Rolling drums container
local digitsFrame = Instance.new("Frame")
digitsFrame.Size = UDim2.new(0.7, 0, 0.6, 0)
digitsFrame.Position = UDim2.new(0.28, 0, 0.5, 0)
digitsFrame.AnchorPoint = Vector2.new(0, 0.5)
digitsFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 10) -- Very dark background behind drums
digitsFrame.BorderSizePixel = 0
digitsFrame.Parent = shadowFrame

local digitsCorner = Instance.new("UICorner")
digitsCorner.CornerRadius = UDim.new(0.02, 0) -- Very slight rounding like LCD display
digitsCorner.Parent = digitsFrame

-- LCD-style inset border
local digitsBorder = Instance.new("UIStroke")
digitsBorder.Thickness = 1
digitsBorder.Color = Color3.fromRGB(40, 40, 40)
digitsBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
digitsBorder.Parent = digitsFrame

-- List layout for digits - more reliable than grid
local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Horizontal
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 0) -- No padding between digits
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
listLayout.Parent = digitsFrame

-- Odometer system
local maxDigits = 6
local digitFrames = {}
local currentValue = 0

-- Create individual rolling drum digit displays
for i = 1, maxDigits do
    local digitContainer = Instance.new("Frame")
    digitContainer.Name = "Digit" .. i
    digitContainer.Size = UDim2.new(0.166, 0, 1, 0) -- Fixed size for each digit
    digitContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Dark background like rolling drums
    digitContainer.BorderSizePixel = 0
    digitContainer.LayoutOrder = i
    digitContainer.Parent = digitsFrame
    
    -- Rolling drum styling - more rectangular
    local digitCorner = Instance.new("UICorner")
    digitCorner.CornerRadius = UDim.new(0.08, 0) -- Slightly rounded like drum edges
    digitCorner.Parent = digitContainer
    
    -- Add subtle border for drum separation
    local digitBorder = Instance.new("UIStroke")
    digitBorder.Thickness = 1
    digitBorder.Color = Color3.fromRGB(60, 60, 60) -- Subtle dark border
    digitBorder.Parent = digitContainer
    
    -- Scrolling frame for rolling effect
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 10, 0) -- 10x height for digits 0-9
    scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame.Parent = digitContainer
    
    -- Create digits 0-9 in the scroll frame
    for digit = 0, 9 do
        local digitLabel = Instance.new("TextLabel")
        digitLabel.Name = "Digit" .. digit
        digitLabel.Size = UDim2.new(1, 0, 0.1, 0) -- 10% height (1/10th)
        digitLabel.Position = UDim2.new(0, 0, digit * 0.1, 0)
        digitLabel.BackgroundTransparency = 1
        digitLabel.Text = tostring(digit)
        digitLabel.TextColor3 = Color3.fromRGB(220, 180, 120) -- Warm cream/beige like rolling drum numbers
        digitLabel.TextScaled = true
        digitLabel.Font = Enum.Font.GothamBold -- Bold numbers for rolling drums
        digitLabel.TextStrokeTransparency = 0.8
        digitLabel.TextStrokeColor3 = Color3.fromRGB(160, 120, 80) -- Subtle warm outline
        digitLabel.Parent = scrollFrame
    end
    
    digitFrames[i] = scrollFrame
end

-- Function to update odometer with rolling animation
local function updateOdometer(newValue)
    if newValue == currentValue then return end
    
    local valueStr = string.format("%06d", newValue) -- Pad to 6 digits
    
    for i = 1, maxDigits do
        local digit = tonumber(string.sub(valueStr, i, i))
        local scrollFrame = digitFrames[i]
        
        -- Wait for frame to be properly sized
        if scrollFrame.AbsoluteCanvasSize.Y > 0 then
            -- Calculate target scroll position
            -- Each digit takes up 10% of the canvas (1/10th)
            local digitHeight = scrollFrame.AbsoluteCanvasSize.Y / 10
            local targetScrollY = digit * digitHeight
            
            -- Animate scroll to show the correct digit
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(scrollFrame, tweenInfo, {
                CanvasPosition = Vector2.new(0, targetScrollY)
            })
            tween:Play()
        else
            -- Fallback: Set position directly if canvas not ready
            spawn(function()
                wait(0.1) -- Wait for canvas to be sized
                if scrollFrame.AbsoluteCanvasSize.Y > 0 then
                    local digitHeight = scrollFrame.AbsoluteCanvasSize.Y / 10
                    local targetScrollY = digit * digitHeight
                    scrollFrame.CanvasPosition = Vector2.new(0, targetScrollY)
                end
            end)
        end
    end
    
    currentValue = newValue
end

local function updateCoinDisplay()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local coins = leaderstats:FindFirstChild("Coins")
        if coins then
            updateOdometer(coins.Value)
        end
    end
end

player.ChildAdded:Connect(function(child)
    if child.Name == "leaderstats" then
        local coins = child:WaitForChild("Coins")
        coins.Changed:Connect(updateCoinDisplay)
        updateCoinDisplay()
    end
end)

if player:FindFirstChild("leaderstats") then
    local coins = player.leaderstats:FindFirstChild("Coins")
    if coins then
        coins.Changed:Connect(updateCoinDisplay)
        updateCoinDisplay()
    end
end

-- Simple autoscaling complete