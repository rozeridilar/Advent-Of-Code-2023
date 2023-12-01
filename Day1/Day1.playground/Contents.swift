import Foundation
// #Day1 Part1&2
// https://adventofcode.com/2023/day/1

func sumCalibrationValues(lines: [String]) -> Int {
    var totalSum = 0
    for line in lines {
        totalSum += calculateLineValue(line: line)
    }
    return totalSum
}

func calculateLineValue(line: String) -> Int {
    let firstDigit = findFirstDigit(in: line)
    let lastDigit = findLastDigit(in: line)
    return firstDigit * 10 + lastDigit
}

private let digitPatterns = [
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
    "1", "2", "3", "4", "5", "6", "7", "8", "9"
]

private func findFirstDigit(in line: String) -> Int {
    var earliestIndex = Int.max
    var digitValue = 0
    for (index, pattern) in digitPatterns.enumerated() {
        if let foundIndex = line.firstOccurrenceIndex(of: pattern), foundIndex < earliestIndex {
            earliestIndex = foundIndex
            digitValue = index + 1
            if foundIndex == 0 { break }
        }
    }
    return digitValue > 9 ? digitValue - 9 : digitValue
}

private func findLastDigit(in line: String) -> Int {
    var latestIndex = Int.min
    var digitValue = 0
    for (index, pattern) in digitPatterns.enumerated() {
        if let foundIndex = line.lastOccurrenceIndex(of: pattern), foundIndex > latestIndex {
            latestIndex = foundIndex
            digitValue = index + 1
            if foundIndex == line.count - pattern.count { break }
        }
    }
    return digitValue > 9 ? digitValue - 9 : digitValue
}

extension String {
    func firstOccurrenceIndex(of substring: String) -> Int? {
        guard let range = self.range(of: substring) else { return nil }
        return self.distance(from: self.startIndex, to: range.lowerBound)
    }

    func lastOccurrenceIndex(of substring: String) -> Int? {
        guard let range = self.range(of: substring, options: .backwards) else { return nil }
        return self.distance(from: self.startIndex, to: range.lowerBound)
    }
}

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
    let lines = fileContent.components(separatedBy: .newlines)
    let result = sumCalibrationValues(lines: lines)
    print("Sum of calibration values:", result)
} else {
    fatalError("Could not read the file.")
}
