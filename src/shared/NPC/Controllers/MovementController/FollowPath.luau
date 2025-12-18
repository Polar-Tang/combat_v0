local PathfindingService = game:GetService("PathfindingService")

local path = PathfindingService:CreatePath()

local STOP_DISTANCE = 4

local waypoints
local nextWaypointIndex
local reachedConnection
local blockedConnection

local function GetProximityPosition(targetPosition: Vector3, fromPosition: Vector3, offset: number): Vector3
	local direction = (targetPosition - fromPosition).Unit
	return targetPosition - direction * offset
end

local function FilterWaypoints(waypoints, destination: Vector3, stopDistance, minDistance)
	local filtered = {}
	for i, wp in ipairs(waypoints) do
		local distToDestination = (wp.Position - destination).Magnitude
		if distToDestination <= stopDistance then
			-- Push the NPC to a nearby offset position (like "in front of player")
			local proximityLocation = GetProximityPosition(destination, wp.Position, 4)
			local newWaypoint = PathWaypoint.new(proximityLocation, wp.Action)
			table.insert(filtered, newWaypoint)
			break -- stop after this proximity point
		end

		table.insert(filtered, wp)
	end

	return filtered
end

local function followPath(destination, npc)
	print("Called follow Path")
	-- Disconnect old connections if they exist
	if reachedConnection then
		reachedConnection:Disconnect()
		reachedConnection = nil
	end
	if blockedConnection then
		blockedConnection:Disconnect()
		blockedConnection = nil
	end

	-- Try computing the path
	local success, errorMessage = pcall(function()
		path:ComputeAsync(npc.PrimaryPart.Position, destination)
	end)

	if not success or path.Status ~= Enum.PathStatus.Success then
		warn("Path computation failed: ", errorMessage)
		return
	end

	waypoints = path:GetWaypoints()

	local filteredWaypoints = FilterWaypoints(waypoints, destination, STOP_DISTANCE, 0.1)
	nextWaypointIndex = 2

	-- Blocked handler
	blockedConnection = path.Blocked:Connect(function(blockedWaypointIndex)
		if blockedWaypointIndex >= nextWaypointIndex then
			blockedConnection:Disconnect()
			blockedConnection = nil
			followPath(destination, npc) -- Recursive re-path
		end
	end)

	-- Movement finished handler
	if not reachedConnection then
		reachedConnection = npc.Humanoid.MoveToFinished:Connect(function(reached)
			if reached and nextWaypointIndex <= #filteredWaypoints then
				local waypoint = filteredWaypoints[nextWaypointIndex]
				local distance = (waypoint.Position - destination).Magnitude
				if distance <= STOP_DISTANCE then
					print("Reached close enough to destination.")
					reachedConnection:Disconnect()
					blockedConnection:Disconnect()
					reachedConnection = nil
					blockedConnection = nil
					return
				end

				nextWaypointIndex += 1
				if nextWaypointIndex <= #filteredWaypoints then
					npc.Humanoid:MoveTo(filteredWaypoints[nextWaypointIndex].Position)
					--walkAnimationTrack:Play()
				end
			else
				-- Finished or failed
				reachedConnection:Disconnect()
				blockedConnection:Disconnect()
				reachedConnection = nil
				blockedConnection = nil
			end
		end)
	end
	
	-- Start movement
	if filteredWaypoints[nextWaypointIndex] then
		npc.Humanoid:MoveTo(filteredWaypoints[nextWaypointIndex].Position)
	end
end

return followPath