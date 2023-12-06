import Foundation

// #Day6
// https://adventofcode.com/2023/day/6
// Distance=Speed×Time - Array Manipulation

// Steps:
// 1. Understand the Boat's Movement: Distance=Button Hold Time×(Total Race Time−Button Hold Time)
// 2. Calculate Ways to Beat the Record for Each Race:
//      Time:      7  15   30
//      Distance:  9  40  200
//      Output: 4 different total ways to win, 8, and 9
// 3. Multiply the Numbers Together: 4*8*9

final class Day06 {

    private let times: [Int]
    private let distances: [Int]

     init(input: String) {
         let regex = try! NSRegularExpression(pattern: "\\d+")
         let results = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
         let numbers = results.map { Int(input[Range($0.range, in: input)!])! }
         let midPoint = numbers.count/2

         times = Array(numbers[..<midPoint])
         distances = Array(numbers[midPoint...])

         print(times)
         print(distances)
     }

     func part1() -> Int {
         var races: [Race] = []
         for i in 0..<times.count {
             races.append(Race(time: times[i], distance: distances[i]))
         }

         return races.map { $0.totalWaysToWin() }.reduce(1, *)
        }

       func part2() -> Int {
           let time = Int(times.map { String($0) }.joined())!
           let distance = Int(distances.map { String($0) }.joined())!
           let race = Race(time: time, distance: distance)
           return race.totalWaysToWin()
       }
}

// MARK: - Models

struct Race {
    var time: Int
    var distance: Int

    func totalWaysToWin() -> Int {
        var result = 0
        for t in 0...time {
            let moveTime = time - t
            let speed = t
            let possibleDistance = speed * moveTime
            if possibleDistance > distance {
                result += 1
            }
        }
        return result
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
    let day06 = Day06(input: fileContent)
    let resultPart1 = day06.part1()
    let resultPart2 = day06.part2()
    print("Times of total ways to win (Part 1):", resultPart1)
    print("One game with all the ints, total ways to win (Part 2):", resultPart2)
} else {
    fatalError("Could not read the file.")
}
