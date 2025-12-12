local require = require(script.Parent.loader).load(script)
local HitboxModule = require("MuchachoHitbox")
local get_trail = require("get_trail")
local BaseAbility = require("BaseAbility")

local AttackBaseAbility = setmetatable({}, BaseAbility)
AttackBaseAbility.__index = AttackBaseAbility

type AttackBaseAbilityConfig = {
	name: string,
	cooldown: number?,
	damage: number,
	_max_combo: number?,
	_serviceBag: any,
	character: Model,
	hitbox_size: Vector3,
	hitbox_offset: CFrame,
}

function AttackBaseAbility.new(config)
	print("QUE PASA COPN ESTA MIERAAAAA")
	local self = setmetatable(BaseAbility.new(config), AttackBaseAbility)
	self.name = config.name
	self.cooldown = config._cooldown or 0
	self.damage = config.damage or 0
	self._lastSwing = 0
	self._max_combo = config._max_combo
	self.hitbox_size = config.hitbox_size
	self.hitbox_offset = config.hitbox_offset
	self.stun_time = config.stun_time
	-- BINDERS
	self._serviceBag = config._serviceBag
	assert(_G.BinderProvider, "Binder Provider not initialized")
	-- Get the animation binder
	local BinderProvider = self._serviceBag:GetService(_G.BinderProvider)
	-- weapon Binder
	local WeaponBinder = BinderProvider:Get("Armed")
	self._weaponHandler = WeaponBinder:Get(self.character)

	-- Animation Binder
	local AnimationBinder = BinderProvider:Get("AnimationHandler")
	self._animHandler = AnimationBinder:Get(self.character)

	return self
end

function AttackBaseAbility:createHitBox()
	local CHAR = self.character
	local hitbox_offset = self.hitbox_offset
	local hitbox_size = self.hitbox_size
	local HRP = CHAR:WaitForChild("HumanoidRootPart")
	local trail = get_trail(CHAR)
	local tool = CHAR:FindFirstChildWhichIsA("Tool")
	if tool and trail then
		trail.Enabled = false
	end
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude

	local newHitbox = HitboxModule.CreateHitbox() --creating the hitbox
	newHitbox.Size = hitbox_size
	newHitbox.CFrame = HRP
	newHitbox.Offset = hitbox_offset
	newHitbox.OverlapParams = params
	newHitbox.AutoDestroy = false
	newHitbox.Puncher = CHAR
	return newHitbox
end

function AttackBaseAbility:SetAttributes()
	local CHAR = self.character
	local HUM = CHAR:WaitForChild("Humanoid")

	CHAR:SetAttribute("Attacking", true)
	CHAR:SetAttribute("Swing", true)

	HUM.WalkSpeed = 7
	HUM.JumpHeight = 0
end

return AttackBaseAbility
