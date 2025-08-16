local TrailData = {}
-- Updated with coin multipliers instead of speed boosts

TrailData.Trails = {
    ["Orange Fire"] = {
        order = 1,
        price = 0, -- Free starter trail
        coinMultiplier = 1.0, -- No multiplier for default (1.0x)
        unlocked = true, -- Always unlocked
        color1 = Color3.fromRGB(255, 140, 0), -- Orange
        color2 = Color3.fromRGB(255, 69, 0), -- Red-orange
        particle = "Fire"
    },
    
    ["Blue Flame"] = {
        order = 2,
        price = 100,
        coinMultiplier = 1.1, -- +0.1x coin multiplier
        unlocked = false,
        color1 = Color3.fromRGB(0, 191, 255), -- Deep sky blue
        color2 = Color3.fromRGB(30, 144, 255), -- Dodger blue
        particle = "Fire"
    },
    
    ["Green Blaze"] = {
        order = 3,
        price = 250,
        coinMultiplier = 1.2, -- +0.2x coin multiplier
        unlocked = false,
        color1 = Color3.fromRGB(50, 205, 50), -- Lime green
        color2 = Color3.fromRGB(0, 255, 0), -- Pure green
        particle = "Fire"
    },
    
    ["Purple Inferno"] = {
        order = 4,
        price = 500,
        coinMultiplier = 1.3, -- +0.3x coin multiplier
        unlocked = false,
        color1 = Color3.fromRGB(138, 43, 226), -- Blue violet
        color2 = Color3.fromRGB(147, 0, 211), -- Dark violet
        particle = "Fire"
    },
    
    ["Pink Phoenix"] = {
        order = 5,
        price = 1000,
        coinMultiplier = 1.4, -- +0.4x coin multiplier
        unlocked = false,
        color1 = Color3.fromRGB(255, 20, 147), -- Deep pink
        color2 = Color3.fromRGB(255, 105, 180), -- Hot pink
        particle = "Fire"
    },
    
    ["Golden Burst"] = {
        order = 6,
        price = 2000,
        coinMultiplier = 1.5, -- +0.5x coin multiplier
        unlocked = false,
        color1 = Color3.fromRGB(255, 215, 0), -- Gold
        color2 = Color3.fromRGB(255, 223, 0), -- Gold yellow
        particle = "Fire"
    },
    
    ["Ice Crystal"] = {
        order = 7,
        price = 4000,
        coinMultiplier = 1.6, -- +0.6x coin multiplier
        unlocked = false,
        color1 = Color3.fromRGB(173, 216, 230), -- Light blue
        color2 = Color3.fromRGB(135, 206, 250), -- Light sky blue
        particle = "Sparkles"
    },
    
    ["Rainbow Comet"] = {
        order = 8,
        price = 8000,
        coinMultiplier = 1.7, -- +0.7x coin multiplier
        unlocked = false,
        color1 = Color3.fromRGB(255, 0, 255), -- Magenta
        color2 = Color3.fromRGB(0, 255, 255), -- Cyan
        particle = "Fire"
    },
    
    ["Dark Matter"] = {
        order = 9,
        price = 15000,
        coinMultiplier = 1.8, -- +0.8x coin multiplier
        unlocked = false,
        color1 = Color3.fromRGB(75, 0, 130), -- Indigo
        color2 = Color3.fromRGB(25, 25, 112), -- Midnight blue
        particle = "Fire"
    },
    
    ["Divine Light"] = {
        order = 10,
        price = 30000,
        coinMultiplier = 1.9, -- +0.9x coin multiplier
        unlocked = false,
        color1 = Color3.fromRGB(255, 255, 255), -- Pure white
        color2 = Color3.fromRGB(255, 255, 224), -- Light yellow
        particle = "Sparkles"
    }
}

function TrailData.getTrailsSorted()
    local trails = {}
    for name, data in pairs(TrailData.Trails) do
        local trailInfo = {}
        for key, value in pairs(data) do
            trailInfo[key] = value
        end
        trailInfo.name = name
        table.insert(trails, trailInfo)
    end
    
    table.sort(trails, function(a, b)
        return a.order < b.order
    end)
    
    return trails
end

return TrailData