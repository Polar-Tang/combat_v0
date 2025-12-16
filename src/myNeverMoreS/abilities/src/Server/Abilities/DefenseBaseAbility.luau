-- Abstract class for Defense abilities
local require = require(script.Parent.loader).load(script)
local BaseAbility = require("BaseAbility")

local DefenseAbility =  setmetatable({}, BaseAbility)
DefenseAbility.__index = DefenseAbility

function DefenseAbility.new(config)
    local self = setmetatable(BaseAbility.new(config), DefenseAbility)
    self.isActive = false

    return self
end

function DefenseAbility:Execute()
    -- Toggle blocking state
    if self.isActive then
        self:Deactivate()
    else
        self:Activate()
    end
end

local EnumDefense = {
    "Dodge",
    "Absorb",

}

-- link the handler to the chain, should be called in every :Execute()
function DefenseAbility:Activate()
    self.isActive = true
    
    self._weaponHandler:SetActiveDefense(self)
end

function DefenseAbility:Deactivate()
    self.isActive = false
    self._weaponHandler:ClearActiveDefense()
    -- Stop animation, etc.
end

-- Add modifiers to the defense chain
function DefenseAbility:AddModifier(modifier)
    table.insert(self._defenseChain, modifier)
    return self
end

return DefenseAbility