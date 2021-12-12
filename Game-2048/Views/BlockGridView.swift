//
//  BlockGridView.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/7.
//

import SwiftUI

struct BlockGridView: View {
    var blocks: [GameState.Block]
    var gridRows: Int
    var blockSize: CGFloat = 65
    var blockSpacing: CGFloat = 12
    var gridSize: CGFloat {
        CGFloat(gridRows) * (blockSize + blockSpacing) - blockSpacing
    }
    
    func getBlockOffset(at: GameState.Block.AtPosition) -> CGPoint {
        CGPoint(
            x: CGFloat(at.1) * (blockSize + blockSpacing),
            y: CGFloat(at.0) * (blockSize + blockSpacing)
        )
    }
    
    func createBlockView(number: Int? = nil, at: GameState.Block.AtPosition) -> some View {
        let offset = getBlockOffset(at: at)
        return BlockViewWithAnimation(number: number, blockSize: blockSize)
            .offset(x: offset.x, y: offset.y)
            .transition(
                .asymmetric(
                    insertion: .scale(scale: 0, anchor: UnitPoint(x: offset.x / blockSize + 0.5, y: offset.y / blockSize + 0.5))
                        .animation(.linear(duration: 0.4).delay(0.3)),
                    removal: .opacity.animation(nil)
                )
            )
    }
    
    var body: some View {
        return ZStack {
            ForEach(0..<4) { i in
                ForEach(0..<4) { j in
                    createBlockView(at: (i, j))
                }
            }
            .zIndex(1.0)
            
            ForEach(blocks) { block in
                createBlockView(number: block.number, at: block.at)
                    .zIndex(Double(block.number))
                    .animation(.linear(duration: 0.3), value: block.getIndex(gridRows: gridRows))
            }
            .zIndex(100)
        }
        .frame(width: gridSize, height: gridSize, alignment: .topLeading)
    }
}

struct BlockGridView_Previews: PreviewProvider {
    static var previews: some View {
        BlockGridView(
            blocks: [
                GameState.Block(id: 1, number: 2, at: (0, 0)),
                GameState.Block(id: 2, number: 4, at: (0, 0)),
                GameState.Block(id: 3, number: 2, at: (1, 2)),
                GameState.Block(id: 4, number: 8, at: (2, 3)),
            ],
            gridRows: 4
        )
    }
}
