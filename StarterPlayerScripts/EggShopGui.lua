local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvents
local hatchEggEvent = ReplicatedStorage:WaitForChild("HatchEgg")

local EggShopGui = {}

-- Egg data (matches server-side data)
local eggData = {
    {
        name = "Basic Egg",
        price = 500,
        icon = "🥚",
        description = "Common pets with basic multipliers",
        eggType = "BasicEgg"
    },
    {
        name = "Forest Egg", 
        price = 2000,
        icon = "🌳",
        description = "Forest creatures with better stats",
        eggType = "ForestEgg"
    },
    {
        name = "Mystic Egg",
        price = 10000,
        icon = "🔮",
        description = "Magical pets with rare abilities",
        eggType = "MysticEgg"
    },
    {
        name = "Legendary Egg",
        price = 50000,
        icon = "⭐",
        description = "Legendary creatures with epic power",
        eggType = "LegendaryEgg"
    }
}

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EggShopGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main shop frame (initially hidden)
local shopFrame = Instance.new("Frame")
shopFrame.Name = "ShopFrame"
shopFrame.Size = UDim2.new(0, 700, 0, 550)
shopFrame.Position = UDim2.new(0.5, -350, 0.5, -275)
shopFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
shopFrame.BorderSizePixel = 0
shopFrame.Visible = false
shopFrame.Parent = screenGui

local shopCorner = Instance.new("UICorner")
shopCorner.CornerRadius = UDim.new(0, 10)
shopCorner.Parent = shopFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = shopFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Fix corner on bottom
local titleCornerFix = Instance.new("Frame")
titleCornerFix.Size = UDim2.new(1, 0, 0, 10)
titleCornerFix.Position = UDim2.new(0, 0, 1, -10)
titleCornerFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleCornerFix.BorderSizePixel = 0
titleCornerFix.Parent = titleBar

-- Title text
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🥚 Egg Shop"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -60, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Coins display
local coinsFrame = Instance.new("Frame")
coinsFrame.Size = UDim2.new(0, 200, 0, 40)
coinsFrame.Position = UDim2.new(0.5, -100, 0, 70)
coinsFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
coinsFrame.BorderSizePixel = 0
coinsFrame.Parent = shopFrame

local coinsCorner = Instance.new("UICorner")
coinsCorner.CornerRadius = UDim.new(0, 8)
coinsCorner.Parent = coinsFrame

local coinsLabel = Instance.new("TextLabel")
coinsLabel.Size = UDim2.new(1, 0, 1, 0)
coinsLabel.Position = UDim2.new(0, 0, 0, 0)
coinsLabel.BackgroundTransparency = 1
coinsLabel.Text = "💰 0 Coins"
coinsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
coinsLabel.TextScaled = true
coinsLabel.Font = Enum.Font.GothamBold
coinsLabel.Parent = coinsFrame

-- Egg container
local eggContainer = Instance.new("Frame")
eggContainer.Size = UDim2.new(1, -40, 1, -130)
eggContainer.Position = UDim2.new(0, 20, 0, 120)
eggContainer.BackgroundTransparency = 1
eggContainer.Parent = shopFrame

-- Grid layout for eggs
local gridLayout = Instance.new("UIGridLayout")
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.CellSize = UDim2.new(0, 150, 0, 200)
gridLayout.CellPadding = UDim2.new(0, 20, 0, 20)
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.Parent = eggContainer

