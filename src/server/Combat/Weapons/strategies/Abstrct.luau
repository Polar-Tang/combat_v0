-- Weapon.lua
local Weapon = {}
Weapon.__index = Weapon

type weaponAbilities = {
	["M1"] : EnumItem,
	["Sprint"] : EnumItem,
	["Heavy"] : EnumItem,
	["Blocking"] : EnumItem,
}

type Weapon = {
	char : Model,
	attacks : weaponAbilities,
}

function Weapon.new(char: Model): Weapon
	local self: Weapon = setmetatable({
		char = char,
		attacks = nil
	} :: Weapon, Weapon)

	return self
end




-- This will loop abilities, setting new ones based on the weapon type
--[[function Weapon:Start(weaponAbilities: {[string]})
	for keyCode, abilityName in pairs(weaponAbilities) do
		local abilityClass = assert(ALL_ABILITIES[abilityName], "Ability "..abilityName.." not found")
		self[keyCode] = abilityClass.new({
			name = abilityName,
		})
	end
end
]]
return Weapon
