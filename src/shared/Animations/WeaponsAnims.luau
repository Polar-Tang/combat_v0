local Attkcs = {}
export type AttackGroup = {
	[string]: string, -- any key inside groups maps to an animationId string
}

export type Weapon = {
	Attacking: AttackGroup,
	Hit: AttackGroup,
	Sprint: string,
	Equip: string,
	Idle: string,
	UnEquip: string,
}

export type Attkcs = {
	[string]: Weapon,
}
Attkcs["Fist"] = {
	["Heavy"] = "rbxassetid://80889299731223",
	["Swing1"] = "rbxassetid://82035883154975",
	["Swing2"] = "rbxassetid://128850067271793",
	["Swing3"] = "rbxassetid://135638578236815",
	["Swing4"] = "rbxassetid://124560167736177",
	["Swing5"] = "rbxassetid://98992071933663",
	["HeavyHit"] = "rbxassetid://80889299731223",
	["Hit1"] = "rbxassetid://82035883154975",
	["Hit2"] = "rbxassetid://128850067271793",
	["Hit3"] = "rbxassetid://135638578236815",
	["Hit4"] = "rbxassetid://124560167736177",
	["Hit5"] = "rbxassetid://98992071933663",
	["Sprint"] = "rbxassetid://130609866336149",
	["Equip"] = "rbxassetid://91567634616046",
	["Idle"] = "rbxassetid://91567634616046",
	["UnEquip"] = "rbxassetid://76401194937920",
	["Blocking"] = "rbxassetid://109266615151969",
}

Attkcs["Fist-r6"] = {
	["Heavy"] = "rbxassetid://84447851639470",
	["Swing1"] = "rbxassetid://130203779806436",
	["Swing2"] = "rbxassetid://100499038415190",
	["Swing3"] = "rbxassetid://126563645344009",
	["Swing4"] = "rbxassetid://112821950233659",
	["Swing5"] = "rbxassetid://80100527539838",
	["HeavyHit"] = "rbxassetid://84447851639470",
	["Hit1"] = "rbxassetid://130203779806436",
	["Hit2"] = "rbxassetid://100499038415190",
	["Hit3"] = "rbxassetid://126563645344009",
	["Hit4"] = "rbxassetid://112821950233659",
	["Hit5"] = "rbxassetid://80100527539838",
	["Sprint"] = "rbxassetid://108548036345475",
	["Equip"] = "rbxassetid://90317007650678",
	["Idle"] = "rbxassetid://90317007650678",
	--["UnEquip"] = "rbxassetid://15451005805",
	["Blocking"] = "rbxassetid://119463100691422",
	["GuardBreak"] = "rbxassetid://70952470480164",
}

return Attkcs :: { Attkcs }
