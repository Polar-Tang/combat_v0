local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StateMachine = require(ReplicatedStorage.StateMachine)
local setCTX = require(script.Parent.helpers.setCtx)
local StatesFolder = ReplicatedStorage.NPC.States

local StateMachineBinder = {}
StateMachineBinder.ServiceName = "StateMachineBinder"
StateMachineBinder.__index = StateMachineBinder

function StateMachineBinder.new(char: Model, serviceBag)
	local self = setmetatable({}, StateMachineBinder)

	self.state = nil
	self._initialized = false
	self._players = {}
	return self
end

-- this method is called on nearby players
function StateMachineBinder:init(player)
	-- the state machine is like the npc's brain
	if self:isInitialized() then
		table.insert(self._players, player)
		return
	end

	local state =
		StateMachine.new("Chasing", StateMachine:LoadDirectory(StatesFolder), setCTX(self.char, self.serviceBag))
	self.state = state
	table.insert(self._players, player, player.UserId)

	return self
end

function StateMachineBinder:isInitialized()
	return next(self._players)
end

-- remove a player from the registry
function StateMachineBinder:onRemove(player)
	-- the state machine is like the npc's brain

	table.remove(self._players, player.UserId)
	return self
end

function StateMachineBinder:Destroy()
	self.state:Destroy()
end
return StateMachineBinder
