--the script got changed a bit after the video so some lines are not 100% the same, keep that in mind

--||Services||--
local RS = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")

--||Variables||--
local plr = game.Players.LocalPlayer
local char = plr.Character
local hum = char:WaitForChild("Humanoid")
local TS = game:GetService("TweenService")
local camera = game.Workspace.CurrentCamera
local isSprinting = false
local debounce = false
local lastKeyPressTime = 0

--||Settings||--
local runSpeed = 18
local walkSpeed = 14
local doubleTapTimeThreshold = 0.3 --the time "window" you have to double tap W to start sprinting, so you have 0.3 seconds to double press W and start sprinting

--||Animations||--
local SprintTrack: AnimationTrack? = nil
local SprintAnim: Animation? = nil

--||Helpers||--
local AttachChck = require(script.Parent.Helpers.AttackCheck)

local CheckingForValues = require(RS.Helpers.CheckingForValues)
------------------------------------------------------------------------------------------------------------------

local Sprint = {}

function Sprint.isIdle()
	local isNotBusy = not char:GetAttribute("Stunned")
		and not char:GetAttribute("IsRagdoll")
		and not char:GetAttribute("IsBlocking")
		and not char:GetAttribute("Attacking")
	return isNotBusy
end

function Sprint.Check()
	local currentTime = tick()

	-- Check for double-tap
	local isDoubleTap = (currentTime - lastKeyPressTime) <= doubleTapTimeThreshold
	print("currentTime - lastKeyPressTime ", currentTime - lastKeyPressTime)
	print("lastKeyPressTime ", lastKeyPressTime)
	print("currentTime ", currentTime)
	print("isDoubleTap ", isDoubleTap)

	lastKeyPressTime = currentTime

	return isDoubleTap
end

function shiftToSprint()
	if isSprinting and not debounce then
		debounce = true

		--if we are not attacking and are not stunned we reset our walkspeed
		if not char:GetAttribute("Attacking") and not char:GetAttribute("Stunned") then
			hum.WalkSpeed = walkSpeed
		end

		TS:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { FieldOfView = 70 })
			:Play() --tweening the FOV
		isSprinting = false

		if SprintTrack then
			SprintTrack:Stop()
		end

		char:SetAttribute("Sprinting", false)

		task.wait(0.5) -- so we can't spam sprint
		debounce = false
	elseif not isSprinting and debounce == false then
		char:SetAttribute("Sprinting", true)

		hum.WalkSpeed = runSpeed

		TS:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { FieldOfView = 80 })
			:Play() --tweening the FOV
		isSprinting = true
		--SprintTrack = hum.Animator:LoadAnimation(SprintAnim)
		--SprintTrack:Play()
	end
end

function Sprint.Execute()
	-- Double-tap detected
	local isEquipped = char:FindFirstChildWhichIsA("Tool")
		and char:FindFirstChildWhichIsA("Tool"):GetAttribute("Type") == "Attack"
	-- Make something with anim handler
	if isEquipped then
		SprintAnim = RS.Animations.Weapons[char:FindFirstChildWhichIsA("Tool").Name].Movement.Sprint
	else
		SprintAnim = RS.Animations.Weapons[char:FindFirstChildWhichIsA("Tool").Name].Movement.Sprint
	end
	shiftToSprint()
end

function Sprint.Kill(inputObject)
	shiftToSprint()
end

hum.Changed:Connect(function()
	local stunned = char:GetAttribute("Stunned")
	local ragdoll = char:GetAttribute("IsRagdoll")
	local attacking = char:GetAttribute("Attacking")

	if stunned or ragdoll or attacking or char.HumanoidRootPart.Anchored then
		if isSprinting then
			shiftToSprint()
		end
	end
end)

char.ChildAdded:Connect(function()
	if char:FindFirstChildWhichIsA("Tool") then
		if isSprinting then
			shiftToSprint()
		end --if we equip a tool and are sprinting we stop sprinting
	end
end)

return Sprint
