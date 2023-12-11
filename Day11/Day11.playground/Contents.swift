import Foundation

// #Day11
// https://adventofcode.com/2023/day/11
// Grid as a Graph: Pathfinding problem on a Grid
final class Day11 {
    private let input: String

    init(input: String) {
        self.input = input
    }

    func part1() -> Int {
        let image = input.components(separatedBy: .newlines).map(Array.init)
        let expanded = expandGalaxies(image)
        let galaxyPairs = galaxyLocations(in: expanded).combinations(of: 2)
        let distances = galaxyPairs.map { $0[0].distance(to: $0[1]) }

        return distances.reduce(0, +)
    }

    func part2() -> Int {
        let image = input.components(separatedBy: .newlines).map(Array.init)
        let (emptyRows, emptyColumns) = countEmptyRowsAndColumns(in: image)
        let galaxyPairs = galaxyLocations(in: image).combinations(of: 2)
        let expansionFactor = 1000000
        let distances = galaxyPairs.map { $0[0].distanceWithExpansion(from: $0[0], to: $0[1], emptyRows: emptyRows, emptyColumns: emptyColumns, expansionFactor: expansionFactor) }

        return distances.reduce(0, +)
    }

    func countEmptyRowsAndColumns(in image: [[Character]]) -> (rows: Int, columns: Int) {
        let emptyRows = image.filter { $0.allSatisfy { $0 == "." } }.count

        let columnCount = image.map { $0.count }.min() ?? 0
        let emptyColumns = (0..<columnCount).filter { col in
            image.allSatisfy { $0[col] == "." }
        }.count

        return (emptyRows, emptyColumns)
    }

    func expandGalaxies(_ image: [[Character]], rotateAndExpand: Bool = true) -> [[Character]] {
        var result: [[Character]] = image[0].map { [$0] }
        for line in image.dropFirst() {
            let isEmpty = line.allSatisfy({ $0 == "." })
            line.enumerated().forEach { (idx: Int, char: Character) in
                if isEmpty {
                    result[idx].append(contentsOf: [char, char])
                } else {
                    result[idx].append(char)
                }
            }
        }
        return rotateAndExpand ? expandGalaxies(result, rotateAndExpand: false) : result
    }

    func galaxyLocations(in image: [[Character]]) -> [Coordinate] {
        image.enumerated().reduce(into: []) { result, pair in
            let y = pair.offset
            return result.append(contentsOf: pair.element.enumerated().compactMap({
                $0.element == "#" ? Coordinate(x: $0.offset, y: y) : nil
            }))
        }
    }
}

// MARK: - Models

struct Coordinate: Hashable {
    var x: Int
    var y: Int

    static let origin: Self = .init(x: 0, y: 0)

    var up: Self { .init(x: x, y: y - 1) }
    var down: Self { .init(x: x, y: y + 1) }
    var left: Self { .init(x: x - 1, y: y) }
    var right: Self { .init(x: x + 1, y: y) }

    var adjacent: [Self] { [up, left, right, down] }

    /// Calculates the Manhattan Distance to another coordinate.
    /// gets the sum of the absolute differences of the Cartesian coordinates.
    /// It represents the total number of horizontal and vertical steps
    /// needed to move from the current coordinate to the other, assuming
    /// movement is only allowed along grid lines (not diagonally).
    ///
    /// Formula: D(P, Q) = |x2 - x1| + |y2 - y1|
    /// Where:
    /// - |x2 - x1| is the absolute difference in the x-coordinates.
    /// - |y2 - y1| is the absolute difference in the y-coordinates.
    ///
    /// - Parameter other: The coordinate to which the distance is calculated.
    /// - Returns: The Manhattan Distance to the other coordinate.
    func distance(to other: Coordinate) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }

    func distanceWithExpansion(from: Coordinate, to: Coordinate, emptyRows: Int, emptyColumns: Int, expansionFactor: Int) -> Int {
        let dx = abs(from.x - to.x)
        let dy = abs(from.y - to.y)

        // Calculate additional distance due to expanded rows and columns
        let additionalX = dx > 0 ? emptyColumns * (expansionFactor - 1) : 0
        let additionalY = dy > 0 ? emptyRows * (expansionFactor - 1) : 0

        return dx + dy + additionalX + additionalY
    }
}

// MARK: - Helpers

func readFileContent(filename: String) -> String? {
    if let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") {
        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print("Failed to read from file: \(error)")
            return nil
        }
    }
    return nil
}

extension Collection {
    func combinations(of size: Int) -> [[Element]] {
        func pick(_ count: Int, from: ArraySlice<Element>) -> [[Element]] {
            guard count > 0 else { return [] }
            guard count < from.count else { return [Array(from)] }
            if count == 1 {
                return from.map { [$0] }
            } else {
                return from.dropLast(count - 1)
                    .enumerated()
                    .flatMap { pair in
                        return pick(count - 1, from: from.dropFirst(pair.offset + 1)).map { [pair.element] + $0 }
                    }
            }
        }

        return pick(size, from: ArraySlice(self))
    }
}

let filename = "Input"
if let fileContent = readFileContent(filename: filename) {
    let day11 = Day11(input: fileContent)
    let resultPart1 = day11.part1()
    let resultPart2 = day11.part2()
    print("Shortest path between every pair of galaxies (Part 1):", resultPart1)
    print("Shortest path between every pair after expanding 1M (Part 2):", resultPart2)
} else {
    fatalError("Could not read the file.")
}
