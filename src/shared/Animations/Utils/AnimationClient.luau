local Debris = game:GetService("Debris")
local anim = {}
--||Animation Folder||--
local serviceBag = _G.ServiceBag

local BinderProvider = serviceBag:GetService(_G.BinderProvider)
local NPCAnimBinder = BinderProvider:Get("AnimationHandler")
local WeaponBinder = BinderProvider:Get("Armed")
-- local NPCAnimBinder =

------------------------------------------------------------------------------------------------------------------

--local function getHandler(char)
--	local animationHandler = PlayerAnimationHandler:GetHandler(char)
--	animationHandler
--end

------------------ Equip ------------------
anim.Equip = function(char: Model)
	--print("AnimationsClient required by:", debug.info(2, "sln"))
	--StopAllAnimations(char)

	-- PENDING: an equipping animation should play, onEnded play the idle animation

	local AnimationHandler = NPCAnimBinder:Get(char)
	AnimationHandler:LoadAnimation(true, "Equip")

	local weapon = WeaponBinder:Get(char)
	local EquipSound = weapon.Folder:WaitForChild("Equip"):Clone()
		
	--EquipAnim[char]:GetMarkerReachedSignal("Equipped"):Connect(
	-- make a higher order function that take the tanimation track as a parameter
	-- PENDING. SUPPORT AN EQUIP ANIMATION WHICH IS A TRASITION TO IDLE

	-- IN SUCH CASE PLAY THIS char:SetAttribute("Swing",true) --so the player can't attack while still equipping
	local onEquipp = function(animTrack)
		char:SetAttribute("Swing", false)
		AnimationHandler:LoadAnimation(true, "Idle")
		EquipSound.Parent = char:WaitForChild("HumanoidRootPart")
		EquipSound:Play()
		Debris:AddItem(EquipSound, 1)
		--animTrack:Play()
	end
	AnimationHandler:OnSignal({
		callback = onEquipp,
		animationName = "Equip",
		animationEventName = "Equipped",
	})

	-- IDK WHY THE ORIGINAL AUTHOR MADE THIS, IT HAS NO SENSE, IT REPLAYS AN ANIMATION THAT SHOULD BE LOOPED
	--[[
		local onEnded = function(animTack) --we are actually still keeping the ended in case the player gets hit while equipping
			if char:FindFirstChildWhichIsA("Tool") and char:GetAttribute("Stunned") then --actually checking if we didnt just unequip the weapon while we still equipped it
				animTack:Play()
			end
		end
		
		AnimationHandler:OnSignal({
			callback = onEnded,
			animationName = "Equip",
			animationEventName = "EndedCon"
		})
	]]
end

anim.UnEquip = function(char: Model) --function for UnEquip animation
	local AnimationHandler = NPCAnimBinder:Get(char)
	AnimationHandler:LoadAnimation(true, "UnEquip")
	local onUnEquipp = function(animTrack)
		char:SetAttribute("Swing", false)
		AnimationHandler:LoadAnimation(false, "Idle")
		-- EquipSound.Parent = char:WaitForChild("HumanoidRootPart")
		-- EquipSound:Play()
		-- Debris:AddItem(EquipSound, 1)
		--animTrack:Play()
	end
	AnimationHandler:OnSignal({
		callback = onUnEquipp,
		animationName = "UnEquip",
		animationEventName = "EndedCon",
	})


end

anim.Blocking = function(char: Model)
	local AnimationHandler = NPCAnimBinder:Get(char)
	AnimationHandler:LoadAnimation(true, "Blocking")
end

anim.UnBlocking = function(char: Model)
	local AnimationHandler = NPCAnimBinder:Get(char)
	AnimationHandler:LoadAnimation(false, "Blocking")
end

return anim
