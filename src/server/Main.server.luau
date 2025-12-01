--||Services||--
local RS = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")

--||Nevermore Shit||--
--BINDERS
local AnimationUtils = RS.Animations.Utils

local HandlerBindler = require(AnimationUtils.HandlerBinder)
local WeaponBinder = require(SSS.Combat.Weapons.WeaponBinder)

local Nevermore = require(RS.Nevermore.loader)
local ServiceBag = Nevermore("ServiceBag")
local serviceBag = ServiceBag.new() 
local Binder = Nevermore("Binder")

local animationHandlerBinder = HandlerBindler.init(Binder)
local WeaponBinderBinder = WeaponBinder.init(Binder)

--local Cooldown = RS.Nevermore.cooldown.Shared.Binders.Cooldown
local CooldownBinder = Nevermore("Cooldown")
local Cooldown = serviceBag:GetService(CooldownBinder)

local BlockingNpc = game.Workspace.Blocking
local nv = Instance.new("NumberValue")
nv.Name = "AttackCooldown"
nv.Parent = BlockingNpc
nv:AddTag("Cooldown")

serviceBag:Init()

serviceBag:Start()
------------------------------------------------------------
---
local cooldDownBLocking = Cooldown:Get(nv)
--WeaponBinderBinder:_add(Cooldown)
--local Cooldown2 = serviceBag:GetService("Cooldown")
print("cooldDownBLocking ", cooldDownBLocking)
print("cooldDownBLocking ", BlockingNpc.AttackCooldown)


------------------------------------------------------------


local anims = RS.Animations

--||RemoteEvents||--
local remotes = RS.Events
local Equipment = remotes.Equipment
local swingEvent = remotes.Swing

--||Folders||--
local SFXFolder = SoundService:WaitForChild("SFX")

--||Modules||--
local AnimationClient = require(AnimationUtils.AnimationClient)

local animations = require(RS.Animations.WeaponsAnims)
local combatServer = require(SSS.Combat.Attacks.AttckInvoker)
--------------

--||PlayerAdded||--
local PlayerAnimationHandler = require(RS.Animations.Player.PlayerAnimationHandler)

local CombatMediator = require(SSS.Combat.CombatMediator)
local CollectionService = game:GetService("CollectionService")
Players.PlayerAdded:Connect(function(player)
	local char = player.Character or player.CharacterAdded:Wait()
	CollectionService:AddTag(char, "AnimationHandler")
	CollectionService:AddTag(char, "Armed")

	CombatMediator.PlayerAdded(player)
	PlayerAnimationHandler:InitPlayer(player)
	--local animHandler =PlayerAnimationHandler:GetHandler(player)
	
end)
--||PlayerRemoving||--
Players.PlayerRemoving:Connect(function(player)
	PlayerAnimationHandler:RemovePlayer({player = player})
end)

--||Equipment||--
Equipment.OnServerEvent:Connect(function(player, data)
	local tool = data.tool
	local has_to_equip = data.has_to_equip
	local char: Model = player.Character or player.CharacterAdded:Wait()
	local arm = "RightLowerArm"
	local HUM: Humanoid = char:WaitForChild("Humanoid")
	
	local animationHandler = animationHandlerBinder:Get(char)
	local WeaponData = WeaponBinderBinder:Get(char)
	WeaponData:registryTool(tool.Name)
	if HUM.RigType == Enum.HumanoidRigType.R15 then
		arm = "RightLowerArm"
		local tool_anims = animations[tool.Name]
		animationHandler:registryAnims(tool_anims)
		animationHandler:preloadAll()
	else 
		arm = "Right Arm"
		local r6Name = tostring(tool.Name).."-r6"
		local tool_anims = animations[r6Name]
		animationHandler:registryAnims(tool_anims)
		animationHandler:preloadAll()
	end
	local WeaponSFXFolder = SFXFolder.Weapons:FindFirstChild(tool.Name)
	if not WeaponSFXFolder  then
		return warn("Weapon folder not found")
	end
	if has_to_equip  then

		local M6D = Instance.new("Motor6D")
		M6D.Name = "ToolGrip"
		M6D.Parent = char[arm]

		char[arm].ToolGrip.Part0 = char[arm]
		char[arm].ToolGrip.Part1 = char[tool.Name].BodyAttach

		local EquipSound = WeaponSFXFolder:WaitForChild("Equip"):Clone()
		EquipSound.Parent = char:WaitForChild("HumanoidRootPart")
		EquipSound:Play()
		Debris:AddItem(EquipSound,1)

		AnimationClient.Equip(char)
	end

	if not has_to_equip  then
		tool.BodyAttach.Trail.Enabled = false

		char[arm]:FindFirstChild("ToolGrip"):Destroy()
		
		AnimationClient.UnEquip(char)
		
		local UnEquipSound = WeaponSFXFolder:WaitForChild("UnEquip"):Clone()
		UnEquipSound.Parent = char:WaitForChild("HumanoidRootPart")
		UnEquipSound:Play()
		Debris:AddItem(UnEquipSound,1)
		
		local WeaponData = WeaponBinderBinder:Get(char)
		WeaponData:deleteToolData()
	end
end)

