var inventory = (function() {
	var data = {} // the inventory object
	var self = {} // self object basically means "public." Thing visible by "inventory."

	self.getItem = function(item) {
		var result; // amount of inventory item to be returned

		// loop through inventory item names
		for (var i of Object.keys(data)) {
			if (i == item) {
				result = data[i];
				break;
			}
		}
		return result;
	}

	// returns boolean true or false if item exists
	self.exists = function(item) {
		return self.getItem(item) != undefined;
	}

	// add item by amount
	self.addItem = function(item, amount) {
		if (self.exists(item)) {
			data[item] += parseInt(amount)
		}
		else {
			data[item] = parseInt(amount)
		}
	}

	// add items from a string like fireball=5,nelson=2
	self.addItems = function(str) {
		var arr = str.split(",")

		for (var i of arr) {
			var item = i.split("=")[0]
			var amount = i.split("=")[1]

			self.addItem(item, amount)
		}
	}

	// remove item by amount
	self.removeItem = function(item, amount) {
		if (self.exists(item)) {
			data[item] -= amount

			// delete item if amount under 1
			if (data[item] < 1) delete data[item]
		}
		else {
			delete data[item]
		}
	}

	// delete an item
	self.deleteItem = function(item) {
		delete data[item]
	}

	// print out inventory data in console for testing purposes.
	self.print = function() {
		console.log(data)
	}

	// this function returns the variable "self" which contains all the functions I just added to
	// said object. IE. self.print(), self.deleteItem(), self.addItem()
	return self;
})();
var inv = inventory // made an alias because im lazy