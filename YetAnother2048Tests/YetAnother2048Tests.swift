//
//  YetAnother2048Tests.swift
//  YetAnother2048Tests
//
//  Created by 宋 奎熹 on 2018/8/14.
//  Copyright © 2018 宋 奎熹. All rights reserved.
//

import XCTest

class YetAnother2048Tests: XCTestCase {
    
    enum SwipeDirection {
        case left
        case right
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        var array = [-1, 2, 2, 2]
        handle(tiles: &array)
        print(array)
    }
    
    func handle(tiles: inout [Int]) {
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
        
        print(move)
        print(tiles)
        
        i = 0
        moveStep = 0
        move = Array(repeating: 0, count: tiles.count)
        while i < tiles.count - 1 {
            if tiles[i] == -1 {
                moveStep += 1
                move[i + 1] = moveStep
            } else {
                if tiles[i] == tiles[i + 1] {
                    moveStep += 1
                    tiles[i] *= 2
                    tiles[i + 1] = -1
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
    }
    
}
