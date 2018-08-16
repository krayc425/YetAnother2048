//
//  GameModel.swift
//  YetAnother2048
//
//  Created by 宋 奎熹 on 2018/8/6.
//  Copyright © 2018 宋 奎熹. All rights reserved.
//

import Foundation

typealias BoardMatrix = [[Int]]

class GameModel: NSObject, Codable, NSCoding {
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.score = aDecoder.decodeInteger(forKey: "score")
        self.tileMatrix = aDecoder.decodeObject(forKey: "matrix") as! BoardMatrix
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(score, forKey: "score")
        aCoder.encode(tileMatrix, forKey: "matrix")
    }
    
    static let size: Int = 4
    var score: Int = 0
    var tileMatrix: BoardMatrix = BoardMatrix()
    var isLose: Bool {
        return self.checkIsLose()
    }
    
    override init() {
        super.init()
        reset()
    }
    
    func reset() {
        tileMatrix = Array(repeating: Array(repeating: -1, count: GameModel.size), count: GameModel.size)
        
        score = 0
        
        for _ in 0...1 {
            self.generateNewTile()
        }
    }
    
    func up() {
        var moved: Bool = false
        var temps: [[Int]] = []
        for i in 0..<GameModel.size {
            temps.append(tileMatrix.map { $0[i] })
        }
        for i in 0..<GameModel.size {
            let res = handle(tiles: &temps[i])
            moved = moved || res
        }
        if moved {
            for i in 0..<GameModel.size {
                for j in 0..<GameModel.size {
                    tileMatrix[i][j] = temps[j][i]
                }
            }
            generateNewTile()
        }
    }
    
    func down() {
        var moved: Bool = false
        var temps: [[Int]] = []
        for i in 0..<GameModel.size {
            temps.append(tileMatrix.map { $0[i] })
        }
        for i in 0..<GameModel.size {
            var tempArray: [Int] = temps[i].reversed()
            let res = handle(tiles: &tempArray)
            moved = moved || res
            temps[i] = tempArray.reversed()
        }
        if moved {
            for i in 0..<GameModel.size {
                for j in 0..<GameModel.size {
                    tileMatrix[i][j] = temps[j][i]
                }
            }
            generateNewTile()
        }
    }
    
    func left() {
        var moved: Bool = false
        for i in 0..<GameModel.size {
            let res = handle(tiles: &tileMatrix[i])
            moved = moved || res
        }
        if moved {
            generateNewTile()
        }
    }
    
    func right() {
        var moved: Bool = false
        for i in 0..<GameModel.size {
            var tempArray: [Int] = tileMatrix[i].reversed()
            let res = handle(tiles: &tempArray)
            moved = moved || res
            tileMatrix[i] = tempArray.reversed()
        }
        if moved {
            generateNewTile()
        }
    }
    
    func checkIsFull() -> Bool {
        return tileMatrix.flatMap { $0.map { $0 } }.filter { $0 == -1 }.count == 0
    }
    
    func checkIsLose() -> Bool {
        guard checkIsFull() else {
            return false
        }
        
        var isLose = true
        for i in 0..<GameModel.size {
            for j in 0..<GameModel.size-1 {
                if tileMatrix[i][j] == tileMatrix[i][j + 1] && tileMatrix[i][j] != -1 {
                    isLose = false
                    break
                }
            }
        }
        if isLose {
            for j in 0..<GameModel.size {
                for i in 0..<GameModel.size-1 {
                    if tileMatrix[i + 1][j] == tileMatrix[i][j] && tileMatrix[i][j] != -1 {
                        isLose = false
                        break
                    }
                }
            }
        }
        return isLose
    }
    
    private func generateNewTile() {
        while true {
            let x = Int(arc4random()) % GameModel.size
            let y = Int(arc4random()) % GameModel.size
            if tileMatrix[x][y] != -1 {
                continue
            }
            tileMatrix[x][y] = arc4random() % 10 > 7 ? 4 : 2
            break
        }
    }
    
    private func handle(tiles: inout [Int]) -> Bool {
        let original = Array(tiles)
        var move: [Int] = Array(repeating: 0, count: tiles.count)
        var moveStep = 0
        var i = 0
        while i < tiles.count - 1 {
            if tiles[i] == -1 {
                moveStep += 1
            }
            move[i + 1] = moveStep
            i += 1
        }
        for i in 0..<tiles.count {
            tiles[i - move[i]] = tiles[i]
        }
        for i in (tiles.count - moveStep)..<tiles.count {
            tiles[i] = -1
        }
        
        i = 0
        moveStep = 0
        move = Array(repeating: 0, count: tiles.count)
        while i < tiles.count - 1 {
            if tiles[i] == -1 {
                moveStep += 1
                move[i + 1] = moveStep
            } else {
                if tiles[i] == tiles[i + 1] && tiles[i] != -1 {
                    moveStep += 1
                    tiles[i] *= 2
                    tiles[i + 1] = -1
                    score += tiles[i]
                    i += 1
                    if i < tiles.count - 2 {
                        move[i + 1] = moveStep
                    }
                } else {
                    move[i + 1] = moveStep
                }
            }
            i += 1
        }
        for i in 0..<tiles.count {
            tiles[i - move[i]] = tiles[i]
        }
        for i in (tiles.count - moveStep)..<tiles.count {
            tiles[i] = -1
        }
        
        return original != tiles
    }
    
}
