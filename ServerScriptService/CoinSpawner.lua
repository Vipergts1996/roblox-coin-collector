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
    hitbox.Size = Vector3.new(12, 12, 12)
    hitbox.Position = position
    hitbox.Anchored = true
    hitbox.CanCollide = false
    hitbox.Transparency = 1
    hitbox.Parent = workspace
    
    local coin = Instance.new("Part")
    coin.Name = "CoinVisual"
    coin.Shape = Enum.PartType.Cylinder
    coin.Size = Vector3.new(0.2, 6, 6)
    coin.Position = position
    coin.Anchored = false
    coin.CanCollide = false
    coin.Material = Enum.Material.Neon
    coin.Parent = hitbox
    
    local coinValue = 1
    local lightColor = Color3.fromRGB(255, 215, 0)
    
    if coinType == "red" then
        coin.BrickColor = BrickColor.new("Bright red")
        coinValue = 2
        lightColor = Color3.fromRGB(255, 0, 0)
    elseif coinType == "blue" then
        coin.BrickColor = BrickColor.new("Bright blue")
        coinValue = 5
        lightColor = Color3.fromRGB(0, 100, 255)
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
    pointLight.Brightness = 2
    pointLight.Range = 10
    pointLight.Parent = coin
    
    local spinConnection = RunService.Heartbeat:Connect(function()
        if hitbox.Parent then
            hitbox.CFrame = hitbox.CFrame * CFrame.Angles(0, math.rad(2), 0)
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
    local y = 5
    
    return Vector3.new(x, y, z)
end

function CoinSpawner.getRandomCoinType()
    local rand = math.random(1, 100)
    if rand <= 10 then
        return "blue"
    elseif rand <= 40 then
        return "red"
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