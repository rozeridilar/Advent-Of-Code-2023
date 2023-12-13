import Foundation

// #Day13
// https://adventofcode.com/2023/day/13
// 2D Array

final class Day13 {
    private let patterns: [Pattern]

     init(input: String) {
         let patternStrings = input.components(separatedBy: "\n\n")

         patterns = patternStrings.map { patternString in
             let lines = patternString.components(separatedBy: .newlines)
             let grid = lines.map { Array($0) }
             print("----")
             print(grid)
             print("----")
             return Pattern(grid: grid)
         }
     }

    func processPatterns(patterns: [Pattern]) -> Int {
        return patterns.map { $0.summarize() }.reduce(0, +)
    }

    func part1() -> Int {
        return processPatterns(patterns: patterns)
    }

    func part2() -> Int {
        return 0
    }
}

// MARK: - Models
struct Pattern {
    var grid: [[Character]]

    func findVerticalReflectionLine() -> Int? {
        // Iterate over columns to find a potential vertical reflection line
        return 0
    }

    func findHorizontalReflectionLine() -> Int? {
        // Iterate over rows to find a potential horizontal reflection line
        return 0
    }

    func summarize() -> Int {
        // Calculate summary number based on reflection lines
        return 0
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
    let challenge = Day13(input: fileContent)
    let resultPart1 = challenge.part1()
    let resultPart2 = challenge.part2()
    print("Total vertical and horizontal reflection check (Part 1):", resultPart1)
    print("(Part 2):", resultPart2)
} else {
    fatalError("Could not read the file.")
}
