-- COMBAT UTTILITIES
local module = {}

--||Services||--
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

--||Folders||--
local CombatStuff = SSS.Combat.Attacks

local SFXFolder = SoundService:WaitForChild("SFX")

--||Modules||--
local stunt_client = require(CombatStuff.Helpers.stunt_client)
local NPCAnimBinder = require(RS.Animations.Utils.HandlerBinder).NPCAnimBinder


--||Stuff||--
local lastSwing = {}
local Max_Combo = 5

------------------------------------------------------------------------------------------------------------------


-- RETURN TRU IF GUARD BREAKS
local function GuardBreak(enemyChar,toolName): boolean?
	print("enemyChar:GetAttribute('Blocking')  ", enemyChar:GetAttribute("Blocking") )
	if enemyChar:GetAttribute("Blocking") >= 100 then	
		-- client effects
		RS.Events.VFX:FireAllClients("GuardBreak", enemyChar)
		
		--stopAnims(enemyChar.Humanoid)
		
		-- PLAY GUARDBREAK SOUND
		do
			local BlockSound = SFXFolder.Weapons:WaitForChild(toolName):WaitForChild("BlockBreak"):Clone()
			BlockSound.Parent = enemyChar:WaitForChild("HumanoidRootPart")
			BlockSound:Play()
			Debris:AddItem(BlockSound,2)
		end
		
		local animHandler = NPCAnimBinder:Get(enemyChar)
		animHandler:LoadAnimation(true, "GuardBreak")

		-- CHANGE THE PLAYER UI
		local enemyPlr = game:GetService("Players"):GetPlayerFromCharacter(enemyChar)
		if enemyPlr then
			RS.Events.VFX:FireClient(enemyPlr,"GuardBreakCamera")	
			enemyPlr.PlayerGui.BlockingUi.MainFrame.Visible = false
			enemyPlr.PlayerGui.BlockingUi.MainFrame.Bar.Size = UDim2.new(0,0,1,0)
		end

		local enemyH = enemyChar:WaitForChild("Humanoid")
		print("enemyH ", enemyH)
		stunt_client(enemyH, 3)
		
		-- RESET BLOCKING
		enemyChar:SetAttribute("Blocking", 0)
		return true
	end
end

--[[
function for changing the players combo
set the current combo as an attribute
and stores the cooldown
]]
module.ChangeCombo = function(char): nil
	-- SET THE COMBO ATT
	local combo = char:GetAttribute("Combo")
	
	if lastSwing[char] then
		local passedTime = tick() - lastSwing[char]
		if passedTime <= 2 then --change the 2 if you wan't the combo to reset faster/slower
			if combo >= Max_Combo then
				char:SetAttribute("Combo", 1)				
			else
				char:SetAttribute("Combo", combo + 1)
			end
		else
			char:SetAttribute("Combo", 1)			
		end
	end
	-- sets the Tick for cc
	lastSwing[char] = tick()
end

---------------- stopAnimation function ---------------- 
module.stopAnims = function(hum): nil
	--stopAnims(hum)
	error("don't use this shit", 2)
end

-- GETTING HIT WHILE BLOCKING
module.Blocking = function(enemyChar, damage): nil

	if enemyChar:GetAttribute("Blocking") <= 100  then
		local toolName
		-- is for npc's cuz they have an attribute for there weapon
		if not enemyChar:FindFirstChildWhichIsA("Tool") then 
			toolName = enemyChar:GetAttribute("Weapon") 
		else 
			toolName = enemyChar:FindFirstChildWhichIsA("Tool").Name 
		end 
		
		RS.Events.VFX:FireAllClients("BlockingHit", enemyChar)
		
		local attValue = enemyChar:GetAttribute("Blocking")
		--enemyChar:SetAttribute("Blocking", attValue + damage * 2.75)
		enemyChar:SetAttribute("Blocking", attValue + 20)
		
		-- Play blocked sound
		do
			local BlockSound = SFXFolder.Weapons:WaitForChild(toolName):WaitForChild("Blocked"):Clone()
			BlockSound.Parent = enemyChar:WaitForChild("HumanoidRootPart")
			BlockSound:Play()
			Debris:AddItem(BlockSound,2)
		end
		

		GuardBreak(enemyChar,toolName)
		--if not 	then 
		--back_by_impact
		--end
		
	end
end

--function for parrying the enemies hit, --enemy is the one that parryed
module.Parrying = function(char,enemyChar): nil
	local toolName

	if not enemyChar:FindFirstChildWhichIsA("Tool") then toolName = enemyChar:GetAttribute("Weapon") else toolName = enemyChar:FindFirstChildWhichIsA("Tool").Name end -- is for npc's cuz they have an attribute for there weapon
	
	char:SetAttribute("Blocking",  char:GetAttribute("Blocking") + 20)
	enemyChar:SetAttribute("Blocking",  enemyChar:GetAttribute("Blocking") - 20)
	if enemyChar:GetAttribute("Blocking") <= 0 then
		enemyChar:SetAttribute("Blocking",0)
	end
	
	--stopAnims(char.Humanoid)
	
	if not GuardBreak(char,toolName)	then 
		
		char:SetAttribute("Attacking", false)
		char:SetAttribute("Swing", false)
		
		RS.Events.VFX:FireAllClients("ParryHit", enemyChar)
		local plr = game:GetService("Players"):GetPlayerFromCharacter(char)
		if plr  then RS.Events.VFX:FireClient(plr, "ParryEffect") end

		local ParrySound = SFXFolder.Weapons:WaitForChild(toolName):WaitForChild("Parryed"):Clone()
		ParrySound.Parent = char:WaitForChild("HumanoidRootPart")
		ParrySound:Play()
		Debris:AddItem(ParrySound,3)
		
		stunt_client(char:WaitForChild("Humanoid"), 1.2)
	end
	
end

--math stuff for checking if the one character is infront or behind the other one
module.CheckInfront = function(char,enemyChar): boolean
	local RootPart = enemyChar.HumanoidRootPart
	local AttackDirection = (char.HumanoidRootPart.Position - RootPart.Position).Unit
	local FrontDirection = RootPart.CFrame.LookVector
	local Direction = math.acos(AttackDirection:Dot(FrontDirection)) < math.rad(90)
	
	if not Direction then
		--print("anywhere else")
		return false
	else
		--print("Ifront")
		return true
	end
end

return module

