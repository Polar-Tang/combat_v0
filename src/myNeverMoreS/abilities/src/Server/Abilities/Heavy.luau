local SSS = game:GetService("ServerScriptService")
local WeaponBinder = require(SSS.Combat.Weapons.WeaponBinder).WeaponBinder
local Heavy = {}
Heavy.Type = "Attack"

-- WTF THIS FUNCTION??
-- TODO: DEBUG THIS SHIT
function Heavy.Execute(CHAR)

	local WeaponData = WeaponBinder:Get(CHAR)
	return CHAR:WaitForChild(WeaponData.tool_name):WaitForChild("BodyAttach"):FindFirstChild("Trail")
end

return Heavy
