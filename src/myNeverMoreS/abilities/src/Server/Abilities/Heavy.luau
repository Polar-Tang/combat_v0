local require = require(script.Parent.loader).load(script)
local AttackBaseAbility = require("AttackBaseAbility")

local hitTouchTemplate = require("hitTouchTemplate")
local hitbox_start_stop = require("hitbox_start_stop")
local DebrisFX = require("DebrisFX")

local Heavy = setmetatable({}, AttackBaseAbility)
Heavy.__index = Heavy

Heavy.Type = "Attack"

function Heavy.new(config)
	local self = setmetatable(AttackBaseAbility.new(config), Heavy)
	print("QUE PASA COPN ESTA MIERAAAAA ", config)
	print("fucking self ", self)

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
	local animHandler = self._animHandler
	animHandler:LoadAnimation(true, "Heavy")

	local hitFx = function()
		self:PlaySound("Heavy")
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

	-- HITBOX SHIT

	-- local WeaponData = self._weaponHandler:Get(CHAR)
	--return CHAR:WaitForChild(WeaponData.tool_name):WaitForChild("BodyAttach"):FindFirstChild("Trail")
	newHitbox.Touched:Connect(hitTouchTemplate(newHitbox, function(hit, enemyHum)
		self.RagdollService:Tag(enemyHum)
			task.delay(.5, function()
			self.RagdollService:Untag(enemyHum)
			end)
		DebrisFX:GroundSmash({
			position = hit.Position,
			amount = 14,
			velocity = 70,
			material = Enum.Material.Slate,
			dust = true,
			shockwave = true,
			sizeRange = Vector2.new(1, 2.5),
			lifetime = 2.5,
		})
		return { Strength = 50 }
	end, self))
end

return Heavy
