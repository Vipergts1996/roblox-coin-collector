local Stats = {
	-- Main Stats --
	Power = 0;
	OpenEggs = 0;
	-- Table -- 
	StoragePets = 0;
	MaxStorage = 25;
	MaxEquipped = 3;
	EquipPets = 0;
	idpet = 0;
	
	Gamepass = {
		["TripleEgg"] = false;
		["AutoEgg"] = false;
		["AddPets"] = false;
		["AddPets2"] = false;
		["AddStorage"] = false;
		["AddStorage2"] = false;
		["Lucky"] = false;
	};
	AutoRarity = {
		Common = false;
		Rare = false;
		Epic = false;
		Legendary = false;
	};
	PowerX = 1;
	AutoPets = {};
	EquippedPets = {};
	Pets = {};
	Start = false;
}
return Stats
