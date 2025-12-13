local RS = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local Events = RS.Events
local swingEvent = Events.Swing
--||RemoteEvents||--
local remotes = RS.Events
local Equipment = remotes.Equipment

local SFXFolder = SoundService.SFX
local AnimationUtils = RS.Animations.Utils
local animations = require(RS.Animations.WeaponsAnims)

local AnimationClient = require(AnimationUtils.AnimationClient)

--local blockingEvent = Events.Blocking

local serviceBag = _G.ServiceBag

local BinderProvider = serviceBag:GetService(_G.BinderProvider)
local AnimationHandler = BinderProvider:Get("AnimationHandler")
local WeaponBinder = BinderProvider:Get("Armed")
local CombatMediator = {}

function CombatMediator.PlayerAdded(player: Player)
	local char = player.Character or player.CharacterAdded:Wait()
	char:SetAttribute("Combo", 1)
	char:SetAttribute("Stunned", false)
	char:SetAttribute("Swing", false)
	char:SetAttribute("Attacking", false)
	char:SetAttribute("IsRagdoll", false)
	char:SetAttribute("Iframes", false)
	char:SetAttribute("IsBlocking", false)
	char:SetAttribute("Blocking", 0)
	char:SetAttribute("Parrying", false)		
end

local AttckInvoker = script.Parent.AttckInvoker

--||Event for combat||--
local combatServer = require(AttckInvoker)

swingEvent.OnServerEvent:Connect(combatServer.swingEvent)

--||Equipment||--
Equipment.OnServerEvent:Connect(function(player, data)
	local tool = data.tool
	local has_to_equip = data.has_to_equip
	local char: Model = player.Character or player.CharacterAdded:Wait()
	local arm = "RightLowerArm"
	local HUM: Humanoid = char:WaitForChild("Humanoid")

	local animationHandler = AnimationHandler:Get(char)
	local WeaponHandler = WeaponBinder:Get(char)
	WeaponHandler:registryTool(tool.Name)
	WeaponHandler:EquiTool(tool.Name)
	if HUM.RigType == Enum.HumanoidRigType.R15 then
		arm = "RightLowerArm"
		local tool_anims = animations[tool.Name]
		animationHandler:registryAnims(tool_anims)
	else
		arm = "Right Arm"
		local r6Name = tostring(tool.Name) .. "-r6"
		local tool_anims = animations[r6Name]
		animationHandler:registryAnims(tool_anims)
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

		local WeaponHandler = WeaponBinder:Get(char)
		WeaponHandler:deleteToolData()
	end
end)

------------------------------------------------------------------------------------------------------------------

local DashEvent = RS.Events.Dash

local range = 45

DashEvent.OnServerEvent:Connect(function(Player,DashButton)
	local Character = Player.Character
	local CharacterParts = {
		HumRp = Character.HumanoidRootPart,
		Hum = Character.Humanoid,
	}
	
	local SoundEfx = SoundService.SFX.Other.Dust:Clone()
	SoundEfx.Parent = CharacterParts.HumRp 
	SoundEfx:Play()
	game.Debris:AddItem(SoundEfx,1.4)
	
	if DashButton == "WButton" then
		local WVelocity = Instance.new("BodyVelocity",CharacterParts.HumRp)
		WVelocity.MaxForce = Vector3.new(50000, 0, 50000)
		WVelocity.Velocity = (CharacterParts.HumRp.CFrame.LookVector * range)
		WVelocity.Name = "WDashVelocity"
		game.Debris:AddItem(WVelocity,0.2)
	elseif DashButton == "SButton" then
		local SVelocity = Instance.new("BodyVelocity",CharacterParts.HumRp)
		SVelocity.MaxForce = Vector3.new(50000, 0, 50000)
		SVelocity.Velocity = (CharacterParts.HumRp.CFrame.LookVector * -range)
		SVelocity.Name = "SDashVelocity"
		game.Debris:AddItem(SVelocity,0.2)
	elseif DashButton == "AButton" then
		local AVelocity = Instance.new("BodyVelocity",CharacterParts.HumRp)
		AVelocity.MaxForce = Vector3.new(50000, 0, 50000)
		AVelocity.Velocity = (CharacterParts.HumRp.CFrame.RightVector * -range)
		AVelocity.Name = "ADashVelocity"
		game.Debris:AddItem(AVelocity,0.2)
	elseif DashButton == "DButton" then
		local DVelocity = Instance.new("BodyVelocity",CharacterParts.HumRp)
		DVelocity.MaxForce = Vector3.new(50000, 0, 50000)
		DVelocity.Velocity = (CharacterParts.HumRp.CFrame.RightVector * range)
		DVelocity.Name = "DDashVelocity"
		game.Debris:AddItem(DVelocity,0.2)
	end
end)


return CombatMediator
