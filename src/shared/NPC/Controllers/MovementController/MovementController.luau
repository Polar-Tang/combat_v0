-- MovementController.lua
-- TODO: Implement a method for completly stop moving the character
local ReplicatedSorage = game:GetService("ReplicatedStorage")
local FollowPath = require(script.Parent.FollowPath)
local MovementController = {}
MovementController.__index = MovementController

function MovementController.new(model: Instance?, serviceBag: any)
	local self = setmetatable({}, MovementController)
	self.Model = model
	self.Humanoid = self.Model:WaitForChild("Humanoid")
	self.Humanoid.WalkSpeed = 10

	self._root = self.Model:WaitForChild("HumanoidRootPart")
	local BinderProvider = serviceBag:GetService(_G.BinderProvider)

	-- local WeaponBinder = BinderProvider:Get("Armed")
	local AnimationBinder = BinderProvider:Get("AnimationHandler")
	self._AnimationHandler = AnimationBinder:Get(model)
	local Animations = ReplicatedSorage.Animations
	local anims = require(Animations.WeaponsAnims)["Fist-r6"]
	local otherAnims = require(Animations.OtherAnims)["default_r6"]
	self._AnimationHandler:registryAnims(anims)
	self._AnimationHandler:AddAnimations(otherAnims)
	return self
end

function MovementController:MoveTo(targetPosition)
	--self.Strategy:Update(self.Model, targetPosition, self.animator, animationId, petPos)
	-- We should use followPath function here
	print("targetPosition", targetPosition)
	local hum: Humanoid = self.Humanoid
	print("hum ", hum)
	-- hum:MoveTo(targetPosition, self._root)
	FollowPath(targetPosition, self.Model) 
	self._AnimationHandler:LoadAnimation(true, "walk")
end


return MovementController
