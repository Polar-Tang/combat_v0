-- AttackerController.lua
local Anims = game:GetService("ReplicatedStorage").Animations
local StarterPack = game:GetService("StarterPack")
local weaponAnims = require(Anims.WeaponsAnims)

local AttackerController = {}
AttackerController.__index = AttackerController

function AttackerController.new(model, serviceBag)
	local self = setmetatable({}, AttackerController)
	
	local BinderProvider = serviceBag:GetService(_G.BinderProvider)

	local WeaponBinder = BinderProvider:Get("Armed")
	self._WeaponBinder = WeaponBinder:Get(model)
	self._WeaponBinder:registryTool("Fist")
	local FistTool = StarterPack:FindFirstChild("Fist")

	self._WeaponBinder:EquiTool(FistTool)

	local AnimationHandler = BinderProvider:Get("AnimationHandler")
	self._AnimationHandler = AnimationHandler:Get(model)
	self._AnimationHandler:registryAnims(weaponAnims["Fist-r6"])
	return self
end

function AttackerController:Attack()
	self._WeaponBinder:Execute(Enum.UserInputType.MouseButton1)
end

return AttackerController