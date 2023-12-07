import Foundation

// #Day6
// https://adventofcode.com/2023/day/7
// Distance=Speed×Time - Array Manipulation

// Rules for Ranking Hands in Camel Cards:
// Five of a kind, where all five cards have the same label: AAAAA
// Four of a kind, where four cards have the same label and one card has a different label: AA8AA
// Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
// Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
// Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
// One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
// High card, where all cards' labels are distinct: 23456

final class Day07 {
    private let hands: [Hand]

    init(input: String) {
        hands = input.components(separatedBy: .newlines).compactMap { Hand($0) }
    }

    func part1() -> Int {
        sumBids(hands.sorted(by: Hand.compareRank))
    }

    private func sumBids(_ hands: [Hand]) -> Int {
        hands
            .enumerated()
            .reduce(0) {
                $0 + ($1.offset + 1) * $1.element.bid
            }
    }
}

// MARK: - Models

private enum HandRank: Int, Comparable {
    case highCard
    case onePair
    case twoPair
    case threeOfAKind
    case fullHouse
    case fourOfAKind
    case fiveOfAKind

    static func < (lhs: HandRank, rhs: HandRank) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

private class Hand {
    let cards: [Character]
    let bid: Int

    private var _rank: HandRank?
    private var _jokerRank: HandRank?

    init?(_ string: String) {
        let parts = string.components(separatedBy: " ")
        if parts[0].map {$0}.isEmpty { return nil }
        cards = parts[0].map { $0 }
        print(cards)
        bid = Int(parts[1]) ?? 0
        print(bid)
    }

    var rank: HandRank {
        if _rank == nil {
            _rank = getRank()
        }
        return _rank!
    }

    private func getRank() -> HandRank {
        let cardCounts = Dictionary(cards.map { ($0, 1) }, uniquingKeysWith: +).values.sorted(by: >)
          switch cardCounts {
          case let counts where counts.count == 1 && counts.first == 5:
              return .fiveOfAKind
          case let counts where counts.count == 2 && counts.contains(4):
              return .fourOfAKind
          case let counts where counts.count == 2 && counts.contains(3):
              return .fullHouse
          case let counts where counts.count == 3 && counts.contains(3):
              return .threeOfAKind
          case let counts where counts.count == 3 && counts.contains(2):
              return .twoPair
          case let counts where counts.count == 4:
              return .onePair
          default:
              return .highCard
          }
    }

    private func getJokerRank() -> HandRank {
        var dict = cards.reduce(into: [:]) { $0[$1, default: 0] += 1}
        let jokers = dict.removeValue(forKey: "J") ?? 0
        let max = dict.values.max() ?? 0

        switch dict.count {
        case 0:
            // no cards left -> JJJJJ -> five
            return .fiveOfAKind
        case 1:
            // all cards are the same:
            // 11111 -> five
            // 1111J -> five
            // 1111x -> four
            // 111JJ -> five
            // 11JJJ -> five
            // 1JJJJ -> five
            if jokers == 0 {
                return max == 4 ? .fourOfAKind : .fiveOfAKind
            }
            return .fiveOfAKind
        case 2:
            // two kinds of cards:
            // 1122J -> FH
            // 11122 -> FH
            // 1112J -> 4
            // 122JJ -> 4
            // 12JJJ -> 4
            switch jokers {
            case 0:
                return dict.values.contains(4) ? .fourOfAKind : .fullHouse
            case 1:
                switch max {
                case 3: return jokers == 1 ? .fourOfAKind : .fullHouse
                case 2: return .fullHouse
                default: fatalError()
                }
            case 2, 3: return .fourOfAKind
            default: fatalError()
            }
        case 3:
            // three kinds of cards:
            // 11223 -> 2P
            // 123JJ -> 3
            // 1123J -> 3
            // 11123 -> 3
            if jokers == 0 {
                return dict.values.contains(2) ? .twoPair : .threeOfAKind
            }
            return .threeOfAKind
        case 4:
            // four kinds of cards:
            // 1234J -> 2
            // 11234 -> 2
            return .onePair
        case 5:
            return .highCard
        default:
            fatalError()
        }
    }
}

extension Hand {
    private static let map: [Character: Int] = [
        "A": 14, "K": 13, "Q": 12, "J": 11, "T": 10, "9": 9, "8": 8, "7": 7, "6": 6, "5": 5, "4": 4, "3": 3, "2": 2
    ]

    static func compareRank (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.rank != rhs.rank {
            return lhs.rank < rhs.rank
        }

        for (c1, c2) in zip(lhs.cards, rhs.cards) {
            if c1 != c2 {
                return map[c1]! < map[c2]!
            }
        }
        fatalError()
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
    let day07 = Day07(input: fileContent)
    let resultPart1 = day07.part1()
    print("Sum of total ranks (Part 1):", resultPart1)
} else {
    fatalError("Could not read the file.")
}
