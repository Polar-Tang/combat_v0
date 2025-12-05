--||Services||--
local SSS = game:GetService("ServerScriptService")

--||Binders||--
local WeaponBinder = require(SSS.Combat.Weapons.WeaponBinder).WeaponBinder
local CooldownBinder = require(SSS.Combat.Weapons.CooldownBinder).CooldownBinder

--||Folder||--

local CombatModules = SSS.Combat.Attacks

--||Helpers||--
local Helpers = CombatModules.Helpers
local get_trail = require(Helpers.get_trail)
local get_hit_sound = require(Helpers.get_hit_sound)

--||AttackStuff||--
--local ServerCombatModule = require(ServerModules.CombatModule)
local AttackStuff = CombatModules.Utils
local ServerCombatModule = require(AttackStuff.CombatUtils)
local HitboxModule = require(AttackStuff.MuchachoHitbox)

--||Settings||--
local Max_Combo = 4

local params = OverlapParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude

------------------------------------------------------------------------------------------------------------------
local CombatServer = {}

local Attcks = CombatModules.Abillities

CombatServer.swingEvent = function(plr, action)
	print("action ", action)
	---------------------- CONSTANS ----------------------
	local CHAR = plr.Character
	local HUM = CHAR:WaitForChild("Humanoid")
	local HRP = CHAR:WaitForChild("HumanoidRootPart")
	------------------------------------------------------

	---------------------- getting all the weapon stats ----------------------
	local WeaponData = WeaponBinder:Get(CHAR)
	if not WeaponData or not WeaponData.tool_name then
		return warn("WeaponData not found")
	end
	local Damage = WeaponData.damage
	local SwingReset = WeaponData.swing_reset
	local StunTime = WeaponData.stun_time
	local HitboxSize = WeaponData.hitbox_size
	local HitboxOffset = WeaponData.hitbox_offset
	local HeavyDamage = WeaponData.heavy_damage
	local HeavyHitboxSize = WeaponData.heavy_hitbox_size
	--------------------------------------------------------------------------

	--Feinting(CHAR,HUM,action) --feinting function

	--------------------------PLAYER ATTRIBUTES----------------------------

	local attacking = CHAR:GetAttribute("Attacking")
	local stunned = CHAR:GetAttribute("Stunned")
	local isRagdoll = CHAR:GetAttribute("IsRagdoll")
	local swing = CHAR:GetAttribute("Swing")
	local blocking = CHAR:GetAttribute("IsBlocking")

	local Heavy = get_hit_sound(CHAR)

	local IS_OCUPPED = attacking or stunned or swing or isRagdoll or Heavy

	if IS_OCUPPED then
		return
	end
	local command = require(Attcks:FindFirstChild(action))

	if command.Type ~= "Attack" then
		command.Execute(CHAR)
		return
	end
	IS_OCUPPED = IS_OCUPPED or blocking
	if IS_OCUPPED then
		return
	end

	--------------------------PLAYER ATTRIBUTES----------------------------

	--------------------------SET PLAYER ATTRIBUTES----------------------------

	CHAR:SetAttribute("Attacking", true)
	CHAR:SetAttribute("Swing", true)

	ServerCombatModule.ChangeCombo(CHAR)
	-- change current animations?
	--ServerCombatModule.stopAnims(hum)

	HUM.WalkSpeed = 7
	HUM.JumpHeight = 0

	--------------------------SET PLAYER ATTRIBUTES----------------------------
	----- hit box ----
	local trail = get_trail(CHAR)
	-- enable the trail for the hitbox
	if trail then
		trail.Enabled = true
	end

	------------ CREATE HIT BOX ------------
	local newHitbox = HitboxModule.CreateHitbox() --creating the hitbox
	newHitbox.Size = HitboxSize
	newHitbox.CFrame = HRP
	newHitbox.Offset = HitboxOffset
	newHitbox.OverlapParams = params
	newHitbox.AutoDestroy = false
	newHitbox.Puncher = CHAR
	------------ EXECUTE COMMAND ------------
	print("WTF IS THIS SHIT? ", CooldownBinder)
	local CooldownController = CooldownBinder:Get(CHAR)
	print("CD : ", CooldownController:init(3))

	print("nil and not error ", CooldownController:getCD())

	command.Execute(CHAR, newHitbox)
	------------ ON HIT FUNCTION ------------
	-- This play when a humanoid is hit
end

return CombatServer
