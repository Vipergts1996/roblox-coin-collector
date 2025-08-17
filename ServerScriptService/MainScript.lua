-- DEBUG MODE SWITCH - Set to true for 4x orb values
local DEBUG_MODE = true

-- Core game systems
local GameManager = require(script.Parent.GameManager)
local CoinSpawner = require(script.Parent.CoinSpawner)
local SpeedShop = require(script.Parent.SpeedShop)
local SpeedController = require(script.Parent.SpeedController)
local SpeedEffects = require(script.Parent.SpeedEffects)
local TrailManager = require(script.Parent.TrailManager)
local NitroSystem = require(script.Parent.NitroSystem)
local RaceSystem = require(script.Parent.RaceSystem)

print("🎮 Initializing Roblox Coin Collector Game...")

-- Start core systems
GameManager.start()
CoinSpawner.start(DEBUG_MODE)
SpeedShop.start()
SpeedController.start()
SpeedEffects.start()
RaceSystem.start()

print("✅ Game fully initialized!")
print("🔥 Fire Trail System ready! Press T to open Trail Shop")
print("🚀 Nitro System ready! Press SHIFT to boost!")
print("🏁 Race System ready! Races every 60 seconds!")