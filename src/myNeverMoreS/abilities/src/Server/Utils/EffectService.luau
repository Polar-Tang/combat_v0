local Debris = game:GetService("Debris")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remotes = RS.Events
local VFX_Event: RemoteEvent = remotes.VFX

-- CUstom helpers/services
local require = require(script.Parent.loader).load(script)
local DebrisFX = require("DebrisFX")
local stunt_client = require("stunt_client")


local EffectService = {}

function EffectService.SetAttHit(hited)
	hited:SetAttribute("IsBlocking", false)
	hited:SetAttribute("Attacking", false)
	hited:SetAttribute("Swing", false)
	hited:SetAttribute("Parrying", false)
	hited:SetAttribute("IsBlocking", false)
end

export type effectHitCtx = {
	Defender: {
		Character: Model,
		Humanoid: Humanoid,
		HRP: BasePart
	},
	Attacker: {
		Character: Model,
		Humanoid: Humanoid,
		HRP: BasePart
	},
	groundSmash: {
		position: Vector3,
		amount : number,
		velocity : number,
		material : EnumItem,
		dust : boolean ,
		shockwave : boolean,
		sizeRange : Vector2,
		lifetime : number,
	},
	strength: number,
	damage: number,
	kockback: Vector3,
	stunt_time: number,
	ragdoll: {
		isRag: boolean,
		duration: number
	},
	serviceBag: any
}

function EffectService:Apply(context: effectHitCtx)
    local serviceBag = context.serviceBag
    local RagdollService = serviceBag:GetService(require("Ragdoll"))

	local defender_char = context.Defender.Character
	local defender_humanoid = context.Defender.Humanoid

	if context.ragdoll then
		RagdollService:Tag(defender_humanoid)
		task.delay(context.ragdoll.duration, function()
			RagdollService:Untag(defender_humanoid)
		end)
	end
	
	if context.groundSmash then
		local GConfig = context.groundSmash
		DebrisFX:GroundSmash({
			position = GConfig.position,
			amount = GConfig.amount,
			velocity = GConfig.velocity,
			material = GConfig.material,
			dust = GConfig.dust,
			shockwave = GConfig.shockwave,
			sizeRange = GConfig.sizeRange,
			lifetime = GConfig.lifetime,
		})
	end
	-- Decide what to do with strength
	local defender_hrp = context.Defender.HRP

	if context.strength >= 35 then
		local bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
		bv.P = 50000
		bv.Velocity = context.kockback
		bv.Parent = defender_hrp

		Debris:AddItem(bv, 0.2)
	end

	if context.damage then
		defender_humanoid:TakeDamage(context.damage)
		defender_hrp.Anchored = false
	end

	stunt_client(defender_humanoid, context.stunt_time)

	self.SetAttHit(defender_char)

	VFX_Event:FireAllClients("SwordHit", defender_char)
	local Player = Players:GetPlayerFromCharacter(defender_char)
	if Player then
		VFX_Event:FireClient(Player, "SwordHitShake")
	end
end

return EffectService