local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local packages = RS.Nevermore.Quenty
local BaseObject = require(packages.baseobject.Shared.BaseObject)
-- TEST IF this doesn't break
local HumanoidTracker = require(packages.humanoidtracker.Shared.HumanoidTracker)


local TargetingController = setmetatable({}, BaseObject)
TargetingController.__index = TargetingController

function TargetingController.new(character: Instance, serviceBag: any)
	local self = setmetatable(BaseObject.new() :: any, TargetingController)

	self._character = character
	self._root = character:WaitForChild("HumanoidRootPart")
    
    self._serviceBag = serviceBag

    

	self._currentPlayer = nil
	self._humanoidTracker = nil

	return self
end

function TargetingController:SetTargetPlayer(player: Player?)
	-- Clear previous target
	self._maid.target = nil
	self._currentPlayer = player

	if not player then
		self._humanoidTracker = nil
		return
	end

    --local tracker = self._serviceBag:GetService(HumanoidTracker)
    
	local tracker = HumanoidTracker.new(player)
	self._humanoidTracker = tracker
	self._maid.target = tracker

	self._maid.targetDeath = tracker.HumanoidDied:Connect(function()
		self:SetTargetPlayer(nil)
	end)
end

function TargetingController:_GetAliveHumanoid()
	if not self._humanoidTracker then
		return nil
	end

	return self._humanoidTracker.AliveHumanoid.Value
end

function TargetingController:GetTarget()
    -- self.HumanoidTracker
	return self._currentTarget
end

function TargetingController:GetTargetPosition(): Vector3?
	local humanoid = self:_GetAliveHumanoid()
	if not humanoid then
		return nil
	end

	local root = humanoid.Parent:FindFirstChild("HumanoidRootPart")
	return root and root.Position or nil
end

function TargetingController:GetDistanceToTarget()
	local pos = self:GetTargetPosition()
	if not pos then
		return math.huge
	end
	return (pos - self._root.Position).Magnitude
end


function TargetingController:_isTargetInFront(dotThreshold: number?): boolean
	dotThreshold = dotThreshold or 0.5

	local pos = self:GetTargetPosition()
	if not pos then
		return false
	end

	local forward = self._root.CFrame.LookVector
	local direction = (pos - self._root.Position).Unit

	return forward:Dot(direction) >= dotThreshold
end


function TargetingController:LookTarget()
    if not self:_isTargetInFront() then

        local targetPos = self:GetTargetPosition()
        local targetCFrame = CFrame.lookAt(self._root.Position, targetPos)

        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = { CFrame = targetCFrame }
        local tween = TweenService:Create(self._root, tweenInfo, goal)
        tween:Play()
    end
end

return TargetingController
