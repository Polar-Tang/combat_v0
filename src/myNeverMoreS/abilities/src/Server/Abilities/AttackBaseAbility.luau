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
	local self = setmetatable(BaseAbility.new(config), AttackBaseAbility)
	
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
	params.FilterDescendantsInstances = {CHAR}

	local newHitbox = HitboxModule.CreateHitbox() --creating the hitbox
	newHitbox.Size = hitbox_size
	newHitbox.CFrame = HRP
	newHitbox.Offset = hitbox_offset
	newHitbox.OverlapParams = params
	newHitbox.AutoDestroy = false
	newHitbox.Puncher = CHAR
	newHitbox.DetectionMode = "HitOnce"
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
