local types = require("../../types")

local Vector3_schema = require("./Vector3")

return function(format: types.NumberFormat?): types.Schema<PathWaypoint>
	local pos = Vector3_schema(format)
	local pos_write, pos_read, pos_size = pos.write, pos.read, pos.size(Vector3.zero)

	return {
		write = function(b: buffer, offset: number, waypoint: PathWaypoint)
			buffer.writeu8(b, offset, waypoint.Action.Value)
			pos_write(b, offset + 1, waypoint.Position)
		end,
		read = function(b: buffer, offset: number): PathWaypoint
			local action = Enum.PathWaypointAction:FromValue(buffer.readu8(b, offset))
				or Enum.PathWaypointAction.Walk
			local position = pos_read(b, offset + 1)

			return PathWaypoint.new(position, action)
		end,
		size = function(waypoint: PathWaypoint): number
			return pos_size + 1
		end,
		validate = function(value: unknown): boolean
			return typeof(value) == "PathWaypoint"
		end,
	}
end
