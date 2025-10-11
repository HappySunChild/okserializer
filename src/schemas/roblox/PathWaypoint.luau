local types = require "../../types"

local Schema = require "../Schema"

local Schema_Vector3 = require "./Vector3"

return function(format: types.NumberFormat?): types.Schema<PathWaypoint>
	local _pos = Schema_Vector3(format)
	local pos_write, pos_read, pos_size = _pos.write, _pos.read, _pos.size(Vector3.zero)

	return Schema "PathWaypoint" {
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
