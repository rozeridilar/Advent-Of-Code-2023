import Foundation

// #Day4
// https://adventofcode.com/2023/day/5
// Mapping & Caching Efficiency

// Solution:
// Start with the initial seed numbers.
// For each seed number, follow the conversion maps in sequence (seed-to-soil, soil-to-fertilizer, etc.) to find the final location number.
// If a seed number is within a range in the map, convert it using the map's rule. If not, it remains the same.
// Repeat this for each category until you reach the location number.
// Among all the final location numbers obtained, find the lowest one.

final class Day05 {

    private let almanac: Almanac

     init(input: String) {
         almanac = Almanac(input.components(separatedBy: .newlines))
     }

     func part1() -> Int {
         var minLocation = Int.max
         for seed in almanac.seeds {
             let location = almanac.location(for: seed)
             minLocation = min(minLocation, location)
         }
         return minLocation
     }

    func part2() -> Int {
        return 0
    }
}

// MARK: - Models

private struct Almanac {
    let seeds: [Int]

    let maps: [Map]

    init(_ lines: [String]) {
        seeds = lines[0].split(separator: " ").compactMap { Int($0) }
        let chunks = Array(lines.dropFirst(2)).grouped { $0.isEmpty }

        maps = chunks.map { Map($0) }
    }

    func location(for seed: Int) -> Int {
        var seed = seed
        for map in maps {
            if let range = map.ranges.first(where: { $0.contains(seed) }) {
                seed += range.adjustment
            }
        }
        return seed
    }
}

private struct Map {
    let ranges: [Range]

    init(_ lines: [String]) {
        self.ranges = lines.dropFirst().map { Range($0) }.sorted { $0.from < $1.from }
    }
}

private struct Range {
    let from: Int
    let to: Int
    let adjustment: Int

    init(from: Int, to: Int, adjustment: Int = 0) {
        self.from = from
        self.to = to
        self.adjustment = adjustment
    }

    init(_ string: String) {
        let ints = string.components(separatedBy: " ").compactMap{ Int($0) }
        self.init(from: ints[1], to: ints[1] + ints[2] - 1, adjustment: ints[0] - ints[1])
    }

    func contains(_ x: Int) -> Bool {
        x >= from && x <= to
    }

    var isValid: Bool { from <= to }
}


// MARK: - Helpers

extension Array {
    func grouped(by predicate: (Element) -> Bool) -> [[Element]] {
        var groups: [[Element]] = []
        var currentGroup: [Element] = []

        for element in self {
            if predicate(element) {
                if !currentGroup.isEmpty {
                    groups.append(currentGroup)
                    currentGroup = []
                }
            } else {
                currentGroup.append(element)
            }
        }

        if !currentGroup.isEmpty {
            groups.append(currentGroup)
        }

        return groups
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
    let day05 = Day05(input: fileContent)
    let resultPart1 = day05.part1()
    let resultPart2 = day05.part2()
    print("Matching card numbers total point (Part 1):", resultPart1)
    print("Calculate total scratchcard (Part 2):", resultPart2)
} else {
    fatalError("Could not read the file.")
}
