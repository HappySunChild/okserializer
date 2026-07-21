const butler = require("@butler/butler")
const butler_chrono = require("@butler/hooks/butler_chrono")
const butler_pretty = require("@butler/hooks/butler_pretty")

const configured = butler({
	hooks = {
		butler_chrono,
		butler_pretty({
			disable_color = false,
			disable_emoji = true,
			disable_unicode = false,
			hooks = { butler_chrono },
			line_width = 100,
		}),
	},
})

const test_config = require("./config")

const configured_units = {}

for _, unit_constructor in test_config.all_units do
	table.insert(configured_units, unit_constructor(configured))
end

configured.run_units(configured_units)
