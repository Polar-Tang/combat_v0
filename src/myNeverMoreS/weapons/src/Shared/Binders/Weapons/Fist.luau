local require = require(script.Parent.loader).load(script)
local WeaponBase = require("WeaponBase")
local AbilityBuilder = require("AbilityBuilder")
local WeaponInfo = require("WeaponInfo")
local Table = require("Table")

-- code smell here
local WeaponStats = WeaponInfo:getweapon("Fist")

local Fist = setmetatable({}, WeaponBase)
Fist.__index = Fist

function Fist.new(char, serviceBag)
	local self = setmetatable(WeaponBase.new(char, serviceBag, WeaponStats), Fist)
	self.tool_name = "Fist"
	self:_createAbilities()

	return self
end

function Fist:_createAbilities()
	local attackData = WeaponStats["attacks"]
	-- attacks of type Attack and maybe Movement in the future
	self.attacks = AbilityBuilder.new(self.char, self._serviceBag)
		:Add(Enum.UserInputType.MouseButton1, "M1", {
			name = "Basic",
			type = "Attack",
			_cooldown = attackData.Basic.cooldown,
			damage = attackData.Basic.damage,
			hitbox_size = attackData.Basic.hitbox_size,
			hitbox_offset = attackData.Basic.hitbox_offset,
			character = self.char,
			_max_combo = attackData.Basic.max_combo,
			stun_time = self.stun_time,
			tool_name = "Fist",
		})
		:Add(
			Enum.KeyCode.F,
			"Blocking",
			Table.merge({
				name = "Blocking",
				type = "Defense",
				character = self.char,
				-- _cooldown = attackData.Heavy.cooldown,
			}, self)
		)
		:Add(
			Enum.KeyCode.W,
			"Sprint",
			Table.merge({
				name = "Sprint",
				type = "Movement",
				_cooldown = attackData.Sprint.cooldown,
			}, self)
		)
		:Add(
			Enum.KeyCode.R,
			"Heavy",
			Table.merge({
				name = "Heavy",
				type = "Attack",
				_cooldown = attackData.Heavy.cooldown,
				damage = attackData.Heavy.damage,
				hitbox_size = attackData.Heavy.hitbox_size,
				character = self.char,
			}, self)
		)
		:Build()

	-- here goes the defence abilities

	-- This shit was intended to reduce the blocking atribute every second
	--[[
		self.char:GetAttributeChangedSignal("Blocking"):Connect(function()
			local isBlocking = character:GetAttribute("IsBlocking")
			-- IMPORTANT! LastStopTime do record the last blocking time... or something alike
			local lastStopTime = character:GetAttribute("LastStopTime") or 0
			local currentTime = tick()
	
			if not isBlocking and currentTime - lastStopTime >= block_reset_time then
				character:SetAttribute("Blocking", math.max(0, character:GetAttribute("Blocking") - 1.5))
			end
		end)
	]]
	return self
end

function Fist:Execute(action: string)
	if not self.attacks[action] then
		return
	end
	print("self.attacks[action] ", self.attacks[action])
	self.attacks[action]:Execute()
end

return Fist
