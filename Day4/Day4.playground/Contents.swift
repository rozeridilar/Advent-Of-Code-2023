import Foundation

// #Day4
// https://adventofcode.com/2023/day/3
// Math Sets - Easy Search Algo

private struct Card {
    let id: Int
    let matches: Int

    init?(_ string: String) {
        let parts = string.components(separatedBy: ":")
        guard let id = parts[0].extractNumber() else { return nil }

        self.id = id
        print(parts.first!)
        print(id)
        let nums = parts[1].components(separatedBy: "|")
        let winners = Set(nums[0].split(separator: " ").compactMap { Int($0) })
        let numbers = Set(nums[1].split(separator: " ").compactMap { Int($0) })
        print("nums[0]: \(nums[0])")
        print("nums[1]: \(nums[1])")
        print("winners: \(winners)")
        print("numbers: \(numbers)")
        matches = numbers.intersection(winners).count
    }

    var points: Int {
        Int(pow(2.0, Double(matches - 1)))
    }
}

final class Day04 {
    private let cards: [Card]

    init(input: String) {
        cards = input.components(separatedBy: .newlines).compactMap { Card($0) }
    }

    func part1() -> Int {
        cards.map(\.points).reduce(0, +)
    }

    func part2() -> Int {
        var copies = [Int](repeating: 1, count: cards.count + 1) // Start with 1 for each original card

        for card in cards where card.matches > 0 {
            let start = card.id + 1
            let end = min(card.id + card.matches, cards.count)

            for i in start...end {
                copies[i] += copies[card.id]
            }
        }

        return copies.reduce(0, +) - 1 // Subtract 1 for the initial 0 index which is not used
    }
}

// MARK: - Helpers

extension String {
    func extractNumber() -> Int? {
        let numbersString = self.compactMap { $0.isNumber ? $0 : nil }
        return Int(String(numbersString))
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
    let day04 = Day04(input: fileContent)
    let resultPart1 = day04.part1()
    let resultPart2 = day04.part2()
    print("Matching card numbers total point (Part 1):", resultPart1)
    print("Calculate total scratchcard (Part 2):", resultPart2)
} else {
    fatalError("Could not read the file.")
}
