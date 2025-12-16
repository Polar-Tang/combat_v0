return function(parentClass)
	local newHitbox = parentClass.hitBox

	local CHAR: Model = newHitbox.Puncher
	local BinderProvider = parentClass._serviceBag:GetService(_G.BinderProvider)
	-- weapon Binder
	local WeaponBinder = BinderProvider:Get("Armed")
	--newHitbox.Touched:Connect
	return function(hit, enemyHum)
		----------------------------------------------------
		-- TODO: destroy the old hitboxes un Unequip tool
		local context = {}
		context.Defender_Humanoid = enemyHum

		local ENEMY_CHAR: Model = enemyHum.Parent
		context.Defender = ENEMY_CHAR

		context.strength = parentClass.strength

		local ENEMYHRP = ENEMY_CHAR:WaitForChild("HumanoidRootPart")
		context.Defender_HRP = ENEMYHRP

		local HRP = CHAR:WaitForChild("HumanoidRootPart")
		local CENTER = (ENEMYHRP.Position - HRP.Position).Unit
		local kockback = CENTER * parentClass.strength
		context.kockback = kockback
		----------------------------------------------------
		-- LAST BUT NOT LEAST, IMPORTANT DATA FROM THE PARENT
		context.damage = parentClass.damage
		context.stun_time = parentClass.stun_time
		context._serviceBag = parentClass._serviceBag

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
