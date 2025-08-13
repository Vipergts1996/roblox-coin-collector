local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UpgradeButtons"
screenGui.Parent = playerGui

-- Speed Upgrade Button
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Size = UDim2.new(0, 150, 0, 60)
speedButton.Position = UDim2.new(0.5, -160, 1, -80)
speedButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
speedButton.BorderSizePixel = 0
speedButton.Text = "Speed Lv1\n10 Coins"
speedButton.TextColor3 = Color3.fromRGB(0, 0, 0)
speedButton.TextScaled = true
speedButton.Font = Enum.Font.SourceSansBold
speedButton.Parent = screenGui

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedButton

-- Jump Upgrade Button
local jumpButton = Instance.new("TextButton")
jumpButton.Name = "JumpButton"
jumpButton.Size = UDim2.new(0, 150, 0, 60)
jumpButton.Position = UDim2.new(0.5, 10, 1, -80)
jumpButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
jumpButton.BorderSizePixel = 0
jumpButton.Text = "Jump Lv1\n15 Coins"
jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpButton.TextScaled = true
jumpButton.Font = Enum.Font.SourceSansBold
jumpButton.Parent = screenGui

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 8)
jumpCorner.Parent = jumpButton

local function updateButtonDisplay()
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local coins = leaderstats:FindFirstChild("Coins")
    local speedLevel = leaderstats:FindFirstChild("SpeedLevel")
    local jumpLevel = leaderstats:FindFirstChild("JumpLevel")
    
    if coins and speedLevel and jumpLevel then
        -- Speed button update
        local speedCost = 10 + ((speedLevel.Value - 1) * 5)
        speedButton.Text = "Speed Lv" .. speedLevel.Value .. "\n" .. speedCost .. " Coins"
        
        if coins.Value >= speedCost then
            speedButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            speedButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            speedButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            speedButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        
        -- Jump button update
        local jumpCost = 15 + ((jumpLevel.Value - 1) * 8)
        jumpButton.Text = "Jump Lv" .. jumpLevel.Value .. "\n" .. jumpCost .. " Coins"
        
        if coins.Value >= jumpCost then
            jumpButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            jumpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            jumpButton.TextColor3 = Color3.fromRGB(150, 150, 150)
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

