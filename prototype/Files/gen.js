function Category(options) {
	return {
		name: options.name,
		rarity: options.rarity,
		overlap: options.overlap,
		priority: options.priority
	}
}

function Layout(options) {
	return {
		name: options.name,
		amount: options.amount
	}
}

function Rate(category) {
	return {
		category: category,
		value: category.rarity
	}
}

function Degen(options) {

	var self = {}

	var _interval = options.interval
	var _count = 1
	var _active = {}

	var _layouts = []
	var _rates = []

	self.setInterval = (interval) => {
		_interval = interval
	}

	self.addCategories = (...categories) => {
		for (var category of categories) {
			_rates.push(Rate(stringToObject(category)))
		}
	}
	self.addLayouts = (...layouts) => {
		for (var layout of layouts) {
			_layouts.push(stringToObject(layout))
		}
	}

	function iterateRates() {
		var results = []

		for (var rate of _rates) {
			rate.value = rate.value - 1

			if (rate.value < 1) {
				rate.value = rate.category.rarity
				results.push(rate)
			}
		}
		return results
	}

	function sortPriority(rates) {
		rates = rates.sort((a, b) => 
			a.category.priority > b.category.priority ? 1 : -1)
		return rates.reverse()
	}

	function checkOverlappable(rates) {

		if (rates.length <= 1) return rates

		if (rates[0].category.overlap) {
			rates = rates.filter(a =>
				a.category.overlap)

			// 50% chance to remove overlapping
			if (getRandomInt(2) === 1) { 
				rates.length = 1
			}
		}
		else {
			rates.length = 1
		}

		return rates
	}

	function stringifyRates(rates) {
		var str = ""

		for (var rate of rates) {
			if (rate.category.name === "default") continue
			str += rate.category.name + " "
		}
		return str.substring(0, str.length-1)
	}

	function iterateLayout() {

		_count -= 1

		// new layout
		if (_count < 1) {
			_count = _interval

			_active["layout"] = _layouts[getRandomInt(_layouts.length)]
			_active["number"] = getRandomInt(_active.layout.amount) + 1
		}
		else {
			_active["number"] = getRandomInt(_active.layout.amount) + 1
		}
		return _active.layout.name + " " + _active.number
	}


	self.next = () => {
		// generate rates
		var rates = iterateRates()
		rates = sortPriority(rates)
		rates = checkOverlappable(rates)
		rates = stringifyRates(rates)

		// generate layouts
		var layout = iterateLayout()

		return layout + " " + rates
	}

	self.print = () => {
		console.log(_interval)
		console.log(_count)
		console.log(_layouts)
		console.log(_rates)
	}

	self.test = (amount) => {
		for (var i = 0; i < amount; i++) {
			console.log(self.next())
		}
	}

	return self;
}

var degenerate = configDegenerate;

function configDegenerate(options) {
	options = stringToObject(options)
	degenerate = Degen(options)
}

function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}

function stringToObject(string) {
	var obj = {}
	
	string = string.split(",")

	for (var s of string) {
		var key = s.split("=")[0].trim()
		var val = s.split("=")[1].trim()

		if (!isNaN(val)) val = parseInt(val)

		obj[key] = val
	}
	return obj
}











function Degenerate() {
	var _data = []

	var RATES = {
		CHEST: 3,
		ENEMY: 1
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
