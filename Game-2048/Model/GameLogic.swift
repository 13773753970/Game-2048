//
//  GameLogic.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/7.
//

import Foundation

final class GameLogic: ObservableObject {
    struct Block: Identifiable, CustomStringConvertible {
        typealias AtPosition = (Int, Int)
        let id: Int
        var number: Int
        var at: AtPosition
        func getIndex(gridRows: Int) -> Int { self.at.0 * gridRows + self.at.1 }
        
        var description: String {
            return "BLOCK(id: \(id), number: \(number), at: (\(at.0), \(at.1)))"
        }
    }
    
    private var id = 0
    @Published private(set) var gridRows = 4
    @Published private(set) var existBlocks: [Block] = []
    @Published private(set) var score = 0
    // visible blocks
    private var realBlocks: [Block] {
        existBlocks.filter { block in
            let blockIndex = block.getIndex(gridRows: gridRows)
            if existBlocks.firstIndex(where: {
                $0.id != block.id && $0.getIndex(gridRows: gridRows) == blockIndex && $0.number > block.number
            }) != nil {
                return false
            }
            return true
        }
    }
    var overIf: Bool {
        if realBlocks.count >= (gridRows * gridRows) {
            for block_i in realBlocks {
                for block_j in realBlocks {
                    if block_j.number == block_i.number &&
                        ((block_j.at.0 == block_i.at.0 && block_j.at.1 == block_i.at.1 + 1) ||
                        (block_j.at.1 == block_i.at.1 && block_j.at.0 == block_i.at.0 + 1) ||
                        (block_j.at.0 == block_i.at.0 + 1 && block_j.at.1 == block_i.at.1 + 1)){
                        return false
                    }
                }
            }
            return true
        }
        return false
    }
    
    init() {
        restartAction()
    }
    
    // create one block random in grid
    private func createBlock(blocks: [Block], gridRows: Int) -> Block {
        id += 1
        let allIndexs = 0..<(gridRows * gridRows)
        let existIndexs = blocks.map { $0.getIndex(gridRows: gridRows) }
        guard let index = allIndexs.filter({ !existIndexs.contains($0) }).sample else {
            fatalError("There is no vacancy in grid")
        }
        return Block(id: id, number: 2, at: (index / gridRows, index % gridRows))
    }
    
    // clear exist blocks and add two new blocks
    func restartAction() {
        id = 0
        score = 0
        var blocks: [Block] = []
        for _ in 0..<2 {
            let block = createBlock(blocks: blocks, gridRows: gridRows)
            blocks.append(block)
        }
        existBlocks = blocks
    }
    
    private func blocksGoUp(blocks prevBlocks: [Block], gridRows: Int) -> (moved: Bool, blocks: [Block]) {
        var blocks: [Block] = []
        var moved = false
        for column in 0..<gridRows {
            var columnBlocks = prevBlocks.filter({ $0.at.1 == column }).sorted(by: { $0.at.0 < $1.at.0})
            var i = 0
            var row = 0
            while i < columnBlocks.count {
                if i + 1 < columnBlocks.count {
                    if columnBlocks[i].number == columnBlocks[i + 1].number {
                        self.score += columnBlocks[i].number
                        columnBlocks[i].number = columnBlocks[i].number * 2
                        columnBlocks[i].at.0 = row
                        columnBlocks[i + 1].at.0 = row
                        i += 2
                        row += 1
                        moved = true
                    }else {
                        if !(columnBlocks[i].at.0 == row && columnBlocks[i + 1].at.0 == row + 1) {
                            columnBlocks[i].at.0 = row
                            columnBlocks[i + 1].at.0 = row + 1
                            moved = true
                        }
                        i += 1
                        row += 1
                    }
                }else {
                    if columnBlocks[i].at.0 != row {
                        columnBlocks[i].at.0 = row
                        moved = true
                    }
                    i += 1
                }
            }
            blocks += columnBlocks
        }
        return (moved, blocks)
    }
    
    // pure
    private func gridClockwiseRotation(blocks prevBlocks: [Block], gridRows: Int) -> [Block] {
        prevBlocks.map { block in
            var newBlock = block
            newBlock.at = (block.at.1, gridRows - block.at.0 - 1)
            return newBlock
        }
    }
    
    // pure
    private func gridAnticlockwiseRotation(blocks prevBlocks: [Block], gridRows: Int) -> [Block] {
        prevBlocks.map { block in
            var newBlock = block
            newBlock.at = (gridRows - block.at.1 - 1, block.at.0)
            return newBlock
        }
    }
    
    // pure
    private func gridFlipHorizontal(blocks prevBlocks: [Block], gridRows: Int) -> [Block] {
        prevBlocks.map { block in
            var newBlock = block
            newBlock.at = (gridRows - block.at.0 - 1, block.at.1)
            return newBlock
        }
    }
    
    func upAction() {
        if overIf {
            return;
        }
        let (moved, blocks) = blocksGoUp(blocks: realBlocks, gridRows: gridRows)
        if moved {
            existBlocks = blocks + [createBlock(blocks: blocks, gridRows: gridRows)]
        }
    }
    
    func leftAction() {
        if overIf {
            return;
        }
        var (moved, blocks) = blocksGoUp(blocks: gridClockwiseRotation(blocks: realBlocks, gridRows: gridRows), gridRows: gridRows)
        if moved {
            blocks = gridAnticlockwiseRotation(blocks: blocks, gridRows: gridRows)
            existBlocks = blocks + [createBlock(blocks: blocks, gridRows: gridRows)]
        }
    }
    
    func rightAction() {
        if overIf {
            return;
        }
        var (moved, blocks) = blocksGoUp(blocks: gridAnticlockwiseRotation(blocks: realBlocks, gridRows: gridRows), gridRows: gridRows)
        if moved {
            blocks = gridClockwiseRotation(blocks: blocks, gridRows: gridRows)
            existBlocks = blocks + [createBlock(blocks: blocks, gridRows: gridRows)]
        }
    }
    
    func downAction() {
        if overIf {
            return;
        }
        var (moved, blocks) = blocksGoUp(blocks: gridFlipHorizontal(blocks: realBlocks, gridRows: gridRows), gridRows: gridRows)
        if moved {
            blocks = gridFlipHorizontal(blocks: blocks, gridRows: gridRows)
            existBlocks = blocks + [createBlock(blocks: blocks, gridRows: gridRows)]
        }
    }
}
