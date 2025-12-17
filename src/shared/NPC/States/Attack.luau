local ReplicatedSorage = game:GetService("ReplicatedStorage")

local StateMachine = require(ReplicatedSorage.StateMachine)

local State = StateMachine.State

local Attack = State.new("Attack")

-- Transitions 
local Transition = ReplicatedSorage.NPC.Transitions
local OffAtackRange = require(Transition.AttackOffRange)
local Died = require(Transition.Died)

Attack.Transitions = {
	OffAtackRange,
	Died,
}



function Attack:OnEnter(data)
	self._timer = 0
	self._lastTriggerTime = 0
end

function Attack:OnDataChanged(data)
	
end

function Attack:OnHeartbeat(data, deltaTime)
	self.timer += deltaTime
	if self.timer - self.lastTriggerTime >= 1 then
		data.TargetingController:LookTarget()
		data.AttackerController:Attack()
	end

end
return Attack
