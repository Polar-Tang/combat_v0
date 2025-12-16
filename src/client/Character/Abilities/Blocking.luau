local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")

--||Character||--
local plr = game:GetService("Players").LocalPlayer
local char = plr.Character

--||Events / Ui||--
local blockingUi = plr.PlayerGui:WaitForChild("BlockingUi")

--||Folder||--
local SFXFolder = SoundService:WaitForChild("SFX")


--||Settings||--
local debounce = false

------------------------------------------------------------------------------------------------------------------
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
char:WaitForChild("Humanoid").Died:Connect(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)

local Blocking = {}

function Blocking.Execute() --function for starting to block
	local attacking = char:GetAttribute("Attacking")
	local Stunned = char:GetAttribute("Stunned")
	local IsRagdoll = char:GetAttribute("IsRagdoll")
	local Blocking = char:GetAttribute("IsBlocking")
	if attacking or Stunned or IsRagdoll or Blocking then return end

	debounce = true
	blockingUi.MainFrame.Visible = true
	local BlockSound = SFXFolder.Weapons:WaitForChild(char:FindFirstChildWhichIsA("Tool").Name):WaitForChild("BlockingStart"):Clone()
	BlockSound.Parent = char:WaitForChild("HumanoidRootPart")
	BlockSound:Play()
	Debris:AddItem(BlockSound,1)
	task.wait(1)
	debounce = false
end 

function Blocking.Kill() --function for stoping to block
	if char:GetAttribute("Blocking") == 0 then blockingUi.MainFrame.Visible = false	end
	local BlockSound = SFXFolder.Weapons:WaitForChild(char:FindFirstChildWhichIsA("Tool").Name):WaitForChild("BlockingStop"):Clone()
	BlockSound.Parent = char:WaitForChild("HumanoidRootPart")
	BlockSound:Play()
	Debris:AddItem(BlockSound,1)
end 

--uis.InputBegan:Connect(function(key, isTyping)
--	if isTyping then return end

--	if key.KeyCode == Enum.KeyCode.F then
--		if not debounce and char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):GetAttribute("Type") == "Attack" then
--			startBlocking()
--		end
--	end
--end)

function Blocking.Check()
	return not debounce 
end

function Blocking.IsBlocking()
	local Stunned = char:GetAttribute("Stunned")
	return not Stunned and char:GetAttribute("IsBlocking")
end
	

--uis.InputEnded:Connect(function(key)
--	local Stunned = char:GetAttribute("Stunned")
--	if key.KeyCode == Enum.KeyCode.F and not Stunned and char:GetAttribute("IsBlocking") then
--		Blocking.Kill()
--	end
--end)

char.ChildRemoved:Connect(function()
	if not char:FindFirstChildWhichIsA("Tool") and char:GetAttribute("IsBlocking") then
		Blocking.Kill()
		
	end
end)

char:GetAttributeChangedSignal("Stunned"):Connect(function()
	if char:GetAttribute("Stunned") and char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):GetAttribute("Type") == "Attack" then
		Blocking.Kill()
	end
end)
char:GetAttributeChangedSignal("IsBlocking"):Connect(function()
	if char:GetAttribute("IsBlocking")  and char:GetAttribute("Stunned") then
		Blocking.Kill()
	end
end)
char:GetAttributeChangedSignal("Blocking"):Connect(function()
	if char:GetAttribute("Blocking") >= 100 then
		Blocking.Kill()
	end
end)

char:GetAttributeChangedSignal("Blocking"):Connect(function()
	blockingUi.MainFrame.Bar:TweenSize(UDim2.new(char:GetAttribute("Blocking") / 100,0,1,0), Enum.EasingDirection.InOut,Enum.EasingStyle.Sine, .3)
	blockingUi.MainFrame.Visible = true
	if char:GetAttribute("Blocking") == 0 then
		blockingUi.MainFrame.Visible = false
	end
end)

return Blocking