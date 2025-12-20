-- TODO: It would be call if this is described and not directly executed, so move this logic to the effect service domain

local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local windVFX = RS.Effects.winds
local Power_dome = windVFX.power_up_dome
local winds = windVFX.winds

local require = require(script.Parent.loader).load(script)
local AttackBaseAbility = require("AttackBaseAbility")

local hitTouchTemplate = require("hitTouchTemplate")
local hitbox_start_stop = require("hitbox_start_stop")

local PowerDome = setmetatable({}, AttackBaseAbility)
PowerDome.__index = PowerDome

-- Config is the data created by the weapon through the builder
function PowerDome.new(config)
	local self = setmetatable(AttackBaseAbility.new(config), PowerDome)
	-- TODO: move this to the weaponInfo domain
	self.maxRadius = 20

	return self
end

-- Expnad the dome to its original size
function PowerDome:_ExpandDomePart(part)
	local originalSizes = {
		["Base"] = Vector3.new(84.957, 4.96, 91.099),
		["DustWind"] = Vector3.new(65.868, 34.496, 72.463),
		["Dome"] = Vector3.new(64.967, 32.483, 66.633),
	}
	self.dome.Parent = workspace
	
	local DUR = 0.5
	local tweenInfo = TweenInfo.new(
		DUR,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)

	local goal = {
		Size = originalSizes[part.Name],
		Transparency = 1,
	}

	local tween = TweenService:Create(part, tweenInfo, goal)
	tween:Play()
end

-- Start the dome in the player position
function PowerDome:_SetDomePosition()
	for _, part in ipairs(self.dome:GetDescendants()) do
		task.spawn(function()
			if part:IsA("Part") or part:IsA("MeshPart") then
				part.Position = self.currentPosition
			end
		end)
	end
end

function PowerDome:_ThrowOctagonalWinds()
	for i = 1, 8 do
		local wind = winds:Clone()

		-- Horizontal angle around the circle
		local horizontalAngle = (i / 8) * math.pi * 2

		-- Vertical angle for hemisphere (0 to 90 degrees)
		-- You can adjust this to control how high up the dome the winds appear
		local verticalAngle = math.pi / 4 -- 45 degrees - adjust between 0 and math.pi/2

		-- Calculate position on hemisphere surface
		local radius = 5
		local offset = Vector3.new(
			math.cos(horizontalAngle) * math.cos(verticalAngle) * radius,
			math.sin(verticalAngle), -- Y component for height
			math.sin(horizontalAngle) * math.cos(verticalAngle) * radius
		)

		wind.Position = self.currentPosition + offset

		-- Orient the wind to point outward along the dome surface
		-- The wind should face away from center, tangent to the sphere
		local outwardDirection = (wind.Position - self.currentPosition).Unit
		wind.CFrame = CFrame.lookAt(wind.Position, wind.Position + outwardDirection)
		wind.Parent = workspace

		-- Animate wind moving outward along the hemisphere trajectory
		local finalOffset = offset.Unit * (radius * 10)
		local windTween =
			TweenService:Create(wind, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = self.currentPosition + finalOffset,
				Transparency = 1,
			})
		windTween:Play()

		game:GetService("Debris"):AddItem(wind, 0.6)
	end
end

function PowerDome:CreateExplosionVFX()
	-- PASS THE DEBUGER HERE
	for _, part in ipairs(self.dome:GetDescendants()) do
		task.spawn(function()
			if part:IsA("Part") or part:IsA("MeshPart") then
				self:_ExpandDomePart(part)
			end
		end)
	end
	self:_ThrowOctagonalWinds()
	game:GetService("Debris"):AddItem(self.dome, 0.5)
end

function PowerDome:_CreateDome()
-- First set the dome clone, attach it a hit box
	self.dome = Power_dome:Clone()
	self.dome:ScaleTo(0.1)
	self.HRP = self.dome:FindFirstChild("HumanoidRootPart")
		or self.dome.PrimaryPart
		or self.dome:FindFirstChildOfClass("MeshPart")
		or self.dome:FindFirstChildOfClass("Part")
	self.currentPosition = self.character.PrimaryPart.Position

	self:_SetDomePosition()
	self.dome.Parent = Workspace
end

function PowerDome:Execute()
	-- check if can run
	if self._cooldownController:getCD() then
		return
	end

	self._cooldownController:init(self.cooldown)
	--Settin attr
	-- self:SetAttributes()

	self:_CreateDome()	

	self.hitBox = self:createHitBox({
		Puncher = self.dome,
		mode = "Default",
	})

	------------- Create the description -------------
	local data
	do
		local groundSmash = {
			position = nil,
			amount = 14,
			velocity = 70,
			material = Enum.Material.Slate,
			dust = true,
			shockwave = true,
			sizeRange = Vector2.new(1, 2.5),
			lifetime = 2.5,
		}

		local ragdoll = {
			duration = 1,
		}
		data = {
			serviceBag = self._serviceBag,
			ragdoll = ragdoll,
			groundSmash = groundSmash,
			damage = self.damage,
			hitBox = self.hitBox,
			stun_time = self.stun_time,
			["Explosion"] = {
				["Explosion"] = true,
			},
			["Attacker"] = {
				["Character"] = self.character,
				["HRP"] = self.character.PrimaryPart,
			},

			["kockback"] = math.huge,
			["strength"] = 100,
			["HRP"] = self.HRP,
		}
	end
	---------------------------------------------------------------------------------

	--create the connection
	-- asumming the data is always the same, the connection should remain the same too

	if not self._maid["Heavy"] then
		local hitTask = self.hitBox.Touched:Connect(hitTouchTemplate(data))
		self._maid:__newindex("Heavy", hitTask)
	end

	-- PLay an animation
	-- TODO: get a cool asimation that resembles goku henkidama
	local animHandler = self._animHandler
	animHandler:LoadAnimation(true, "Heavy")

	-- run the effect
	self:CreateExplosionVFX()

	-- Start the damn box
	task.defer(function()
		hitbox_start_stop(self.character, self.hitBox)
	end)
end

return PowerDome
