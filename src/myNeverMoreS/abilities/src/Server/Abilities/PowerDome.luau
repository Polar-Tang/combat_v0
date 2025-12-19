local RS = game:GetService("ReplicatedStorage")
local windVFX = RS.Effects.winds

local require = require(script.Parent.loader).load(script)
local AttackBaseAbility = require("AttackBaseAbility")

local hitTouchTemplate = require("hitTouchTemplate")
local hitbox_start_stop = require("hitbox_start_stop")

local PowerDome = setmetatable({}, AttackBaseAbility)
PowerDome.__index = PowerDome


-- Config is the data created by the weapon through the builder
function PowerDome.new(config)
	local self = setmetatable(AttackBaseAbility.new(config), PowerDome)
	self.hitBox = self:createHitBox()

	return self
end

-- TODO: It would be call if this is described and not directly executed, so move this logic to the effect service domain
function PowerDome:_explosionGrowthOverTime()
end

function PowerDome:Explotion()
    -- local  = windVFX.winds

    local power_up_dome: Part = windVFX.power_up_dome
    power_up_dome.Size = Vector3.new(1,1,1)
    power_up_dome.Position = self.character.PrimaryPart.Position

end

function PowerDome:Execute()
	if self._cooldownController:getCD() then
		return
	end
	
	self._cooldownController:init(self.cooldown)
	local CHAR = self.character
	local newHitbox = self.hitBox

	--Settin attr
	self:SetAttributes()
	-------------
    -- TODO: get a cool asimation that resembles goku henkidama
	local animHandler = self._animHandler
	animHandler:LoadAnimation(true, "Heavy")

	
	-- HITBOX SHIT

	local groundSmash = {
		position = nil,
		amount = 14,
		velocity = 70,
		material = Enum.Material.Air,
		dust = true,
		sizeRange = Vector2.new(1, 2.5),
		lifetime = 2.5,
	}

	local ragdoll = {
		duration = 1
	}
	local data = {
		serviceBag = self._serviceBag,
		strength = 50,
		ragdoll = ragdoll,
		groundSmash = groundSmash,
		damage = self.damage,
		hitBox = newHitbox,
		stun_time = self.stun_time
	}
	-- asumming the data is always the same, the connection should remain the same too
	if self._maid["Heavy"] then
			return
		end
	local hitTask = self.hitBox.Touched:Connect(hitTouchTemplate(data))
    self:Explotion()
	self._maid:__newindex("Heavy", hitTask)
end

return PowerDome