-- Function to create an egg slot
function EggShopGui.createEggSlot(eggInfo, index)
    local eggSlot = Instance.new("Frame")
    eggSlot.Size = UDim2.new(0, 150, 0, 200)
    eggSlot.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    eggSlot.BorderSizePixel = 2
    eggSlot.BorderColor3 = Color3.fromRGB(120, 120, 120)
    eggSlot.LayoutOrder = index
    eggSlot.Parent = eggContainer
    
    local slotCorner = Instance.new("UICorner")
    slotCorner.CornerRadius = UDim.new(0, 10)
    slotCorner.Parent = eggSlot
    
    -- Egg icon/display
    local eggDisplay = Instance.new("Frame")
    eggDisplay.Size = UDim2.new(1, -10, 0, 80)
    eggDisplay.Position = UDim2.new(0, 5, 0, 5)
    eggDisplay.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    eggDisplay.BorderSizePixel = 0
    eggDisplay.Parent = eggSlot
    
    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, 8)
    displayCorner.Parent = eggDisplay
    
    -- Egg icon text
    local eggIcon = Instance.new("TextLabel")
    eggIcon.Size = UDim2.new(1, 0, 1, 0)
    eggIcon.Position = UDim2.new(0, 0, 0, 0)
    eggIcon.BackgroundTransparency = 1
    eggIcon.Text = eggInfo.icon
    eggIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    eggIcon.TextScaled = true
    eggIcon.Font = Enum.Font.SourceSans
    eggIcon.Parent = eggDisplay
    
    -- Egg name
    local eggName = Instance.new("TextLabel")
    eggName.Size = UDim2.new(1, 0, 0, 25)
    eggName.Position = UDim2.new(0, 0, 0, 90)
    eggName.BackgroundTransparency = 1
    eggName.Text = eggInfo.name
    eggName.TextColor3 = Color3.fromRGB(255, 255, 255)
    eggName.TextScaled = true
    eggName.Font = Enum.Font.GothamBold
    eggName.Parent = eggSlot
    
    -- Egg price
    local eggPrice = Instance.new("TextLabel")
    eggPrice.Size = UDim2.new(1, 0, 0, 20)
    eggPrice.Position = UDim2.new(0, 0, 0, 115)
    eggPrice.BackgroundTransparency = 1
    eggPrice.Text = "💰 " .. eggInfo.price .. " Coins"
    eggPrice.TextColor3 = Color3.fromRGB(255, 215, 0)
    eggPrice.TextScaled = true
    eggPrice.Font = Enum.Font.Gotham
    eggPrice.Parent = eggSlot
    
    -- Egg description
    local eggDesc = Instance.new("TextLabel")
    eggDesc.Size = UDim2.new(1, -10, 0, 30)
    eggDesc.Position = UDim2.new(0, 5, 0, 140)
    eggDesc.BackgroundTransparency = 1
    eggDesc.Text = eggInfo.description
    eggDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    eggDesc.TextScaled = true
    eggDesc.Font = Enum.Font.Gotham
    eggDesc.TextWrapped = true
    eggDesc.Parent = eggSlot
    
    -- Purchase button
    local buyButton = Instance.new("TextButton")
    buyButton.Size = UDim2.new(1, -10, 0, 25)
    buyButton.Position = UDim2.new(0, 5, 1, -30)
    buyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    buyButton.BorderSizePixel = 0
    buyButton.Text = "Hatch Egg"
    buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyButton.TextScaled = true
    buyButton.Font = Enum.Font.GothamBold
    buyButton.Parent = eggSlot
    
    local buyCorner = Instance.new("UICorner")
    buyCorner.CornerRadius = UDim.new(0, 5)
    buyCorner.Parent = buyButton
    
    -- Button click handler
    buyButton.MouseButton1Click:Connect(function()
        -- Check if player has enough coins
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats and leaderstats:FindFirstChild("Coins") then
            if leaderstats.Coins.Value >= eggInfo.price then
                -- Fire server event to hatch egg
                hatchEggEvent:FireServer(eggInfo.eggType)
                
                -- Button animation
                local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true)
                local tween = TweenService:Create(buyButton, tweenInfo, {Size = UDim2.new(1, -5, 0, 20)})
                tween:Play()
            else
                -- Not enough coins animation
                local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true)
                local tween = TweenService:Create(buyButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)})
                tween:Play()
                tween.Completed:Connect(function()
                    buyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                end)
            end
        end
    end)
    
    return eggSlot
end

-- Function to update coins display
function EggShopGui.updateCoinsDisplay()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Coins") then
        coinsLabel.Text = "💰 " .. leaderstats.Coins.Value .. " Coins"
    end
end

-- Function to refresh shop display
function EggShopGui.refreshShop()
    -- Clear existing eggs
    for _, child in pairs(eggContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add egg slots
    for i, eggInfo in pairs(eggData) do
        EggShopGui.createEggSlot(eggInfo, i)
    end
    
    -- Update coins
    EggShopGui.updateCoinsDisplay()
end

-- Toggle shop visibility
function EggShopGui.toggleShop()
    shopFrame.Visible = not shopFrame.Visible
    if shopFrame.Visible then
        -- Close pet inventory if open
        local petInventoryGui = playerGui:FindFirstChild("PetInventoryGui")
        if petInventoryGui and petInventoryGui:FindFirstChild("InventoryFrame") then
            petInventoryGui.InventoryFrame.Visible = false
        end
        EggShopGui.refreshShop()
    end
end

-- Function to close shop (called from other scripts)
function EggShopGui.closeShop()
    shopFrame.Visible = false
end

-- Close button handler
closeButton.MouseButton1Click:Connect(function()
    shopFrame.Visible = false
end)

-- Keyboard shortcut (E key for egg shop)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        EggShopGui.toggleShop()
    end
end)

-- Listen for coin changes
spawn(function()
    while true do
        EggShopGui.updateCoinsDisplay()
        wait(0.5)
    end
end)

-- Handle hatching results
hatchEggEvent.OnClientEvent:Connect(function(resultData)
    if resultData.success then
        -- Show hatching animation/notification
        print("Hatched a " .. resultData.pet.rarity .. " " .. resultData.pet.name .. "!")
        
        -- Create notification
        local notification = Instance.new("Frame")
        notification.Size = UDim2.new(0, 300, 0, 80)
        notification.Position = UDim2.new(0.5, -150, 0, -100)
        notification.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        notification.BorderSizePixel = 2
        notification.BorderColor3 = Color3.fromRGB(0, 255, 0)
        notification.Parent = screenGui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notification
        
        local notifText = Instance.new("TextLabel")
        notifText.Size = UDim2.new(1, 0, 1, 0)
        notifText.Position = UDim2.new(0, 0, 0, 0)
        notifText.BackgroundTransparency = 1
        notifText.Text = "🎉 Hatched " .. resultData.pet.rarity .. " " .. resultData.pet.name .. "!"
        notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
        notifText.TextScaled = true
        notifText.Font = Enum.Font.GothamBold
        notifText.Parent = notification
        
        -- Animate notification
        local slideIn = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0, 20)})
        slideIn:Play()
        
        -- Remove after delay
        spawn(function()
            wait(3)
            local slideOut = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -150, 0, -100)})
            slideOut:Play()
            slideOut.Completed:Connect(function()
                notification:Destroy()
            end)
        end)
    end
end)

-- Initialize
EggShopGui.refreshShop()

print("Egg Shop GUI loaded! Press E to open/close shop.")

return EggShopGui