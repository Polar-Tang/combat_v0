local RS = game:GetService("ReplicatedStorage")

local animationsData = require(RS.Animations.WeaponsAnims)
local nome = {}

nome.NPCAnimBinder = {}

nome.init = function(Binder)
	nome.NPCAnimBinder = Binder.new(
		"AnimationHandler",
		require(script.Parent.AnimationHandler)
	)
	nome.NPCAnimBinder:GetClassAddedSignal():Connect(function(handler, npcModel)
		if npcModel.Name == "Blocking"  then
			handler:registryAnims(animationsData["Fist-r6"])
			handler:preloadAll()
			handler:LoadAnimation(true, "Blocking")
			
		end 
	end)
	nome.NPCAnimBinder:Start()
	return nome.NPCAnimBinder
end

return nome