local okserde = require("../types")

local Vector3_schema = require("./Vector3")

const function PathWaypoint_schema(pos_enc: okserde.NumberEncoding?): okserde.Schema<PathWaypoint>
	local pos = Vector3_schema(pos_enc)
	local pos_write, pos_read, pos_size = pos.write, pos.read, pos.size(Vector3.zero)

	const static_size = pos_size + 1

	return {
		write = @native function(b: buffer, offset: number, waypoint: PathWaypoint): number
			buffer.writeu8(b, offset, waypoint.Action.Value)
			pos_write(b, offset + 1, waypoint.Position)
			return static_size
		end,
		read = @native function(b: buffer, offset: number): (number, PathWaypoint)
			const action = Enum.PathWaypointAction:FromValue(buffer.readu8(b, offset))
				or Enum.PathWaypointAction.Walk
			const _, pos = pos_read(b, offset + 1)

			return static_size, PathWaypoint.new(pos, action)
		end,
		validate = @native function(value: unknown): (boolean, string?)
			if typeof(value) ~= "PathWaypoint" then
				return false, `expected value of type PathWaypoint, got {typeof(value)}`
			end

			return true, nil
		end,

		static_size = static_size,
	}
end

return PathWaypoint_schema
