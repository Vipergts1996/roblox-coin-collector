local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoinGui"
screenGui.Parent = playerGui

-- Odometer-style coin display
local odometerFrame = Instance.new("Frame")
odometerFrame.Size = UDim2.new(0.25, 0, 0.08, 0) -- Wider for odometer
odometerFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
odometerFrame.AnchorPoint = Vector2.new(0, 0)
odometerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Dark like speedometer
odometerFrame.BorderSizePixel = 0
odometerFrame.Parent = screenGui

local odometerCorner = Instance.new("UICorner")
odometerCorner.CornerRadius = UDim.new(0.1, 0)
odometerCorner.Parent = odometerFrame

-- Add metallic border
local odometerBorder = Instance.new("UIStroke")
odometerBorder.Thickness = 2
odometerBorder.Color = Color3.fromRGB(100, 100, 100)
odometerBorder.Parent = odometerFrame

-- Coins label
local coinsLabel = Instance.new("TextLabel")
coinsLabel.Size = UDim2.new(0.3, 0, 1, 0)
coinsLabel.Position = UDim2.new(0.02, 0, 0, 0)
coinsLabel.BackgroundTransparency = 1
coinsLabel.Text = "COINS"
coinsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
coinsLabel.TextScaled = true
coinsLabel.Font = Enum.Font.GothamBold
coinsLabel.Parent = odometerFrame

-- Odometer digits container
local digitsFrame = Instance.new("Frame")
digitsFrame.Size = UDim2.new(0.65, 0, 0.8, 0)
digitsFrame.Position = UDim2.new(0.33, 0, 0.1, 0)
digitsFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Very dark background
digitsFrame.BorderSizePixel = 0
digitsFrame.Parent = odometerFrame

local digitsCorner = Instance.new("UICorner")
digitsCorner.CornerRadius = UDim.new(0.1, 0)
digitsCorner.Parent = digitsFrame

-- Inset border for digits
local digitsBorder = Instance.new("UIStroke")
digitsBorder.Thickness = 1
digitsBorder.Color = Color3.fromRGB(60, 60, 60)
digitsBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
digitsBorder.Parent = digitsFrame

-- Grid layout for digits
local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0.15, 0, 1, 0) -- 6 digits max
gridLayout.CellPadding = UDim2.new(0.01, 0, 0, 0)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.FillDirection = Enum.FillDirection.Horizontal
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
gridLayout.Parent = digitsFrame

-- Odometer system
local maxDigits = 6
local digitFrames = {}
local currentValue = 0

-- Create individual digit displays
for i = 1, maxDigits do
    local digitContainer = Instance.new("Frame")
    digitContainer.Name = "Digit" .. i
    digitContainer.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    digitContainer.BorderSizePixel = 0
    digitContainer.LayoutOrder = i
    digitContainer.Parent = digitsFrame
    
    local digitCorner = Instance.new("UICorner")
    digitCorner.CornerRadius = UDim.new(0.1, 0)
    digitCorner.Parent = digitContainer
    
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
        digitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        digitLabel.TextScaled = true
        digitLabel.Font = Enum.Font.Code -- Monospace font like car odometer
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