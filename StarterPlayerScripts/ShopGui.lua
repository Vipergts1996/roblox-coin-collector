local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shopOpen = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShopGui"
screenGui.Parent = playerGui

local shopFrame = Instance.new("Frame")
shopFrame.Name = "ShopFrame"
shopFrame.Size = UDim2.new(0, 400, 0, 300)
shopFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
shopFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
shopFrame.BorderSizePixel = 0
shopFrame.Visible = false
shopFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = shopFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "SPEED SHOP"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = shopFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = shopFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

local speedUpgradeFrame = Instance.new("Frame")
speedUpgradeFrame.Size = UDim2.new(1, -20, 0, 150)
speedUpgradeFrame.Position = UDim2.new(0, 10, 0, 70)
speedUpgradeFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedUpgradeFrame.BorderSizePixel = 0
speedUpgradeFrame.Parent = shopFrame

local upgradeCorner = Instance.new("UICorner")
upgradeCorner.CornerRadius = UDim.new(0, 8)
upgradeCorner.Parent = speedUpgradeFrame

local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(1, 0, 0, 30)
speedTitle.Position = UDim2.new(0, 0, 0, 10)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "Speed Upgrade"
speedTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
speedTitle.TextScaled = true
speedTitle.Font = Enum.Font.SourceSansBold
speedTitle.Parent = speedUpgradeFrame

local speedInfo = Instance.new("TextLabel")
speedInfo.Size = UDim2.new(1, -20, 0, 40)
speedInfo.Position = UDim2.new(0, 10, 0, 40)
speedInfo.BackgroundTransparency = 1
speedInfo.Text = "Current Speed: 16\nNext Level: 20 (+4)"
speedInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
speedInfo.TextScaled = true
speedInfo.Font = Enum.Font.SourceSans
speedInfo.Parent = speedUpgradeFrame

local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.new(0, 150, 0, 40)
buyButton.Position = UDim2.new(0.5, -75, 0, 100)
buyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
buyButton.BorderSizePixel = 0
buyButton.Text = "Buy for 10 Coins"
buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
buyButton.TextScaled = true
buyButton.Font = Enum.Font.SourceSansBold
buyButton.Parent = speedUpgradeFrame

local buyCorner = Instance.new("UICorner")
buyCorner.CornerRadius = UDim.new(0, 5)
buyCorner.Parent = buyButton

local shopButton = Instance.new("TextButton")
shopButton.Size = UDim2.new(0, 100, 0, 50)
shopButton.Position = UDim2.new(0, 10, 1, -60)
shopButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
shopButton.BorderSizePixel = 0
shopButton.Text = "SHOP"
shopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
shopButton.TextScaled = true
shopButton.Font = Enum.Font.SourceSansBold
shopButton.Parent = screenGui

local shopButtonCorner = Instance.new("UICorner")
shopButtonCorner.CornerRadius = UDim.new(0, 8)
shopButtonCorner.Parent = shopButton

local function updateShopDisplay()
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local coins = leaderstats:FindFirstChild("Coins")
    local speedLevel = leaderstats:FindFirstChild("SpeedLevel")
    
    if coins and speedLevel then
        local currentSpeed = 16 + (speedLevel.Value * 4)
        local nextSpeed = currentSpeed + 4
        local cost = 10 + (speedLevel.Value * 5)
        
        speedInfo.Text = "Current Speed: " .. currentSpeed .. "\nNext Level: " .. nextSpeed .. " (+" .. (nextSpeed - currentSpeed) .. ")"
        buyButton.Text = "Buy for " .. cost .. " Coins"
        
        if coins.Value >= cost then
            buyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            buyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            buyButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end
end

local function toggleShop()
    shopOpen = not shopOpen
    shopFrame.Visible = shopOpen
    if shopOpen then
        updateShopDisplay()
    end
end

shopButton.MouseButton1Click:Connect(toggleShop)
closeButton.MouseButton1Click:Connect(toggleShop)

buyButton.MouseButton1Click:Connect(function()
    local remoteEvent = ReplicatedStorage:WaitForChild("PurchaseSpeedUpgrade")
    remoteEvent:FireServer()
end)

player.ChildAdded:Connect(function(child)
    if child.Name == "leaderstats" then
        local coins = child:WaitForChild("Coins")
        local speedLevel = child:WaitForChild("SpeedLevel")
        coins.Changed:Connect(updateShopDisplay)
        speedLevel.Changed:Connect(updateShopDisplay)
        updateShopDisplay()
    end
end)

if player:FindFirstChild("leaderstats") then
    local leaderstats = player.leaderstats
    if leaderstats:FindFirstChild("Coins") and leaderstats:FindFirstChild("SpeedLevel") then
        leaderstats.Coins.Changed:Connect(updateShopDisplay)
        leaderstats.SpeedLevel.Changed:Connect(updateShopDisplay)
        updateShopDisplay()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.B then
        toggleShop()
    end
end)