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
	

	--------------------------PLAYER ATTRIBUTES----------------------------

	--------------------------SET PLAYER ATTRIBUTES----------------------------

	CHAR:SetAttribute("Attacking", true)
	CHAR:SetAttribute("Swing", true)

	-- change current animations?
	--ServerCombatModule.stopAnims(hum)

	HUM.WalkSpeed = 7
	HUM.JumpHeight = 0

	------------ CREATE HIT BOX ------------
	
	------------ EXECUTE COMMAND ------------
	Weapon:Execute(action)
	------------ ON HIT FUNCTION ------------
	-- This play when a humanoid is hit
end

return CombatServer
