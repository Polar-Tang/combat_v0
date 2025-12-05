local SSS = game:GetService("ServerScriptService")
local WeaponsFodler = SSS.Combat.Weapons
local CooldownController = require(WeaponsFodler.CooldownController)

local BaseAbility = {}
BaseAbility.__index = BaseAbility

function BaseAbility.new(config)
	return setmetatable({
		name = config.name,
		cooldown = config.cooldown or 0,
		damage = config.damage or 0,

	}, BaseAbility)
end

function BaseAbility:Execute(char)
	error("Execute must be overridden in subclass")
end

return BaseAbility
