local function clearAllParticles(effect)
	local function emitAllParticles(parent)
		for _, child in ipairs(parent:GetChildren()) do
			if child:IsA("ParticleEmitter") then
				child:Clear()
			elseif child:IsA("Attachment") or child:IsA("Model") then
				emitAllParticles(child)
			end
		end
	end
	emitAllParticles(effect)
end

local function emitParticles(effect, destroy: boolean)
	if destroy  then
		return clearAllParticles(effect)
	end
	local function emitAllParticles(parent)
		for _, child in ipairs(parent:GetChildren()) do
			if child:IsA("ParticleEmitter") then
				child:Emit(50)
			elseif child:IsA("Attachment") or child:IsA("Model") then
				emitAllParticles(child)
			end
		end
	end
	emitAllParticles(effect)

end

return emitParticles

