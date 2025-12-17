-- local followPath = require(game:GetService("ServerScriptService"):WaitForChild("Helpers"):WaitForChild("FollowPath"))
-- HumanoidMovementStrategy.lua
local HumanoidMovementStrategy = {}
HumanoidMovementStrategy.__index = HumanoidMovementStrategy

function HumanoidMovementStrategy.new(humanoid, model)
	print("humanoid ", humanoid)
	local self = setmetatable({}, HumanoidMovementStrategy)
	self.humanoid = humanoid
	self.moveFinnish = nil
	self.track = nil
	self.model = model
	self.positionsRegistry = {}
	model:setAttribute("cinematicType", "humanoid")

	return self
end


function HumanoidMovementStrategy:Update(Model, targetPosition, animator: Animator , animationId, petPos)
	local lookVector = (targetPosition - petPos).Unit
	local  goal =  targetPosition - lookVector * 4
	self.humanoid:MoveTo(goal)
	table.insert(self.positionsRegistry, targetPosition)
	
	local animation = Instance.new("Animation")
	animation.AnimationId = animationId
	self.track = animator:LoadAnimation(animation)
	self.track:Play()
	
end

function HumanoidMovementStrategy:Stop(petModel)
	if self.moveFinnish then return end
	self.moveFinnish = self.humanoid.MoveToFinished:Connect(function()
		self.track:Stop()
	end)
end

return HumanoidMovementStrategy