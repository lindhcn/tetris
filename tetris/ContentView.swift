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
    @State private var lastDragTranslation = CGSize.zero

    var drag: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged() { value in
                let currentTranslation = value.translation
                let deltaX = currentTranslation.width - lastDragTranslation.width
                let deltaY = currentTranslation.height - lastDragTranslation.height
                
                if abs(deltaX) >= moveSensitivity {
                    if deltaX < 0 {
                        game.moveLeft()
                    } else {
                        game.moveRight()
                    }
                    lastDragTranslation.width = currentTranslation.width
                }
                
                if abs(deltaY) >= moveSensitivity {
                    if deltaY > 0 {
                        game.moveDown()
                    }
                    lastDragTranslation.height = currentTranslation.height
                }
            }
            .onEnded() { _ in
                lastDragTranslation = .zero  // Reset when drag ends
            }
        
    }
    
    var body: some View {
        VStack(spacing: 15) {
            // Top row - Next block and Play button
            HStack(spacing: 40) {
                let previewPos = Position(row: 0, col: 0)

                let cur = Tetromino.createI(at: previewPos, at: 0)

                //NextView(block: cur).frame(width: 160)
                NextView(block: game.nextBlock).frame(width: 180, height: 120)
                
                Button(action: {
                    if game.isGameOver {
                        game.startGame()
                    } else if game.isGameActive {
                        game.stopGame()
                    } else {
                        game.resumeGame()
                    }
                }) {
                    Image(systemName: game.isGameOver ? "arrow.clockwise" : (game.isGameActive ? "pause.fill" : "play.fill"))
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)  // Same size
                        .background(Color.black)
                        .clipShape(Circle())
                }
            }
            .frame(height: 70)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Game Over text
            /*if game.isGameOver {
                Text("Game Over!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.red)
            }*/
            
            // Game board
            BoardView(board: game.getBoardWithCurrentBlock())
                .aspectRatio(0.7, contentMode: .fill)
                .padding(.horizontal, 20)
                .onTapGesture {
                    game.rotateCurrentBlock()
                }
                .gesture(drag)
                        
            // Bottom - Level and Score
            InfoView(level: game.level, score: game.score)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
    
}
