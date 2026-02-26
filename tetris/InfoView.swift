//
//  InfoView.swift
//  tetris
//
//  Created by linda han on 2026-02-22.
//

import SwiftUI
struct InfoView: View {
    let level: Int
    let score: Int
    
    var body: some View {
        HStack(spacing: 30) {
            VStack(spacing: 5) {
                Text("Level")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text("\(level)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 5) {
                Text("Score")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text("\(score)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
        )
    }
}

#Preview {
    
    InfoView(level: 1, score: 0)
}
