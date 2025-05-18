local ServerStorage = game:GetService "ServerStorage"

local Serializer = require(ServerStorage.Serializer)
local Schemas = Serializer.Schemas

local unionSerde = Schemas.union(Schemas.Color3, Schemas.BrickColor, Schemas.null)

local serializedA = unionSerde:Serialize(BrickColor.new "Hot pink")
local serializedB = unionSerde:Serialize(Color3.new(1, 0, 1))
local serializedC = unionSerde:Serialize(nil)

print(serializedA, serializedB, serializedC)
print(#serializedA, #serializedB, #serializedC)
