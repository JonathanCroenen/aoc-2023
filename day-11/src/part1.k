import java.io.File

enum class Tile {
    EMPTY,
    GALAXY,
}

typealias Map = MutableList<MutableList<Tile>>

fun Map.addRow(y: Int) {
    this.add(y, MutableList(this[0].size) { Tile.EMPTY })
}

fun Map.addColumn(x: Int) {
    for (y in this.indices) {
        this[y].add(x, Tile.EMPTY)
    }
}


fun Map.rowIsEmpty(y: Int): Boolean {
    for (x in this[y]) {
        if (x != Tile.EMPTY) {
            return false
        }
    }

    return true
}

fun Map.columnIsEmpty(x: Int): Boolean {
    for (y in this) {
        if (y[x] != Tile.EMPTY) {
            return false
        }
    }

    return true
}

fun Map.stringify(): String {
    var string = ""
    for (y in this.indices) {
        for (x in this[y].indices) {
            string += when (this[y][x]) {
                Tile.EMPTY -> "."
                Tile.GALAXY -> "#"
            }
        }
        string += "\n"
    }

    return string
}

fun Map.duplicateEmptyLines() {
    val rowIndices = mutableListOf<Int>()
    for (y in this.indices) {
        if (this.rowIsEmpty(y)) {
            rowIndices.add(y)
        }
    }

    val columnIndices = mutableListOf<Int>()
    for (x in this[0].indices) {
        if (this.columnIsEmpty(x)) {
            columnIndices.add(x)
        }
    }

    for (y in rowIndices.reversed()) {
        this.addRow(y)
    }

    for (x in columnIndices.reversed()) {
        this.addColumn(x)
    }
}


fun readInput(path: String): Map {
    val input = File(path).readText()
    val lines = input.split("\n")
    val map = mutableListOf<MutableList<Tile>>()

    for (line in lines) {
        if (line.isEmpty()) {
            continue
        }

        val row = mutableListOf<Tile>()
        for (char in line) {
            when (char) {
                '.' -> row.add(Tile.EMPTY)
                '#' -> row.add(Tile.GALAXY)
            }
        }
        map.add(row)
    }

    return map
}

data class Point(val x: Int, val y: Int)

fun solve(map: Map): Int {
    val galaxyLocations = mutableListOf<Point>()
    for (y in map.indices) {
        for (x in map[y].indices) {
            if (map[y][x] == Tile.GALAXY) {
                galaxyLocations.add(Point(x, y))
            }
        }
    }

    var total = 0;

    galaxyLocations.forEachIndexed { index1, point1 ->
        galaxyLocations.slice(index1 + 1..<galaxyLocations.size).forEach { point2 ->
            val hammingDistance = Math.abs(point1.x - point2.x) + Math.abs(point1.y - point2.y)
            total += hammingDistance
        }
    }

    return total
}

fun main() {
    val map = readInput("input/input.txt")
    map.duplicateEmptyLines()

    println(solve(map))
}

