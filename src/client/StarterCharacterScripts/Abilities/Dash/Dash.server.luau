local SoundService = game:GetService("SoundService")

local DashEvent = script.Parent

local range = 45

------------------------------------------------------------------------------------------------------------------



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
