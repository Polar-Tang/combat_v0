local tool = game:GetService("StarterPack").Fist
script.Parent = tool
local StarterGui = game:GetService("StarterGui")
local RS = game:GetService("ReplicatedStorage")
local BackpackCoreGui = Enum.CoreGuiType.Backpack

--||RemoteEvents||--
local remotes = RS.Events
local Equipment = remotes.Equipment

tool.Equipped:Connect(function()
	StarterGui:SetCoreGuiEnabled(BackpackCoreGui, false)
	task.wait(.6)
	StarterGui:SetCoreGuiEnabled(BackpackCoreGui, true)
	Equipment:FireServer({
		tool = tool,
		has_to_equip = true
	})
end)



tool.Unequipped:Connect(function()
	StarterGui:SetCoreGuiEnabled(BackpackCoreGui, false)
	task.wait(.6)
	StarterGui:SetCoreGuiEnabled(BackpackCoreGui, true)
	Equipment:FireServer({
		tool = tool,
		has_to_equip = false
	})
end)