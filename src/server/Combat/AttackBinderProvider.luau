
local AttackBinderProvider = {}
function AttackBinderProvider.new(BinderProvider, Binders) 

    return BinderProvider.new("AttackBinders", function(self, serviceBag)
        for _, Binder in ipairs(Binders) do
            self:Add(Binder, serviceBag)
        end
    end)
end
return AttackBinderProvider