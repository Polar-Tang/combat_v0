task.wait(5)
local RS = game:GetService("ReplicatedStorage")
local CooldownPath = RS.Nevermore.cooldown.Server.Binders.Cooldown

local Cooldown = _G.ServiceBag:GetService(require(CooldownPath))

local npc = workspace.Blocking
local nv = Instance.new("NumberValue")
nv.Name = "TheTestOne"
nv.Parent = npc
nv:AddTag("Cooldown")

-- trigger cooldown
nv.Value = 3

task.delay(0.2, function()
	local cd = Cooldown:Get(nv)
	print("Cooldown:", cd)
	print("GetTimePassed:", cd:GetTimePassed())
	print("GetStartTime:", cd:GetStartTime())
end)
