local Players = game:GetService("Players")
local player: Player = Players.LocalPlayer
local tool = player.Backpack:WaitForChild("Fist")
local StarterGui = game:GetService("StarterGui")
local RS = game:GetService("ReplicatedStorage")
local BackpackCoreGui = Enum.CoreGuiType.Backpack

--||RemoteEvents||--
local remotes = RS.Events
local Equipment = remotes.Equipment

tool.Equipped:Connect(function()
	
	StarterGui:SetCoreGuiEnabled(BackpackCoreGui, false)
	task.delay(.6, function()
		StarterGui:SetCoreGuiEnabled(BackpackCoreGui, true)
	end)
	Equipment:FireServer({
		tool = tool,
		has_to_equip = true
	})
end)



tool.Unequipped:Connect(function()
	
	StarterGui:SetCoreGuiEnabled(BackpackCoreGui, false)
	task.delay(.6, function()
		StarterGui:SetCoreGuiEnabled(BackpackCoreGui, true)
	end)
	Equipment:FireServer({
		has_to_equip = false
	})
end)