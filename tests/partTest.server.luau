local ServerStorage = game:GetService "ServerStorage"

local Serializer = require(ServerStorage.Serializer)
local Schemas = Serializer.Schemas

local PartSerde = Schemas.struct {
	CFrame = Schemas.CFrame("f32", "r16"),
	Size = Schemas.Vector3 "f32",
	Color = Schemas.Color3,
}

local PartsSerde = Schemas.array(PartSerde, "u8")

local encoded = workspace:FindFirstChild "Encoded" or Instance.new "Configuration"
encoded.Name = "Encoded"
encoded.Parent = workspace

if not encoded:GetAttribute "Parts" then
	local parts = {}

	for _, part: BasePart in workspace.Parts:GetChildren() do
		table.insert(parts, {
			CFrame = part.CFrame,
			Size = part.Size,
			Color = part.Color,
		})
	end

	local serialized = PartsSerde:Serialize(parts)

	encoded:SetAttribute("Parts", serialized)
else
	local parts = PartsSerde:Deserialize(encoded:GetAttribute "Parts")

	for _, data in parts do
		local newPart = Instance.new "Part"
		newPart.CFrame = data.CFrame
		newPart.Size = data.Size
		newPart.Color = data.Color
		newPart.Anchored = true
		newPart.Parent = workspace.Parts
	end
end
