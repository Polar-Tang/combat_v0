--||Services||--
local RS = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local TS = game:GetService("TweenService")

--||Player||--
local plr = game:GetService("Players").LocalPlayer

--||Folder||--
local Effects = RS:WaitForChild("Effects")
--||Services||--
local RS = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TS = game:GetService("TweenService")

--||Camera||--
local camera = game.Workspace.CurrentCamera

--||Camera Shake Module||--
local CameraShakeModule = require(RS:WaitForChild("Modules"):WaitForChild("CameraShaker"))	
local camShake = CameraShakeModule.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	camera.CFrame = camera.CFrame * shakeCf
end)
camShake:Start()
------------------------------------------------------------------------------------------------------------------

local function getTorso(char)
	local HUM = char:WaitForChild("Humanoid")

	local Torso 
	if HUM.RigType == Enum.HumanoidRigType.R6 then
		Torso = char:WaitForChild("Torso")
	else
		Torso = char:WaitForChild("UpperTorso")
	end
end

--||VFX All Clients Function||--
RS:WaitForChild("Events"):WaitForChild("VFX").OnClientEvent:Connect(function(action,...)
	--print("new action: ", action)
	
	if action == "SwordHitShake" then		
		camShake:ShakeOnce(1.6,4.5,0.2,1)
	end

	if action == "ParryEffect" then
		Lighting.BlurEffect.Size = 25
		TS:Create(Lighting.BlurEffect, TweenInfo.new(1.5), {Size = 0}):Play()
		camShake:ShakeOnce(1.2,3.8,0.15,.7)
	end

	if action == "GuardBreakCamera" then
		camShake:ShakeOnce(2.2,5.7,0.8,1.5)
	end
	if action == "SwordHit" then
		local enemy = ...
		local Hit = plr.Character:GetAttribute("Combo")
		if Hit ~= 4 then enemy.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
		
		local BloodEffect = Effects:WaitForChild("Blood").Attachment:Clone()
		BloodEffect.Parent = getTorso(enemy)
		Debris:AddItem(BloodEffect, 3)
		
		for i,v in pairs(BloodEffect:GetDescendants()) do
			v:Emit(v:GetAttribute("EmitCount"))
		end
		
	end
	
	if action == "BlockingHit" then
		local enemy: Model = ...
		--print(enemy, "enemy ", type(enemy))
		--enemy.
		local BlockEffect = Effects:WaitForChild("Block").Attachment:Clone()
		BlockEffect.Parent = getTorso(enemy)
		Debris:AddItem(BlockEffect, 3)

		for i,v in pairs(BlockEffect:GetDescendants()) do
			v:Emit(v:GetAttribute("EmitCount"))
		end

	end
	
	if action == "ParryHit" then
		local enemy = ...

		local ParryEffect = Effects:WaitForChild("Parry").Attachment:Clone()
		ParryEffect.Parent = getTorso(enemy)
		Debris:AddItem(ParryEffect, 3)

		for i,v in pairs(ParryEffect:GetDescendants()) do
			v:Emit(v:GetAttribute("EmitCount"))
		end

	end
	
	if action == "GuardBreak" then
		local enemy = ...
		local GuardBreakEffect = Effects:WaitForChild("GuardBreak").Attachment:Clone()

		GuardBreakEffect.Parent = getTorso(enemy)
		Debris:AddItem(GuardBreakEffect, 3)

		for i,v in pairs(GuardBreakEffect:GetDescendants()) do
			v:Emit(v:GetAttribute("EmitCount"))
		end

	end
	
	if action == "HeavyAttack" then
		local char = ...

		local KanjiEffect = Effects:WaitForChild("DangerKanji"):Clone()
		KanjiEffect.Parent = char.Head.FaceCenterAttachment
		Debris:AddItem(KanjiEffect, 3)

		KanjiEffect:Emit(1)

	end
	
	if action == "Iframes" then
		local enemyHRP, duration = ...
		
		if enemyHRP then 			
			local highlight = Instance.new("Highlight")			
			highlight.Parent =  enemyHRP.Parent 
			highlight.DepthMode = Enum.HighlightDepthMode.Occluded
			highlight.FillTransparency = 0.2
			highlight.FillColor = Color3.fromRGB(255, 255, 255)
			highlight.OutlineTransparency = 0
			highlight.OutlineColor = Color3.fromRGB(185, 185, 185)
			local TweenGoal1 = {FillTransparency = 1, OutlineTransparency = 1}
			local enemyHitTween = TS:Create(highlight, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false), TweenGoal1):Play()
			Debris:AddItem(highlight,duration)					
		end
	end

	
end)