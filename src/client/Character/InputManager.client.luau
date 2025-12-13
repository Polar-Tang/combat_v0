local repStore = game:GetService("ReplicatedStorage")
local UserInputSer = game:GetService("UserInputService")

local remotes = repStore.Events
local swingEvent = remotes:WaitForChild("Swing")

-- constants
local plr = game:GetService("Players").LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
print("char ", char)

--helpers functions
local attckChck = function()
	local tool = char:FindFirstChildWhichIsA("Tool")
	return tool and char:FindFirstChildWhichIsA("Tool"):GetAttribute("Type") == "Attack"
end

local isCD = false
-- FUCK DRY
local function GCD(secs: number)
	isCD = true
	task.delay(secs, function()
		isCD = false
	end)
end

local InputManager = {}

InputManager.Bindings = {
	[Enum.KeyCode.Q] = require(char:WaitForChild("Abilities").Dash.DashClient),
	[Enum.KeyCode.R] = require(char:WaitForChild("Abilities").heavyAttack),
	[Enum.KeyCode.F] = require(char:WaitForChild("Abilities").Blocking),
	[Enum.KeyCode.W] = require(char:WaitForChild("Abilities").Sprint),
	--[Enum.KeyCode.R] = require(script.Parent.Abilities.CombatClient).FeintFunction,
}

local isBlocking = char:GetAttribute("IsBlocking")

UserInputSer.InputBegan:Connect(function(input, IsTyping)
	if IsTyping or isCD then
		print("not run")
		return
	end
	print("run")
	local command = InputManager.Bindings[input.KeyCode]
	if input.KeyCode == Enum.KeyCode.Q and not isBlocking and command.Check() then
		command.Execute()
		GCD(1)
		swingEvent:FireServer(input.UserInputType)
		-- TODO: CREATE AN Heavy check
	elseif input.KeyCode == Enum.KeyCode.R and not isBlocking and attckChck(char) then --for the heavy attack
		command.Execute()
		GCD(1)
		swingEvent:FireServer(Enum.KeyCode.R)
	elseif input.KeyCode == Enum.KeyCode.F and attckChck(char) and command.Check() then
		print("block")
		command.Execute()
		GCD(1)

		swingEvent:FireServer(Enum.KeyCode.F)
	elseif input.KeyCode == Enum.KeyCode.W and command.isIdle() and command.Check() then
		-- command.Execute()
		-- SPRINT needs a tire/energy system to be cool, so it's better to ignore it
		-- swingEvent:FireServer(Enum.KeyCode.W)

		-- GCD(1)
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 and attckChck(char) and not isBlocking then
		--lastMouseButton1Pressed = tick()

		swingEvent:FireServer(input.UserInputType)
		GCD(1)
		--[[task.spawn(function() --for hiding the inventory
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
			task.wait(.1)				
			repeat task.wait() until not char:GetAttribute("Swing")
				StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
			end)
		]]
	end
end)
UserInputSer.InputEnded:Connect(function(input, isTyping)
	if isTyping then
		return
	end

	local command = InputManager.Bindings[input.KeyCode]
	
	if input.KeyCode == Enum.KeyCode.F and attckChck() and not isBlocking then
		command.Kill()
		swingEvent:FireServer(Enum.KeyCode.F)
	elseif input.KeyCode == Enum.KeyCode.W and command.Check() then
		-- command.Kill()
	end
end)

---------------------------------MOBILE------------------------------------

if UserInputSer.TouchEnabled then
	local MobileButtons = plr.PlayerGui:WaitForChild("MobileButtons"):WaitForChild("MobileButtons2")
	MobileButtons.Visible = true

	--StarterGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeRight
	--[[
	MobileButtons.Dash.Activated:Connect(function()		
		if Dash.Check then
			Dashing()
		end		
	end)
	
	
	local MobileButtons1 = plr.PlayerGui:WaitForChild("MobileButtons"):WaitForChild("MobileButtons")
	MobileButtons1.Visible = true
	local MobileButtons2 = plr.PlayerGui:WaitForChild("MobileButtons"):WaitForChild("MobileButtons2")
	MobileButtons2.Visible = true

	

	MobileButtons2.Swing.Activated:Connect(function()
		if char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):GetAttribute("Type") == "Attack" then
			lastMouseButton1Pressed = tick()
			swingEvent:FireServer("none",char:FindFirstChildWhichIsA("Tool").Name)
		end	
	end)

	MobileButtons1.Feint.Activated:Connect(function() --if you delete the feint stuff also delete this
		if char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):GetAttribute("Type") == "Attack" then
			FeintFunction()
		end
	end)

	MobileButtons1.Heavy.Activated:Connect(function() --if you delete the feint stuff also delete this
		HeavyFunction()
	end)

	-- THE BLOCKING
	if uis.TouchEnabled then
	plr.PlayerGui:WaitForChild("MobileButtons"):WaitForChild("MobileButtons").Visible = true

	char:WaitForChild("Humanoid").AutoJumpEnabled = false --auto jump is annoying for mobile

	blockingUi.MainFrame.Position = UDim2.new(0.35,0,0.75,0)

	plr.PlayerGui:WaitForChild("MobileButtons"):WaitForChild("MobileButtons").Block.Activated:Connect(function()
		local Stunned = char:GetAttribute("Stunned")
		if not debounce and char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):GetAttribute("Type") == "Attack" and not char:GetAttribute("IsBlocking") then
			startBlocking()
		elseif not Stunned and char:GetAttribute("IsBlocking") then
			stopBlocking()
		end
	end)

end

	---------------- SPRINTING
	if uis.TouchEnabled then
	local MobileButtons = plr.PlayerGui:WaitForChild("MobileButtons"):WaitForChild("MobileButtons2")

	MobileButtons.Sprint.Activated:Connect(function()		
		shiftToSprint()
	end)
end	

	]]
end

---------------------------------MOBILE------------------------------------
