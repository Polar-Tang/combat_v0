-- CooldownController.lua

local RS = game:GetService("ReplicatedStorage")
local CoolDOWN = require(RS.Nevermore.cooldown.Server.Binders.Cooldown)
local serviceBag = _G.ServiceBag
-- local SSS = game:GetService("ServerScriptService")

-------------- TESTING ZONE --------------

local CooldownController = {}
CooldownController.__index = CooldownController

function CooldownController.new(char: Model)
	-- Binder constructor
	local self = setmetatable({}, CooldownController)

	self.parent = char
	self.currentCD = nil
	self._cooldown = nil
	self._inst = nil
	return self
end
-- local require = require(RS.Nevermore.loader).load(script)
-- Service bag injection
--[[
function CooldownController:Start(serviceBag) end
function CooldownController:getCD()
	return Cooldown:Get(self._inst)
end
]]
function CooldownController:init(currentCD: number)
	if not self._inst then
		local nv = Instance.new("NumberValue")
		nv.Name = "AttackCooldown"
		nv.Parent = self.parent
		nv:AddTag("Cooldown")
		self._inst = nv
	end

	self._inst.Value = currentCD
end

function CooldownController:getCD()
	-- local serviceShit = require(SSS.ServiceShit)
	-- local serviceBag = serviceShit.serviceBag()
	print("serviceBag ", serviceBag)
	local coolDown = serviceBag:GetService(CoolDOWN)
	print("coolDown ", coolDown)
	return coolDown:Get(self._inst)
end

function CooldownController:IsReady(): boolean
	assert(self._inst, "Do CooldownController:init(currentCD: number) first")
	local CD = self:getCD()
	print("CD ", CD)
	return self.currentCD - CD:GetTimePassed() >= 0
end

function CooldownController:Destroy()
	print("AAAAAAAAAAAAAAAAh!")
end

return CooldownController
