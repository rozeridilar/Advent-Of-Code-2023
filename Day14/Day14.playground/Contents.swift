import Foundation

// #Day14
// https://adventofcode.com/2023/day/14
// 2D Array

final class Day14 {
    private var grid: [[Character]]
    private var byGrid: [String: Int] = [:]

    init(input: String) {
        let lines = input.components(separatedBy: "\n")
        self.grid = lines.map { Array($0) }
    }

    func rotate() {
        let R = grid.count
        let C = grid[0].count
        var newGrid = Array(repeating: Array(repeating: Character("?"), count: R), count: C)
        for r in 0..<R {
            for c in 0..<C {
                newGrid[c][R - 1 - r] = grid[r][c]
            }
        }
        grid = newGrid
    }

    func roll() {
        let R = grid.count
        let C = grid[0].count
        for c in 0..<C {
            for _ in 0..<R {
                for r in 1..<R {
                    if grid[r][c] == "O" && grid[r - 1][c] == "." {
                        grid[r][c] = "."
                        grid[r - 1][c] = "O"
                        break
                    }
                }
            }
        }
    }

    func score() -> Int {
        var ans = 0
        let R = grid.count
        for r in 0..<R {
            for c in grid[r] {
                if c == "O" {
                    ans += R - r
                }
            }
        }
        return ans
    }

    func process() -> Int {
        let target = Int(1e9)
        var t = 0
        while t < target {
            t += 1
            for _ in 0..<4 {
                roll()
                if t == 1 {
                    print(score()) // part1
                }
                rotate()
            }
            let gridHash = grid.map { String($0) }.joined(separator: ",")
            if let cycleStart = byGrid[gridHash] {
                let cycleLength = t - cycleStart
                let amt = (target - t) / cycleLength
                t += amt * cycleLength
            }
            byGrid[gridHash] = t
        }
        return score()
    }
}

// MARK: - File Reading Utility
func readFileContent(filename: String) -> String? {
    guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") else { return nil }
    return try? String(contentsOf: fileURL, encoding: .utf8)
}

// MARK: - Main Execution
let filename = "Input"
if let fileContent = readFileContent(filename: filename) {
    let challenge = Day14(input: fileContent)
    let result = challenge.process()
    print("Final score (Day 14):", result)
} else {
    fatalError("Could not read the file.")
}
