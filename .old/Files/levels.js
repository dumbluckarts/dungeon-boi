function Picker(max, list) {
    var count = 0
    var levels = [...list]
    var last = ""
    var current = ""

    function pick() {
        if (levels.length <= 0) return "NONE"
        if (count >= max) return "NONE"

        var random = Math.floor(Math.random() * levels.length)
        var level = levels[random]

        current = level
        count += 1

        levels.splice(levels.indexOf(level), 1)

        return level
    }

    function getLast() {
        return last ? last : "NONE"
    }

    function setLast(name) {
        last = name
    }

    function setMax(int) {
        max = int
    } 

    return {
        levels,
        last,
        current,
        pick,
        getLast,
        setLast,
        setMax,
    }
}

var Leveler = Picker(6, [
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