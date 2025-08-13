local CoinCollector = require(script.Parent.CoinCollector)
local RunService = game:GetService("RunService")

local CoinSpawner = {}

local SPAWN_RATE = 2
local MAX_COINS = 20
local SPAWN_AREA_SIZE = 100
local coins = {}

function CoinSpawner.createCoin(position, coinType)
    coinType = coinType or "yellow"
    
    local hitbox = Instance.new("Part")
    hitbox.Name = "CoinHitbox"
    hitbox.Size = Vector3.new(4.2, 4.2, 4.2)
    hitbox.Position = position
    hitbox.Anchored = true
    hitbox.CanCollide = false
    hitbox.Transparency = 1
    hitbox.Parent = workspace
    
    local coin = Instance.new("Part")
    coin.Name = "CoinVisual"
    coin.Shape = Enum.PartType.Cylinder
    coin.Size = Vector3.new(0.08, 2.5, 2.5)
    coin.Position = position
    coin.Anchored = false
    coin.CanCollide = false
    coin.Material = Enum.Material.Neon
    coin.Parent = hitbox
    
    local coinValue = 1
    local lightColor = Color3.fromRGB(255, 215, 0)
    
    if coinType == "green" then
        coin.BrickColor = BrickColor.new("Bright green")
        coinValue = 2
        lightColor = Color3.fromRGB(100, 255, 100)
    elseif coinType == "blue" then
        coin.BrickColor = BrickColor.new("Bright blue")
        coinValue = 5
        lightColor = Color3.fromRGB(150, 200, 255)
    else
        coin.BrickColor = BrickColor.new("Bright yellow")
        coinValue = 1
        lightColor = Color3.fromRGB(255, 215, 0)
    end
    
    local coinValueData = Instance.new("IntValue")
    coinValueData.Name = "CoinValue"
    coinValueData.Value = coinValue
    coinValueData.Parent = hitbox
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hitbox
    weld.Part1 = coin
    weld.Parent = hitbox
    
    local pointLight = Instance.new("PointLight")
    pointLight.Color = lightColor
    pointLight.Brightness = 1.5
    pointLight.Range = 8
    pointLight.Parent = coin
    
    -- Create a glowing aura part
    local auraPart = Instance.new("Part")
    auraPart.Name = "CoinAura"
    auraPart.Shape = Enum.PartType.Ball
    auraPart.Size = Vector3.new(4.2, 4.2, 4.2)
    auraPart.Position = coin.Position
    auraPart.Anchored = false
    auraPart.CanCollide = false
    auraPart.Material = Enum.Material.Neon
    auraPart.BrickColor = coin.BrickColor
    auraPart.Transparency = 0.9
    auraPart.Parent = hitbox
    
    local auraWeld = Instance.new("WeldConstraint")
    auraWeld.Part0 = coin
    auraWeld.Part1 = auraPart
    auraWeld.Parent = hitbox
    
    -- Add a second smaller glow layer
    local innerGlow = Instance.new("Part")
    innerGlow.Name = "InnerGlow"
    innerGlow.Shape = Enum.PartType.Ball
    innerGlow.Size = Vector3.new(2.9, 2.9, 2.9)
    innerGlow.Position = coin.Position
    innerGlow.Anchored = false
    innerGlow.CanCollide = false
    innerGlow.Material = Enum.Material.Neon
    innerGlow.BrickColor = coin.BrickColor
    innerGlow.Transparency = 0.85
    innerGlow.Parent = hitbox
    
    local innerWeld = Instance.new("WeldConstraint")
    innerWeld.Part0 = coin
    innerWeld.Part1 = innerGlow
    innerWeld.Parent = hitbox
    
    local spinConnection = RunService.Heartbeat:Connect(function()
        if hitbox.Parent then
            hitbox.CFrame = hitbox.CFrame * CFrame.Angles(0, math.rad(5), 0)
        else
            spinConnection:Disconnect()
        end
    end)
    
    CoinCollector.setupCoin(hitbox)
    
    table.insert(coins, hitbox)
    
    hitbox.AncestryChanged:Connect(function()
        if not hitbox.Parent then
            for i, c in ipairs(coins) do
                if c == hitbox then
                    table.remove(coins, i)
                    break
                end
            end
            spinConnection:Disconnect()
        end
    end)
    
    return hitbox
end

function CoinSpawner.getRandomPosition()
    local x = math.random(-SPAWN_AREA_SIZE, SPAWN_AREA_SIZE)
    local z = math.random(-SPAWN_AREA_SIZE, SPAWN_AREA_SIZE)
    local y = 3
    
    return Vector3.new(x, y, z)
end

function CoinSpawner.getRandomCoinType()
    local rand = math.random(1, 100)
    if rand <= 10 then
        return "blue"
    elseif rand <= 40 then
        return "green"
    else
        return "yellow"
    end
end

function CoinSpawner.spawnCoin()
    if #coins < MAX_COINS then
        local position = CoinSpawner.getRandomPosition()
        local coinType = CoinSpawner.getRandomCoinType()
        CoinSpawner.createCoin(position, coinType)
    end
end

function CoinSpawner.start()
    spawn(function()
        while true do
            CoinSpawner.spawnCoin()
            wait(SPAWN_RATE)
        end
    end)
    
    for i = 1, 10 do
        local position = CoinSpawner.getRandomPosition()
        local coinType = CoinSpawner.getRandomCoinType()
        CoinSpawner.createCoin(position, coinType)
    end
    
    print("Coin spawner started!")
end

return CoinSpawner