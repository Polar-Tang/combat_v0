local RS = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")

local require = require(script.Parent.loader).load(script)
-- local CombatUtils = require("CombatUtils")

--||BINDERS||--
-- TODO: doubt about require WeaponBInder or Weapon

--||Events||--
local remotes = RS.Events
local VFX_Event: RemoteEvent = remotes.VFX

--local hitbox_start_stop = require(Helpers.hitbox_start_stop)
local stunt_client = require("stunt_client")

return function(parentClass, getStrength)
	local newHitbox = parentClass.hitBox

	local CHAR: Model = newHitbox.Puncher
	local BinderProvider = parentClass._serviceBag:GetService(_G.BinderProvider)
	-- weapon Binder
	local WeaponBinder = BinderProvider:Get("Armed")
	--newHitbox.Touched:Connect
	return function(hit, enemyHum)
		----------------------------------------------------
		-- TODO: destroy the old hitboxes un Unequip tool
		local ENEMY_CHAR: Model = enemyHum.Parent
		local weaponEnemy = WeaponBinder:Get(ENEMY_CHAR)
		weaponEnemy:OnIncomingAttack()

		local HRP = CHAR:WaitForChild("HumanoidRootPart")
		----------------------------------------------------

		local Damage = parentClass.damage
		local StunTime = parentClass.stun_time
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
		local ENEMYCHAR = ENEMY_CHAR
		local ENEMYHRP = ENEMYCHAR:WaitForChild("HumanoidRootPart")

		local CENTER = (ENEMYHRP.Position - HRP.Position).Unit
		--local STRENGTH = 10
		local data = getStrength(hit, enemyHum)
		local STRENGTH = data.Strength

		---------------------- HIT: ANIM, DAMAGA ----------------------
		--enemyHrp.CFrame = CFrame.lookAt(enemyHrp.Position, hrp.Position)--makes the enemy look at you, disabled it cuz it doesnt look good lol

		-- PLAY THE HIT FROM THE COMBO
		--print("Stop animation playing feint")
		--print("NPCAnimBinder ", NPCAnimBinder)

		local kockback = CENTER * STRENGTH

		if STRENGTH >= 35 then
			local bv = Instance.new("BodyVelocity")
			bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
			bv.P = 50000
			bv.Velocity = kockback
			bv.Parent = ENEMYHRP

			Debris:AddItem(bv, 0.2)
		end

		ENEMYCHAR:SetAttribute("IsRagdoll", false)
		if Damage then
			enemyHum:TakeDamage(Damage)
			ENEMYHRP.Anchored = false
		end

		stunt_client(enemyHum, StunTime)

		ENEMYCHAR:SetAttribute("IsBlocking", false)
		ENEMYCHAR:SetAttribute("Attacking", false)
		ENEMYCHAR:SetAttribute("Swing", false)
		ENEMYCHAR:SetAttribute("Parrying", false)
		ENEMYCHAR:SetAttribute("IsBlocking", false)

		VFX_Event:FireAllClients("SwordHit", ENEMYCHAR)
		local Player = Players:GetPlayerFromCharacter(CHAR)
		if Player then
			VFX_Event:FireClient(Player, "SwordHitShake")
		end
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
