local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RobloxStateMachine = require(ReplicatedStorage.StateMachine)
local setCTX = require(ReplicatedStorage.NPC.helpers.setCtx)
local StatesFolder = ReplicatedStorage.NPC.States


local StateMachine = {}
StateMachine.ServiceName = "StateMachine"

function StateMachine.new(char: Model, serviceBag)
    local state = RobloxStateMachine.new("Idle", RobloxStateMachine:LoadDirectory(StatesFolder), setCTX(char, serviceBag))
	return state
end

return StateMachine
