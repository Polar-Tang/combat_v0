local RS = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local SSS = game:GetService("ServerScriptService")

local SoundFolder = SoundService:WaitForChild("SFX")
local WeaponSoundFolder = SoundFolder:WaitForChild("Weapons")
local NPCAnimBinder = require(RS.Animations.Utils.AnimationHandlerBinder).NPCAnimBinder
local WeaponBinder = require(SSS.Combat.Weapons.WeaponBinder).WeaponBinder

--||Helpers||--
local CombatFolder = SSS.Combat.Attacks
local Helpers = CombatFolder.Helpers
local back_by_impact = require(Helpers.back_by_impact)
local hitbox_start_stop = require(Helpers.hitbox_start_stop)

--utils
local Utils = CombatFolder.Utils
local hitTouchTemplate = require(Utils.hitTouchTemplate)
local Basic = {}

-- RETURN THE WEAPON ANIMATION FOR THE NEXT COMBO
Basic.getSwingAnimation = function(char, toolName): string
	local combo = char:GetAttribute("Combo")

	return "Swing" .. combo
end

Basic.Type = "Attack"

Basic.Execute = function(CHAR, newHitbox)
	local WeaponData = WeaponBinder:Get(CHAR)
	local HUM = CHAR:WaitForChild("Humanoid")
	local tool_name = WeaponData.tool_name

	local swingName: string = Basic.getSwingAnimation(CHAR, tool_name)
	local animHandler = NPCAnimBinder:Get(CHAR)
	animHandler:LoadAnimation(true, swingName)

	local current_combo = CHAR:GetAttribute("Combo")
	local max_combo = WeaponData.max_combo
	local hitFx = function()
		local nameAttack = swingName
		CHAR:SetAttribute("Attacking", false)
		hitbox_start_stop(CHAR, newHitbox)
		--if the combo is the last hit then let him not attack for longer
		if current_combo == max_combo then
			task.wait(1)
		else
			task.wait(WeaponData.swing_reset)
		end
		CHAR:SetAttribute("Swing", false)
	end
	animHandler:OnSignal({
		callback = hitFx,
		animationName = swingName,
		animationEventName = "Hit",
	})
	local hitEnd = function(track: AnimationTrack)
		-- Ithink this is handled by autodestroy
		--newHitbox:Stop()
		local trail = require(Helpers.get_trail)(CHAR)
		if CHAR:FindFirstChild(tool_name) and trail then
			trail.Enabled = false
		end
		if not CHAR:GetAttribute("IsBlocking") then
			HUM.WalkSpeed = 14
			HUM.JumpHeight = 6.5
		end
	end

	animHandler:OnSignal({
		callback = hitEnd,
		animationName = swingName,
		animationEventName = "EndedCon",
	})

	WeaponData:PlaySwingSound()

	local getStrnght = function(enemyHum)
		local Strenght = 10
		if current_combo == max_combo then
			Strenght = 35
		end

		return { Strength = Strenght }
	end

	newHitbox.Touched:Connect(hitTouchTemplate(newHitbox, getStrnght))
end

return Basic
