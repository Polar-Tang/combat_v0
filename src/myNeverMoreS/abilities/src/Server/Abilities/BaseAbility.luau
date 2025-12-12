local require = require(script.Parent.loader).load(script)
local CooldownController = require("CooldownController")

local BaseAbility = {}
BaseAbility.__index = BaseAbility

function BaseAbility.new(config)
	local self = setmetatable(config, BaseAbility)
	self.character = config.character
	self._serviceBag = config._serviceBag
	self._cooldownController = CooldownController.new(config.character, config._serviceBag, config)
	local BinderProvider = self._serviceBag:GetService(_G.BinderProvider)
	self.WeaponBinder = BinderProvider:Get("Armed"):Get(config.character)
	self.AnimationHandler = BinderProvider:Get("AnimationHandler"):Get(config.character)

	return self
end

function BaseAbility:createHitBox() end

function BaseAbility:Execute(char)
	error("Execute must be overridden in subclass")
end

return BaseAbility
