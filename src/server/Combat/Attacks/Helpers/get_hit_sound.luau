local SSS = game:GetService("ServerScriptService")
local WeaponBinder = require(SSS.Combat.Weapons.WeaponBinder).WeaponBinder
--checking if the player has the heavy sound, if yes then we know that he is currently using his heavy attack
return function(char)
	local WeaponData = WeaponBinder:Get(char)
	char.HumanoidRootPart:FindFirstChild(WeaponData.Folder:FindFirstChild("Heavy").Name)
end
