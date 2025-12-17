-- MovementController.lua
-- TODO: Implement a method for completly stop moving the character
local MovementController = {}
MovementController.__index = MovementController

function MovementController.new(model: Instance?, serviceBag: any)
	local self = setmetatable({}, MovementController)
	self.Model = model
	self.Humanoid = self.Model:WaitForChild("Humanoid")
	self.Humanoid.WalkSpeed = 10

	local BinderProvider = serviceBag:GetService(_G.BinderProvider)

	-- local WeaponBinder = BinderProvider:Get("Armed")
	local AnimationBinder = BinderProvider:Get("AnimationHandler")
	self._AnimationHandler = AnimationBinder:Get(model)

	return self
end

function MovementController:MoveTo(targetPosition)
	--self.Strategy:Update(self.Model, targetPosition, self.animator, animationId, petPos)
	-- We should use followPath function here
	self.Humanoid:MoveTo(targetPosition)
	self._AnimationHandler:LoadAnimation(true, "walk")
end


return MovementController
