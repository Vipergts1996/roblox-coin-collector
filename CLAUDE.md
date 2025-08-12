# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Roblox coin collection game with an upgrade shop system. Players collect coins scattered around a map and spend them on speed and jump upgrades.

## Architecture

### Core Game Loop
1. **MainScript.lua** - Entry point that initializes all game systems
2. **GameManager** - Handles player lifecycle and leaderstats setup
3. **CoinSpawner** - Manages coin generation with probability-based spawning
4. **CoinCollector** - Handles coin collection logic and player rewards
5. **SpeedShop** - Server-side upgrade purchasing and stat management
6. **ShopGui** - Client-side shop interface and display updates
7. **CoinDisplay** - Real-time coin counter GUI

### Script Types and Location Requirements
- **MainScript.lua** must be a Server Script (green icon) in ServerScriptService
- **GameManager.lua, CoinSpawner.lua, CoinCollector.lua, SpeedShop.lua** must be ModuleScripts (blue icon) in ServerScriptService  
- **ShopGui.lua, CoinDisplay.lua** must be LocalScripts (yellow icon) in StarterPlayerScripts

### Coin System
- **Yellow coins** (60% spawn rate): Worth 1 coin
- **Red coins** (30% spawn rate): Worth 2 coins  
- **Blue coins** (10% spawn rate): Worth 5 coins
- Coins use invisible 12x12x12 hitboxes for collection detection
- Each coin stores its value in a CoinValue IntValue

### Player Stats & Upgrades
- **Speed upgrades**: Start at level 1 (16 walkspeed), +4 per level, cost: 10 + (level-1)*5 coins
- **Jump upgrades**: Start at level 1 (50 jumppower), +20 per level, cost: 15 + (level-1)*8 coins  
- Levels start at 1 and increment by 1 per purchase
- Stats update immediately via RemoteEvents (PurchaseSpeedUpgrade, PurchaseJumpUpgrade)

### Client-Server Communication
- Uses ReplicatedStorage RemoteEvents for upgrade purchases
- Client GUI updates automatically when leaderstats change
- Shop opens with "B" key or clicking shop button

### Known Issues to Watch For
- Coin collection can fail if hair/accessories touch coins - the code searches up parent hierarchy to find character
- Ensure proper script types in Roblox Studio or the game won't start
- Self-touch detection prevents coins from triggering on their own parts

## Development Notes

When adding new features:
- New upgrade types should follow the pattern in SpeedShop.lua with separate RemoteEvents
- Coin modifications should update both CoinSpawner (creation) and CoinCollector (collection logic)
- GUI changes require updates to both display logic and update functions in ShopGui.lua
- Always test coin collection with different character accessories/clothing items