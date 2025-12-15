--Services
-- The weapon context strategy
local SoundService = game:GetService("SoundService")
local SoundFolder = SoundService.SFX
local WeaponSoundFolder = SoundFolder.Weapons
local Debris = game:GetService("Debris")
local require = require(script.Parent.loader).load(script)
local Table = require("Table")

local BaseObject = require("BaseObject")
local Weapon = {}
Weapon.__index = Weapon

local Strategies = {
	Fist = require("Fist"),
}

function Weapon.new(char: Model, serviceBag)
	local self = setmetatable(BaseObject.new(char), Weapon)
	self.Char = char
	self._weapon = nil
	self._serviceBag = serviceBag
	self.Humanoid = char:WaitForChild("Humanoid")
	if self.Humanoid.RigType == Enum.HumanoidRigType.R15 then
		self.armName = "RightLowerArm"
	else
		self.armName = "Right Arm"
	end
	return self
end

function Weapon:Execute(action)
	self._weapon:Execute(action)
end
-- TODO: very weapon will have an onDefended connection, which will be fired by the hiboxHit event

function Weapon:OnDefended()
	self._weapon:OnDefended()
end

function Weapon:GetAbilityStats(action)
	return Table.merge(self._weapon:GetAction(action), self)
end

function Weapon:EquiTool(tool)
	local toolName = tool.Name

	if not Strategies[toolName] then
		warn("Weapon not found")
		return
	end
	self._weapon = Strategies[toolName].new(self.Char, self._serviceBag)
	self.tool = tool

	local arm = self.Char:FindFirstChild(self.armName)
	if not arm then
		warn(string.format("The %s should has a %s", self.Char.Name, self.armName))
		return
	end

	local M6D = Instance.new("Motor6D")
	M6D.Name = "ToolGrip"
	M6D.Parent = arm

	arm.ToolGrip.Part0 = arm
	arm.ToolGrip.Part1 = self.Char[toolName].BodyAttach
end

function Weapon:UnequiTool()
	if not self.tool then
		warn("No tool equiped")
		return
	end
	self.tool.BodyAttach.Trail.Enabled = false

	local arm = self.Char:FindFirstChild(self.armName)
	arm:FindFirstChild("ToolGrip"):Destroy()

	local UnEquipSound = self.Folder:WaitForChild("UnEquip"):Clone()
	UnEquipSound.Parent = self.Char:WaitForChild("HumanoidRootPart")
	UnEquipSound:Play()
	Debris:AddItem(UnEquipSound, 1)

	self:deleteToolData()
end

function Weapon:GetAction(action)
	return self._weapon:GetAction(action)
end
function Weapon:registryTool(toolName)
	local f = WeaponSoundFolder:FindFirstChild(toolName)
	if not f then
		warn("Weapon not found")
		return
	end

	self.Folder = f
	self.tool_name = toolName
end

-- TODO: create a method that lookup the attack by the given name, and do call coolDownControler.init(attck.reset_time), API between weapon controller and ability controller

function Weapon:deleteToolData()
	for k, v in pairs(self) do
		if k == "Char" then
			continue
		end
		self[k] = nil
	end
	self.tool = nil
end

-- If the sound thing causes issue we move it to a facade
function Weapon:PlaySound(lifeTime: number?, nameSound: string)
	local dur = lifeTime or 2
	local Sound = self.Folder[nameSound]:Clone()
	Sound.Parent = self.Char:WaitForChild("HumanoidRootPart")
	Sound:Play()
	Debris:AddItem(Sound, dur)
end

function Weapon:PlaySwingSound(lifeTime: number?)
	local dur = lifeTime or 1
	local SwordSwingSound = self.Folder:WaitForChild("Swing"):Clone()
	SwordSwingSound.Parent = self.Char:WaitForChild("HumanoidRootPart")
	SwordSwingSound:Play()
	Debris:AddItem(SwordSwingSound, dur)
end

function Weapon:PlayHeavySound(lifeTime: number?)
	local dur = lifeTime or 4
	local HeavySound = WeaponSoundFolder:WaitForChild(self.tool_name):WaitForChild("Heavy"):Clone() -- the sound is very important
	HeavySound.Parent = self.Char.HumanoidRootPart
	HeavySound:Play()
	Debris:AddItem(HeavySound, dur)
end

return Weapon
