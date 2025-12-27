return function(char: Model, cc)
	local attacking = char:GetAttribute("Attacking")
	local attacked = char:GetAttribute("Attacked")
	local stunned = char:GetAttribute("Stunned")
	local isRagdoll = char:GetAttribute("IsRagdoll")
	local swing = char:GetAttribute("Swing")
	local blocking = char:GetAttribute("IsBlocking")
	local hrp = char:WaitForChild("HumanoidRootPart")
	local Heavy = hrp:FindFirstChild("Heavy")

	if attacking or attacked or stunned or swing or isRagdoll or blocking or Heavy or cc then
		return false
	else
		return true
	end
end
