local module = {}

function module:PetTable(name,id,equip,lock,craft)
	return {
		PetName = tostring(name) or "Slime Green";
		PetID = id or 1;
		Equip = equip or false;
		Locked = lock or false;
		Craft = craft or "Normal"
	}
end

function module:TableEquipped(t,id,name)
	return {
		Type = t or 1;
		PetID = id;
		PetName = name;
	}
end

return module
