local DataStoreService = game:GetService "DataStoreService"
local ServerStorage = game:GetService "ServerStorage"

local GlobalStore = DataStoreService:GetGlobalDataStore()

local Serializer = require(ServerStorage.Serializer)
local Schemas = Serializer.Schemas

local PartSerde = Schemas.struct {
	CFrame = Schemas.CFrame("f32", "r16"),
	Size = Schemas.Vector3 "f32",
	Color = Schemas.Color3,
}

local PartsSerde = Schemas.array(PartSerde, "u8")

local partBuffer = GlobalStore:GetAsync "Parts"

if partBuffer then
	local serialized = buffer.tostring(partBuffer)
	local parts

	local success, err = pcall(function()
		parts = PartsSerde:Deserialize(serialized)
	end)

	if not success then
		warn(err)
	else
		for _, data in parts do
			local newPart = Instance.new "Part"
			newPart.CFrame = data.CFrame
			newPart.Size = data.Size
			newPart.Color = data.Color
			newPart.Anchored = true
			newPart.Parent = workspace.Parts
		end
	end
end

game:BindToClose(function()
	local parts = {}

	for _, part: BasePart in workspace.Parts:GetChildren() do
		table.insert(parts, {
			CFrame = part.CFrame,
			Size = part.Size,
			Color = part.Color,
		})
	end

	local ser, b = PartsSerde:serialize(parts)

	print(#ser)

	GlobalStore:SetAsync("Parts", b)
end)
