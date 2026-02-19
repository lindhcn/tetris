//
//  Blocks.swift
//  tetris
//
//  Created by linda han on 2026-02-15.
//

import SwiftUI

enum BlockType {
    case I
    case J
    case O
    case L
    case S
    case empty
    
    var color: Color {
        switch self {
        case .I: return .cyan
        case .J: return .blue
        case .O: return .yellow
        case .L: return .orange
        case .S: return .pink
        case .empty: return .clear
        }
    }
}

struct Position {
    var row: Int
    var col: Int
}

struct Tetromino {
    let type: BlockType
    var positions: [Position]
    var rotation: Int
    
    static func createI(at position: Position, at rot: Int) -> Tetromino {
        var block = Tetromino(
            type: .I,
            positions: [
                Position(row: position.row, col: position.col),
                Position(row: position.row, col: position.col + 1),
                Position(row: position.row, col: position.col + 2),
                Position(row: position.row, col: position.col + 3)
            ],
            rotation: rot
        )
        for _ in 0..<rot {
            block.rotate()
        }
        return block
    }
    static func createS(at position: Position, at rot: Int) -> Tetromino {
        var block = Tetromino(
            type: .S,
            positions: [
                Position(row: position.row, col: position.col - 1),
                Position(row: position.row, col: position.col),
                Position(row: position.row - 1, col: position.col),
                Position(row: position.row - 1, col: position.col + 1)
            ],
            rotation: rot
        )
        for _ in 0..<rot {
            block.rotate()
        }
        return block
    }

    
    static func createJ(at position: Position, at rot: Int) -> Tetromino {
        var block = Tetromino(
            type: .J,
            positions: [
                Position(row: position.row, col: position.col),
                Position(row: position.row, col: position.col + 1),
                Position(row: position.row, col: position.col + 2),
                Position(row: position.row - 1, col: position.col)
            ],
            rotation: rot
        )
        for _ in 0..<rot {
            block.rotate()
        }
        return block
    }
    static func createO(at position: Position, at rot: Int) -> Tetromino {
        var block = Tetromino(
            type: .O,
            positions: [
                Position(row: position.row, col: position.col),
                Position(row: position.row, col: position.col + 1),
                Position(row: position.row + 1, col: position.col + 1),
                Position(row: position.row + 1, col: position.col)
            ],
            rotation: rot
        )
        for _ in 0..<rot {
            block.rotate()
        }
        return block
    }
    static func createL(at position: Position, at rot: Int) -> Tetromino {
        var block = Tetromino(
            type: .L,
            positions: [
                Position(row: position.row, col: position.col),
                Position(row: position.row, col: position.col + 1),
                Position(row: position.row, col: position.col + 2),
                Position(row: position.row - 1, col: position.col + 2)
            ],
            rotation: rot
        )
        for _ in 0..<rot {
            block.rotate()
        }
        return block
    }

    mutating func moveDown() {
        positions = positions.map { Position(row: $0.row + 1, col: $0.col) }
    }
    
    mutating func rotate() {
        if type == .I {
            let pivot = positions[1]
            if rotation % 2 == 0 { // horizontal to vertical
                positions = [
                    Position(row: pivot.row - 1, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row + 1, col: pivot.col),
                    Position(row: pivot.row + 2, col: pivot.col)
                ]
            } else { // vertical to horizontal
                positions = [
                    Position(row: pivot.row, col: pivot.col - 1),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col + 1),
                    Position(row: pivot.row, col: pivot.col + 2)
                ]
            }
            rotation = (rotation + 1) % 4
        }
        else if type == .S { // need four rotations for s and z block Look Closely.
            let pivot = positions[1]
            
            if rotation % 2 == 0 {  // horizontal S
                positions = [
                    Position(row: pivot.row, col: pivot.col + 1),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row + 1, col: pivot.col),
                    Position(row: pivot.row + 1, col: pivot.col - 1)
                ]
            } else {  // vertical S
                positions = [
                    Position(row: pivot.row - 1, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col + 1),
                    Position(row: pivot.row + 1, col: pivot.col + 1)
                ]
            }
            
            rotation = (rotation + 1) % 4
        }

        else if type == .J {
            let pivot = positions[1]
            if rotation == 0 {
                positions = [
                    Position(row: pivot.row - 1, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row + 1, col: pivot.col),
                    Position(row: pivot.row - 1, col: pivot.col + 1)
                ]
                rotation = 1
            } else if rotation == 1 {
                positions = [
                    Position(row: pivot.row, col: pivot.col - 1),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col + 1),
                    Position(row: pivot.row + 1, col: pivot.col + 1)
                ]
                rotation = 2
            } else if rotation == 2 {
                positions = [
                    Position(row: pivot.row - 1, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row + 1, col: pivot.col),
                    Position(row: pivot.row + 1, col: pivot.col - 1)
                ]
                rotation = 3
            } else {
                positions = [
                    Position(row: pivot.row + 1, col: pivot.col - 1),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col - 1),
                    Position(row: pivot.row, col: pivot.col + 1)
                ]
                rotation = 0
            }
        }
        else if type == .L {
            let pivot = positions[1]
            if rotation == 0 {
                positions = [
                    Position(row: pivot.row - 1, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row + 1, col: pivot.col),
                    Position(row: pivot.row + 1, col: pivot.col + 1)
                ]
                rotation = 1
            } else if rotation == 1 {
                positions = [
                    Position(row: pivot.row, col: pivot.col - 1),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col + 1),
                    Position(row: pivot.row + 1, col: pivot.col - 1)
                ]
                rotation = 2
            } else if rotation == 2 {
                positions = [
                    Position(row: pivot.row - 1, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row + 1, col: pivot.col),
                    Position(row: pivot.row - 1, col: pivot.col - 1)
                ]
                rotation = 3
            } else {
                positions = [
                    Position(row: pivot.row, col: pivot.col - 1),
                    Position(row: pivot.row, col: pivot.col),
                    Position(row: pivot.row, col: pivot.col + 1),
                    Position(row: pivot.row - 1, col: pivot.col - 1),
                ]
                rotation = 0
            }
        }
    }
}
