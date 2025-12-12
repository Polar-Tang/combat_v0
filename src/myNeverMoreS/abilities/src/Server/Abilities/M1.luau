local require = require(script.Parent.loader).load(script)

-- Binders
--||Helpers||--
local CooldownController = require("CooldownController")

local hitbox_start_stop = require("hitbox_start_stop")
--utils
local hitTouchTemplate = require("hitTouchTemplate")

--classes
local AttackBaseAbility = require("AttackBaseAbility")

local Basic = setmetatable({}, AttackBaseAbility)
Basic.__index = Basic

-- Config is the data created by the weapon through the builder
function Basic.new(config)
	local self = setmetatable(AttackBaseAbility.new(config), Basic)
	self._comboController = CooldownController.new(config.character, config._serviceBag, config)

	return self
end

-- RETURN THE WEAPON ANIMATION FOR THE NEXT COMBO
function Basic:getSwingAnimation(): string
	local char = self.character
	local combo = char:GetAttribute("Combo")

	return "Swing" .. combo
end

--[[
function for changing the players combo
set the current combo as an attribute
and stores the cooldown
]]
function Basic:_ChangeCombo()
	-- SET THE COMBO ATT
	local char = self.character
	local Max_Combo = self._max_combo

	-- If the last hit was after 3 seconds, reset the combo
	if not self._comboController:getCD() then
		char:SetAttribute("Combo", 1)
		self._comboController:init(3)
		return
	end

	self._comboController:init(3)

	local combo = char:GetAttribute("Combo")

	if combo >= Max_Combo then
		char:SetAttribute("Combo", 1)
	else
		char:SetAttribute("Combo", combo + 1)
	end

	-- Cooldown handler goes here
	-- sets the Tick for cc
	-- self._cooldownController:init(self.cooldown)s
end

function Basic:Execute()
	if self._cooldownController:getCD() then
		return
	end
	self._cooldownController:init(self.cooldown)
	local newHitbox = self:createHitBox()
	local CHAR = self.character

	local HUM = CHAR:WaitForChild("Humanoid")

	local swingName: string = self:getSwingAnimation()

	local animHandler = self._animHandler
	animHandler:LoadAnimation(true, swingName)

	--Settin attr
	self:SetAttributes()
	-------------

	local current_combo = CHAR:GetAttribute("Combo")
	self:_ChangeCombo()

	local max_combo = self._max_combo
	local hitFx = function()
		CHAR:SetAttribute("Attacking", false)
		hitbox_start_stop(CHAR, newHitbox)
		print("m1 Hit event reached!! ") --Prints
		self:PlaySound("Swing", 2)

		CHAR:SetAttribute("Swing", false)
	end
	animHandler:OnSignal({
		callback = hitFx,
		animationName = swingName,
		animationEventName = "Hit",
	})
	local hitEnd = function(track: AnimationTrack)
		-- Ithink this is handled by autodestroy
		--newHitbox:Stop()

		if not CHAR:GetAttribute("IsBlocking") then
			HUM.WalkSpeed = 14
			HUM.JumpHeight = 6.5
		end
	end

	animHandler:OnSignal({
		callback = hitEnd,
		animationName = swingName,
		animationEventName = "EndedCon",
	})

	--WeaponData:PlaySwingSound()
	local getStrnght = function(enemyHum)
		local Strenght = 10
		if current_combo == max_combo then
			Strenght = 35
		end

		return { Strength = Strenght }
	end

	newHitbox.Touched:Connect(hitTouchTemplate(newHitbox, getStrnght, self))
end

return Basic
