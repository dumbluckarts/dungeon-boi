var RATES = {
	CHEST: 5,
	ENEMY: 3
}

function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}

function LevelSet(name, variations) {

	var layouts = {}

	// Populate layouts object
	for (var layout of variations.split(",")) {
		var arr = layout.split("=")
		var key = arr[0]
		var val = parseInt(arr[1])

		layouts[key] = val
	}

	return {
		name: name,
		layouts: layouts,
		rates: {
			chest: RATES.CHEST,
			enemy: RATES.ENEMY
		}
	}
}

var generate = (function() {
	var data = []
	var self = {}

	function get(name) {
		var result

		for (var levelSet of data) {
			if (!levelSet.name
				|| levelSet.name != name) continue;

			result = levelSet
			break;
		}
		return result
	}

	function exists(name) {
		return get(name) != undefined
	}

	function randomLevelNumber(level, genre, i = 0) {
		var max = level.layouts[genre]
		var ran = getRandomInt(max) + 1

		if (i < 4 && ran == self.last_num) return randomLevelNumber(level, genre, i + 1)
		return ran
	}

	function randomLayout(level, genre) {
		var result = level.name + " "
		var num = randomLevelNumber(level, genre)

		// remove default from the layout name generated
		if (genre == "default") {
			genre = ""
		}
		// add a space after the genre name for formatting. Also reset the gen rate for when that next
		// layout genre will appear.
		else {
			level.rates[genre] = RATES[genre.toUpperCase()]
			genre += " "
		}

		result += `${genre}${num}`

		self.last_level = level.name
		self.last_num = num
		self.last_genre = genre

		return result
	}

	// PUBLIC
	self.create = function(name, ...variations) {
		if (exists(name)) return

		var layouts = ""
		for (var layout of variations) {
			layouts += layout + ","
		}
		// remove last comma
		layouts = layouts.substring(0, layouts.length - 1)

		data.push(LevelSet(name, layouts))
	}


	self.level = function(name) {
		var level = get(name)

		for (var g of Object.keys(level.rates))
			level.rates[g] -= 1

		if (level.rates.chest < 1)
			return randomLayout(level, "chest")

		if (level.rates.enemy < 1)
			return randomLayout(level, "enemy")

		return randomLayout(level, "default")
	}

	return self;
})();
var gen = generate;

var room = (() => {
	var rooms = []
	var rates = []

	function Room(name, variations) {
		var self = {}

		self.name = name
		self.layouts = {}

		// Populate layouts object
		for (var layout of variations.split(",")) {
			var arr = layout.split("=")
			var key = arr[0]
			var val = parseInt(arr[1])

			layouts[key] = val
		}

		return self
	}

	return {

	}
})();