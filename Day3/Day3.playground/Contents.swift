import Foundation

// #Day3
// https://adventofcode.com/2023/day/3
// Array/Matrix Manipulation

// Represents a point in a 2D grid
struct Point: Hashable {
    let x: Int
    let y: Int
}

// Represents a number found in the schematic
struct Number: Hashable {
    let value: Int
    let start: Point
    let length: Int
    let neighbors: Set<Point>

    // Initializes a Number with its value, starting point, and length
    init(value: Int, start: Point, length: Int) {
        self.value = value
        self.start = start
        self.length = length
        // Calculates neighboring points (including diagonals)
        neighbors = Set(
            (start.y - 1 ... start.y + 1).flatMap { y in
                (start.x - 1 ... start.x + length).map { x in
                    Point(x: x, y: y)
                }
            }
        )
    }
}

// Main class for processing the schematic
final class Day03 {
    var symbols: Set<Point>
    var numbers: Set<Number>

    // Initialize with the input schematic as a string
    init(input: String) {
        symbols = Set<Point>()
        numbers = Set<Number>()

        // Process each line of the input
        input.components(separatedBy: .newlines).enumerated().forEach { y, line in
            self.processLine(line, y: y, symbols: &symbols, numbers: &numbers)
        }
    }

    // Processes a single line of the schematic
    private func processLine(_ line: String, y: Int, symbols: inout Set<Point>, numbers: inout Set<Number>) {
        for (x, ch) in line.enumerated() {
            // Identify symbols
            if !(ch.isNumber || ch == ".") {
                symbols.insert(Point(x: x, y: y))
            }
        }

        // Process and store numbers
        processNumbersInLine(line, y: y, numbers: &numbers)
    }

    // Processes and stores numbers found in a line
    private func processNumbersInLine(_ line: String, y: Int, numbers: inout Set<Number>) {
        let digits = line.enumerated().filter { $1.isNumber }
        if digits.isEmpty { return }

        var value = digits[0].element.wholeNumberValue!
        var start = digits[0].offset
        var prevOffset = start
        var length = 1

        for d in digits.dropFirst() {
            if d.offset == prevOffset + 1 {
                value = value * 10 + d.element.wholeNumberValue!
                length += 1
                prevOffset = d.offset
            } else {
                numbers.insert(Number(value: value, start: Point(x: start, y: y), length: length))
                value = d.element.wholeNumberValue!
                start = d.offset
                prevOffset = start
                length = 1
            }
        }

        numbers.insert(Number(value: value, start: Point(x: start, y: y), length: length))
    }

    // Part 1: Sum of part numbers
    func part1() -> Int {
        numbers
            .filter { !$0.neighbors.intersection(symbols).isEmpty }
            .map { $0.value }
            .reduce(0, +)
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


let filename = "Input"
if let fileContent = readFileContent(filename: filename) {
    let day03 = Day03(input: fileContent)
    let resultPart1 = day03.part1()
    print("Sum of part numbers (Part 1):", resultPart1)
} else {
    fatalError("Could not read the file.")
}
