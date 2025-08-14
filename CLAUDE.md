# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Roblox orb collection game with an upgrade shop system and comprehensive pet system. Players collect orbs scattered around a map, spend coins on speed and jump upgrades, and hatch pets from eggs that auto-collect coins with multiplier bonuses.

## Architecture

### Core Game Loop
1. **MainScript.lua** - Entry point that initializes all game systems
2. **GameManager** - Handles player lifecycle and leaderstats setup
3. **CoinSpawner** - Manages orb generation with probability-based spawning
4. **CoinCollector** - Handles orb collection logic and player rewards
5. **SpeedShop** - Server-side upgrade purchasing and stat management
6. **SpeedController** - Progressive speed acceleration system
7. **SpeedEffects** - Visual speed effects (trails, particles, smoke)
8. **PetSystem/** - Complete modular pet management system (see Pet System section)
9. **ShopGui** - Client-side shop interface and display updates
10. **CoinDisplay** - Real-time coin counter GUI

### Script Types and Location Requirements
- **MainScript.lua** must be a Server Script (green icon) in ServerScriptService
- **GameManager.lua, CoinSpawner.lua, CoinCollector.lua, SpeedShop.lua, SpeedController.lua, SpeedEffects.lua** must be ModuleScripts (blue icon) in ServerScriptService
- **PetSystem/** folder contains modular pet system (see Pet System Architecture)
- **ShopGui.lua, CoinDisplay.lua** must be LocalScripts (yellow icon) in StarterPlayerScripts
- **PetGuis/** folder contains pet-related client scripts (see Pet System Architecture)

## Pet System Architecture

### Server-Side Structure (ServerScriptService/PetSystem/)
```
PetSystem/
├── init.lua          -- Main pet system initializer
├── PetData.lua       -- Pet data, rarities, egg configurations
├── PetLogic.lua      -- Core pet logic (equip/unequip/hatching)
└── PetFollower.lua   -- Pet following mechanics and coin collection
```

### Client-Side Structure (StarterPlayerScripts/PetGuis/)
```
PetGuis/
├── init.lua          -- GUI system initializer
├── PetInventory.lua  -- Pet inventory interface
└── EggShop.lua       -- Egg shop interface
```

### Pet System Features
- **12 Different Pets** across 6 rarity tiers (Common → Mythic)
- **Egg System**: 4 egg types with weighted random pet selection
- **Auto-Collection**: Pets follow behind player and auto-collect coins
- **Multiplier System**: Equipped pets multiply coin collection (1.1x to 6.0x)
- **Pet Inventory**: Grid-based UI with equip/unequip functionality
- **Real-time Updates**: Immediate GUI refresh on pet changes
- **Auto-closing GUIs**: Pet inventory and egg shop don't overlap

### Pet Data Structure
```lua
-- Pet rarities and their colors
Common (Gray) → Uncommon (Green) → Rare (Blue) → Epic (Purple) → Legendary (Orange) → Mythic (Red)

-- Egg pricing and probabilities
BasicEgg: 500 coins (Common pets)
ForestEgg: 2,000 coins (Common/Uncommon mix)
MysticEgg: 10,000 coins (Rare/Epic pets)
LegendaryEgg: 50,000 coins (Epic/Legendary/Mythic pets)
```

### Orb System
- **Yellow orbs** (60% spawn rate): Worth 1 coin
- **Green orbs** (30% spawn rate): Worth 2 coins  
- **Blue orbs** (10% spawn rate): Worth 5 coins
- Orbs use invisible 4.2x4.2x4.2 hitboxes for collection detection
- Each orb stores its value in a CoinValue IntValue
- **Pet Auto-Collection**: Pets collect coins within 15 studs with multiplier bonuses

### Player Stats & Upgrades
- **Speed upgrades**: Start at level 1 (16 walkspeed), +4 per level, cost: 10 + (level-1)*5 coins
- **Jump upgrades**: Start at level 1 (50 jumppower), +20 per level, cost: 15 + (level-1)*8 coins  
- Levels start at 1 and increment by 1 per purchase
- Stats update immediately via RemoteEvents (PurchaseSpeedUpgrade, PurchaseJumpUpgrade)

### Client-Server Communication
- Uses ReplicatedStorage RemoteEvents for upgrade purchases
- Client GUI updates automatically when leaderstats change
- Two upgrade buttons permanently displayed at bottom center of screen

### Known Issues to Watch For
- Orb collection can fail if hair/accessories touch orbs - the code searches up parent hierarchy to find character
- Ensure proper script types in Roblox Studio or the game won't start
- Self-touch detection prevents orbs from triggering on their own parts

## Development Notes

When adding new features:
- New upgrade types should follow the pattern in SpeedShop.lua with separate RemoteEvents
- Orb modifications should update both CoinSpawner (creation) and CoinCollector (collection logic)
- GUI changes require updates to both display logic and update functions in ShopGui.lua
- Always test orb collection with different character accessories/clothing items

### Pet System Development:
- **Adding new pets**: Update PetData.lua with pet info and egg probabilities
- **New egg types**: Add to PetData.Eggs with pricing and pet selection
- **Pet model improvements**: Replace createPetModel() function with better Asset IDs
- **GUI modifications**: Update PetInventory.lua and EggShop.lua for new features
- **Collection mechanics**: Modify PetFollower.lua for different collection behaviors

### Modular Architecture Benefits:
- **Clean organization**: All pet functionality contained in PetSystem/ folder
- **Easy maintenance**: Each module has a specific responsibility
- **Simple initialization**: Single `PetSystem.start()` call in MainScript
- **Reusable**: Entire PetSystem folder can be copied to other projects
- **Scalable**: Easy to add new pet features without cluttering main game code