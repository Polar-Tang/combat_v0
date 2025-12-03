--||Services||--
local RS = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

--||Character||--
local plr = game:GetService("Players").LocalPlayer
repeat
	task.wait()
until plr.Character
local char = plr.Character

--||Camera||--
local camera = game.Workspace.CurrentCamera

--||Events||--
local remotes = RS:WaitForChild("Events")
local swingEvent = remotes:WaitForChild("Swing")

--||Settings||--
local lastMouseButton1Pressed = 0
local TimeToFeint = 0.25
local FeintDebounce = false

local HeavyDebounce = false
local HeavyCooldown = 10

------------------------------------------------------------------------------------------------------------------

local Combat = {}

function Combat.Execute()
	if
		char:FindFirstChildWhichIsA("Tool")
		and char:FindFirstChildWhichIsA("Tool"):GetAttribute("Type") == "Attack"
		and not HeavyDebounce
		and not char:GetAttribute("Swing")
		and not char:GetAttribute("Attacking")
	then
		swingEvent:FireServer("Heavy", char:FindFirstChildWhichIsA("Tool").Name)

		HeavyDebounce = true

		task.spawn(function()
			TS
				:Create(
					camera,
					TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
					{ FieldOfView = 55 }
				)
				:Play()
			task.wait(0.6)
			TS
				:Create(
					camera,
					TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
					{ FieldOfView = 70 }
				)
				:Play()
		end)

		task.delay(HeavyCooldown, function()
			HeavyDebounce = false
		end)
	end
end

--[[
function Combat.FeintFunction() --you can delete the feint stuff if you don't like it, its not that good
	local timeSinceMouseButton1 = tick() - lastMouseButton1Pressed
	if timeSinceMouseButton1 <= TimeToFeint and not FeintDebounce then
		swingEvent:FireServer("Feint",char:FindFirstChildWhichIsA("Tool").Name)

		FeintDebounce = true

		task.spawn(function()
			TS:Create(camera, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {FieldOfView = 85}):Play()
			task.wait(.3)
			TS:Create(camera, TweenInfo.new(.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {FieldOfView = 70}):Play()
			task.wait(.7)
			FeintDebounce = false
		end)

	end
end

]]

function Combat.Check()
	return char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):GetAttribute("Type") == "Attack"
end

--uis.InputBegan:Connect(function(key, isTyping)
--if key.UserInputType == Enum.UserInputType.MouseButton2 then --if you delete the feint stuff also delete this
--	FeintFunction()
--end
--end)

return Combat
