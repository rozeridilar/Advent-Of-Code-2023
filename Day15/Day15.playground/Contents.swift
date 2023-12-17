import Foundation

// #Day15
// https://adventofcode.com/2023/day/15
// Sum Array

import Foundation

func readFileContent(filename: String) -> String? {
    guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") else { return nil }
    return try? String(contentsOf: fileURL, encoding: .utf8)
}

let filename = "Input"

var grid = [Int]()
if let fileContent = readFileContent(filename: filename) {
    let components = fileContent.description.replacingOccurrences(of: "\n", with: "").components(separatedBy: ",")
    print(components)
    for component in components {
        let intValue = hashAlgorithm(component)
        grid.append(intValue)
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

let result = grid.reduce(0, +)
print(result)
print(grid)

