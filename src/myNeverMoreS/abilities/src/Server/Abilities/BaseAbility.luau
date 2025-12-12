local Debris = game:GetService("Debris")

local SoundService = game:GetService("SoundService")
local SoundFolder = SoundService.SFX
local WeaponSoundFolder = SoundFolder.Weapons

local require = require(script.Parent.loader).load(script)
local CooldownController = require("CooldownController")

local BaseAbility = {}
BaseAbility.__index = BaseAbility

function BaseAbility.new(config)
	local self = setmetatable(config, BaseAbility)
	print("config shit: ", config)
	self.character = config.character
	self.humanoid = config.character:WaitForChild("Humanoid")

	self.sound_folder = WeaponSoundFolder[config.tool_name]

	self._serviceBag = config._serviceBag
	self._cooldownController = CooldownController.new(config.character, config._serviceBag, config)
	local BinderProvider = self._serviceBag:GetService(_G.BinderProvider)
	self.WeaponBinder = BinderProvider:Get("Armed"):Get(config.character)
	self.AnimationHandler = BinderProvider:Get("AnimationHandler"):Get(config.character)

	return self
end

function BaseAbility:PlaySound(nameSound: string, lifeTime: number?)
	local dur = lifeTime or 2
	local Sound = self.sound_folder[nameSound]:Clone()
	Sound.Parent = self.character:WaitForChild("HumanoidRootPart")
	Sound:Play()
	Debris:AddItem(Sound, dur)
end

function BaseAbility:Execute(char)
	error("Execute must be overridden in subclass")
end

return BaseAbility
