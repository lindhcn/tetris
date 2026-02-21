//
//  TetrisGame.swift
//  tetris
//
//  Created by linda han on 2026-02-16.
//

import SwiftUI

class TetrisGame: ObservableObject {
    static let rows = 20
    static let cols = 10
    
    @Published var board: [[BlockType]]
    @Published var currentBlock: Tetromino?
    @Published var isGameActive = false
    
    private var TetrisTimer: Timer?

    
    init() {
        board = Array(repeating: Array(repeating: BlockType.empty, count: TetrisGame.cols),
                     count: TetrisGame.rows)
    }

    func startGame() {
        resetBoard()
        spawnBlock()
        isGameActive = true
        startTimer()

    }

    func resetBoard() {
        board = Array(repeating: Array(repeating: BlockType.empty, count: TetrisGame.cols),
                      count: TetrisGame.rows)
    }
    
    func spawnBlock() {

        let blockTypes = ["I", "J", "O", "L", "S", "Z", "T"]
        let rotations = [0, 1, 2, 3]
        let chosenBlock = blockTypes.randomElement()!
        let chosenRot = rotations.randomElement()!
        
        if chosenBlock == "I" {
            currentBlock = Tetromino.createI(at: Position(row: 0, col: 3), at: chosenRot)
        } else if chosenBlock == "J" {
            currentBlock = Tetromino.createJ(at: Position(row: 0, col: 3), at: chosenRot)
        } else if chosenBlock == "O" {
            currentBlock = Tetromino.createO(at: Position(row: 0, col: 3), at: chosenRot)
        } else if chosenBlock == "S" {
            currentBlock = Tetromino.createS(at: Position(row: 0, col: 4), at: 0)
        } else if chosenBlock == "T" {
            currentBlock = Tetromino.createT(at: Position(row: 0, col: 4), at: 0)
         } else if chosenBlock == "Z" {
             currentBlock = Tetromino.createZ(at: Position(row: 0, col: 4), at: 0)
         } else {
            currentBlock = Tetromino.createL(at: Position(row: 0, col: 3), at: chosenRot)
        }
    }
    
    func canMoveDown(_ block: Tetromino) -> Bool {
        for position in block.positions {
            let newRow = position.row + 1
            if (newRow >= TetrisGame.rows) {
                return false
            }
            if board[newRow][position.col] != .empty {
                return false
            }
        }
        return true
    }

    func canMoveRight(_ block: Tetromino) -> Bool {
        for position in block.positions {
            let newCol = position.col + 1
            if (newCol >= TetrisGame.cols) {
                return false
            }
            if board[position.row][newCol] != .empty {
                return false
            }
        }
        return true
    }
    func canMoveLeft(_ block: Tetromino) -> Bool {
        for position in block.positions {
            let newCol = position.col - 1
            if (newCol < 0) {
                return false
            }
            if board[position.row][newCol] != .empty {
                return false
            }
        }
        return true
    }
    func moveLeft() {
        guard var block = currentBlock else { return }
        
        if canMoveLeft(block) {
            // Update positions
            block.positions = block.positions.map {
                Position(row: $0.row, col: $0.col - 1)
            }
            currentBlock = block
        }
    }
    
    func moveRight() {
        guard var block = currentBlock else { return }
        
        if canMoveRight(block) {
            block.positions = block.positions.map {
                Position(row: $0.row, col: $0.col + 1)
            }
            currentBlock = block
        }
    }
    

    private func gameLoop() {
        guard var block = currentBlock else { return }
        if canMoveDown(block) {
            block.moveDown()
            currentBlock = block
        } else {
            // Lock block in place
            lockBlock(block)
            // Spawn new block
            spawnBlock()
        }
        
    }
    func cancelTimer() {
            // Call cancel() on the AnyCancellable instance
        TetrisTimer?.invalidate()
        TetrisTimer = nil // Set the reference to nil after cancellation
        }

    private func startTimer() {
        TetrisTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.gameLoop()
        }
    }

    private func lockBlock(_ block: Tetromino) {
        for position in block.positions {
            if position.row >= 0 && position.row < TetrisGame.rows &&
               position.col >= 0 && position.col < TetrisGame.cols {
                board[position.row][position.col] = block.type
            }
        }
    }

    private func canRotate(_ block: Tetromino) -> Bool {
        for position in block.positions {
            if position.row < 0 || position.row >= TetrisGame.rows {
                return false
            }
            if position.col < 0 || position.col >= TetrisGame.cols {
                return false
            }
            
            if board[position.row][position.col] != .empty {
                return false
            }
        }
        return true
    }
    
    func rotateCurrentBlock() {
        guard var block = currentBlock else { return }
        let originalBlock = block
        block.rotate()

        if canRotate(block) {
            currentBlock = block
        } else {
            currentBlock = originalBlock
        }
    }
    
    func getBoardWithCurrentBlock() -> [[BlockType]] {
        var displayBoard = board
        if let block = currentBlock {
            for position in block.positions {
                if position.row >= 0 && position.row < TetrisGame.rows &&
                   position.col >= 0 && position.col < TetrisGame.cols {
                    displayBoard[position.row][position.col] = block.type
                }
            }
        }

        return displayBoard
    }

}
