--||Services||--
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local repStore = game:GetService("ReplicatedStorage")
local Debris: Debris = game:GetService("Debris")

--||Helper||--
local CheckingForValues = require(repStore.Helpers.CheckingForValues)

--||Event||--
local DashEvent = RS.Events.Dash

--||Player||--
local plr = game:GetService("Players").LocalPlayer
local char = plr.Character

local hum = char:WaitForChild("Humanoid")

--||Other||--
local CurrentButton = ""
local DashDebouce = false

--||Animations||--
local lcdl = require(RS.Animations.OtherAnims)
local dashAnims = lcdl.Dash

local MakeAnim = function(rblxId: string)
	local newAnim: Animation = Instance.new("Animation")
	newAnim.AnimationId = rblxId
	return newAnim
end

local sTrack: AnimationTrack = hum.Animator:LoadAnimation(MakeAnim(dashAnims.SDash))
local aTrack: AnimationTrack = hum.Animator:LoadAnimation(MakeAnim(dashAnims.ADash))
local dTrack: AnimationTrack = hum.Animator:LoadAnimation(MakeAnim(dashAnims.DDash))
local wTrack: AnimationTrack = hum.Animator:LoadAnimation(MakeAnim(dashAnims.WDash))

local Helpers = RS.Helpers
local EmitParticles = require(Helpers.emitParticles)

--||Dash VFX||--
local dashVFX = RS.Effects.Speed

-- variables
local Cooldown = 2
local keyPress

------------------------------------------------------------------------------------------------------------------

local function getMoveDirection()
	local rootPart = hum.RootPart
	local forwardDirection = rootPart.CFrame.LookVector
	local rightDirection = rootPart.CFrame.RightVector
	local moveDirection = forwardDirection * hum.MoveDirection.Z + rightDirection * hum.MoveDirection.X

	return moveDirection.Unit
end

local Dash = {}

function Dash.Execute()
	local rotX90 = CFrame.Angles(0, 0, 0)
	keyPress = true
	local function dashVFXUtil()
		local speed = dashVFX:Clone()
		local root = char.HumanoidRootPart
		--local camCF = cam.CFrame
		local pCframe: CFrame = root.CFrame
		--local upVector = pCframe.UpVector
		local forwardDirection = pCframe.LookVector
		local rightDirection = pCframe.RightVector

		local speedOrientation = pCframe

		if CurrentButton == "WButton" then
			dir = forwardDirection
		elseif CurrentButton == "SButton" then
			dir = -forwardDirection
			rotX90 = CFrame.Angles(0, math.rad(180), 0)
		elseif CurrentButton == "AButton" then
			dir = -rightDirection
			rotX90 = CFrame.Angles(0, math.rad(90), 0)
		elseif CurrentButton == "DButton" then
			dir = rightDirection

			rotX90 = CFrame.Angles(0, math.rad(-90), 0)
		end
		speedOrientation = speedOrientation * rotX90
		speed.CFrame = speedOrientation

		speed.Parent = char
		print("speed ", speed)
		EmitParticles(speed)
		Debris:AddItem(speed, 0.5)
	end
	if CurrentButton == "WButton" then
		DashDebouce = true
		DashEvent:FireServer("WButton")

		wTrack:Play()
		dashVFXUtil()

		task.delay(Cooldown, function()
			DashDebouce = false
		end)
		task.wait(Cooldown)
		DashDebouce = false
	elseif CurrentButton == "SButton" then
		DashDebouce = true
		DashEvent:FireServer("SButton")

		sTrack:Play()
		dashVFXUtil()

		task.delay(Cooldown, function()
			DashDebouce = false
		end)
	elseif CurrentButton == "AButton" then
		DashDebouce = true
		DashEvent:FireServer("AButton")

		aTrack:Play()

		dashVFXUtil()

		task.delay(Cooldown, function()
			DashDebouce = false
		end)
	elseif CurrentButton == "DButton" then
		DashDebouce = true
		DashEvent:FireServer("DButton")

		dTrack:Play()
		dashVFXUtil()

		task.delay(Cooldown, function()
			DashDebouce = false
		end)
	end
end

RunService.Heartbeat:Connect(function()
	-- Run this only once the key is pressed
	if not keyPress then
		return
	end
	local moveDirection = getMoveDirection()
	if moveDirection.Magnitude > 0 then
		local dotForward = moveDirection:Dot(Vector3.new(0, 0, -1))
		local dotBackward = moveDirection:Dot(Vector3.new(0, 0, 1))
		local dotLeft = moveDirection:Dot(Vector3.new(-1, 0, 0))
		local dotRight = moveDirection:Dot(Vector3.new(1, 0, 0))

		if dotForward > 0.5 then
			CurrentButton = "SButton"
		elseif dotBackward > 0.5 then
			CurrentButton = "WButton"
		elseif dotLeft > 0.5 then
			CurrentButton = "AButton"
		elseif dotRight > 0.5 then
			CurrentButton = "DButton"
		end
		keyPress = false
	else --this is when the character is not moving, so is idle
		CurrentButton = ""
		keyPress = false
	end
end)

function Dash.Check()
	return CheckingForValues(char, DashDebouce)
end

return Dash
