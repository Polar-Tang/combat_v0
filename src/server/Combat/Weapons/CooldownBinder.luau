local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

-- print("RS.Nevermore.cooldown.Server.Binders.Cooldown ", RS.Nevermore.cooldown.Server.Binders.Cooldown)
-- local Cooldown = serviceBag:GetService()
-- print("Cooldown ", Cooldown)

local CooldownBinder = {}

CooldownBinder.CooldownBinder = {}

CooldownBinder.test = nil
CooldownBinder.init = function(ServiceBag, Binder)
	CooldownBinder.CooldownBinder = Binder.new("CD", require(script.Parent.CooldownController))
	-- CooldownBinder.CooldownBinder:GetClassAddedSignal():Connect(function(handler, npcModel)

	-- end)
	print("RETURN THIS SHIT ", CooldownBinder.CooldownBinder)
	return CooldownBinder.CooldownBinder
end

return CooldownBinder
