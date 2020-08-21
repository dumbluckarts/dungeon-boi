function Picker(list) {
    var levels = [...list]
    var last = ""
    var current = ""

    function pick() {
        if (levels.length <= 0) return "NONE"

        var random = Math.floor(Math.random() * levels.length)
        var level = levels[random]

        current = level

        levels.splice(levels.indexOf(level), 1)

        return level
    }

    function getLast() {
        console.log(last)
        return last ? last : "NONE"
    }

    function setLast(name) {
        last = name
    }

    return {
        levels,
        last,
        current,
        pick,
        getLast,
        setLast,
        print,
    }
}

var Leveler = Picker([
    'Level 1',
    'Level 2',
    'Level 3',
    'Level 4',
    'Level 5',
    'Level 6',
    'Level 7',
    'Level 8',
    'Level 9',
])