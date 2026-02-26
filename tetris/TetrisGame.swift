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
    @Published var nextBlock: Tetromino?
    @Published var isGameActive = false
    @Published var isGameOver = true
    @Published var score = 0
    @Published var level = 1
    @Published var linesCleared = 0

    private var TetrisTimer: Timer?

    
    init() {
        board = Array(repeating: Array(repeating: BlockType.empty, count: TetrisGame.cols),
                     count: TetrisGame.rows)
    }

    func startGame() {
        resetBoard()
        isGameOver = false
        generateNextBlock()
        spawnBlock()
        isGameActive = true
        score = 0
        level = 1
        linesCleared = 0
        startTimer()

    }
    func resumeGame() {
        isGameActive = true
        startTimer()
    }

    func resetBoard() {
        board = Array(repeating: Array(repeating: BlockType.empty, count: TetrisGame.cols),
                      count: TetrisGame.rows)
    }

    private func generateNextBlock() {
        let blockTypes: [BlockType] = [.I, .J, .O, .L, .S, .Z, .T]
        let chosenBlock = blockTypes.randomElement()!
        let rotation = 0
        
        let previewPos = Position(row: 0, col: 0)
        
        switch chosenBlock {
        case .I:
            nextBlock = Tetromino.createI(at: previewPos, at: rotation)
        case .J:
            nextBlock = Tetromino.createJ(at: previewPos, at: rotation)
        case .O:
            nextBlock = Tetromino.createO(at: previewPos, at: rotation)
        case .S:
            nextBlock = Tetromino.createS(at: previewPos, at: rotation)
        case .T:
            nextBlock = Tetromino.createT(at: previewPos, at: rotation)
        case .Z:
            nextBlock = Tetromino.createZ(at: previewPos, at: rotation)
        case .L:
            nextBlock = Tetromino.createL(at: previewPos, at: rotation)
        default:
            break
        }
    }

    func spawnBlock() {
        if let next = nextBlock {
            var block = next
            let spawnPos = Position(row: 1, col: 3)
            let offset = Position(row: spawnPos.row - block.positions[0].row,
                                col: spawnPos.col - block.positions[0].col)
            
            block.positions = block.positions.map {
                Position(row: $0.row + offset.row, col: $0.col + offset.col)
            }
            currentBlock = block
        }
        
        // Generate new next block
        generateNextBlock()
    }
    
    func canClearRows() -> [Int] {
        var rowsToClear: [Int] = []
        for row in 0..<TetrisGame.rows {
            if board[row].allSatisfy({ $0 != .empty }) {
                rowsToClear.append(row)
            }
        }
        return rowsToClear
    }
    
    func clearRows(_ rowsToClear: [Int]) {
        let rowsToRemove = Set(rowsToClear)
        
        board = board.enumerated()
            .filter { !rowsToRemove.contains($0.offset) }
            .map { $0.element }
        
        let emptyRows = Array(repeating: Array(repeating: BlockType.empty, count: TetrisGame.cols),
                             count: rowsToClear.count)
        board = emptyRows + board
        updateScore(rowsCleared: rowsToClear.count)
    }
    
    private func updateScore(rowsCleared: Int) {
        let points: Int
        switch rowsCleared {
        case 1:
            points = 100 * level
        case 2:
            points = 300 * level
        case 3:
            points = 500 * level
        case 4:
            points = 800 * level
        default:
            points = 0
        }
        
        score += points
        linesCleared += rowsCleared
    }
    
    func canMoveDown(_ block: Tetromino) -> Bool {
        for position in block.positions {
            let newRow = position.row + 1
            if (newRow >= TetrisGame.rows) {
                return false
            }
            if position.col < 0 || position.col >= TetrisGame.cols {
                continue
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
            
            if position.row < 0 || position.row >= TetrisGame.rows {
                continue
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
    
    func moveDown() {
        guard var block = currentBlock else { return }
        
        if canMoveDown(block) {
            block.positions = block.positions.map {
                Position(row: $0.row + 1, col: $0.col)
            }
            currentBlock = block
        }
    }
    
    private func checkGameOver() -> Bool {
        guard let block = currentBlock else { return false }
            
        for position in block.positions {
            if position.row >= 0 && position.row < TetrisGame.rows &&
               position.col >= 0 && position.col < TetrisGame.cols {
                if board[position.row][position.col] != .empty {
                    return true  // New block overlaps existing blocks
                }
            }
        }
        return false
    }

    private func gameLoop() {
        guard var block = currentBlock else { return }
        if canMoveDown(block) {
            block.moveDown()
            currentBlock = block
        } else {
            // Lock block in place
            lockBlock(block)
            let rowsToClear = canClearRows()
            if !rowsToClear.isEmpty {
                print(rowsToClear)
                clearRows(rowsToClear)
            }
            // Spawn new block
            spawnBlock()
            if checkGameOver() {
                print("GAMEOVER")
                stopGame()
                isGameOver = true  // Set the flag
            }

            
        }
        
    }
    func stopGame() {
        isGameActive = false
        TetrisTimer?.invalidate()
        TetrisTimer = nil
    }

    private func startTimer() {
        TetrisTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
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
