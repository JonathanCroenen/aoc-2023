import java.io.File
import kotlin.math.*

enum class Tile {
    EMPTY,
    GALAXY,
}

typealias Map = List<List<Tile>>

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

const val EXPANSION_FACTOR = 1_000_000L

fun main() {
    val map = readInput("input/input.txt")

    val galaxyLocations = mutableListOf<Point>()
    for (y in map.indices) {
        for (x in map[y].indices) {
            if (map[y][x] == Tile.GALAXY) {
                galaxyLocations.add(Point(x, y))
            }
        }
    }

    var total = 0L;

    galaxyLocations.forEachIndexed { index1, point1 ->
        galaxyLocations.slice(index1 + 1..<galaxyLocations.size).forEach { point2 ->
            var hammingDistance = 0L
            for (x in min(point1.x, point2.x) + 1..max(point1.x, point2.x)) {
                if (map.columnIsEmpty(x)) {
                    hammingDistance += EXPANSION_FACTOR
                } else {
                    hammingDistance++
                }
            }

            for (y in min(point1.y, point2.y) + 1..max(point1.y, point2.y)) {
                if (map.rowIsEmpty(y)) {
                    hammingDistance += EXPANSION_FACTOR
                } else {
                    hammingDistance++
                }
            }

            total += hammingDistance
        }
    }

    println(total)
}
