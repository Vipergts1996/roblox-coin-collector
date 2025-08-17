local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local TrailShop = {}

local shopGui = nil
local isShopOpen = false
local playerTrails = {}
local equippedTrail = "Orange Fire"

print("TrailShop: Module loaded successfully!")

-- Initialize RemoteEvents as nil - they'll be found when needed
local purchaseTrailEvent = nil
local equipTrailEvent = nil
local getTrailDataEvent = nil

-- Function to safely get RemoteEvents when needed
local function getRemoteEvent(name)
    return ReplicatedStorage:FindFirstChild(name)
end

function TrailShop.createGui()
    if shopGui then
        shopGui:Destroy()
    end
    
    -- Main GUI
    shopGui = Instance.new("ScreenGui")
    shopGui.Name = "TrailShop"
    shopGui.Parent = playerGui
    
    -- Background blur
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.5
    background.BorderSizePixel = 0
    background.Parent = shopGui
    
    -- Main shop frame - automotive dashboard style
    local shopFrame = Instance.new("Frame")
    shopFrame.Name = "ShopFrame"
    shopFrame.Size = UDim2.new(0.8, 0, 0.8, 0) -- 80% of screen width and height
    shopFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center of screen
    shopFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    shopFrame.BackgroundColor3 = Color3.fromRGB(40, 35, 30) -- Dark brown/black like dashboard
    shopFrame.BorderSizePixel = 0
    shopFrame.Parent = background
    
    -- Automotive border effect
    local shopBorder = Instance.new("UIStroke")
    shopBorder.Thickness = 2
    shopBorder.Color = Color3.fromRGB(100, 100, 100) -- Metallic border
    shopBorder.Parent = shopFrame
    
    local shopCorner = Instance.new("UICorner")
    shopCorner.CornerRadius = UDim.new(0.02, 0) -- Less rounded for automotive look
    shopCorner.Parent = shopFrame
    
    -- Title - automotive dashboard style
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0) -- 10% of shop height
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Dark automotive gray
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "TRAIL SHOP"
    titleLabel.TextColor3 = Color3.fromRGB(255, 140, 0) -- Amber accent color
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.Highway -- Automotive font
    titleLabel.Parent = shopFrame
    
    -- Automotive border for title
    local titleBorder = Instance.new("UIStroke")
    titleBorder.Thickness = 1
    titleBorder.Color = Color3.fromRGB(80, 80, 80)
    titleBorder.Parent = titleLabel
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0.02, 0) -- Less rounded for automotive look
    titleCorner.Parent = titleLabel
    
    -- Close button - autoscales with screen size
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.12, 0, 0.8, 0) -- 12% width, 80% height of title
    closeButton.Position = UDim2.new(0.98, 0, 0.1, 0) -- Top right with small margin
    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.FredokaOne
    closeButton.Parent = titleLabel
    
    -- Add aspect ratio constraint for square close button
    local closeAspect = Instance.new("UIAspectRatioConstraint")
    closeAspect.AspectRatio = 1.0 -- Perfect square
    closeAspect.Parent = closeButton
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0.2, 0) -- 20% radius for proportional corners
    closeCorner.Parent = closeButton
    
    -- Coins display - automotive gauge style
    local coinsFrame = Instance.new("Frame")
    coinsFrame.Size = UDim2.new(0.35, 0, 0.08, 0) -- 35% width, 8% height
    coinsFrame.Position = UDim2.new(0.02, 0, 0.12, 0) -- 2% from left, 12% from top
    coinsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Dark background like odometer
    coinsFrame.BorderSizePixel = 0
    coinsFrame.Parent = shopFrame
    
    -- Automotive border for coins
    local coinsBorder = Instance.new("UIStroke")
    coinsBorder.Thickness = 1
    coinsBorder.Color = Color3.fromRGB(80, 80, 80)
    coinsBorder.Parent = coinsFrame
    
    local coinsCorner = Instance.new("UICorner")
    coinsCorner.CornerRadius = UDim.new(0.05, 0) -- Less rounded for automotive look
    coinsCorner.Parent = coinsFrame
    
    local coinsLabel = Instance.new("TextLabel")
    coinsLabel.Name = "CoinsLabel"
    coinsLabel.Size = UDim2.new(1, 0, 1, 0)
    coinsLabel.Position = UDim2.new(0, 0, 0, 0)
    coinsLabel.BackgroundTransparency = 1
    coinsLabel.Text = "💰 0 Coins"
    coinsLabel.TextColor3 = Color3.fromRGB(255, 140, 0) -- Amber color
    coinsLabel.TextScaled = true
    coinsLabel.Font = Enum.Font.Highway -- Automotive font
    coinsLabel.Parent = coinsFrame
    
    -- Current trail display - automotive gauge style
    local currentFrame = Instance.new("Frame")
    currentFrame.Size = UDim2.new(0.35, 0, 0.08, 0) -- 35% width, 8% height
    currentFrame.Position = UDim2.new(0.98, 0, 0.12, 0) -- 2% from right, 12% from top
    currentFrame.AnchorPoint = Vector2.new(1, 0)
    currentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Dark background like odometer
    currentFrame.BorderSizePixel = 0
    currentFrame.Parent = shopFrame
    
    -- Automotive border for current trail
    local currentBorder = Instance.new("UIStroke")
    currentBorder.Thickness = 1
    currentBorder.Color = Color3.fromRGB(80, 80, 80)
    currentBorder.Parent = currentFrame
    
    local currentCorner = Instance.new("UICorner")
    currentCorner.CornerRadius = UDim.new(0.05, 0) -- Less rounded for automotive look
    currentCorner.Parent = currentFrame
    
    local currentLabel = Instance.new("TextLabel")
    currentLabel.Name = "CurrentLabel"
    currentLabel.Size = UDim2.new(1, 0, 1, 0)
    currentLabel.Position = UDim2.new(0, 0, 0, 0)
    currentLabel.BackgroundTransparency = 1
    currentLabel.Text = "Current: Orange Fire"
    currentLabel.TextColor3 = Color3.fromRGB(255, 140, 0) -- Amber color
    currentLabel.TextScaled = true
    currentLabel.Font = Enum.Font.Highway -- Automotive font
    currentLabel.Parent = currentFrame
    
    -- Scroll frame for trails - automotive dashboard style
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(0.96, 0, 0.75, 0) -- 96% width, 75% height
    scrollFrame.Position = UDim2.new(0.02, 0, 0.22, 0) -- 2% from left, 22% from top
    scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 25, 20) -- Darker housing like odometer
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 12 -- Thicker for mobile
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    scrollFrame.Parent = shopFrame
    
    -- Automotive border for scroll area
    local scrollBorder = Instance.new("UIStroke")
    scrollBorder.Thickness = 1
    scrollBorder.Color = Color3.fromRGB(40, 40, 40)
    scrollBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    scrollBorder.Parent = scrollFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0.02, 0) -- Less rounded for automotive look
    scrollCorner.Parent = scrollFrame
    
    -- Grid layout for trails - mobile optimized
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0.48, 0, 0, 100) -- 48% width per cell, smaller height for mobile
    gridLayout.CellPadding = UDim2.new(0.01, 0, 0, 8) -- Smaller padding for mobile
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.Parent = scrollFrame
    
    local gridPadding = Instance.new("UIPadding")
    gridPadding.PaddingTop = UDim.new(0.02, 0) -- 2% padding
    gridPadding.PaddingBottom = UDim.new(0.02, 0)
    gridPadding.PaddingLeft = UDim.new(0.02, 0)
    gridPadding.PaddingRight = UDim.new(0.02, 0)
    gridPadding.Parent = scrollFrame
    
    -- Add loading message that shows immediately
    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Name = "LoadingLabel"
    loadingLabel.Size = UDim2.new(1, 0, 0, 100)
    loadingLabel.Position = UDim2.new(0, 0, 0, 50)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.Text = "Loading trails..."
    loadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingLabel.TextScaled = true
    loadingLabel.Font = Enum.Font.GothamBold
    loadingLabel.Parent = scrollFrame
    
    -- Event connections
    closeButton.MouseButton1Click:Connect(function()
        TrailShop.closeShop()
    end)
    
    -- Background click removed - Frames don't have MouseButton1Click
    
    -- Shop frame click removed - Frames don't have MouseButton1Click
    
    shopGui.Enabled = false
    return shopGui
