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

return invokeBadNPC
