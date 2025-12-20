-- TODO: It would be call if this is described and not directly executed, so move this logic to the effect service domain

local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
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

local TweenService = game:GetService("TweenService")
function PowerDome:_ExpandDoom(shockwave)
	shockwave.Parent = workspace

	local tweenInfo = TweenInfo.new(
		0.5, -- Duration
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
	)

	local goal = {
		Size = Vector3.new(self.maxRadius * 2, self.maxRadius * 2, self.maxRadius * 2),
		Transparency = 1,
	}

	local tween = TweenService:Create(shockwave, tweenInfo, goal)
	tween:Play()
end

function PowerDome:_SetDomePosition(shockwave)
	for _, part in ipairs(shockwave:GetDescendants()) do
		task.spawn(function()
			if part:IsA("Part") or part:IsA("MeshPart") then
				part.Position = self.currentPosition
			end
		end)
	end
end

function PowerDome:CreateExplosionVFX(shockwave: Model)
	for _, part in ipairs(shockwave:GetDescendants()) do
		task.spawn(function()
			if part:IsA("Part") or part:IsA("MeshPart") then
				self:_ExpandDoom(part)
			end
		end)
	end

	for i = 1, 8 do
		local wind = winds:Clone()
		local angle = (i / 8) * math.pi * 2
		local offset = Vector3.new(math.cos(angle) * 5, 0, math.sin(angle) * 5)

		wind.Position = self.currentPosition + offset
		wind.CFrame = CFrame.lookAt(wind.Position, self.currentPosition)
		wind.Parent = workspace

		local windTween =
			TweenService:Create(wind, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = self.currentPosition + (offset * 10),
				Transparency = 1,
			})
		windTween:Play()

		game:GetService("Debris"):AddItem(wind, 0.6)
	end

	game:GetService("Debris"):AddItem(shockwave, 0.5)
end

function PowerDome:Execute()
	-- check if can run
	if self._cooldownController:getCD() then
		return
	end

	self._cooldownController:init(self.cooldown)
	--Settin attr
	-- self:SetAttributes()

	-- First set the dome clone, attach it a hit box
	local shockwave = Power_dome:Clone()
	self.currentPosition = self.character.PrimaryPart.Position

	self:_SetDomePosition(shockwave)
	shockwave.Parent = Workspace

	self.hitBox = self:createHitBox({
		Puncher = shockwave,
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
		}
	end
	---------------------------------------------------------------------------------

	--create the connection
	-- asumming the data is always the same, the connection should remain the same too

	if self._maid["Heavy"] then
		return
	end
	local hitTask = self.hitBox.Touched:Connect(hitTouchTemplate(data))
	self._maid:__newindex("Heavy", hitTask)

	-- PLay an animation
	-- TODO: get a cool asimation that resembles goku henkidama
	local animHandler = self._animHandler
	animHandler:LoadAnimation(true, "Heavy")

	-- instantly run the effect
	task.spawn(function()
		self:CreateExplosionVFX(shockwave)
	end)

	-- Start the damn box
	hitbox_start_stop(self.character, self.hitBox)
end

return PowerDome
