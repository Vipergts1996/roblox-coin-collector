local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvents
local hatchEggEvent = ReplicatedStorage:WaitForChild("HatchEgg")
local equipPetEvent = ReplicatedStorage:WaitForChild("EquipPet")
local unequipPetEvent = ReplicatedStorage:WaitForChild("UnequipPet")
local getPetDataEvent = ReplicatedStorage:WaitForChild("GetPetData")

local PetInventoryGui = {}

-- Player's actual pet data (will be populated from server)
local playerPets = {}

-- Rarity colors
local rarityColors = {
    Common = Color3.fromRGB(155, 155, 155),
    Uncommon = Color3.fromRGB(85, 255, 85),
    Rare = Color3.fromRGB(85, 170, 255),
    Epic = Color3.fromRGB(170, 85, 255),
    Legendary = Color3.fromRGB(255, 170, 0),
    Mythic = Color3.fromRGB(255, 85, 85)
}

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetInventoryGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main inventory frame (initially hidden)
local inventoryFrame = Instance.new("Frame")
inventoryFrame.Name = "InventoryFrame"
inventoryFrame.Size = UDim2.new(0, 600, 0, 500)
inventoryFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
inventoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inventoryFrame.BorderSizePixel = 0
inventoryFrame.Visible = false
inventoryFrame.Parent = screenGui

local inventoryCorner = Instance.new("UICorner")
inventoryCorner.CornerRadius = UDim.new(0, 10)
inventoryCorner.Parent = inventoryFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = inventoryFrame

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
titleLabel.Text = "Pet Inventory"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 5)
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

-- Pet container with scrolling
local petContainer = Instance.new("ScrollingFrame")
petContainer.Size = UDim2.new(1, -20, 1, -70)
petContainer.Position = UDim2.new(0, 10, 0, 60)
petContainer.BackgroundTransparency = 1
petContainer.BorderSizePixel = 0
petContainer.ScrollBarThickness = 8
petContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
petContainer.Parent = inventoryFrame

-- Grid layout for pets
local gridLayout = Instance.new("UIGridLayout")
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.CellSize = UDim2.new(0, 140, 0, 180) -- Larger cells for better spacing
gridLayout.CellPadding = UDim2.new(0, 15, 0, 15) -- More padding
gridLayout.Parent = petContainer

-- Function to create a pet slot
function PetInventoryGui.createPetSlot(petData)
    local petSlot = Instance.new("Frame")
    petSlot.Name = "PetSlot_" .. petData.id
    petSlot.Size = UDim2.new(0, 140, 0, 180)
    petSlot.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    petSlot.BorderSizePixel = 3
    petSlot.BorderColor3 = rarityColors[petData.rarity] or Color3.fromRGB(255, 255, 255)
    petSlot.Parent = petContainer
    
    local slotCorner = Instance.new("UICorner")
    slotCorner.CornerRadius = UDim.new(0, 10)
    slotCorner.Parent = petSlot
    
    -- Equipped glow effect
    if petData.equipped then
        local equippedGlow = Instance.new("Frame")
        equippedGlow.Size = UDim2.new(1, 8, 1, 8)
        equippedGlow.Position = UDim2.new(0, -4, 0, -4)
        equippedGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        equippedGlow.BorderSizePixel = 0
        equippedGlow.ZIndex = 0
        equippedGlow.Parent = petSlot
        
        local glowCorner = Instance.new("UICorner")
        glowCorner.CornerRadius = UDim.new(0, 12)
        glowCorner.Parent = equippedGlow
    end
    
    -- Pet model display area
    local petDisplay = Instance.new("Frame")
    petDisplay.Size = UDim2.new(1, -10, 0, 80)
    petDisplay.Position = UDim2.new(0, 5, 0, 5)
    petDisplay.BackgroundColor3 = rarityColors[petData.rarity] or Color3.fromRGB(100, 100, 100)
    petDisplay.BorderSizePixel = 0
    petDisplay.Parent = petSlot
    
    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, 8)
    displayCorner.Parent = petDisplay
    
    -- Pet icon/emoji (placeholder for 3D model)
    local petIcon = Instance.new("TextLabel")
    petIcon.Size = UDim2.new(1, 0, 1, 0)
    petIcon.Position = UDim2.new(0, 0, 0, 0)
    petIcon.BackgroundTransparency = 1
    petIcon.Text = "🐕" -- Default dog emoji, could be customized per pet
    petIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    petIcon.TextScaled = true
    petIcon.Font = Enum.Font.SourceSans
    petIcon.Parent = petDisplay
    
    -- Pet name
    local petName = Instance.new("TextLabel")
    petName.Size = UDim2.new(1, -10, 0, 25)
    petName.Position = UDim2.new(0, 5, 0, 90)
    petName.BackgroundTransparency = 1
    petName.Text = petData.name
    petName.TextColor3 = Color3.fromRGB(255, 255, 255)
    petName.TextScaled = true
    petName.Font = Enum.Font.GothamBold
    petName.Parent = petSlot
    
    -- Pet rarity
    local petRarity = Instance.new("TextLabel")
    petRarity.Size = UDim2.new(1, -10, 0, 18)
    petRarity.Position = UDim2.new(0, 5, 0, 115)
    petRarity.BackgroundTransparency = 1
    petRarity.Text = petData.rarity
    petRarity.TextColor3 = rarityColors[petData.rarity]
    petRarity.TextScaled = true
    petRarity.Font = Enum.Font.GothamBold
    petRarity.Parent = petSlot
    
    -- Pet multiplier
    local petMultiplier = Instance.new("TextLabel")
    petMultiplier.Size = UDim2.new(1, -10, 0, 15)
    petMultiplier.Position = UDim2.new(0, 5, 0, 133)
    petMultiplier.BackgroundTransparency = 1
    petMultiplier.Text = "💰 " .. petData.multiplier .. "x Coins"
    petMultiplier.TextColor3 = Color3.fromRGB(255, 215, 0)
    petMultiplier.TextScaled = true
    petMultiplier.Font = Enum.Font.Gotham
    petMultiplier.Parent = petSlot
    
    -- Equip/Unequip button
    local actionButton = Instance.new("TextButton")
    actionButton.Name = "ActionButton"
    actionButton.Size = UDim2.new(1, -10, 0, 25)
    actionButton.Position = UDim2.new(0, 5, 1, -30)
    actionButton.BackgroundColor3 = petData.equipped and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 150, 50)
    actionButton.BorderSizePixel = 0
    actionButton.Text = petData.equipped and "❌ Unequip" or "✅ Equip"
    actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionButton.TextScaled = true
    actionButton.Font = Enum.Font.GothamBold
    actionButton.Parent = petSlot
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = actionButton
    
    -- Button click handler
    actionButton.MouseButton1Click:Connect(function()
        if petData.equipped then
            unequipPetEvent:FireServer(petData.id)
        else
            equipPetEvent:FireServer(petData.id)
        end
    end)
    
    return petSlot
