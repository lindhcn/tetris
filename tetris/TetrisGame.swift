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
    
    private var timer: Timer?

    
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
        currentBlock = Tetromino.createI(at: Position(row: 0, col: 3))
    }
    
    func canMoveDown(_ block: Tetromino) -> Bool {
        for position in block.positions {
            let newRow = position.row + 1
            if (position.row >= TetrisGame.rows) {
                return false
            }
            if board[newRow][position.col] != .empty {
                return false
            }
        }
        return true
    }
    
    private func gameLoop() {
        guard var block = currentBlock else { return }
        
        if canMoveDown(block) {
            block.moveDown()
            currentBlock = block
        } else {
            // Spawn new block
            lockBlock(block)
            spawnBlock()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
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
