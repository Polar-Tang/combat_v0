local RS = game:GetService("ReplicatedStorage")

local nome = {}

nome.WeaponCooldown = {}

nome.init = function(Cooldown, serviceBag)
	
	Cooldown:Start()
	return nome.WeaponCooldown
end

return nome