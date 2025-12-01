return function(char) 
	return char:FindFirstChildWhichIsA("Tool") and char:FindFirstChildWhichIsA("Tool"):GetAttribute("Type") == "Attack" 
end