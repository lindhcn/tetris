//
//  Blocks.swift
//  tetris
//
//  Created by linda han on 2026-02-15.
//

import SwiftUI

enum BlockType {
    case I
    case empty
    
    var color: Color {
        switch self {
        case .I: return .cyan
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
    
    static func createI(at position: Position) -> Tetromino {
        return Tetromino(
            type: .I,
            positions: [
                Position(row: position.row, col: position.col),
                Position(row: position.row, col: position.col + 1),
                Position(row: position.row, col: position.col + 2),
                Position(row: position.row, col: position.col + 3)
            ]
        )
    }
    
    mutating func moveDown() {
        positions = positions.map { Position(row: $0.row + 1, col: $0.col) }
    }
}
