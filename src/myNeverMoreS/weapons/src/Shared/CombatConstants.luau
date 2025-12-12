local SSS = game:GetService("ServerScriptService")
local AttacksFodler = SSS.Combat.Attacks

local skills = AttacksFodler.AbilityFactory.Abillities

local constants = {}

constants.ALL_ABILITIES = {
	["M1"] = require(skills.Basic),
	["Sprint"] = require(skills.Sprint),
	["Heavy"] = require(skills.Heavy),
	["Blocking"] = require(skills.Blocking),
}

return constants