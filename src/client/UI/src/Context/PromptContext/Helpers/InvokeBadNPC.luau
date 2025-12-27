local Players: Players = game:getService("Players")
local player = Players.LocalPlayer

local serviceBag = _G.Client_ServiceBag
local BinderProvider = serviceBag:GetService(_G.Client_BinderProvider)
local NpcBinder = BinderProvider:Get("NPC")

local invokeBadNPC = {}

invokeBadNPC.Invoke = function(npc)
	local npc_controller = NpcBinder:Get(npc)
	npc_controller:Init(player)
end

invokeBadNPC.Uninvoke = function(npc)
	local npc_controller = NpcBinder:Get(npc)
	npc_controller:onRemove(player)
end

return invokeBadNPC
