--||Services||--
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")

--||Nevermore Shit||--
----------------------------- declaring process -----------------------------

local NeverMorePackages = RS.Nevermore
local loader = NeverMorePackages:FindFirstChild("LoaderUtils", true).Parent
local Nevermore = require(loader).bootstrapGame(NeverMorePackages)

local ServiceBag = Nevermore("ServiceBag")
local serviceBag = ServiceBag.new()

----------------------------- init process -----------------------------
_G.FistBag = serviceBag

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
		self:Add(Binder.new(tag, contructor), serviceBag)
	end
end)

serviceBag:GetService(AttacksBinders)

----- ------------------------ START SERVICEBAG -----------------------------
serviceBag:Init()
serviceBag:Start()
_G.FistBag = nil
_G.ServiceBag = serviceBag
_G.BinderProvider = AttacksBinders
-- local testying = serviceBag:GetService(CooldownBinder)
-- print("This is the service initilized i bet", testying)

-- Cooldown:Start(serviceBag)

-- require(AnimationUtils.AnimationHandlerBinder).start()
---------------- Coldown test ----------------------------
--[[
	local npc = workspace.Blocking
	local nv = Instance.new("NumberValue")
	nv.Name = "AttackCooldown"
	nv.Parent = npc
	nv:AddTag("Cooldown")
	
	-- trigger cooldown
	nv.Value = 3
	
	task.delay(0.2, function()
		local cd = Cooldown:Get(nv)
		print("Cooldown:", cd)
		print("GetTimePassed:", cd:GetTimePassed()) -- GetTimePassed: 0.2756490707397461
		print("GetStartTime:", cd:GetStartTime()) -- GetStartTime: 1764843054.5570555
	end)
]]
------------------------------------------------------------

--||PlayerAdded||--

local CombatMediator = require(SSS.Combat.CombatMediator)
local CollectionService = game:GetService("CollectionService")
Players.PlayerAdded:Connect(function(player)
	local char = player.Character or player.CharacterAdded:Wait()
	CollectionService:AddTag(char, "AnimationHandler")
	CollectionService:AddTag(char, "Armed")
	CollectionService:AddTag(char, "CD")

	CombatMediator.PlayerAdded(player)
	--local animHandler =PlayerAnimationHandler:GetHandler(player)
end)
--||PlayerRemoving||--
Players.PlayerRemoving:Connect(function(player)
	-- PlayerAnimationHandler:RemovePlayer({ player = player })
end)


