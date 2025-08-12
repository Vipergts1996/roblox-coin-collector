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
shopFrame.Size = UDim2.new(0, 400, 0, 350)
shopFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
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
speedUpgradeFrame.Size = UDim2.new(1, -20, 0, 120)
speedUpgradeFrame.Position = UDim2.new(0, 10, 0, 70)
speedUpgradeFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedUpgradeFrame.BorderSizePixel = 0
speedUpgradeFrame.Parent = shopFrame

local jumpUpgradeFrame = Instance.new("Frame")
jumpUpgradeFrame.Size = UDim2.new(1, -20, 0, 120)
jumpUpgradeFrame.Position = UDim2.new(0, 10, 0, 200)
jumpUpgradeFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jumpUpgradeFrame.BorderSizePixel = 0
jumpUpgradeFrame.Parent = shopFrame

local upgradeCorner = Instance.new("UICorner")
upgradeCorner.CornerRadius = UDim.new(0, 8)
upgradeCorner.Parent = speedUpgradeFrame

local jumpUpgradeCorner = Instance.new("UICorner")
jumpUpgradeCorner.CornerRadius = UDim.new(0, 8)
jumpUpgradeCorner.Parent = jumpUpgradeFrame

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
speedInfo.Size = UDim2.new(1, -20, 0, 30)
speedInfo.Position = UDim2.new(0, 10, 0, 35)
speedInfo.BackgroundTransparency = 1
speedInfo.Text = "Level 1 Speed: 16\nNext Level: 20 (+4)"
speedInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
speedInfo.TextScaled = true
speedInfo.Font = Enum.Font.SourceSans
speedInfo.Parent = speedUpgradeFrame

local speedBuyButton = Instance.new("TextButton")
speedBuyButton.Size = UDim2.new(0, 150, 0, 30)
speedBuyButton.Position = UDim2.new(0.5, -75, 0, 75)
speedBuyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
speedBuyButton.BorderSizePixel = 0
speedBuyButton.Text = "Buy for 10 Coins"
speedBuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBuyButton.TextScaled = true
speedBuyButton.Font = Enum.Font.SourceSansBold
speedBuyButton.Parent = speedUpgradeFrame

local speedBuyCorner = Instance.new("UICorner")
speedBuyCorner.CornerRadius = UDim.new(0, 5)
speedBuyCorner.Parent = speedBuyButton

local jumpTitle = Instance.new("TextLabel")
jumpTitle.Size = UDim2.new(1, 0, 0, 25)
jumpTitle.Position = UDim2.new(0, 0, 0, 5)
jumpTitle.BackgroundTransparency = 1
jumpTitle.Text = "Jump Upgrade"
jumpTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
jumpTitle.TextScaled = true
jumpTitle.Font = Enum.Font.SourceSansBold
jumpTitle.Parent = jumpUpgradeFrame

local jumpInfo = Instance.new("TextLabel")
jumpInfo.Size = UDim2.new(1, -20, 0, 30)
jumpInfo.Position = UDim2.new(0, 10, 0, 35)
jumpInfo.BackgroundTransparency = 1
jumpInfo.Text = "Level 1 Jump: 50\nNext Level: 55 (+5)"
jumpInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
jumpInfo.TextScaled = true
jumpInfo.Font = Enum.Font.SourceSans
jumpInfo.Parent = jumpUpgradeFrame

local jumpBuyButton = Instance.new("TextButton")
jumpBuyButton.Size = UDim2.new(0, 150, 0, 30)
jumpBuyButton.Position = UDim2.new(0.5, -75, 0, 75)
jumpBuyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
jumpBuyButton.BorderSizePixel = 0
jumpBuyButton.Text = "Buy for 15 Coins"
jumpBuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBuyButton.TextScaled = true
jumpBuyButton.Font = Enum.Font.SourceSansBold
jumpBuyButton.Parent = jumpUpgradeFrame

local jumpBuyCorner = Instance.new("UICorner")
jumpBuyCorner.CornerRadius = UDim.new(0, 5)
jumpBuyCorner.Parent = jumpBuyButton

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
    local jumpLevel = leaderstats:FindFirstChild("JumpLevel")
    
    if coins and speedLevel and jumpLevel then
        -- Speed upgrade info
        local currentSpeed = 16 + ((speedLevel.Value - 1) * 4)
        local nextSpeed = currentSpeed + 4
        local speedCost = 10 + ((speedLevel.Value - 1) * 5)
        
        speedInfo.Text = "Level " .. speedLevel.Value .. " Speed: " .. currentSpeed .. "\nNext Level: " .. nextSpeed .. " (+4)"
        speedBuyButton.Text = "Buy for " .. speedCost .. " Coins"
        
        if coins.Value >= speedCost then
            speedBuyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            speedBuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            speedBuyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            speedBuyButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        
        -- Jump upgrade info
        local currentJump = 50 + ((jumpLevel.Value - 1) * 5)
        local nextJump = currentJump + 5
        local jumpCost = 15 + ((jumpLevel.Value - 1) * 8)
        
        jumpInfo.Text = "Level " .. jumpLevel.Value .. " Jump: " .. currentJump .. "\nNext Level: " .. nextJump .. " (+5)"
        jumpBuyButton.Text = "Buy for " .. jumpCost .. " Coins"
        
        if coins.Value >= jumpCost then
            jumpBuyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            jumpBuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            jumpBuyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            jumpBuyButton.TextColor3 = Color3.fromRGB(150, 150, 150)
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

speedBuyButton.MouseButton1Click:Connect(function()
    local remoteEvent = ReplicatedStorage:WaitForChild("PurchaseSpeedUpgrade")
    remoteEvent:FireServer()
end)

jumpBuyButton.MouseButton1Click:Connect(function()
    local remoteEvent = ReplicatedStorage:WaitForChild("PurchaseJumpUpgrade")
    remoteEvent:FireServer()
end)

player.ChildAdded:Connect(function(child)
    if child.Name == "leaderstats" then
        local coins = child:WaitForChild("Coins")
        local speedLevel = child:WaitForChild("SpeedLevel")
        local jumpLevel = child:WaitForChild("JumpLevel")
        coins.Changed:Connect(updateShopDisplay)
        speedLevel.Changed:Connect(updateShopDisplay)
        jumpLevel.Changed:Connect(updateShopDisplay)
        updateShopDisplay()
    end
end)

if player:FindFirstChild("leaderstats") then
    local leaderstats = player.leaderstats
    if leaderstats:FindFirstChild("Coins") and leaderstats:FindFirstChild("SpeedLevel") and leaderstats:FindFirstChild("JumpLevel") then
        leaderstats.Coins.Changed:Connect(updateShopDisplay)
        leaderstats.SpeedLevel.Changed:Connect(updateShopDisplay)
        leaderstats.JumpLevel.Changed:Connect(updateShopDisplay)
        updateShopDisplay()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.B then
        toggleShop()
    end
end)