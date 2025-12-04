--||Services||--
local RS = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")

--||Nevermore Shit||--
----------------------------- declaring process -----------------------------
local AnimationUtils = RS.Animations.Utils

local NeverMorePackages = RS.Nevermore
local loader = NeverMorePackages:FindFirstChild("LoaderUtils", true).Parent
local Nevermore = require(loader).bootstrapGame(NeverMorePackages)

local ServiceBag = Nevermore("ServiceBag")
local serviceBag = ServiceBag.new()

----------------------------- init process -----------------------------

---------- BINDERS ----------
local Binder = Nevermore("Binder")
local BinderProvider = Nevermore("BinderProvider")
local CooldownUtils = Nevermore("CooldownUtils")

local HandlerAnimationBindler = require(AnimationUtils.AnimationHandlerBinder).init(serviceBag, Binder)
local WeaponBinder = require(SSS.Combat.Weapons.WeaponBinder).init(serviceBag, Binder)
-- local CooldownBinder = require(SSS.Combat.Weapons.CooldownBinder).init(serviceBag, Binder)

---------- COOLDOWN-BINDERS ----------
local Cooldown = serviceBag:GetService(Nevermore("Cooldown"))
local TimeSyncService = serviceBag:GetService(Nevermore("TimeSyncService"))
-- local CooldownHandler = require(SSS.Combat.Attacks.Utils.CooldownBinder).init(ServiceBag, Cooldown)

---------- USE BINDER PORVIDER ----------
local AttacksBinders = require(SSS.Combat.AttackBinderProvider).new(BinderProvider, {
	HandlerAnimationBindler,
	WeaponBinder,
})

serviceBag:GetService(AttacksBinders)

----- ------------------------ START SERVICEBAG -----------------------------
-- Cooldown:Init(serviceBag)
-- CooldownHandler.start()
serviceBag:Init()
serviceBag:Start()
-- local testying = serviceBag:GetService(CooldownBinder)
-- print("This is the service initilized i bet", testying)
-- DO A NASTY SINGLETON

local serviceShit = require(SSS.ServiceShit)
serviceShit.init(serviceBag)

-- Cooldown:Start(serviceBag)

require(AnimationUtils.AnimationHandlerBinder).start()
---------------- Coldown test ----------------------------

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
	CollectionService:AddTag(char, "CD")

	CombatMediator.PlayerAdded(player)
	PlayerAnimationHandler:InitPlayer(player)
	--local animHandler =PlayerAnimationHandler:GetHandler(player)
end)
--||PlayerRemoving||--
Players.PlayerRemoving:Connect(function(player)
	PlayerAnimationHandler:RemovePlayer({ player = player })
end)

--||Equipment||--
Equipment.OnServerEvent:Connect(function(player, data)
	local tool = data.tool
	local has_to_equip = data.has_to_equip
	local char: Model = player.Character or player.CharacterAdded:Wait()
	local arm = "RightLowerArm"
	local HUM: Humanoid = char:WaitForChild("Humanoid")

	local animationHandler = HandlerAnimationBindler:Get(char)
	local WeaponData = WeaponBinder:Get(char)
	WeaponData:registryTool(tool.Name)
	if HUM.RigType == Enum.HumanoidRigType.R15 then
		arm = "RightLowerArm"
		local tool_anims = animations[tool.Name]
		animationHandler:registryAnims(tool_anims)
		animationHandler:preloadAll()
	else
		arm = "Right Arm"
		local r6Name = tostring(tool.Name) .. "-r6"
		local tool_anims = animations[r6Name]
		animationHandler:registryAnims(tool_anims)
		animationHandler:preloadAll()
	end
	local WeaponSFXFolder = SFXFolder.Weapons:FindFirstChild(tool.Name)
	if not WeaponSFXFolder then
		return warn("Weapon folder not found")
	end
	if has_to_equip then
		local M6D = Instance.new("Motor6D")
		M6D.Name = "ToolGrip"
		M6D.Parent = char[arm]

		char[arm].ToolGrip.Part0 = char[arm]
		char[arm].ToolGrip.Part1 = char[tool.Name].BodyAttach

		local EquipSound = WeaponSFXFolder:WaitForChild("Equip"):Clone()
		EquipSound.Parent = char:WaitForChild("HumanoidRootPart")
		EquipSound:Play()
		Debris:AddItem(EquipSound, 1)

		AnimationClient.Equip(char)
	end

	if not has_to_equip then
		tool.BodyAttach.Trail.Enabled = false

		char[arm]:FindFirstChild("ToolGrip"):Destroy()

		AnimationClient.UnEquip(char)

		local UnEquipSound = WeaponSFXFolder:WaitForChild("UnEquip"):Clone()
		UnEquipSound.Parent = char:WaitForChild("HumanoidRootPart")
		UnEquipSound:Play()
		Debris:AddItem(UnEquipSound, 1)

		local WeaponData = WeaponBinder:Get(char)
		WeaponData:deleteToolData()
	end
end)
