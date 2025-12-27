--||Services||--
local RS = game:GetService("ReplicatedStorage")

--||Nevermore Shit||--
----------------------------- getting servicebag and loader -----------------------------

local NeverMorePackages = RS.Nevermore
local loader = NeverMorePackages:FindFirstChild("LoaderUtils", true).Parent
local Nevermore = require(loader).bootstrapGame(NeverMorePackages)

local ServiceBag = Nevermore("ServiceBag")
local serviceBag = ServiceBag.new()

local Binder = Nevermore("Binder")
serviceBag:GetService(Nevermore("RagdollClient"))

local StateMachine = Nevermore("StateMachine")

local Binders = {
	["NPC"] = StateMachine,
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
serviceBag:Start()

_G.Client_ServiceBag = serviceBag
_G.Client_BinderProvider = AttacksBinders

require(script.Parent.App)
