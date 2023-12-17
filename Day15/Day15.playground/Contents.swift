import Foundation

// #Day15
// https://adventofcode.com/2023/day/15
// 2D Array

import Foundation

func readFileContent(filename: String) -> String? {
    guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") else { return nil }
    return try? String(contentsOf: fileURL, encoding: .utf8)
}

let filename = "Input"

var grid = [[Int]]()
if let fileContent = readFileContent(filename: filename) {
    let components = fileContent.description.replacingOccurrences(of: "\n", with: "").components(separatedBy: ",")
    print(components)
    for component in components {
        let intValue = hashAlgorithm(component)
        grid.append( [intValue])
    }
}

func hashAlgorithm(_ string: String) -> Int {
    var currentValue = 0
    for char in string {
        if let asciiValue = char.asciiValue {
            currentValue = (currentValue + Int(asciiValue)) * 17 % 256
        }
    }
    return currentValue
}

print(grid)

let rowCount = grid.count
let colCount = grid[0].count

let rowDelta = [-1, 0, 1, 0]
let colDelta = [0, 1, 0, -1]

func solve(tiles: Int) -> Int? {
    var distances = Array(repeating: Array(repeating: Int.max, count: tiles * colCount), count: tiles * rowCount)
    var priorityQueue = [(distance: Int, row: Int, col: Int)]()
    priorityQueue.append((0, 0, 0))

    while let current = priorityQueue.popLast() {
        let (currentDistance, currentRow, currentCol) = current
        if currentRow < 0 || currentRow >= tiles * rowCount || currentCol < 0 || currentCol >= tiles * colCount {
            continue
        }

        let val = grid[currentRow % rowCount][currentCol % colCount] + currentRow / rowCount + currentCol / colCount
        let actualVal = val % 9 == 0 ? 9 : val % 9
        let newDistance = currentDistance + actualVal

        if distances[currentRow][currentCol] > newDistance {
            distances[currentRow][currentCol] = newDistance
        } else {
            continue
        }
        if currentRow == tiles * rowCount - 1 && currentCol == tiles * colCount - 1 {
            break
        }

        for d in 0..<4 {
            let newRow = currentRow + rowDelta[d]
            let newCol = currentCol + colDelta[d]
            priorityQueue.append((distances[currentRow][currentCol], newRow, newCol))
        }
    }
    return distances[tiles * rowCount - 1][tiles * colCount - 1] - grid[0][0]
}

if let result1 = solve(tiles: 1) {
    print(result1)
}

if let result5 = solve(tiles: 11) {
    print(result5)
}
