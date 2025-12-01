--||Services||--
local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

--||Folder||--
local CombatM = SSS.Combat

local remotes = RS:WaitForChild("Events")

--||Modules||--
local WeaponInfoModule = require(CombatM.Weapons.WeaponInfo)
local BlockingStats = WeaponInfoModule:getweapon("Blocking_General")


local AnimationClient = require(RS.Animations.Utils.AnimationClient)
--||Settings||--
local Walk_Speed_Normal = 14
local Walk_Speed_Blocking = 6
local Parry_Time = BlockingStats.Parry_Time
local Block_Reset_Time = BlockingStats.Block_Reset_Time

------------------------------------------------------------------------------------------------------------------
local BlockingServer = {}
BlockingServer.Type = "Blocking"
function BlockingServer.Execute(character, action)

	local isBlocking = character:GetAttribute("IsBlocking")
	local lastStopTime = character:GetAttribute("LastStopTime") or 0
	local currentTime = tick()
	print("IsBlocking", character:GetAttribute("IsBlocking"))
	if not isBlocking then
		character:SetAttribute("IsBlocking", true)
		character:SetAttribute("LastStopTime", 0)
		character.Humanoid.WalkSpeed = Walk_Speed_Blocking
		AnimationClient.Blocking(character)

		task.spawn(function()
			character:SetAttribute("Parrying", true)
			task.wait(Parry_Time)
			character:SetAttribute("Parrying", false)
		end)

	elseif isBlocking then
		character:SetAttribute("IsBlocking", false)		
		character:SetAttribute("Parrying", false)
		character:SetAttribute("LastStopTime", currentTime)
		character.Humanoid.WalkSpeed = Walk_Speed_Normal
		AnimationClient.UnBlocking(character)

	end
end



local connectionRunning = {}

local function onBlockingChanged(char)	
	if char:GetAttribute("Blocking") > 0 and connectionRunning[char] == nil then
		coroutine.wrap(function() 
			connectionRunning[char] = true
			while char:GetAttribute("Blocking") > 0  do 	-- Connect the loop only when Blocking is greater than 0
				task.wait(1)
				for i, char in pairs(game.Workspace:GetDescendants()) do
					if char:IsA("Humanoid") then
						local character = char.Parent
						if character then
							local isBlocking = character:GetAttribute("IsBlocking")
							local lastStopTime = character:GetAttribute("LastStopTime") or 0
							local currentTime = tick()

							if not isBlocking and currentTime - lastStopTime >= Block_Reset_Time then
								character:SetAttribute("Blocking", math.max(0, character:GetAttribute("Blocking") - 1.5))
							end
						end
					end

				end
			end			
			connectionRunning[char] = nil -- Disconnect the loop when Blocking becomes 0
		end)()		
	end
end



--Checking for the block stuff for players and npcs
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		char:GetAttributeChangedSignal("Blocking"):Connect(function()
			onBlockingChanged(char)
		end)
	end)
end)

--[[for i,v in pairs(workspace.Npcs:GetChildren()) do
	v:GetAttributeChangedSignal("Blocking"):Connect(function()
		onBlockingChanged(v)
	end)
end
]]

return BlockingServer