--[[
Animation handler @v_0.2
	The .new accepts an object as a parameter, it tolerates the model player or the player object
	Check the animation priority before stop it
	Got bindable events for animations
]]
local RS = game:GetService("ReplicatedStorage")
local require = require(script.Parent.loader).load(script)

local Maid = require("Maid")
--local NeverMore = require(RS.Packages.neverMore.loader).load(script.Parent.Parent.Parent.Packages.neverMore)
--local Binder = NeverMore("Binder")
--print("binder ", Binder)
local AnimationHandler = {}
AnimationHandler.__index = AnimationHandler
type MaidType = typeof(Maid.new(...))

export type AnimationsData = {
	animationId: string,
	AnimationTrack: AnimationTrack,
	--AnimationPriorityNumber: number -- i'm not sure if this is useful
}

export type AnimationMap = {
	[string]: { Animation },
}

export type Options = {
	player: Player?,
	char: Model?,
	animations: AnimationMap?,
	armName: string?,
}

--[[
local PRIORITY_LIST = {
	Enum.AnimationPriority.Core,
	Enum.AnimationPriority.Idle,
	Enum.AnimationPriority.Movement,
	Enum.AnimationPriority.Action,
	Enum.AnimationPriority.Action2,
	Enum.AnimationPriority.Action3,
	Enum.AnimationPriority.Action4,
}
]]
type AnimationDescriptor = {
	Animation: Animation,
	AnimationTrack: AnimationTrack,
	Maid: MaidType,
}

type AnimationDescriptors = {
	[string]: AnimationDescriptor,
}

function AnimationHandler.new(char, serviceBag): Options
	local self = setmetatable({}, AnimationHandler)
	self.Char = char
	self.animations = {}
	self.animationDescriptors = {}
	self.armName = ""
	return self
end

--[[
If takes state false does nothing, returns nil
If takes state false and animation name, stop it, returns nil
If takes state true and animation name, play it, returns AnimationTrack
If takes state true and animation name and preload true, playr and stop it inmediatly, returns nil
]]
function AnimationHandler:LoadAnimation(state: boolean, animaName: string, isPreload: boolean)
	---- START ANIM ----
	--print("self.animationDescriptors ", self.animationDescriptors)
	local current_desc = self.animationDescriptors[animaName]
	local current_anim = current_desc.Animation

	local animator: Animator = self.animator
	if not animator then
		animator = self.Char:WaitForChild("Humanoid").Animator
	end

	self.CurrentAnimation = current_anim
	local animaTionTrack: AnimationTrack = self.animationDescriptors[animaName].AnimationTrack
	if not animaTionTrack then
		animaTionTrack = animator:LoadAnimation(current_anim)
		self.animationDescriptors[animaName].AnimationTrack = animaTionTrack
	end
	if state and animaTionTrack then
		--local isHighestPriority = animaTionTrack.Priority == Enum.AnimationPriority.Idle or animaTionTrack.Priority == Enum.AnimationPriority.Movement or animaTionTrack.Priority == Enum.AnimationPriority.Core
		local isHighestPriority = (animaTionTrack.Priority == Enum.AnimationPriority.Action)
		-- Don't know why the first animation loaded here is always animation priority action, in spite its ACTUALLY core, so pre-load it
		if isHighestPriority and isPreload then
			animaTionTrack:Play()
			animaTionTrack:Stop()
			return nil
		else
			animaTionTrack:Play()
		end

		return animaTionTrack
	end

	local current_track = self.animationDescriptors[animaName].AnimationTrack
	---- STOP ANIM ----
	if not state and current_track then
		current_track:Stop()
		return nil
	elseif not state then
		return nil
	end
	return nil
	---- STOP ANIM ----
end
function AnimationHandler:setCanEquipTools(state: boolean)
	self.canEquipTools = state
end

function AnimationHandler:Destroy()
	--print("[AnimationHandler] Destroyed for", self.npc)
	setmetatable(self, nil)
end

function AnimationHandler:registryAnims(anims: AnimationMap)
	self.animations = anims
end
local animationsData = require(RS.Animations.WeaponsAnims)

function AnimationHandler:Start(binder)
	print("This shit is starting...")
	if self.Char.Name == "Blocking" then
		print("is this really happening? now yes")
		self:registryAnims(animationsData["Fist-r6"])
		self:preloadAll()
		self:LoadAnimation(true, "Blocking")
	end
end

function AnimationHandler:preloadAll()
	local anims = self.animations
	-- local descriptors = {} :: { AnimationDescriptors }

	for k, v in pairs(anims) do
		local descriptor: AnimationDescriptor = {} :: AnimationDescriptor
		local newAnimation = Instance.new("Animation")
		newAnimation.AnimationId = v
		descriptor.Animation = newAnimation
		descriptor.Maid = Maid.new()
		self.animationDescriptors[k] = descriptor
		self:LoadAnimation(true, k, true)
	end

	--self.animationDescriptors = descriptors
end

type connArgs = {
	callback: (Track: AnimationTrack, params: any) -> (),
	animationName: string,
	animationEventName: string,
}
function AnimationHandler:OnSignal(info: connArgs)
	local animName = info.animationName
	local animationEventName = info.animationEventName
	local descriptor: AnimationDescriptor = self.animationDescriptors[animName]
	print("descriptor ", descriptor)
	if descriptor.Maid and descriptor.Maid[animationEventName] then
		return
	end

	local animationTracker = descriptor.AnimationTrack
	local signal: RBXScriptSignal
	print(
		"Connecting marker:",
		animationEventName,
		"for animation:",
		animName,
		"track exists:",
		descriptor.AnimationTrack ~= nil
	)

	-- if animName == "Heavy" then
	-- 	for _, marker in ipairs(descriptor.AnimationTrack:GetTimeOfKeyframe("Hit")) do
	-- 		print("Marker:", marker.Name)
	-- 	end
	-- end

	if animationEventName == "EndedCon" then
		--print("animationTracker.Ended ", Maid.isMaid(animationTracker.Ended))
		signal = animationTracker.Ended
	else
		--print("animationTracker:GetMarkerReachedSignal(animationEventName) ",animationTracker:GetMarkerReachedSignal(animationEventName))
		signal = animationTracker:GetMarkerReachedSignal(animationEventName)
	end
	local conn = signal:Connect(function(param)
		info.callback(animationTracker, param)
	end)
	descriptor.Maid:__newindex(animationEventName, conn)
end

function AnimationHandler:ClearAnimation(animName)
	local desc = self.animationDescriptors[animName]
	if desc then
		desc.Maid:DoCleaning() -- disconnects ALL marker/ended/start connections
		if desc.AnimationTrack then
			desc.AnimationTrack:Destroy()
		end
	end
end

export type AnimationHandler = typeof(AnimationHandler.new({} :: Options))

return AnimationHandler
