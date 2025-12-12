--||services||----
local RS = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local SFXFolder = SoundService.SFX

local require = require(script.Parent.loader).load(script)

--||Modules||--

local AnimationHandler = require("AnimationHandler")
local stunt_client = require("stunt_client")

-- SETTING CHARACTER ATTRIBUTES TO THE CHARACTER, REDUCES ITS VELOCITY
------------------------------------------------------------------------------------------------------------------
local BaseAbility = require("BaseAbility")

local Blocking = setmetatable({}, BaseAbility)
Blocking.__index = Blocking

function Blocking.new(config)
	local self = BaseAbility.new(config)
	setmetatable(self, Blocking)
	return self
end
Blocking.Type = "Defense"

function Blocking:Execute()
	--||Settings||--
	local character = self.Character
	local WeaponBinder = self._serviceBag:GetService(require("Weapon"))

	local parry_time = WeaponBinder.parry_time
	local walk_speed_normal = WeaponBinder.walk_speed_normal
	local walk_speed_blocking = WeaponBinder.walk_speed_blocking
	local isBlocking = character:GetAttribute("IsBlocking")
	local currentTime = tick()
	print("IsBlocking", character:GetAttribute("IsBlocking"))
	if not isBlocking then
		character:SetAttribute("IsBlocking", true)
		character:SetAttribute("LastStopTime", 0)
		character.Humanoid.WalkSpeed = walk_speed_blocking

		local AnimationHandler = AnimationHandler:Get(character)
		AnimationHandler:LoadAnimation(true, "Blocking")

		task.spawn(function()
			character:SetAttribute("Parrying", true)
			task.wait(parry_time)
			character:SetAttribute("Parrying", false)
		end)
	elseif isBlocking then
		character:SetAttribute("IsBlocking", false)
		character:SetAttribute("Parrying", false)
		character:SetAttribute("LastStopTime", currentTime)
		character.Humanoid.WalkSpeed = walk_speed_normal
		
		local AnimationHandler = AnimationHandler:Get(character)
		AnimationHandler:LoadAnimation(false, "Blocking")
	end
end

function Blocking:_GuardBreak(): boolean?
	local char = self.character
	print("enemyChar:GetAttribute('Blocking')  ", char:GetAttribute("Blocking"))
	-- client effects
	RS.Events.VFX:FireAllClients("GuardBreak", char)
	local WeaponBinder = self._serviceBag:GetService(require("Weapon"))

	local weaponHandler = WeaponBinder:Get(char)

	local toolName = weaponHandler.tool_name
	--stopAnims(char.Humanoid)

	-- PLAY GUARDBREAK SOUND
	do
		local BlockSound = SFXFolder.Weapons[toolName].BlockBreak:Clone()
		BlockSound.Parent = char:WaitForChild("HumanoidRootPart")
		BlockSound:Play()
		Debris:AddItem(BlockSound, 2)
	end

	local animHandler = AnimationHandler:Get(char)
	animHandler:LoadAnimation(true, "GuardBreak")

	-- CHANGE THE PLAYER UI
	local enemyPlr = game:GetService("Players"):GetPlayerFromCharacter(char)
	if enemyPlr then
		RS.Events.VFX:FireClient(enemyPlr, "GuardBreakCamera")
		enemyPlr.PlayerGui.BlockingUi.MainFrame.Visible = false
		enemyPlr.PlayerGui.BlockingUi.MainFrame.Bar.Size = UDim2.new(0, 0, 1, 0)
	end

	local enemyH = char:WaitForChild("Humanoid")
	print("enemyH ", enemyH)
	stunt_client(enemyH, 3)

	-- RESET BLOCKING
	char:SetAttribute("Blocking", 0)
	return true
end

function Blocking:OnDefended()
	local char = self.character
	local WeaponBinder = self._serviceBag:GetService(require("Weapon"))
	local weaponHandler = WeaponBinder:Get(char)
	local toolName = weaponHandler.tool_name

	if not char:GetAttribute("Blocking") then
		return
	end

	if char:GetAttribute("Blocking") >= 100 then
		self:_GuardBreak()
	end

	RS.Events.VFX:FireAllClients("BlockingHit", char)

	local attValue = char:GetAttribute("Blocking")
	--char:SetAttribute("Blocking", attValue + damage * 2.75)
	char:SetAttribute("Blocking", attValue + 20)

	-- Play blocked sound
	do
		local BlockSound = SFXFolder.Weapons[toolName].Blocked:Clone()
		BlockSound.Parent = char:WaitForChild("HumanoidRootPart")
		BlockSound:Play()
		Debris:AddItem(BlockSound, 2)
	end
end

--[[for i,v in pairs(workspace.Npcs:GetChildren()) do
	v:GetAttributeChangedSignal("Blocking"):Connect(function()
		onBlockingChanged(v)
	end)
end
]]

return Blocking
