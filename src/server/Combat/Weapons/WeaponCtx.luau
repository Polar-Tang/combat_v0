local SSS = game:GetService("ServerScriptService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local WeaponsFodler = SSS.Combat.Weapons
local WeaponInfo = require(WeaponsFodler.WeaponInfo)
local WeaponStrat = {}
WeaponStrat.__index = WeaponStrat

local SoundFolder = SoundService:WaitForChild("SFX")
local WeaponSoundFolder = SoundFolder:WaitForChild("Weapons")


function WeaponStrat.new(char: Model)
	local self = setmetatable({}, WeaponStrat)
	self.Char = char
	self._weapon = nil

	return self
end

local Strategies = {
	["Fist"] = require(WeaponsFodler.strategies.Fist),
	["Sword"] = require(WeaponsFodler.strategies.Sword),
	["Axe"] = require(WeaponsFodler.strategies.Axe),
}
function WeaponStrat:equiTool(toolName)
	self._weapon = Strategies[toolName].new(self.Char)
end

function WeaponStrat:registryTool(toolName)
	local WeaponStats = WeaponInfo:getweapon(toolName)
	self.tool_name = toolName
	self.damage = WeaponStats.damage
	self.swing_reset = WeaponStats.swing_reset
	self.stun_time = WeaponStats.stun_time
	self.hitbox_size = WeaponStats.hitbox_size
	self.hitbox_offset = WeaponStats.hitbox_offset
	self.heavy_damage = WeaponStats.heavy_damage
	self.heavy_hitbox_size = WeaponStats.heavy_hitbox_size
	self.max_combo = WeaponStats.max_combo

	self.Folder = WeaponSoundFolder[toolName]
end

-- TODO: create a method that lookup the attack by the given name, and do call coolDownControler.init(attck.reset_time)

function WeaponStrat:deleteToolData()
	for k, v in pairs(self) do
		if k == "Char" then
			continue
		end
		self[k] = nil
	end
end

function WeaponStrat:PlayHitSound(lifeTime: number?)
	local dur = lifeTime or 2
	local HitSound = self.Folder.Hit:Clone()
	HitSound.Parent = self.Char:WaitForChild("HumanoidRootPart")
	HitSound:Play()
	Debris:AddItem(HitSound, 2)
end

function WeaponStrat:PlaySwingSound(lifeTime: number?)
	local dur = lifeTime or 1
	local SwordSwingSound = self.Folder:WaitForChild("Swing"):Clone()
	SwordSwingSound.Parent = self.Char:WaitForChild("HumanoidRootPart")
	SwordSwingSound:Play()
	Debris:AddItem(SwordSwingSound, dur)
end

function WeaponStrat:PlayHeavySound(lifeTime: number?)
	local dur = lifeTime or 4
	local HeavySound = WeaponSoundFolder:WaitForChild(self.tool_name):WaitForChild("Heavy"):Clone() -- the sound is very important
	print("play havy sound")
	HeavySound.Parent = self.Char.HumanoidRootPart
	HeavySound:Play()
	Debris:AddItem(HeavySound, dur)
end

return WeaponStrat
