local PedestrianStat = {}
PedestrianStat.__index = PedestrianStat

function PedestrianStat.new(movementStrategy)
	print("movementStrategy ", movementStrategy)
	local self = setmetatable({}, PedestrianStat)
	self.Strategy = movementStrategy
	
	return self
end

local getTargetCFrame = require(script.Parent.GetTargetCF)

function PedestrianStat:Update(Model, targetPosition, animator, animationId, petPos)
	--local targetCF = getTargetCFrame(targetPosition, petPos)
	self.Strategy:Update(Model, targetPosition, animator, animationId, petPos)
	self.Strategy:Stop()
end
return PedestrianStat

