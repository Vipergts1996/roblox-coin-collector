local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoinGui"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.25, 0, 0.08, 0) -- 25% width, 8% height
frame.Position = UDim2.new(0.02, 0, 0.02, 0) -- 2% from edges
frame.AnchorPoint = Vector2.new(0, 0) -- Top-left anchor
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.15, 0) -- 15% radius for proportional corners
corner.Parent = frame

local coinLabel = Instance.new("TextLabel")
coinLabel.Size = UDim2.new(1, 0, 1, 0)
coinLabel.Position = UDim2.new(0, 0, 0, 0)
coinLabel.BackgroundTransparency = 1
coinLabel.Text = "Coins: 0"
coinLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
coinLabel.TextScaled = true
coinLabel.Font = Enum.Font.GothamBold -- Better font for mobile

-- Add padding for better text spacing
local coinPadding = Instance.new("UIPadding")
coinPadding.PaddingLeft = UDim.new(0.05, 0)
coinPadding.PaddingRight = UDim.new(0.05, 0)
coinPadding.PaddingTop = UDim.new(0.1, 0)
coinPadding.PaddingBottom = UDim.new(0.1, 0)
coinPadding.Parent = coinLabel
coinLabel.Parent = frame

local function updateCoinDisplay()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local coins = leaderstats:FindFirstChild("Coins")
        if coins then
            coinLabel.Text = "Coins: " .. coins.Value
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