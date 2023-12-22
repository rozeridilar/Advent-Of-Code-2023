import Foundation

// #Day22
// https://adventofcode.com/2023/day/22
// 3D Array

import Foundation

func readFileContent(filename: String) -> String? {
    guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") else { return nil }
    return try? String(contentsOf: fileURL, encoding: .utf8)
}

// MARK: - Main Execution
let filename = "Input"
guard let dataInput = readFileContent(filename: filename) else { fatalError() }

let inputLines = dataInput.split(separator: "\n")

var brickStructures: [[(Int, Int, Int)]] = []

for line in inputLines {
    let parts = line.split(separator: "~").map { String($0) }
    let startCoordinates = parts[0].split(separator: ",").map { Int($0)! }
    let endCoordinates = parts[1].split(separator: ",").map { Int($0)! }

    var brick: [(Int, Int, Int)] = []
    if startCoordinates[0] == endCoordinates[0] && startCoordinates[1] == endCoordinates[1] {
        for z in startCoordinates[2]...endCoordinates[2] {
            brick.append((startCoordinates[0], startCoordinates[1], z))
        }
    } else if startCoordinates[0] == endCoordinates[0] && startCoordinates[2] == endCoordinates[2] {
        for y in startCoordinates[1]...endCoordinates[1] {
            brick.append((startCoordinates[0], y, startCoordinates[2]))
        }
    } else if startCoordinates[1] == endCoordinates[1] && startCoordinates[2] == endCoordinates[2] {
        for x in startCoordinates[0]...endCoordinates[0] {
            brick.append((x, startCoordinates[1], startCoordinates[2]))
        }
    } else {
        fatalError("Invalid brick configuration")
    }
    brickStructures.append(brick)
}

var seenBricks = Set<Brick>()
for brick in brickStructures {
    for position in brick {
        seenBricks.insert(Brick(x: position.0, y: position.1, z: position.2))
    }
}

print(brickStructures)
seenBricks.forEach { brick in
    print("Brick at (x: \(brick.x), y: \(brick.y), z: \(brick.z))")
}


struct Brick: Hashable {
    var x: Int
    var y: Int
    var z: Int
}
