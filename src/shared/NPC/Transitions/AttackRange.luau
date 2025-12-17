local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StateMachine = require(ReplicatedStorage.StateMachine)

local Transition = StateMachine.Transition

local AttackRange = Transition.new("Attack")

function AttackRange:OnDataChanged(data)
	--TODO: consider to change self.timer to data.timer, so its accesible to every state
	print("Attack range ", data.timer - data.lastTriggerTime)
	if (data.timer - data.lastTriggerTime) == 0 then

		if data.TargetingController:GetDistanceToTarget() < 6 then
			data.walkAnimationTrack:Stop()
			return true
		end

	end
	return false
end

return AttackRange