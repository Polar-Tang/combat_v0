local OtherAnims = {}

export type Dash = {
	ADash: string,
	DDash: string,
	SDash: string,
	WDash: string,
}

export type OtherAnims = {
	Dash: Dash,
	Extra: string,
}

local otherAnims: OtherAnims = {
	Dash = {
		["ADash"] = "rbxassetid://122305201667449",
		["DDash"] = "rbxassetid://115451998547335",
		["SDash"] = "rbxassetid://133339970955472",
		["WDash"] = "rbxassetid://126359086132557",
	},
	Extra = "some value",
}

return otherAnims