end

function TrailShop.createTrailCard(trailData, index, allTrails, playerData)
    local background = shopGui:GetChildren()[1]
    local shopFrame = background:FindFirstChild("ShopFrame")
    local scrollFrame = shopFrame and shopFrame:FindFirstChild("ScrollingFrame")
    if not scrollFrame then return end
    
    -- Use provided playerData or fall back to global variables
    local currentPlayerTrails = playerData and playerData.trails or playerTrails
    local currentEquippedTrail = playerData and playerData.equipped or equippedTrail
    
    -- Trail card frame - automotive themed
    local cardFrame = Instance.new("Frame")
    cardFrame.Name = trailData.name
    cardFrame.Size = UDim2.new(0, 200, 0, 120) -- Grid layout will override this
    cardFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Dark automotive gray
    cardFrame.BorderSizePixel = 0 -- Remove fixed border
    cardFrame.LayoutOrder = index
    cardFrame.Parent = scrollFrame
    
    -- Add automotive border using UIStroke
    local cardBorder = Instance.new("UIStroke")
    cardBorder.Thickness = 1
    cardBorder.Parent = cardFrame
    
    -- Check if trail is unlocked or if it's the next in sequence
    local isUnlocked = currentPlayerTrails[trailData.name] ~= nil
    local isNextInSequence = TrailShop.isNextTrailInSequence(trailData.name, allTrails, currentPlayerTrails)
    local isEquipped = currentEquippedTrail == trailData.name
    
    if isEquipped then
        cardBorder.Color = Color3.fromRGB(0, 255, 0) -- Green for equipped
    elseif isUnlocked then
        cardBorder.Color = Color3.fromRGB(100, 100, 100) -- Gray for unlocked
    elseif isNextInSequence then
        cardBorder.Color = Color3.fromRGB(255, 140, 0) -- Amber for purchasable (automotive color)
    else
        cardBorder.Color = Color3.fromRGB(200, 50, 50) -- Red for locked
    end
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0.02, 0) -- Less rounded for automotive look
    cardCorner.Parent = cardFrame
    
    -- Trail name - automotive style
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.25, 0) -- 25% of card height
    nameLabel.Position = UDim2.new(0, 0, 0.02, 0) -- 2% from top
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = trailData.name
    nameLabel.TextColor3 = trailData.color1
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.Highway -- Automotive font
    nameLabel.Parent = cardFrame
    
    -- Coin multiplier - automotive style
    local multiplierLabel = Instance.new("TextLabel")
    multiplierLabel.Size = UDim2.new(1, 0, 0.2, 0) -- 20% of card height
    multiplierLabel.Position = UDim2.new(0, 0, 0.28, 0) -- Below name
    multiplierLabel.BackgroundTransparency = 1
    local multiplierValue = trailData.coinMultiplier or trailData.speedBoost or 1.0
    multiplierLabel.Text = "Coins: " .. multiplierValue .. "x"
    multiplierLabel.TextColor3 = Color3.fromRGB(255, 140, 0) -- Amber automotive color
    multiplierLabel.TextScaled = true
    multiplierLabel.Font = Enum.Font.Highway -- Automotive font
    multiplierLabel.Parent = cardFrame
    
    -- Price - automotive style
    local priceLabel = Instance.new("TextLabel")
    priceLabel.Size = UDim2.new(1, 0, 0.2, 0) -- 20% of card height
    priceLabel.Position = UDim2.new(0, 0, 0.5, 0) -- Middle of card
    priceLabel.BackgroundTransparency = 1
    priceLabel.Text = trailData.price == 0 and "FREE" or (trailData.price .. " Coins")
    priceLabel.TextColor3 = Color3.fromRGB(255, 140, 0) -- Amber automotive color
    priceLabel.TextScaled = true
    priceLabel.Font = Enum.Font.Highway -- Automotive font
    priceLabel.Parent = cardFrame
    
    -- Action button - automotive style
    local actionButton = Instance.new("TextButton")
    actionButton.Size = UDim2.new(0.9, 0, 0.25, 0) -- 90% width, 25% height of card
    actionButton.Position = UDim2.new(0.05, 0, 0.72, 0) -- Bottom area with small margins
    actionButton.BorderSizePixel = 0
    actionButton.TextScaled = true
    actionButton.Font = Enum.Font.Highway -- Automotive font
    actionButton.Parent = cardFrame
    
    -- Automotive button border
    local buttonBorder = Instance.new("UIStroke")
    buttonBorder.Thickness = 1
    buttonBorder.Color = Color3.fromRGB(80, 80, 80)
    buttonBorder.Parent = actionButton
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.05, 0) -- Less rounded for automotive look
    buttonCorner.Parent = actionButton
    
    if isEquipped then
        actionButton.Text = "EQUIPPED"
        actionButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif isUnlocked then
        actionButton.Text = "EQUIP"
        actionButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        -- Connecting EQUIP button
        if actionButton:IsA("TextButton") then
            actionButton.MouseButton1Click:Connect(function()
                -- Equip animation - button press effect
                local clickTween = TweenService:Create(actionButton,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0.85, 0, 0.22, 0)} -- Shrink slightly
                )
                local returnTween = TweenService:Create(actionButton,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0.9, 0, 0.25, 0)} -- Return to normal
                )
                
                clickTween:Play()
                clickTween.Completed:Connect(function()
                    returnTween:Play()
                end)
                
                -- Card glow effect while equipping
                local equipGlow = Instance.new("UIStroke")
                equipGlow.Name = "EquipGlow"
                equipGlow.Thickness = 3
                equipGlow.Color = Color3.fromRGB(0, 255, 0) -- Green glow
                equipGlow.Transparency = 0.5
                equipGlow.Parent = cardFrame
                
                -- Pulsing glow animation
                local pulseTween = TweenService:Create(equipGlow,
                    TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 3, true),
                    {Transparency = 0.9}
                )
                pulseTween:Play()
                
                -- Remove glow after animation
                spawn(function()
                    wait(1.5)
                    if equipGlow and equipGlow.Parent then
                        equipGlow:Destroy()
                    end
                end)
                
                equipTrailEvent = getRemoteEvent("EquipTrail")
                if equipTrailEvent then
                    equipTrailEvent:FireServer(trailData.name)
                else
                    print("TrailShop: equipTrailEvent not found!")
                end
            end)
        else
            print("TrailShop: ERROR - actionButton is not a TextButton, it's a", actionButton.ClassName)
        end
    elseif isNextInSequence then
        actionButton.Text = "PURCHASE"
        actionButton.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
        actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        -- Connecting PURCHASE button
        if actionButton:IsA("TextButton") then
            actionButton.MouseButton1Click:Connect(function()
                -- Purchase animation - button press effect
                local clickTween = TweenService:Create(actionButton,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0.85, 0, 0.22, 0)} -- Shrink slightly
                )
                local returnTween = TweenService:Create(actionButton,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0.9, 0, 0.25, 0)} -- Return to normal
                )
                
                clickTween:Play()
                clickTween.Completed:Connect(function()
                    returnTween:Play()
                end)
                
                -- Card purchase glow effect
                local purchaseGlow = Instance.new("UIStroke")
                purchaseGlow.Name = "PurchaseGlow"
                purchaseGlow.Thickness = 4
                purchaseGlow.Color = Color3.fromRGB(255, 140, 0) -- Amber glow
                purchaseGlow.Transparency = 0.3
                purchaseGlow.Parent = cardFrame
                
                -- Expanding glow animation
                local expandTween = TweenService:Create(purchaseGlow,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Thickness = 8, Transparency = 0.8}
                )
                expandTween:Play()
                
                -- Remove glow after animation
                spawn(function()
                    wait(1)
                    if purchaseGlow and purchaseGlow.Parent then
                        purchaseGlow:Destroy()
                    end
                end)
                
                purchaseTrailEvent = getRemoteEvent("PurchaseTrail")
                if purchaseTrailEvent then
                    purchaseTrailEvent:FireServer(trailData.name)
                else
                    print("TrailShop: purchaseTrailEvent not found!")
                end
            end)
        else
            print("TrailShop: ERROR - actionButton is not a TextButton, it's a", actionButton.ClassName)
        end
    else
        actionButton.Text = "LOCKED"
        actionButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        actionButton.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

