local module = {
	
	ColorRarity = {
		["Common"] = Color3.fromRGB(255, 255, 255);
		["Rare"] = Color3.fromRGB(85, 170, 0);
		["Epic"] = Color3.fromRGB(170, 85, 255);
		["Legendary"] = Color3.fromRGB(255, 170, 0);
		["Mythical"] = Color3.fromRGB(255, 0, 0);
		["Exclusive"] = Color3.fromRGB(0, 170, 255);
	};

	RarityEgg = {
		["Common"] = {Color3.fromRGB(255, 255, 255), Color3.fromRGB(132, 132, 132)};
		["Rare"] = {Color3.fromRGB(85, 170, 0), Color3.fromRGB(42, 84, 0)};
		["Epic"] = {Color3.fromRGB(170, 85, 255), Color3.fromRGB(77, 38, 115)};
		["Legendary"] = {Color3.fromRGB(255, 170, 0), Color3.fromRGB(108, 72, 0)};
		["Mythical"] = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(116, 0, 0)};
		["Exclusive"] = {Color3.fromRGB(0, 170, 255), Color3.fromRGB(0, 77, 115)};
	};
	
	IdIcons = {
		Power = {"rbxassetid://13624950049"};
	};
	
	Pets = {
		["Basic Cat"] = {
			PowerBoost = 1.05; 
			Rarity = "Common";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Basic Dog"] = {
			PowerBoost = 1.05; 
			Rarity = "Rare";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Basic Golem"] = {
			PowerBoost = 1.15; 
			Rarity = "Epic";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Green Dragon"] = {
			PowerBoost = 4; 
			Rarity = "Exclusive";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Dominus"] = {
			PowerBoost = 50; 
			Rarity = "Exclusive";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Basic Camel"] = {
			PowerBoost = 1.5; 
			Rarity = "Common";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Basic Spider"] = {
			PowerBoost = 1.65; 
			Rarity = "Rare";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Basic Slime"] = {
			PowerBoost = 1.80; 
			Rarity = "Epic";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;

		};

		["Basic Panda"] = {
			PowerBoost = 2.75; 
			Rarity = "Common";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Basic Bear"] = {
			PowerBoost = 3.1; 
			Rarity = "Rare";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Basic Pig"] = {
			PowerBoost = 3.75; 
			Rarity = "Epic";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;	
		};

		["Fish Orange"] = {
			PowerBoost = 2; 
			Rarity = "Common";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Fish Green"] = {
			PowerBoost = 2.3; 
			Rarity = "Rare";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Shark"] = {
			PowerBoost = 2.55; 
			Rarity = "Epic";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;

		};

		["Lava Cat"] = {
			PowerBoost = 4; 
			Rarity = "Common";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Lava Dog"] = {
			PowerBoost = 4.3; 
			Rarity = "Rare";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Lava Camel"] = {
			PowerBoost = 4.75; 
			Rarity = "Epic";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Polar Bear"] = {
			PowerBoost = 4; 
			Rarity = "Common";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Black Bear"] = {
			PowerBoost = 4.3; 
			Rarity = "Rare";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Basic Deer"] = {
			PowerBoost = 4.75; 
			Rarity = "Epic";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};

		["Explosive Hydro"] = {
			PowerBoost = 10; 
			Rarity = "Exclusive";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 4;
		};

		["Dimer"] = {
			PowerBoost = 1.5; 
			Rarity = "Exclusive";
			Secret = false;
			Delete = true;
			Pos = 1;
			Rotate = 180;
			PosPng = 3.5;
			CanCraft = true;
			Craft = "Normal";
			CanFly = true;
			Height = 0.6;
			UIPos = 2;
		};
	};

	Eggs = {
		["Basic"] = {
			Pos = 1;
			Price = 30;
			Currensy = "Power";
			Active = true;
			Pets = {
				["Basic Cat"] = {50, 1};
				["Basic Dog"] = {35, 2};
				["Basic Golem"] = {15, 3};
			}
		};

		["Desert"] = {
			Pos = 2;
			Price = 250;
			Currensy = "Power";
			Active = true;
			Pets = {
				["Basic Camel"] = {50, 1};
				["Basic Spider"] = {35, 2};
				["Basic Slime"] = {15, 3};
			}
		};

		["Candy"] = {
			Pos = 4;
			Price = 1000;
			Currensy = "Power";
			Active = true;
			Pets = {
				["Basic Panda"] = {50, 1};
				["Basic Bear"] = {35, 2};
				["Basic Pig"] = {15, 3};
			}
		};

		["Ocean"] = {
			Pos = 3;
			Price = 2500;
			Currensy = "Power";
			Active = true;
			Pets = {
				["Fish Orange"] = {50, 1};
				["Fish Green"] = {35, 2};
				["Shark"] = {15, 3};
			}
		};

		["Lava"] = {
			Pos = 5;
			Price = 5000;
			Currensy = "Power";
			Active = true;
			Pets = {
				["Lava Cat"] = {50, 1};
				["Lava Dog"] = {35, 2};
				["Lava Camel"] = {15, 3};

			}
		};
	};	
	
	Gamepass = {
		[806195737] = "TripleEgg";
		[807342731] = "AddPets";
		[809315352] = "AddPets2";
		[806734789] = "AddStorage";
		[806389768] = "AddStorage2";
		[806848752] = "Lucky";
	};
	
}
return module
