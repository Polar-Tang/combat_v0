local RS = game:GetService("ReplicatedStorage")
local PlayerAnimation = require(RS.Animations.Utils.AnimationHandler)
local PlayerAnimationHandler = {}
export type PlayerAnimationHandlerOptions = PlayerAnimation.Options
export type AnimationHandler = PlayerAnimation.AnimationHandler

PlayerAnimationHandler.__index = PlayerAnimationHandler

PlayerAnimationHandler._players = {}
export type PlayerAnimationHandler = {
	InitPlayer: (self: PlayerAnimationHandler, data: PlayerAnimationHandlerOptions) -> (),
	GetHandler: (self: PlayerAnimationHandler, player: Player) -> (),
	RemovePlayer: (self: PlayerAnimationHandler, player: Player) -> (),

}

function PlayerAnimationHandler:InitPlayer(player, handler)
	if not player  then
		warn("Player not found")
		return
	end
	self._players[player.UserId] = handler
end

-- accept a player
-- Get the player handler
-- return the particular player handler
function PlayerAnimationHandler:GetHandler(player)
	local thePlayer = self._players[player.UserId]
	return self._players[player.UserId]
end

function PlayerAnimationHandler:GetPlayersList()
	return self._players
end

-- accept a player
-- remove the player instance
-- return nil
function PlayerAnimationHandler:RemovePlayer(data)
	local player = data.player
	self._players[player.UserId] = nil
end

return PlayerAnimationHandler
