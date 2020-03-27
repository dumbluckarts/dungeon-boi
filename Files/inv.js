var inventory = (function() {
	var data = {}
	var self = {}

	self.getItem = (item) => {
		var result;

		for (var i of Object.keys(data)) {
			if (i == item) {
				result = data[i];
				break;
			}
		}
		return result;
	}

	self.exists = (item) => {
		return self.getItem(item) != undefined;
	}

	self.addItem = (item, amount) => {
		if (self.exists(item)) {
			data[item] += parseInt(amount)
		}
		else {
			data[item] = parseInt(amount)
		}
	}

	self.addItems = (str) => {
		var arr = str.split(",")

		for (var i of arr) {
			var item = i.split("=")[0]
			var amount = i.split("=")[1]

			self.addItem(item, amount)
		}
	}

	self.removeItem = (item, amount) => {
		if (self.exists(item)) {
			data[item] -= amount

			// delete item if amount under 1
			if (data[item] < 1) delete data[item]
		}
		else {
			delete data[item]
		}
	}

	self.deleteItem = (item) => {
		delete data[item]
	}

	self.print = () => {
		console.log(data)
	}

	return self;
})();
var inv = inventory