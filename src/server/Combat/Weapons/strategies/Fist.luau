local SSS = game:GetService("ServerScriptService")
local combatFolder = SSS.Combat
local WeaponsFodler = combatFolder.Weapons

local WeaponBase = require(WeaponsFodler.strategies.Abstrct)
local AbilityBuilder = require(WeaponsFodler.strategies.AbilityBuilder)

local Weapon = require()

local Fist = setmetatable({}, WeaponBase)
Fist.__index = Fist

function Fist.new(char)
	local self = Weapon.new(char)
	return self
end


function Fist:_createAbilities()
    self.attacks =
		AbilityBuilder.new(self.char)
			:Add(Enum.UserInputType.MouseButton1, "M1", {
				name = "Basic",
				type = "Attack",
				cooldown = 0.5,
				damage = 5,
			})
			:Add(Enum.KeyCode.R, "Heavy", {
				name = "Heavy",
				type = "Attack",
				cooldown = 10,
				heavy_damage = 8,
			})
			:Build()
	
	return self
end
return Fist