function TrailShop.isNextTrailInSequence(trailName, trails, currentPlayerTrails)
    if not trails then return false end
    
    local checkPlayerTrails = currentPlayerTrails or playerTrails
    
    -- Find the next trail that the player doesn't own
    for i, trail in ipairs(trails) do
        if not checkPlayerTrails[trail.name] then
            -- This is the next trail they can purchase
            return trail.name == trailName
        end
    end
    
    return false -- All trails owned
end

function TrailShop.updateShop(trails, playerData)
    print("TrailShop: Updating shop with", #trails, "trails")
    playerTrails = playerData.trails or {}
    equippedTrail = playerData.equipped or "Orange Fire"
    print("TrailShop: Player trails:", playerTrails)
    print("TrailShop: Equipped trail:", equippedTrail)
    
    -- Update coins and current trail displays
    local background = shopGui:GetChildren()[1]
    local shopFrame = background:FindFirstChild("ShopFrame")
    if shopFrame then
        -- Find and update coins label
        for _, child in pairs(shopFrame:GetChildren()) do
            local coinsLabel = child:FindFirstChild("CoinsLabel")
            if coinsLabel then
                coinsLabel.Text = "💰 " .. (playerData.coins or 0) .. " Coins"
                break
            end
        end
        
        -- Find and update current trail label
        for _, child in pairs(shopFrame:GetChildren()) do
            local currentLabel = child:FindFirstChild("CurrentLabel")
            if currentLabel then
                currentLabel.Text = "Current: " .. equippedTrail
                break
            end
        end
    end
    
    -- Clear existing trail cards and loading message
    local background = shopGui:GetChildren()[1]
    local shopFrame = background:FindFirstChild("ShopFrame")
    local scrollFrame = shopFrame and shopFrame:FindFirstChild("ScrollingFrame")
    if scrollFrame then
        for _, child in pairs(scrollFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        -- Create trail cards
        print("TrailShop: Creating", #trails, "trail cards")
        for i, trail in ipairs(trails) do
            print("TrailShop: Creating card for", trail.name)
            TrailShop.createTrailCard(trail, i, trails, playerData)
        end
        
        -- Update canvas size
        local gridLayout = scrollFrame:FindFirstChild("UIGridLayout")
        if gridLayout then
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y + 20)
        end
    end
end

function TrailShop.openShop()
    print("TrailShop: openShop() called")
    
    if not shopGui then
        print("TrailShop: Creating GUI...")
        TrailShop.createGui()
    end
    
    if not shopGui then
        print("TrailShop: ERROR - GUI creation failed!")
        return
    end
    
    isShopOpen = true
    shopGui.Enabled = true
    
    print("TrailShop: Shop opened with loading message")
    
    -- Set up event listeners if not already done
    TrailShop.setupEventListeners()
    
    -- Try to get the RemoteEvent and send request
    getTrailDataEvent = getRemoteEvent("GetTrailData")
    if getTrailDataEvent then
        getTrailDataEvent:FireServer()
        print("TrailShop: Sent request to server")
    else
        print("TrailShop: GetTrailData RemoteEvent not found yet")
    end
    
    -- Animate in - using scale-based sizing
    local background = shopGui:GetChildren()[1] -- Get the background frame
    local shopFrame = background:FindFirstChild("ShopFrame")
    if shopFrame then
        shopFrame.Size = UDim2.new(0, 0, 0, 0)
        shopFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        shopFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local openTween = TweenService:Create(shopFrame, tweenInfo, {
            Size = UDim2.new(0.8, 0, 0.8, 0) -- Animate to final autoscaled size
        })
        openTween:Play()
    else
        print("TrailShop: ShopFrame not found!")
        print("TrailShop: Available children:", shopGui:GetChildren())
    end
end

function TrailShop.closeShop()
    if not isShopOpen then return end
    
    isShopOpen = false
    
    -- Animate out - using scale-based sizing
    local background = shopGui:GetChildren()[1] -- Get the background frame
    local shopFrame = background:FindFirstChild("ShopFrame")
    if shopFrame then
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local closeTween = TweenService:Create(shopFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0)
        })
        
        closeTween:Play()
        closeTween.Completed:Connect(function()
            shopGui.Enabled = false
        end)
    else
        shopGui.Enabled = false
    end
