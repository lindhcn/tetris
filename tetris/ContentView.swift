//
//  ContentView.swift
//  tetris
//
//  Created by linda han on 2026-02-15.
//

import SwiftUI
import SwiftData

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

    var body: some View {        
        BoardView(board: game.getBoardWithCurrentBlock())
            .frame(width: 300, height: 600)
            .padding()
            .onTapGesture {
                game.rotateCurrentBlock()  // Call a method in your game
            }
            .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    let verticalAmount = value.translation.height
                    
                    // Determine if swipe is more horizontal or vertical
                    if abs(horizontalAmount) > abs(verticalAmount) {
                        // Horizontal swipe
                        if horizontalAmount < 0 {
                            // Swipe left
                            game.moveLeft()
                        } else {
                            // Swipe right
                            game.moveRight()
                        }
                    } /*else {
                        // Vertical swipe
                        if verticalAmount > 0 {
                            // Swipe down - could make block drop faster
                            game.dropFaster()
                        }
                    }*/
                }
            )
        
        HStack(spacing: 20) {
            Button(action: {
                game.startGame()
            }) {
                Text("Start")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
    
}
