--||Services||--
--[[
	local RS = game:GetService("ReplicatedStorage")
	local SSS = game:GetService("ServerScriptService")
	local SoundService = game:GetService("SoundService")
	local Debris = game:GetService("Debris")
	
	-- COMBAT UTTILITIES
	local module = {}
	
	--||Folders||--
	local CombatStuff = SSS.Combat.Attacks
	local SFXFolder = SoundService.SFX
	local require = require(script.Parent.loader).load(script)
	
	--||Modules||--
	local stunt_client = require("stunt_client")
	local AnimationHandler = require("AnimationHandler")
	
	--TODO: migrate this logic to abiliti abstract/ cooldown controller
	local lastSwing = {}
	local Max_Combo = 3
	------------------------------------------------------------------------------------------------------------------
	
	-- Play a client VFX, play a break sound, play guardbreak animation, change player UI, stunt enemy and reset blocking
	-- RETURN TRU IF GUARD BREAKS
	
	
	---------------- stopAnimation function ----------------
	
	
	--
	
	
	--function for parrying the enemies hit, --enemy is the one that parryed
	module.Parrying = function(char, enemyChar): nil
		local toolName
	
		if not enemyChar:FindFirstChildWhichIsA("Tool") then
			toolName = enemyChar:GetAttribute("Weapon")
		else
			toolName = enemyChar:FindFirstChildWhichIsA("Tool").Name
		end -- is for npc's cuz they have an attribute for there weapon
	
		char:SetAttribute("Blocking", char:GetAttribute("Blocking") + 20)
		enemyChar:SetAttribute("Blocking", enemyChar:GetAttribute("Blocking") - 20)
		if enemyChar:GetAttribute("Blocking") <= 0 then
			enemyChar:SetAttribute("Blocking", 0)
		end
	
		--stopAnims(char.Humanoid)
	
		if not GuardBreak(char, toolName) then
			char:SetAttribute("Attacking", false)
			char:SetAttribute("Swing", false)
	
			RS.Events.VFX:FireAllClients("ParryHit", enemyChar)
			local plr = game:GetService("Players"):GetPlayerFromCharacter(char)
			if plr then
				RS.Events.VFX:FireClient(plr, "ParryEffect")
			end
	
			local ParrySound = SFXFolder.Weapons:WaitForChild(toolName):WaitForChild("Parryed"):Clone()
			ParrySound.Parent = char:WaitForChild("HumanoidRootPart")
			ParrySound:Play()
			Debris:AddItem(ParrySound, 3)
	
			stunt_client(char:WaitForChild("Humanoid"), 1.2)
		end
		return nil
	end
	
	
	return module

]]
