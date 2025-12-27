-- MovementController.lua
-- TODO: Implement a method for completly stop moving the character
local ReplicatedSorage = game:GetService("ReplicatedStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")

local Maid = require(ReplicatedStorage.Nevermore.Quenty.maid.Shared.Maid)
local PathfindingUtils = require(ReplicatedStorage.Nevermore.Quenty.pathfindingutils.Shared.PathfindingUtils)

local STOP_DISTANCE = 6

local MovementController = {}
MovementController.__index = MovementController

function MovementController.new(model: Instance?, serviceBag: any)
	local self = setmetatable({}, MovementController)
	self.Model = model
	self.velocity = 16 -- Test this

	self._root = self.Model:WaitForChild("HumanoidRootPart")
	local BinderProvider = serviceBag:GetService(_G.BinderProvider)

	-- local WeaponBinder = BinderProvider:Get("Armed")
	local AnimationBinder = BinderProvider:Get("AnimationHandler")
	self._AnimationHandler = AnimationBinder:Get(model)
	-- registry the fist animations only
	local Animations = ReplicatedSorage.Animations
	local anims = require(Animations.WeaponsAnims)["Fist-r6"]
	local otherAnims = require(Animations.OtherAnims)["default_r6"]
	self._AnimationHandler:registryAnims(anims)
	self._AnimationHandler:AddAnimations(otherAnims)

	self._maid = Maid.new()
	self._pathMaid = Maid.new()
	self._lastTarget = nil
	self._currentPath = nil

	return self
end

function MovementController:MoveTo(targetPosition)
	if not self._root then
		return
	end

	if (self._root.Position - targetPosition).Magnitude <= STOP_DISTANCE then
		self:Stop()
		return
	end

	if (self._lastTarget and ((self._lastTarget - targetPosition).Magnitude > 0)) or self.isMoving then
		self:Stop()
	end
	self._lastTarget = targetPosition
	self:_computePath(targetPosition)
end

local function onReject()
	return
end

function MovementController:_computePath(destination: Vector3)
	-- Cancel any existing path computation

	local path = PathfindingService:CreatePath()

	self._maid:GiveTask(
		PathfindingUtils.promiseComputeAsync(path, self._root.Position, destination):Then(function(computedPath)
			self:_walkThroughPath(computedPath)
		end, onReject)
	)
end

function MovementController:_walkThroughPath(path)
	self._currentPath = path
	self._waypoints = path:GetWaypoints()
	self._waypointIndex = 2

	self._pathMaid:GiveTask(path.Blocked:Connect(function(blockedIndex)
		if blockedIndex >= self._waypointIndex then
			self:_computePath(self._lastTarget)
		end
	end))

	self:_moveToNext()
end

function MovementController:_advanceWaypoint()
	self._waypointIndex += 1
	self:_moveToNext()
end

-- Move to the next position in the waypoint array
function MovementController:_moveToNext()
	local wp = self._waypoints[self._waypointIndex]
	if not wp then
		return
	end

	Maid.GiveTask(self._currentTween.Completed:Connect(function()
		self:Stop()
	end))

	if self.Humanoid:HasTag("Ragdoll") then
		self:Stop()
		return
	end

	if (self._root.Position - self._lastTarget).Magnitude <= STOP_DISTANCE then
		self:Stop()
		return
	end

	self._AnimationHandler:LoadAnimation(true, "walk")
	self.isMoving = true

	local distance = (wp.Position - self._root.Position).Magnitude
	local timeToReach = distance / self.velocity

	self._currentTween = TweenService:Create(
		self._root,
		TweenInfo.new(timeToReach, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
		{ CFrame = CFrame.new(wp.Position) }
	)

	self._currentTween:Play()
end

function MovementController:Stop()
	self._pathMaid:DoCleaning()
	self._currentPath = nil
	self._waypoints = nil
	self.isMoving = false
	self._currentTween:Stop()
	if self._AnimationHandler then
		self._AnimationHandler:LoadAnimation(false, "walk")
	end
	-- Fire an event to report the last position to the server
end

function MovementController:Destroy()
	self:Stop()
	self._maid:DoCleaning()
end

return MovementController
