import Foundation

// #Day8
// https://adventofcode.com/2023/day/8
// Directed Graph
//
// Problem:
// `Network of Nodes:` Each node in the network is labeled and has a pair of directions associated with it.
// For example, AAA = (BBB, CCC) means that from AAA, you can go left to BBB or right to CCC.
//
// `Left/Right Instructions:` You have a sequence of left/right instructions, like RL, which tells you how to navigate through the network.
//
// `Repeating Instructions:` If you reach the end of the instruction sequence, you repeat it from the beginning until you reach your destination, which is the node ZZZ.
//
// `Objective:` Starting from node AAA, you need to follow these instructions to reach ZZZ. The goal is to find out how many steps it takes to reach ZZZ.
//
// Solution:
//
// Representing the Network:
// The network can be represented as a map, where each key is a node label (like AAA), and the value is a left&right instance representing the left and right destinations from that node.
//
// Navigating the Network:
// You start at AAA and follow the instructions one by one. For each instruction (either 'L' for left or 'R' for right),
// you move to the corresponding node as indicated by the current node's mapping.
//
// Handling Instruction Repetition:
// If you reach the end of the instructions, start over from the beginning of the instruction sequence.
//
// Counting Steps:
// Increment a step counter each time you move to a new node.
//
// Termination Condition:
// The process continues until you reach the ZZZ node. The number of steps taken at this point is your answer.
final class Day08 {
    private let instructions: String
    private let roadMap: String

    init(input: String) {
        let lines = input.components(separatedBy: .newlines).compactMap { $0 }

        instructions = lines.first ?? ""
        roadMap = lines.dropFirst().joined(separator: "\n")
    }

    func part1() -> Int {
        let maps = getMap(ArraySlice(roadMap.components(separatedBy: .newlines).filter { !$0.isEmpty }))
       // print(maps)
        let count = instructions.count
        var index = 0
        var map = "AAA"
        var steps = 0
        while map != "ZZZ" {
            map = maps[map]!.next(instructions.map { String($0) }[index])

            steps += 1
            index = (index + 1) % count
        }
        return steps
    }

    func getMap(_ lines: ArraySlice<String>) -> [String: Map] {
        return lines.reduce(into: [:]) { result, line in
            print(line)
            let parts = line.split(separator: " = ")
            result[String(parts[0])] = Map(pair: String(parts[1]))
        }
    }
}

// MARK: - Models

struct Map {
    let left: String
    let right: String

    func next(_ instruction: String) -> String {
        if instruction == "L" {
            return left
        } else {
            assert(instruction == "R")
            return right
        }
    }
}
extension Map {
    init(pair: String) {
        let values = pair.split(separator: ", ")
        let left = String(values[0].dropFirst())
        let right = String(values[1].dropLast())
        self.init(left: left, right: right)
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
    let day08 = Day08(input: fileContent)
    let resultPart1 = day08.part1()
    print("Total step (Part 1):", resultPart1)
} else {
    fatalError("Could not read the file.")
}
