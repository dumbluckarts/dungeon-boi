function Degenerate() {
	var _data = []

	var RATES = {
		CHEST: 4,
		ENEMY: 2
	}

	var Level = (name, variations) => {
		return {
			name,
			variations,
			rates: {
				chest: RATES.CHEST,
				enemy: RATES.ENEMY
			}
		}
	}

	var _degenerate = (name, variations = -1) => {
		var self = {}

		self.getLayout = (name) => {
			for (var i of _data) {
				if (i.name == name) return i
			}
		}
		self.setLayout = (name, variations) => _data.push(Level(name, variations))

		self.randomLayout = () => {
			var i = getRandomInt(Object.keys(_data).length)
			return _data[Object.keys(_data)[i]]
		}
		self.randomNumber = (name) => {
			var level = self.getLayout(name)
			return " " + (getRandomInt(level.variations) + 1)
		}
		self.randomCategory = (name) => {
			var level = self.getLayout(name)
			var rates = level.rates

			for (var g of Object.keys(rates)) rates[g] -= 1

			level.rates = rates

			if (level.rates.chest < 1) {
				level.rates.chest = RATES.CHEST
				return " chest"
			}

			if (level.rates.enemy < 1) {
				level.rates.enemy = RATES.ENEMY
				return " enemy"
			}

			return ""
		}

		self.newLayout = (name) => {
			var layout = name

			name += self.randomNumber(name) 
				+ self.randomCategory(name)

			console.log(name)

			return name
		}

		// looking to access the object
		if (!name) return self
		// looking to generate a new level
		else if (variations === -1) return self.newLayout(name)
		// looking to access this object
		else return self.setLayout(name, variations)
	}

	return _degenerate
}

var gen = Degenerate()
var generate = gen

// UTILS
function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}