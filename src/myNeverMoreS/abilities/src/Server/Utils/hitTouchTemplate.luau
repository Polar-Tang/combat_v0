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

return function(parentClass)
	local newHitbox = parentClass.hitBox

	local CHAR: Model = newHitbox.Puncher
	local BinderProvider = parentClass.serviceBag:GetService(_G.BinderProvider)
	-- weapon Binder
	local WeaponBinder = BinderProvider:Get("Armed")
	--newHitbox.Touched:Connect
	return function(hit, enemyHum)
		----------------------------------------------------
		-- TODO: destroy the old hitboxes un Unequip tool
		local context = {
			Defender = {},
			Attacker = {},
			groundSmash = {},
			ragdoll = {}
		} :: effectHitCtx
		context.Defender.Humanoid = enemyHum
		context.Attacker.Character = CHAR

		local ENEMY_CHAR: Model = enemyHum.Parent
		context.Defender.Character = ENEMY_CHAR

		context.strength = parentClass.strength

		local ENEMYHRP = ENEMY_CHAR:WaitForChild("HumanoidRootPart")
		context.Defender.HRP = ENEMYHRP

		local HRP = CHAR:WaitForChild("HumanoidRootPart")
		local CENTER = (ENEMYHRP.Position - HRP.Position).Unit
		local kockback = CENTER * parentClass.strength
		context.kockback = kockback
		----------------------------------------------------
		-- LAST BUT NOT LEAST, IMPORTANT DATA FROM THE PARENT
		-- Overwrites groundSMash, if it exists it lacks the hit position, only know by this module
		context.id = newHitbox.Key
		if parentClass.groundSmash then
			parentClass.groundSmash.position = hit.Position
		end

		context.damage = parentClass.damage
		context.stunt_time = parentClass.stun_time
		context.serviceBag = parentClass.serviceBag
		context.ragdoll = parentClass.ragdoll
		
		local weaponEnemy = WeaponBinder:Get(ENEMY_CHAR)
		weaponEnemy:OnIncomingAttack(context)

		----------------------------------------------------
		-- Handling the hit blocking
		-- Heavy will be an attribute set by the heavy attack, execute()
		-- CheckInfront will be an utility directly by the weapon
		-- CombatUtils.Blocking could be a weapon method too, self._weapon[strategy].blockig
		--[[
		
		do
			if ENEMY_CHAR:GetAttribute("Parrying") and not Heavy and CombatUtils.CheckInfront(CHAR, ENEMY_CHAR) then
				CombatUtils.Parrying(CHAR, ENEMY_CHAR)
				return
			end
			if ENEMY_CHAR:GetAttribute("IsBlocking") and not Heavy and CombatUtils.CheckInfront(CHAR, ENEMY_CHAR) then
				CombatUtils.Blocking(ENEMY_CHAR, Damage)
				return
			end
			if ENEMY_CHAR:GetAttribute("IsRagdoll") or ENEMY_CHAR:GetAttribute("Iframes") or enemyHum.Health <= 0 then
				return
			end

			if Heavy then
				CHAR:SetAttribute("Combo", 4)
			end
		end
		]]
		------------ CONSTANTS ------------

		--local STRENGTH = 10

		---------------------- HIT: ANIM, DAMAGA ----------------------
		--enemyHrp.CFrame = CFrame.lookAt(enemyHrp.Position, hrp.Position)--makes the enemy look at you, disabled it cuz it doesnt look good lol

		-- PLAY THE HIT FROM THE COMBO
		--print("Stop animation playing feint")
		--print("NPCAnimBinder ", NPCAnimBinder)
	end
end

--[[
		if ragdoll then
			task.spawn(function()		
				ENEMYCHAR:SetAttribute("IsRagdoll", false)
				ENEMYCHAR:SetAttribute("IsRagdoll", true)
				task.wait(ragdollDuration)
				ENEMYCHAR:SetAttribute("IsRagdoll", false)
				ENEMYCHAR:SetAttribute("Iframes", true)
				if enemyHum.Health > 0 then
					RS.Events.VFX:FireAllClients("Iframes",ENEMYHRP,.4)
					task.delay(.4, function() ENEMYCHAR:SetAttribute("Iframes", false) end)
				end
			end)
		end
		]]
