local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage.Events
local swingEvent = Events.Swing
--local blockingEvent = Events.Blocking

local CombatMediator = {}

function CombatMediator.PlayerAdded(player: Player)
	local char = player.Character or player.CharacterAdded:Wait()
	char:SetAttribute("Combo", 1)
	char:SetAttribute("Stunned", false)
	char:SetAttribute("Swing", false)
	char:SetAttribute("Attacking", false)
	char:SetAttribute("IsRagdoll", false)
	char:SetAttribute("Iframes", false)
	char:SetAttribute("IsBlocking", false)
	char:SetAttribute("Blocking", 0)
	char:SetAttribute("Parrying", false)		
end

local Attcks = script.Parent.Attacks

--||Event for combat||--
local combatServer = require(Attcks.AttckInvoker)

swingEvent.OnServerEvent:Connect(combatServer.swingEvent)

return CombatMediator
