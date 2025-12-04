local ServiceShit = {}
local _shit
function ServiceShit.init(serviceBag)
	_shit = serviceBag
end

function ServiceShit.serviceBag()
	return _shit
end

return ServiceShit