end

-- Function to refresh inventory display
function PetInventoryGui.refreshInventory()
    -- Clear existing pets
    for _, child in pairs(petContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add player's actual pets
    for _, petData in pairs(playerPets) do
        PetInventoryGui.createPetSlot(petData)
    end
    
    -- Update canvas size
    gridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        petContainer.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 20)
    end)
    petContainer.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 20)
end

-- Function to request pet data from server
function PetInventoryGui.requestPetData()
    getPetDataEvent:FireServer()
end

-- Toggle inventory visibility
function PetInventoryGui.toggleInventory()
    inventoryFrame.Visible = not inventoryFrame.Visible
    if inventoryFrame.Visible then
        -- Close egg shop if open
        local eggShopGui = playerGui:FindFirstChild("EggShopGui")
        if eggShopGui and eggShopGui:FindFirstChild("ShopFrame") then
            eggShopGui.ShopFrame.Visible = false
        end
        PetInventoryGui.requestPetData()
    end
end

-- Function to close inventory (called from other scripts)
function PetInventoryGui.closeInventory()
    inventoryFrame.Visible = false
end

-- Close button handler
closeButton.MouseButton1Click:Connect(function()
    inventoryFrame.Visible = false
end)

-- Keyboard shortcut (P key for pets)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.P then
        PetInventoryGui.toggleInventory()
    end
end)

-- Handle receiving pet data from server
getPetDataEvent.OnClientEvent:Connect(function(serverPetData)
    playerPets = serverPetData or {}
    PetInventoryGui.refreshInventory()
    print("Updated pet inventory with " .. #playerPets .. " pets")
end)

-- Handle pet equip/unequip responses
equipPetEvent.OnClientEvent:Connect(function(success)
    if success then
        PetInventoryGui.requestPetData() -- Refresh data
    end
end)

unequipPetEvent.OnClientEvent:Connect(function(success)
    if success then
        PetInventoryGui.requestPetData() -- Refresh data
    end
end)

-- Handle new pets from hatching
hatchEggEvent.OnClientEvent:Connect(function(resultData)
    if resultData.success then
        PetInventoryGui.requestPetData() -- Refresh data after hatching
    end
end)

-- Initialize
PetInventoryGui.refreshInventory()

print("Pet Inventory GUI loaded! Press P to open/close inventory.")

return PetInventoryGui