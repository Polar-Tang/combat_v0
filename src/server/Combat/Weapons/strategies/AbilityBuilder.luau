local SSS = game:GetService("ServerScriptService")
local combatFolder = SSS.Combat
local WeaponsFodler = combatFolder.Weapons
local ALL_ABILITIES = require(combatFolder.constants).ALL_ABILITIES
local CooldownController = require(WeaponsFodler.CooldownController)
local AbilityBuilder = {}
AbilityBuilder.__index = AbilityBuilder

-- The pop drilling to service bag ends... HERE!
function AbilityBuilder.new(char)
	return setmetatable({
        char = char,
		_map = {},
	}, AbilityBuilder)
end

function AbilityBuilder:Add(inputKey, abilityName, config)
    -- 
	local AbilityClass = ALL_ABILITIES[abilityName]
	-- Get the cooldown controller from service bag to every ability
    config._cooldownController = CooldownController.new(self.char)
	self._map[inputKey] = AbilityClass.new(config)
	return self
end

function AbilityBuilder:Build()
	return self._map
end

return AbilityBuilder
