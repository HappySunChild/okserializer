local types = require("../../types")

local Vector3_schema = require("./Vector3")

const function PathWaypoint_schema(format: types.NumberTypeSpec?): types.Schema<PathWaypoint>
	local pos = Vector3_schema(format)
	local pos_write, pos_read, pos_size = pos.write, pos.read, pos.alloc_size(Vector3.zero)

	const schema_size = pos_size + 1

	return {
		write = @native function(b: buffer, offset: number, waypoint: PathWaypoint): number
			buffer.writeu8(b, offset, waypoint.Action.Value)
			pos_write(b, offset + 1, waypoint.Position)
			return schema_size
		end,
		read = @native function(b: buffer, offset: number): (number, PathWaypoint)
			const action = Enum.PathWaypointAction:FromValue(buffer.readu8(b, offset))
				or Enum.PathWaypointAction.Walk
			const _, pos = pos_read(b, offset + 1)

			return schema_size, PathWaypoint.new(pos, action)
		end,
		alloc_size = @native function(waypoint: PathWaypoint): number
			return schema_size
		end,
		validate = function(value: unknown): (boolean, string?)
			if typeof(value) ~= "PathWaypoint" then
				return false, `expected value of type PathWaypoint, got {typeof(value)}`
			end

			return true, nil
		end,
	}
end

return PathWaypoint_schema
