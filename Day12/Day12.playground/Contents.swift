import Foundation

// #Day12
// https://adventofcode.com/2023/day/12
// Array Manipulation

final class Day12 {
    private let springRows: [String]

    init(input: String) {
        self.springRows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
    }

    func part1() -> Int {
        let springEntries = springRows.map(SpringRow.init)
        return springEntries.reduce(0) { $0 + $1.countValidArrangements() }
    }
}

// MARK: - Models
struct SpringRow {
    let springStates: String
    let damagedGroupSizes: [Int]

    init(from input: String) {
        let components = input.components(separatedBy: CharacterSet(arrayLiteral: " ", ","))
        self.springStates = components[0]
        self.damagedGroupSizes = components[1...].compactMap(Int.init)
    }

    func countValidArrangements() -> Int {
        return countArrangementsRecursively(for: Array(springStates), usingGroupSizes: damagedGroupSizes, startingAt: 0)
    }

    private func countArrangementsRecursively(for springArray: [Character], usingGroupSizes groupSizes: [Int], startingAt index: Int) -> Int {
        guard let currentGroupSize = groupSizes.first else {
            return isArrangementValid(springArray: springArray) ? 1 : 0
        }

        var arrangementCount = 0
        var currentIndex = index

        while currentIndex <= springArray.count - currentGroupSize {
            if canPlaceDamagedGroup(in: springArray, startingAt: currentIndex, withSize: currentGroupSize) {
                var modifiedArray = springArray
                for i in currentIndex..<currentIndex + currentGroupSize {
                    modifiedArray[i] = "#"
                }

                arrangementCount += countArrangementsRecursively(for: modifiedArray, usingGroupSizes: Array(groupSizes.dropFirst()), startingAt: currentIndex + currentGroupSize)
            }
            currentIndex += 1
        }

        return arrangementCount
    }

    private func isArrangementValid(springArray: [Character]) -> Bool {
        let actualDamagedGroups = springArray.split(whereSeparator: { $0 != "#" }).map { $0.count }
        return actualDamagedGroups == damagedGroupSizes
    }

    private func canPlaceDamagedGroup(in springArray: [Character], startingAt startIndex: Int, withSize groupSize: Int) -> Bool {
        guard startIndex + groupSize <= springArray.count else {
            return false
        }

        let groupRange = startIndex..<startIndex + groupSize
        let groupIsOk = springArray[groupRange].allSatisfy { $0 == "#" || $0 == "?" }
        let previousIsOk = startIndex == 0 || springArray[startIndex - 1] != "#"
        let nextIsOk = groupRange.upperBound == springArray.count || springArray[groupRange.upperBound] != "#"

        return groupIsOk && previousIsOk && nextIsOk
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
    let challenge = Day12(input: fileContent)
    let resultPart1 = challenge.part1()
    print("Total valid arrangements (Part 1):", resultPart1)
} else {
    fatalError("Could not read the file.")
}
