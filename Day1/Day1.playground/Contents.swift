import Foundation
// #Day1
// https://adventofcode.com/2023/day/1

func sumCalibrationValues(lines: [String]) -> Int {
    var sum = 0
    for line in lines {
        let digits = line.compactMap { Int(String($0)) }
        if let firstDigit = digits.first, let lastDigit = digits.last {
            let twoDigitNumber = firstDigit * 10 + lastDigit
            sum += twoDigitNumber
        }
    }
    return sum
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
