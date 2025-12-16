local EffectService = {}

function EffectService.SetAttHit(hited)
	hited:SetAttribute("IsBlocking", false)
	hited:SetAttribute("Attacking", false)
	hited:SetAttribute("Swing", false)
	hited:SetAttribute("Parrying", false)
	hited:SetAttribute("IsBlocking", false)
end

function EffectService:Apply(effect, context)
    local serviceBag = context._serviceBag
    local RagdollService = serviceBag:GetService

	if effect.Type == "Ragdoll" then
		RagdollService:Tag(context.Defender)
		task.delay(effect.Duration, function()
			RagdollService:Untag(context.Defender)
		end)
	elseif effect.Type == "GroundSmash" then
		DebrisFX:GroundSmash({
			Position = context.Defender.PrimaryPart.Position,
		})
	end
	-- Decide what to do with strength
	if context.strength >= 35 then
		local bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
		bv.P = 50000
		bv.Velocity = context.kockback
		bv.Parent = ENEMYHRP

		Debris:AddItem(bv, 0.2)
	end

	if context.damage then
		enemyHum:TakeDamage(context.damage)
		ENEMYHRP.Anchored = false
	end

	stunt_client(enemyHum, StunTime)

	self.SetAttHit(hited)

	VFX_Event:FireAllClients("SwordHit", ENEMYCHAR)
	local Player = Players:GetPlayerFromCharacter(CHAR)
	if Player then
		VFX_Event:FireClient(Player, "SwordHitShake")
	end
	local weaponEnemy = WeaponBinder:Get(ENEMY_CHAR)
end
