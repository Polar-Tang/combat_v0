local ReplicatedSorage = game:GetService("ReplicatedStorage")

local StateMachine = require(ReplicatedSorage.StateMachine)

local State = StateMachine.State

local Chasing = State.new("Chasing")

-------------- Transitions --------------
local Transition = ReplicatedSorage.NPC.Transitions
local OffAtackRange = require(Transition.AttackRange)
local Died = require(Transition.Died)

Chasing.Transitions = {
	OffAtackRange,
	Died,
}

------------------------------------------

-- Here we initilize
function Chasing:OnInit(data)
	--------- Initiliaze sounds ---------
	local sounds = {
		["battlecries"] = {
			"rbxassetid://111365122274091",
			"rbxassetid://94949373389186",
			"rbxassetid://80283138976950",
		},
	}
	data.SoundController:RegistrySounds(sounds)

	-- Forces to get an enemy
	local enemy: Model = workspace:WaitForChild("virtual_nautilus")
	local Players: Players = game:GetService("Players")
	local player = Players:GetPlayerFromCharacter(enemy)
	data.TargetingController:SetTargetPlayer(player)

end

function Chasing:OnEnter(data)
	-- self.timer = 0
	-- self.lastTriggerTime = 0

end


function Chasing:OnHeartbeat(data, deltatime)
	data.timer += deltatime
	if data.timer - data.lastTriggerTime >= 1 then
		data.lastTriggerTime = data.timer
		
		local currentPos = data.TargetingController:GetTargetPosition()

		if currentPos then
			data.MovementController:MoveTo(currentPos)
		end
	end
end
return Chasing
