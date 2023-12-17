import Foundation

// #Day15
// https://adventofcode.com/2023/day/15
// 2D Array

import Foundation

func readFileContent(filename: String) -> String? {
    guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") else { return nil }
    return try? String(contentsOf: fileURL, encoding: .utf8)
}

// MARK: - Main Execution
let filename = "Input"
guard let dataInput = readFileContent(filename: filename) else { fatalError() }

let lines = dataInput.split(separator: "\n")
let grid = lines.map { Array($0) }

let rowCount = grid.count
let colCount = grid[0].count

let rowDelta = [-1, 0, 1, 0]
let colDelta = [0, 1, 0, -1]

func step(row: Int, col: Int, direction: Int) -> (Int, Int, Int) {
    return (row + rowDelta[direction], col + colDelta[direction], direction)
}

func score(startRow: Int, startCol: Int, startDirection: Int) -> Int {
    var positions = [(startRow, startCol, startDirection)]
    var seen = Set<Position>()
    var seen2 = Set<PositionDirection>()
    while !positions.isEmpty {
        var nextPositions = [(Int, Int, Int)]()
        for (row, col, direction) in positions {
            if (0..<rowCount).contains(row) && (0..<colCount).contains(col) {
                seen.insert(Position(row: row, col: col))
                if seen2.contains(PositionDirection(row: row, col: col, direction: direction)) {
                    continue
                }
                seen2.insert(PositionDirection(row: row, col: col, direction: direction))
                let ch = grid[row][col]
                switch ch {
                case ".":
                    nextPositions.append(step(row: row, col: col, direction: direction))
                case "/":
                    let newDirection = [0: 1, 1: 0, 2: 3, 3: 2][direction]!
                    nextPositions.append(step(row: row, col: col, direction: newDirection))
                case "\\":
                    let newDirection = [0: 3, 1: 2, 2: 1, 3: 0][direction]!
                    nextPositions.append(step(row: row, col: col, direction: newDirection))
                case "|":
                    if direction == 0 || direction == 2 {
                        nextPositions.append(step(row: row, col: col, direction: direction))
                    } else {
                        nextPositions.append(step(row: row, col: col, direction: 0))
                        nextPositions.append(step(row: row, col: col, direction: 2))
                    }
                case "-":
                    if direction == 1 || direction == 3 {
                        nextPositions.append(step(row: row, col: col, direction: direction))
                    } else {
                        nextPositions.append(step(row: row, col: col, direction: 1))
                        nextPositions.append(step(row: row, col: col, direction: 3))
                    }
                default:
                    fatalError("Unexpected character encountered")
                }
            }
        }
        positions = nextPositions
    }
    return seen.count
}

var answer = 0
for row in 0..<rowCount {
    answer = max(answer, score(startRow: row, startCol: 0, startDirection: 1))
    answer = max(answer, score(startRow: row, startCol: colCount - 1, startDirection: 3))
}
for col in 0..<colCount {
    answer = max(answer, score(startRow: 0, startCol: col, startDirection: 2))
    answer = max(answer, score(startRow: rowCount - 1, startCol: col, startDirection: 0))
}
print(answer)

struct Position: Hashable {
    let row: Int
    let col: Int
}

struct PositionDirection: Hashable {
    let row: Int
    let col: Int
    let direction: Int
}

