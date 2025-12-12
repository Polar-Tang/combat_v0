local serviceBag = _G.ServiceBag
local BinderProvider = serviceBag:GetService(_G.BinderProvider)
local WeaponBinder = BinderProvider:Get("Armed")

------------------------------------------------------------------------------------------------------------------
local CombatServer = {}

CombatServer.swingEvent = function(plr, action)
	print("action ", action)
	---------------------- CONSTANS ----------------------
	local CHAR = plr.Character
	local HUM = CHAR:WaitForChild("Humanoid")
	------------------------------------------------------

	---------------------- getting all the weapon stats ----------------------
	local Weapon = WeaponBinder:Get(CHAR)
	if not Weapon or not Weapon.tool_name then
		return warn("Weapon not found")
	end

	--Feinting(CHAR,HUM,action) --feinting function

	--------------------------PLAYER ATTRIBUTES----------------------------

	local attacking = CHAR:GetAttribute("Attacking")
	local stunned = CHAR:GetAttribute("Stunned")
	local isRagdoll = CHAR:GetAttribute("IsRagdoll")
	local swing = CHAR:GetAttribute("Swing")
	local blocking = CHAR:GetAttribute("IsBlocking")

	local IS_OCUPPED = attacking or stunned or swing or isRagdoll or blocking

	if IS_OCUPPED then
		return
	end

	------------ EXECUTE COMMAND ------------
	Weapon:Execute(action)
	------------ ON HIT FUNCTION ------------
	-- This play when a humanoid is hit
end

return CombatServer
