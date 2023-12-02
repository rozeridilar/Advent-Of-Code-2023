import Foundation
// #Day2
// https://adventofcode.com/2023/day/2


func sumOfPossibleGameIDs(lines: [String]) -> Int {
    let maxRed = 12, maxGreen = 13, maxBlue = 14
    var sumOfIDs = 0

    for line in lines where !line.isEmpty {
        let parts = line.components(separatedBy: ": ")
        guard parts.count == 2, let gameID = Int(parts[0].filter { "0"..."9" ~= $0 }) else {
            continue
        }

        let draws = parts[1].components(separatedBy: "; ")
        var isPossible = true

        for draw in draws {
            let counts = draw.components(separatedBy: ", ").reduce(into: [String: Int]()) { acc, colorCount in
                let details = colorCount.components(separatedBy: " ")
                if let count = Int(details[0]) {
                    let color = details[1]
                    acc[color, default: 0] += count
                }
            }

            if (counts["red", default: 0] > maxRed) || (counts["green", default: 0] > maxGreen) || (counts["blue", default: 0] > maxBlue) {
                isPossible = false
                break
            }
        }

        if isPossible {
            sumOfIDs += gameID
        }
    }

    return sumOfIDs
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
    let result = sumOfPossibleGameIDs(lines: lines)
    print("Sum of possible game IDs:", result)
} else {
    fatalError("Could not read the file.")
}
