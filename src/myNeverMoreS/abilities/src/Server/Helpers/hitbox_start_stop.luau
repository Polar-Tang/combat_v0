return function(char, newHitbox)
	print("newHitbox ", newHitbox)
	if not newHitbox then
		return
	end
	
	task.spawn(function()
		newHitbox:Start()
		task.delay(0.5, function()
			newHitbox:Stop()
		end)
	end)
end
