
local SSS = game:GetService("ServerScriptService")
local WeaponBinder = require(SSS.Combat.Weapons.WeaponBinder).WeaponBinder

return function(CHAR)
	local WeaponData = WeaponBinder:Get(CHAR)
	return CHAR:WaitForChild(WeaponData.tool_name):WaitForChild("BodyAttach"):FindFirstChild("Trail")
end