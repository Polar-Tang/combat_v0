local ReplicatedSorage = game:GetService("ReplicatedStorage")
local StateMachine = require(ReplicatedSorage.StateMachine)

local State = StateMachine.State

local Dead = State.new("Dead")

function Dead:OnEnter(data)
	local npc: Model = data.npc
	
	npc:Destroy()
end
return Dead
