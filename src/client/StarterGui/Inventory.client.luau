--This script is for disabling the Backpack ui when the player is stunned 

--||Service||--
local StarterGui = game:GetService("StarterGui")

--||Player||--
local plr = game.Players.LocalPlayer
local char = plr.Character

------------------------------------------------------------------------------------------------------------------



StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)

char:GetAttributeChangedSignal("Stunned"):Connect(function()
	if char:GetAttribute("Stunned") then
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	else
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
	end
end)