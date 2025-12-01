local SSS = game:GetService("ServerScriptService")
local modules = SSS.Combat.Attacks.Utils
local stunHandler = require(modules.StunHandlerV2)

return function(Hum: Humanoid, dur: number)
	Hum.WalkSpeed = 14
	Hum.JumpHeight = 6.5
	stunHandler.Stun(Hum,dur)
end
