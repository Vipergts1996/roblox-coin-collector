-- DEBUG MODE SWITCH - Set to true for 4x orb values
local DEBUG_MODE = true

-- Core game systems
local GameManager = require(script.Parent.GameManager)
local CoinSpawner = require(script.Parent.CoinSpawner)
local SpeedShop = require(script.Parent.SpeedShop)
local SpeedController = require(script.Parent.SpeedController)
local SpeedEffects = require(script.Parent.SpeedEffects)

print("🎮 Initializing Roblox Coin Collector Game...")

-- Start core systems
GameManager.start()
CoinSpawner.start(DEBUG_MODE)
SpeedShop.start()
SpeedController.start()
SpeedEffects.start()

print("✅ Game fully initialized!")