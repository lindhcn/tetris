//
//  ContentView.swift
//  tetris
//
//  Created by linda han on 2026-02-15.
//

import SwiftUI
import SwiftData
import Foundation
struct CellView: View {
    let blockType: BlockType
    
    var body: some View {
        Rectangle()
            .fill(blockType.color)
            .border(Color.gray.opacity(0.3), width: 1)
    }
}

struct BoardView: View {
    let board: [[BlockType]]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<board.count, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<board[row].count, id: \.self) { col in
                        CellView(blockType: board[row][col])
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
        .background(Color.white)
        .border(Color.gray.opacity(0.3), width: 2)
    }
}


struct ContentView: View {
    @StateObject private var game = TetrisGame()
    private let moveSensitivity = 30.0
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 10)
            .onEnded() { value in
                let horizontalAmount = value.translation.width
                let verticalAmount = value.translation.height
                let currentTime = Date()
                print("DATE: \(currentTime), \(horizontalAmount), \(verticalAmount)")
                // Determine if swipe is more horizontal or vertical
                if abs(horizontalAmount) > abs(verticalAmount) {
                    let movedDist = horizontalAmount / moveSensitivity
                    for index in 0...abs(Int(movedDist)) {
                        // Horizontal swipe
                        if horizontalAmount < 0 {
                            // Swipe left
                            game.moveLeft()
                        } else {
                            // Swipe right
                            game.moveRight()
                        }
                    }
                }
                else {
                    if verticalAmount > 0 {
                        let movedDist = verticalAmount / moveSensitivity
                        for index in 0...abs(Int(movedDist)) {
                            game.moveDown()
                        }
                    }
                }
            }
    }

    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Tetris")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.primary)
            
            if game.isGameOver {
                Text("Game Over")
            }
            
            
            BoardView(board: game.getBoardWithCurrentBlock())
                .frame(width: 300, height: 600)
                .padding()
                .onTapGesture {
                    game.rotateCurrentBlock()
                }
                .gesture(drag)
        
            
            HStack(spacing: 20) {
                Button(action: {
                    if game.isGameOver {
                        game.startGame()  // Restart after game over
                    } else if game.isGameActive {
                        game.stopGame()   // Pause active game
                    } else {
                        game.startGame()  // Start new game
                    }
                }) {
                    Text(game.isGameOver ? "Restart" : (game.isGameActive ? "Pause" : "Start"))
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(game.isGameOver ? Color.blue : (game.isGameActive ? Color.orange : Color.green))
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
    
}
