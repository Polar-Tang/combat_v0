local RS = game:GetService("ReplicatedStorage")

local CooldownBinder = {}

CooldownBinder.CD = {}

function CooldownBinder.init (ServiceBag, CooldownShit)
	-- Inject the service bag into the damn binder
	CooldownShit:Init(ServiceBag)
	CooldownBinder.CD = CooldownShit
	CooldownBinder.CD:Start()

	return CooldownBinder.CD
end

return CooldownBinder