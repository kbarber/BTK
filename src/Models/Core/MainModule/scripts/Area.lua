local Schema = require(script.Parent.Parent.Schema)
local Model = require(script.Parent.Model)

local Area = Model:subclass(script.Name)
Area:AddProperty({
	Name = "AreaPart",
	Type = "ObjectValue",
	ValueFn = function(self2)
		return self2:GetPrimaryPart()
	end,
	SchemaFn = Schema:IsA("BasePart"),
})

function Area:initialize(input)
	Model.initialize(self, input)

	local partValue = self:GetAreaPart()
	partValue.Anchored = true
	partValue.CanCollide = false
	partValue.Transparency = 1.0
	partValue.Touched:Connect(self:TouchedConnect())
	partValue.TouchEnded:Connect(self:TouchEndedConnect())
end

function Area:TouchedConnect()
	return function(otherPart)
		local comp = self:GetComponentData({
			Inst = otherPart,
		})
		if not comp then
			return
		end

		local humanoid = comp:GetData("Humanoid")
		if not humanoid then
			return
		end

		local rootPart = humanoid.RootPart
		if (not rootPart) or otherPart ~= rootPart then
			return
		end

		local player = comp:GetData("Player")
		if player ~= nil then
			self:Dbg(("Player touched with %s"):format(tostring(player)))
			local playerEvent = self:GetConfiguration("PlayerTouchedBindableEvent")
			playerEvent:Fire(player)
		end
	end
end

function Area:TouchEndedConnect()
	return function(otherPart)
		local comp = self:GetComponentData({
			Inst = otherPart,
		})
		if not comp then
			return
		end

		local humanoid = comp:GetData("Humanoid")
		if not humanoid then
			return
		end

		local rootPart = humanoid.RootPart
		if (not rootPart) or otherPart ~= rootPart then
			return
		end

		local player = comp:GetData("Player")
		if player ~= nil then
			self:Dbg("Player touch ended")
			local playerEvent = self:GetConfiguration("PlayerTouchEndedBindableEvent")
			playerEvent:Fire(player)
		end
	end
end

return Area
