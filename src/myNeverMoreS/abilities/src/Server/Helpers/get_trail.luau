return function(CHAR)
	local tool: Tool = CHAR:FindFirstChildWhichIsA("Tool")
	return CHAR:WaitForChild(tool.Name):WaitForChild("BodyAttach"):FindFirstChild("Trail")
end