local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage.Events

local npcMediator = {}

-- Server
Events.NPCs.OnServerEvent:Connect(function(player, prompt)
	local npcModel = prompt.Parent
	local id = prompt.ObjectText
	-- EZ anti exploits checks
	do
		local RealNPC = CollectionService:GetTagged(id)[1]
		if not RealNPC then
			return
		end
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
end)

return npcMediator
