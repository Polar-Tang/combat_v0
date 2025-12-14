--||Services||--
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
local StarterPack = game:GetService("StarterPack")
--||Nevermore Shit||--
----------------------------- getting servicebag and loader -----------------------------

local NeverMorePackages = RS.Nevermore
local loader = NeverMorePackages:FindFirstChild("LoaderUtils", true).Parent
local Nevermore = require(loader).bootstrapGame(NeverMorePackages)

local ServiceBag = Nevermore("ServiceBag")
local serviceBag = ServiceBag.new()

----------------------------- init process -----------------------------
_G.FistBag = serviceBag

---------- COLDOWNS ----------
local Cooldown = serviceBag:GetService(Nevermore("Cooldown"))
serviceBag:GetService(Nevermore("TimeSyncService"))
---------- OTHERS ----------
serviceBag:GetService(Nevermore("RagdollService"))
---------- BINDERS ----------
local AnimationHandler = Nevermore("AnimationHandler")
local Binder = Nevermore("Binder")
local WeaponBinder = Nevermore("Weapon")
local Binders = {
	["AnimationHandler"] = AnimationHandler,
	["Armed"] = WeaponBinder,
}
---------- USE BINDER PORVIDER ----------
local BinderProvider = Nevermore("BinderProvider")

local AttacksBinders = BinderProvider.new("Binders", function(self, serviceBag)
	for tag, contructor in pairs(Binders) do
		self:Add(Binder.new(tag, contructor), serviceBag, "test")
	end
end)

----- ------------------------ START SERVICEBAG -----------------------------
serviceBag:GetService(AttacksBinders)
serviceBag:Init()
Cooldown:Start()
serviceBag:Start()
_G.FistBag = nil
_G.ServiceBag = serviceBag
_G.BinderProvider = AttacksBinders

------------------Once initilized-------------------------------
local BinderProviderStarted = serviceBag:GetService(_G.BinderProvider)
local weaponBinder = BinderProviderStarted:Get("Armed")
-- local BinderProvider = self._serviceBag:GetService(_G.BinderProvider)
-- 	-- weapon Binder
-- 	local WeaponBinder = BinderProvider:Get("Armed")
local FistTool = StarterPack:FindFirstChild("Fist")
weaponBinder:GetClassAddedSignal():Connect(function(warrior)
	print("warrior ", warrior)
	if warrior.Char.Name == "Blocking" then
		warrior:EquiTool(FistTool)
	end
end)

local AnimBinder = BinderProviderStarted:Get("AnimationHandler")
local Anims = game:GetService("ReplicatedStorage").Animations
local weaponAnims = require(Anims.WeaponsAnims)

AnimBinder:GetClassAddedSignal():Connect(function(character)
	character:registryAnims(weaponAnims["Fist-r6"])
	character:LoadAnimation(true, "Blocking")
end)

------------------Do binder stuff-------------------------------
--||PlayerAdded||--
local Ragdoll = Nevermore("Ragdoll")
local CombatMediator = require(SSS.Combat.CombatMediator)
local CollectionService = game:GetService("CollectionService")
Players.PlayerAdded:Connect(function(player)
	local char = player.Character or player.CharacterAdded:Wait()
	CollectionService:AddTag(char, "AnimationHandler")
	CollectionService:AddTag(char, "Armed")
	CollectionService:AddTag(char, "CD")
	------------------ TEST ------------------
	CombatMediator.PlayerAdded(player)
	-- TODO: test this
	local hum: Humanoid = char:WaitForChild("Humanoid")
	hum.Died:Connect(function()
		Ragdoll:Tag(hum)
	end)
end)
--||PlayerRemoving||--
Players.PlayerRemoving:Connect(function(player)
	-- PlayerAnimationHandler:RemovePlayer({ player = player })
end)