end


function TrailShop.toggleShop()
    if isShopOpen then
        TrailShop.closeShop()
    else
        TrailShop.openShop()
    end
end

local eventListenersSetup = false
function TrailShop.setupEventListeners()
    if eventListenersSetup then return end
    eventListenersSetup = true
    
    print("TrailShop: Setting up event listeners...")
    
    -- Set up listeners in spawn threads so they don't block
    spawn(function()
        getTrailDataEvent = getTrailDataEvent or ReplicatedStorage:WaitForChild("GetTrailData", 30)
        if getTrailDataEvent then
            getTrailDataEvent.OnClientEvent:Connect(function(trails, playerData)
            print("TrailShop: Received data from server")
            print("TrailShop: Trails count:", #trails)
            print("TrailShop: Player data:", playerData)
            
            -- Debug: Print first trail data to see structure
            if trails and #trails > 0 then
                print("TrailShop: First trail data:", trails[1])
                for key, value in pairs(trails[1]) do
                    print("TrailShop: Trail property:", key, "=", value)
                end
            end
            
            if isShopOpen and shopGui then
                TrailShop.updateShop(trails, playerData)
            else
                print("TrailShop: Shop not open or GUI not created")
            end
            end)
        end
    end)
    
    spawn(function()
        purchaseTrailEvent = purchaseTrailEvent or ReplicatedStorage:WaitForChild("PurchaseTrail", 30)
        if purchaseTrailEvent then
            purchaseTrailEvent.OnClientEvent:Connect(function(success, message)
            if success then
                -- Refresh shop data
                if getTrailDataEvent then
                    getTrailDataEvent:FireServer()
                end
            else
                -- Show error message
                print("Purchase failed:", message)
            end
            end)
        end
    end)
    
    spawn(function()
        equipTrailEvent = equipTrailEvent or ReplicatedStorage:WaitForChild("EquipTrail", 30)
        if equipTrailEvent then
            equipTrailEvent.OnClientEvent:Connect(function(success, trailName)
            if success then
                equippedTrail = trailName
                -- Refresh shop data
                if getTrailDataEvent then
                    getTrailDataEvent:FireServer()
                end
            end
            end)
        end
    end)
    
    print("TrailShop: Event listeners set up successfully!")
end

-- Shop opens via button click only
-- Event listeners are set up when shop is first opened

-- GUI will be created when first needed

return TrailShop