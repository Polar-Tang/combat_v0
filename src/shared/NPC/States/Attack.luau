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
	
end

function Attack:OnDataChanged(data)
	
end

function Attack:OnHeartbeat(data, deltaTime)
	data.timer += deltaTime
	if data.timer - data.lastTriggerTime >= 1 then
		data.lastTriggerTime = data.timer
		data.TargetingController:LookTarget()
		data.AttackerController:Attack()
	end

end
return Attack
