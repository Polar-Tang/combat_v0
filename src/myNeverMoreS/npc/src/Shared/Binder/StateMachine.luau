local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RobloxStateMachine = require(ReplicatedStorage.StateMachine)
local setCTX = require(ReplicatedStorage.NPC.helpers.setCtx)
local StatesFolder = ReplicatedStorage.NPC.States

local StateMachine = {}
StateMachine.ServiceName = "StateMachine"
StateMachine.__index = StateMachine

function StateMachine.new(char: Model, serviceBag)
	local self = setmetatable({}, StateMachine)
	local state =
		RobloxStateMachine.new("Chasing", RobloxStateMachine:LoadDirectory(StatesFolder), setCTX(char, serviceBag))
	self.state = state
	return self
end
function StateMachine:Destroy()
	self.state:Destroy()
end
return StateMachine
