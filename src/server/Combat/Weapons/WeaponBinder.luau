local RS = game:GetService("ReplicatedStorage")

local WeaponBinder = {}

WeaponBinder.WeaponBinder = {}

WeaponBinder.init = function(ServiceBag, Binder)
	WeaponBinder.WeaponBinder = Binder.new("Armed", require(script.Parent.WeaponCtx))

	return WeaponBinder.WeaponBinder
end

return WeaponBinder
