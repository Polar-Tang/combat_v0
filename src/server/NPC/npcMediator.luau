local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage.Events

local npcMediator = {}

local Players: Players = game:getService("Players")
local player = Players.LocalPlayer

local serviceBag = _G.ServiceBag
local BinderProvider = serviceBag:GetService(_G.BinderProvider)
local NpcBinder = BinderProvider:Get("NPC")

local invokeBadNPC = {}

invokeBadNPC.Invoke = function(npc)
	local npc_controller = NpcBinder:Get(npc)
	npc_controller:Init(player)
end

invokeBadNPC.Uninvoke = function(npc)
	local npc_controller = NpcBinder:Get(npc)
	npc_controller:OnRemove(player)
end

-- Server
Events.NPCs.OnServerEvent:Connect(function(player, prompt, hasToDisconnect)
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

	if hasToDisconnect then
		invokeBadNPC.Uninvoke(npcModel)
	else
		invokeBadNPC.Invoke(npcModel)
	end

	Events.NPCs:FireClient(player, {
		npc = npcModel,
		id = id,
		prompt = prompt,
	})
	return true
end)

return npcMediator
