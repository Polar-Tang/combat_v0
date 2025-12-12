local require = require(script.Parent.loader).load(script)
local AttackBaseAbility = require("AttackBaseAbility")

local hitTouchTemplate = require("hitTouchTemplate")
local hitbox_start_stop = require("hitbox_start_stop")

local Heavy = setmetatable({}, AttackBaseAbility)
Heavy.__index = Heavy

Heavy.Type = "Attack"

function Heavy.new(config)
	local self = setmetatable(AttackBaseAbility.new(config), Heavy)

	return self
end
-- TODO: DEBUG THIS SHIT
function Heavy:Execute()
	if self._cooldownController:getCD() then
		return
	end
	self._cooldownController:init(self.cooldown)
	local CHAR = self.character
	local newHitbox = self:createHitBox()

	--Settin attr
	self:SetAttributes()
	-------------

	-- HITBOX SHIT
	local animHandler = self._animHandler
	animHandler:LoadAnimation(true, "Heavy")
	self:PlaySound("Heavy")

	local hitFx = function()
		print("Hit event reached ")
		CHAR:SetAttribute("Attacking", false)
		hitbox_start_stop(CHAR, newHitbox)
		CHAR:SetAttribute("Swing", false)
	end
	animHandler:OnSignal({
		callback = hitFx,
		animationName = "Heavy",
		animationEventName = "Hit",
	})
	local hitEnd = function(track: AnimationTrack)
		-- Ithink this is handled by autodestroy
		--newHitbox:Stop()

		if not CHAR:GetAttribute("IsBlocking") then
			self.humanoid.WalkSpeed = 14
			self.humanoid.JumpHeight = 6.5
		end
	end
	animHandler:OnSignal({
		callback = hitEnd,
		animationName = "Heavy",
		animationEventName = "EndedCon",
	})
	-- local WeaponData = self.WeaponBinder:Get(CHAR)
	--return CHAR:WaitForChild(WeaponData.tool_name):WaitForChild("BodyAttach"):FindFirstChild("Trail")
	newHitbox.Touched:Connect(hitTouchTemplate(newHitbox, function(enemyHum)
		return { Strength = 50 }
	end, self))
end

return Heavy
