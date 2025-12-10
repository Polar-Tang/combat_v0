--[[
local RS = game:GetService("ReplicatedStorage")

local animationsData = require(RS.Animations.WeaponsAnims)
local HandlerBinder = {}

HandlerBinder.NPCAnimBinder = {}

HandlerBinder.init = function(ServiceBag, Binder)
	HandlerBinder.NPCAnimBinder = Binder.new("AnimationHandler", require(script.Parent.AnimationHandler))

	return HandlerBinder.NPCAnimBinder
end

HandlerBinder.start = function()
	HandlerBinder.NPCAnimBinder:GetClassAddedSignal():Connect(function(handler, npcModel)
		print("handler ", handler)
		if npcModel.Name == "Blocking" then
			handler:registryAnims(animationsData["Fist-r6"])
			handler:preloadAll()
			handler:LoadAnimation(true, "Blocking")
		end
	end)
end

return HandlerBinder
]]