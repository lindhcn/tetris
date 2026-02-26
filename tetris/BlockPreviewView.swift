//
//  BlockPreviewView.swift
//  tetris
//
//  Created by linda han on 2026-02-24.
//

import SwiftUI
struct BlockPreviewView: View {
    let currentBlock: BlockType
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = min(geometry.size.width, geometry.size.height) / 5  // Base size
            
            ZStack {
                switch currentBlock {
                case .I:
                    HStack(spacing: 0) {
                        ForEach(0..<4) { _ in
                            Rectangle()
                                .fill(Color.cyan)
                                .frame(width: cellSize, height: cellSize)
                                .border(Color.white, width: 0.5)
                        }
                    }
                    
                case .O:
                    VStack(spacing: 0) {
                        ForEach(0..<2) { _ in
                            HStack(spacing: 0) {
                                ForEach(0..<2) { _ in
                                    Rectangle()
                                        .fill(Color.yellow)
                                        .frame(width: cellSize, height: cellSize)
                                        .border(Color.white, width: 0.5)
                                }
                            }
                        }
                    }
                    
                case .J:
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Rectangle().fill(Color.blue).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Color.clear.frame(width: cellSize, height: cellSize)
                            Color.clear.frame(width: cellSize, height: cellSize)
                        }
                        HStack(spacing: 0) {
                            Rectangle().fill(Color.blue).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Rectangle().fill(Color.blue).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Rectangle().fill(Color.blue).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                        }
                    }
                case .L:
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Color.clear.frame(width: cellSize, height: cellSize)
                            Color.clear.frame(width: cellSize, height: cellSize)
                            Rectangle().fill(Color.orange).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)

                        }
                        HStack(spacing: 0) {
                            Rectangle().fill(Color.orange).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Rectangle().fill(Color.orange).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Rectangle().fill(Color.orange).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                        }
                    }
                case .S:
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Color.clear.frame(width: cellSize, height: cellSize)
                            Rectangle().fill(Color.green).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Rectangle().fill(Color.green).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)

                        }
                        HStack(spacing: 0) {
                            Rectangle().fill(Color.green).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Rectangle().fill(Color.green).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Color.clear.frame(width: cellSize, height: cellSize)
                        }
                    }
                case .T:
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Color.clear.frame(width: cellSize, height: cellSize)
                            Rectangle().fill(Color.purple).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Color.clear.frame(width: cellSize, height: cellSize)

                        }
                        HStack(spacing: 0) {
                            Rectangle().fill(Color.purple).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Rectangle().fill(Color.purple).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Rectangle().fill(Color.purple).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                        }
                    }
                case .Z:
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Rectangle().fill(Color.red).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Rectangle().fill(Color.red).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Color.clear.frame(width: cellSize, height: cellSize)


                        }
                        HStack(spacing: 0) {
                            Color.clear.frame(width: cellSize, height: cellSize)

                            Rectangle().fill(Color.red).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                            Rectangle().fill(Color.red).frame(width: cellSize, height: cellSize).border(Color.white, width: 0.5)
                        }
                    }

                default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
#Preview {
    BlockPreviewView(currentBlock: .I)
    BlockPreviewView(currentBlock: .O)
    BlockPreviewView(currentBlock: .J)
    BlockPreviewView(currentBlock: .L)
    BlockPreviewView(currentBlock: .S)
    BlockPreviewView(currentBlock: .Z)
    BlockPreviewView(currentBlock: .T)
}
