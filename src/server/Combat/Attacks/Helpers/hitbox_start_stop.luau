return function(char,newHitbox)
	if not newHitbox then return end
	task.spawn(function()
		if not char:GetAttribute("Stunned") then
			newHitbox:Start()
			task.wait(.1)				
			newHitbox:Stop()

		else
			newHitbox:Stop()
		end
	end)
end