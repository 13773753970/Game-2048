//
//  GameReducer.swift
//  Game-2048
//
//  Created by 周鹏 on 2021/12/9.
//

import Foundation
import Redux

struct GameState: Persistent {
    struct Block: Identifiable, CustomStringConvertible, Codable {
        typealias AtPosition = (Int, Int)
        let id: Int
        var number: Int
        var at: AtPosition
        
        enum CodingKeys: String, CodingKey {
            case id, number, at0, at1
        }
        init(id: Int, number: Int, at: AtPosition) {
            self.id = id
            self.number = number
            self.at = at
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(Int.self, forKey: .id)
            number = try values.decode(Int.self, forKey: .number)
            at.0 = try values.decode(Int.self, forKey: .at0)
            at.1 = try values.decode(Int.self, forKey: .at1)
        }
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(number, forKey: .number)
            try container.encode(at.0, forKey: .at0)
            try container.encode(at.1, forKey: .at1)
        }
        
        func getIndex(gridRows: Int) -> Int { self.at.0 * gridRows + self.at.1 }
        var description: String {
            return "BLOCK(id: \(id), number: \(number), at: (\(at.0), \(at.1)))"
        }
    }
    struct PersistedState: Codable {
        var id: Int
        var gridRows: Int
        var existBlocks: [Block]
        var score: Int
    }
    init() {}
    init(persistedState: PersistedState) {
        id = persistedState.id
        gridRows = persistedState.gridRows
        existBlocks = persistedState.existBlocks
        score = persistedState.score
    }
    func persist() -> PersistedState {
        PersistedState(id: id, gridRows: gridRows, existBlocks: existBlocks, score: score)
    }
    
    var id: Int = 2
    var gridRows: Int = 4
    var existBlocks: [Block] = ({
        var blocks: [GameState.Block] = []
        for id in 1...2 {
            let block = createBlock(id: id, blocks: blocks, gridRows: 4)
            blocks.append(block)
        }
        return blocks
    })()
    var score: Int = 0
    
    
        
    var realBlocks: [Block] {
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
}

struct GameUpAction: Action {}
struct GameLeftAction: Action {}
struct GameRightAction: Action {}
struct GameDownAction: Action {}
struct GameRestartAction: Action {}

func gameReducer(_ state: GameState?, _ action: Action) -> GameState {
    let state = state ?? GameState()
    if let action = action as? GameUpAction {
        return up(state: state, action: action)
    } else if let action = action as? GameLeftAction {
        return left(state: state, action: action)
    } else if let action = action as? GameRightAction {
        return right(state: state, action: action)
    } else if let action = action as? GameDownAction {
        return down(state: state, action: action)
    } else if let action = action as? GameRestartAction {
        return restart(state: state, action: action)
    }
    return state
}

let persistentGameReducer = persistReducer(reducer: gameReducer)

// pure
fileprivate func createBlock(id: Int, blocks: [GameState.Block], gridRows: Int) -> GameState.Block {
    let allIndexs = 0..<(gridRows * gridRows)
    let existIndexs = blocks.map { $0.getIndex(gridRows: gridRows) }
    guard let index = allIndexs.filter({ !existIndexs.contains($0) }).sample else {
        fatalError("There is no vacancy in grid")
    }
    return GameState.Block(id: id, number: 2, at: (index / gridRows, index % gridRows))
}

// pure
fileprivate func blocksGoUp(blocks prevBlocks: [GameState.Block], gridRows: Int, score: Int) -> (moved: Bool, blocks: [GameState.Block], score: Int) {
    var score = score
    var blocks: [GameState.Block] = []
    var moved = false
    for column in 0..<gridRows {
        var columnBlocks = prevBlocks.filter({ $0.at.1 == column }).sorted(by: { $0.at.0 < $1.at.0})
        var i = 0
        var row = 0
        while i < columnBlocks.count {
            if i + 1 < columnBlocks.count {
                if columnBlocks[i].number == columnBlocks[i + 1].number {
                    score += columnBlocks[i].number
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
    return (moved, blocks, score)
}

// pure
fileprivate func gridClockwiseRotation(blocks prevBlocks: [GameState.Block], gridRows: Int) -> [GameState.Block] {
    prevBlocks.map { block in
        var newBlock = block
        newBlock.at = (block.at.1, gridRows - block.at.0 - 1)
        return newBlock
    }
}

// pure
fileprivate func gridAnticlockwiseRotation(blocks prevBlocks: [GameState.Block], gridRows: Int) -> [GameState.Block] {
    prevBlocks.map { block in
        var newBlock = block
        newBlock.at = (gridRows - block.at.1 - 1, block.at.0)
        return newBlock
    }
}

// pure
fileprivate func gridFlipHorizontal(blocks prevBlocks: [GameState.Block], gridRows: Int) -> [GameState.Block] {
    prevBlocks.map { block in
        var newBlock = block
        newBlock.at = (gridRows - block.at.0 - 1, block.at.1)
        return newBlock
    }
}

fileprivate func up(state: GameState, action: GameUpAction) -> GameState {
    var state = state
    if !state.overIf {
        let (moved, blocks, score) = blocksGoUp(blocks: state.realBlocks, gridRows: state.gridRows, score: state.score)
        if moved {
            state.id += 1
            state.existBlocks = blocks + [createBlock(id: state.id, blocks: blocks, gridRows: state.gridRows)]
            state.score = score
        }
    }
    return state
}

fileprivate func left(state: GameState, action: GameLeftAction) -> GameState {
    var state = state
    if !state.overIf {
        var (moved, blocks, score) = blocksGoUp(blocks: gridClockwiseRotation(blocks: state.realBlocks, gridRows: state.gridRows), gridRows: state.gridRows, score: state.score)
        if moved {
            state.id += 1
            blocks = gridAnticlockwiseRotation(blocks: blocks, gridRows: state.gridRows)
            state.existBlocks = blocks + [createBlock(id: state.id, blocks: blocks, gridRows: state.gridRows)]
            state.score = score
        }
    }
    return state
}

fileprivate func right(state: GameState, action: GameRightAction) -> GameState {
    var state = state
    if !state.overIf {
        var (moved, blocks, score) = blocksGoUp(blocks: gridAnticlockwiseRotation(blocks: state.realBlocks, gridRows: state.gridRows), gridRows: state.gridRows, score: state.score)
        if moved {
            state.id += 1
            blocks = gridClockwiseRotation(blocks: blocks, gridRows: state.gridRows)
            state.existBlocks = blocks + [createBlock(id: state.id, blocks: blocks, gridRows: state.gridRows)]
            state.score = score
        }
    }
    return state
}

fileprivate func down(state: GameState, action: GameDownAction) -> GameState {
    var state = state
    if !state.overIf {
        var (moved, blocks, score) = blocksGoUp(blocks: gridFlipHorizontal(blocks: state.realBlocks, gridRows: state.gridRows), gridRows: state.gridRows, score: state.score)
        if moved {
            state.id += 1
            blocks = gridFlipHorizontal(blocks: blocks, gridRows: state.gridRows)
            state.existBlocks = blocks + [createBlock(id: state.id, blocks: blocks, gridRows: state.gridRows)]
            state.score = score
        }
    }
    return state
}

fileprivate func restart(state: GameState, action: GameRestartAction) -> GameState {
    var state = state
    state.id = 0
    state.score = 0
    var blocks: [GameState.Block] = []
    for _ in 0..<2 {
        state.id += 1
        let block = createBlock(id: state.id, blocks: blocks, gridRows: state.gridRows)
        blocks.append(block)
    }
    state.existBlocks = blocks
    return state
}
