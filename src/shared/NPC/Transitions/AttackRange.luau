local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StateMachine = require(ReplicatedStorage.StateMachine)

local Transition = StateMachine.Transition

local AttackRange = Transition.new("Attack")

function AttackRange:OnDataChanged(data)
	if (data.timer - data.lastTriggerTime) == 0 then
		if data.TargetingController:GetDistanceToTarget() < 6 then
			data.MovementController:Stop()
			return true
		end
	end
	return false
end

return AttackRange
