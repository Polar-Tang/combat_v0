--[[
Animation handler @v_02
	The .new accepts an object as a parameter, it tolerates the model player or the player object
	Check the animation priority before stop it
	Got bindable events for animations
Animation handler @v_03
	implements Lazy load on registered animations

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
	preloaded: boolean,
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
	if isPreload then
		warn("Do you meant to use Preload() " .. debug.traceback())
	end
	self:_ensurePreload(animaName)
	local current_desc = self:_getDescriptor(animaName)
	local animaTionTrack: AnimationTrack = current_desc.AnimationTrack

	
	if state and animaTionTrack then
		
		animaTionTrack:Play()

		return animaTionTrack
	end
	--------------------------------------

	---- STOP ANIM ----
	if not state and animaTionTrack then
		animaTionTrack:Stop()
		return nil
	elseif not state then
		return nil
	end
	return nil
	---- STOP ANIM ----
end

function AnimationHandler:_initDescriptior(animaName: string)
	local desc = self:_getDescriptor(animaName)
	local animId = self.animations[animaName]

	if desc.AnimationTrack then
		warn("This descriptor were intialized " .. debug.traceback())
	end
	local descriptor: AnimationDescriptor = {} :: AnimationDescriptor
	local newAnimation = Instance.new("Animation")
	newAnimation.AnimationId = animId
	descriptor.Animation = newAnimation
	descriptor.Maid = Maid.new()
	self.animationDescriptors[animaName] = descriptor
end

-- Declare the firast animation track and set ptreload to true in the descriptor
function AnimationHandler:_ensurePreload(animaName)
	
	if self.animationDescriptors[animaName].preloaded then
		warn("Animation already preloaded")
		return
	end
	self:_initDescriptior(animaName)

	if not self.animator then
		self.animator = self.Char:WaitForChild("Humanoid").Animator
	end

	-- Load the animation and declare it
	do
		local animaTionTrack: AnimationTrack = self.animator:LoadAnimation(self.animationDescriptors[animaName].Animation)
		animaTionTrack:Play()
		animaTionTrack:Play(0)
		animaTionTrack:AdjustSpeed(0)
		task.wait()
		animaTionTrack:Stop()
		self.animationDescriptors[animaName].AnimationTrack = animaTionTrack
	end

	self.animationDescriptors[animaName].preloaded = true
end

-- Just a helper to getting the animation tracker by its animation name
function AnimationHandler:_getDescriptor(animaName): AnimationDescriptor
	assert(self.animations[animaName], "animation name does not exists")
	return self.animationDescriptors[animaName]
end

function AnimationHandler:Destroy()
	--print("[AnimationHandler] Destroyed for", self.npc)
	setmetatable(self, nil)
end

function AnimationHandler:registryAnims(anims: AnimationMap)
	self.animations = anims
	self:_declarDescriptors()
end

function AnimationHandler:_declarDescriptors()
	local newDescs = {}
	for k, _ in pairs(self.animations) do
		local descriptor = {}

		descriptor.Animation = nil
		descriptor.AnimationTrack = nil
		descriptor.Maid = nil
		descriptor.preloaded = false
		newDescs[k] = descriptor
	end
	self.animationDescriptors = newDescs
end

-- Preaload all the animation at once, better don't use it on long animations list
function AnimationHandler:preloadAll()
	warn(debug.traceback())
	local anims = self.animations
	-- local descriptors = {} :: { AnimationDescriptors }

	for k, v in pairs(anims) do
		local descriptor: AnimationDescriptor = {} :: AnimationDescriptor
		local newAnimation = Instance.new("Animation")
		newAnimation.AnimationId = v
		descriptor.Animation = newAnimation
		descriptor.Maid = Maid.new()
		descriptor.preloaded = true
		self.animationDescriptors[k] = descriptor
		self:LoadAnimation(true, k, true)
	end

	--self.animationDescriptors = descriptors
end

local animationsData = require(RS.Animations.WeaponsAnims)

function AnimationHandler:Init(binder)
	
end

function AnimationHandler:Start(binder)
	if self.Char.Name == "Blocking" then
		self:registryAnims(animationsData["Fist-r6"])
		self:LoadAnimation(true, "Blocking")
	end
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
	if descriptor.Maid and descriptor.Maid[animationEventName] then
		return
	end

	local animationTracker = descriptor.AnimationTrack
	local signal: RBXScriptSignal
	--[[
	print(
		"Connecting marker:",
		animationEventName,
		"for animation:",
		animName,
		"track exists:",
		descriptor.AnimationTrack ~= nil
	)
	]]
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
