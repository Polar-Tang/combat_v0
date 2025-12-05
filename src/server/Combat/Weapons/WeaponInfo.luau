-- [[ By @Liam
--Here you can handle the stats for the weapons
--]]

local module = {}

--[[
TODO:
Create stats for every attack
it could go something like this:
type attack = {
	cd: number
	damage: number?
}
]]

local basic_fist = {
	damage = 4,
	heavy_damage = 8,
	cooldown = 0.1,
	max_combo = 5,
}

local heavy_Fist = {
	heavy_damage = 8,
	cooldown = 10,
}

local info = {
	["Blocking_General"] = {
		Block_Reset_Time = 3, --the time it takes for the blocking value to go down after you last blocked
		Parry_Time = 0.25, --How long the parry last when you start blocking
	},

	["Fist"] = { --If you wan't to make a new weapon just copy and paste one of the already existing tables and change the name  to your weapons name!
		damage = 4, -- How much damage the weapon deals
		heavy_damage = 8, -- How much damage The Heavy attack of the weapon deals
		swing_reset = 0.1, -- After What Amount Of Time you can Swing Again (After reaching the hit event)
		stun_time = 1.7, -- How Long The Enemy Is Stunned
		hitbox_size = Vector3.new(5, 5, 4.5),
		heavy_hitbox_size = Vector3.new(5.5, 5.5, 5),
		hitbox_offset = CFrame.new(0, 0, -2.5),
		max_combo = 5,
	},
	["Dagger"] = {
		damage = 5,
		heavy_damage = 5, -- dagger has 2 hit events in his animation, so 5 x 2
		swing_reset = 0.1,
		stun_time = 1.75,
		hitbox_size = Vector3.new(5, 5, 5),
		heavy_hitbox_size = Vector3.new(5, 5, 5.5),
		hitbox_offset = CFrame.new(0, 0, -2.5),
		max_combo = 4,
	},
	["Katana"] = {
		damage = 6,
		heavy_damage = 10,
		swing_reset = 0.15,
		stun_time = 1.8,
		hitbox_size = Vector3.new(6, 6, 6),
		heavy_hitbox_size = Vector3.new(6.5, 6.5, 6.5),
		hitbox_offset = CFrame.new(0, 0, -2.5),
		max_combo = 4,
	},
	["Naginata"] = {
		damage = 7,
		heavy_damage = 11,
		swing_reset = 0.35,
		stun_time = 1.85,
		hitbox_size = Vector3.new(6, 6, 8),
		heavy_hitbox_size = Vector3.new(6, 6, 9),
		hitbox_offset = CFrame.new(0, 0, -3),
		max_combo = 4,
	},
}

function module:getweapon(WeaponName: string)
	return info[WeaponName]
end

return module
