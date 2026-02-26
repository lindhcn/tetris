//
//  NextView.swift
//  tetris
//
//  Created by linda han on 2026-02-23.
//

import SwiftUI
struct NextView: View {
    let block: Tetromino?
    
    var body: some View {
        HStack(alignment: .center) {
            Text("Next")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.leading, 20)
                        
            if let block = block {
                BlockPreviewView(currentBlock: block.type)
            } else {
                Color.clear
                    .padding(.trailing, 20)
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black)
        )
    }
}
#Preview {
    let previewPos = Position(row: 0, col: 0)

    let cur = Tetromino.createI(at: previewPos, at: 0)

    NextView(block: cur).frame(width: 160, height: 120)
    NextView(block: nil).frame(width: 160, height: 120)

}
