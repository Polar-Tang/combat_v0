local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Events = ReplicatedStorage.Events
-- Server
Events.NPCs.OnServerInvoke = function(player, data)
	local npcModel = data.npc
	local id = data.id
	local prompt = data.prompt
	-- EZ anti exploits checks
	do
		if npcModel.Parent ~= Workspace.NPCs then
			return
		end

		local RealNPC = Workspace.npcModel
		if RealNPC ~= npcModel then
			return
		end
		local RealPrompt = RealNPC:FindFirstChildOfClass("ProximityPrompt")

		if RealPrompt ~= prompt then
			return
		end
		-- Validate distance (anti-teleport exploit)
		local distance = (player.Character.HumanoidRootPart.Position - npcModel.PrimaryPart.Position).Magnitude
		if distance > prompt.MaxActivationDistance + 5 then
			return
		end
	end

	Events.NPCs:FireClient(player, {
		npc = npcModel,
		id = id,
		prompt = prompt,
	})
	return true
end
