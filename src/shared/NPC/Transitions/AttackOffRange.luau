local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StateMachine = require(ReplicatedStorage.StateMachine)

local Transition = StateMachine.Transition

local OffAttackRange = Transition.new("Chasing")

function OffAttackRange:OnDataChanged(data)
	print("consider to change self.timer to data.timer, so its accesible to every state")

	--lastTime = data.lastTriggerTime

	if (data.timer - data.lastTriggerTime) == 0 then
		if data.TargetingController:GetDistanceToTarget() > 6 then
			return true
		end
	end
	return false
end

return OffAttackRange
