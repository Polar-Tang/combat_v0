--TODO: this script is only listeen for a single weapon, we need a weapon to listen to any weapon equipped by the player and fire Equipment remote event

--||Service||--
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

local RS = game:GetService("ReplicatedStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BackpackCoreGui = Enum.CoreGuiType.Backpack

--||Player||--
local player: Player = Players.LocalPlayer

local char = player.Character

--||RemoteEvents||--
local remotes = RS.Events
local Equipment = remotes.Equipment
local tool = player.Backpack:WaitForChild("Fist")
------------------------------------------------------------------------------------------------------------------

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)

char:GetAttributeChangedSignal("Stunned"):Connect(function()
	if char:GetAttribute("Stunned") then
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	else
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
	end
end)

tool.Equipped:Connect(function()
	StarterGui:SetCoreGuiEnabled(BackpackCoreGui, false)
	task.delay(0.6, function()
		StarterGui:SetCoreGuiEnabled(BackpackCoreGui, true)
	end)
	Equipment:FireServer({
		tool = tool,
		has_to_equip = true,
	})
end)

tool.Unequipped:Connect(function()
	StarterGui:SetCoreGuiEnabled(BackpackCoreGui, false)
	task.delay(0.6, function()
		StarterGui:SetCoreGuiEnabled(BackpackCoreGui, true)
	end)
	Equipment:FireServer({
		has_to_equip = false,
	})
end)

local HitboxClass = require(ReplicatedStorage.HitboxClass)

-- Create a sword hitbox that follows the weapon
local hitbox = HitboxClass.new(tool.Name, {
	root = tool,
	size = Vector3.new(4, 1, 6),
	duration = 0.3,
	velocityPrediction = true,
	dotProductFilter = {
		dotProduct = 0.3,
		referenceVector = tool.CFrame.LookVector,
		sourcePosition = tool.Position,
	},
	hitboxId = "sword_" .. player.UserId,
	HitMode = "Weak",
	debug = true,
})

-- Remotes events (i got the code smell to migrate this)
local Events = ReplicatedStorage.Events
local HitboxResponseRemote = Events.HitboxResponseRemote

hitbox.OnHit:Connect(function(character, hitPart)
	HitboxResponseRemote:FireServer(hitPart)
end)

hitbox:Start()
