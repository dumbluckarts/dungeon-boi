var Level = (function() {
    var levels = [
        "Level 1",
        "Level 2",
        "Level 3",
        "Level 4",
        "Level 5",
        "Level 6"
    ]

    var last = levels[0]

    var pick = function() {
        // pick a random level
        var random = Math.floor(Math.random() * levels.length)
        var level = levels[random]

        // remove the possibility of getting the same level twice
        if (level == last) return pick()

        return last = level
    }

    return {
        levels,
        last,
        pick
    }
})();