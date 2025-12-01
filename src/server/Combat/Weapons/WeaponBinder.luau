local RS = game:GetService("ReplicatedStorage")

local WeaponBinder = {}

WeaponBinder.WeaponBinder = {}

WeaponBinder.init = function(Binder)
	WeaponBinder.WeaponBinder = Binder.new(
		"Armed",
		require(script.Parent.WeaponCtx)
	)
	WeaponBinder.WeaponBinder:GetClassAddedSignal():Connect(function(handler, npcModel)
		
	end)
	WeaponBinder.WeaponBinder:Start()
	return WeaponBinder.WeaponBinder
end

return WeaponBinder