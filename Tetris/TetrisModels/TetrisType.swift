//
//  TetrisModel.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 6/1/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation

enum TetrisType {
    case squareType
    case lineType
    case tType
    case lType
    case jType
    case zType
    case sType
    
    static var squareMatrix: [[Int]] {
        return [[1, 1],
                [1, 1]]
    }
    
    static var lineMatrix: [[Int]] {
        return [[0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [1, 1, 1, 1]]
    }
    
    static var tMatrix: [[Int]] {
        return [[0, 0, 0],
                [1, 1, 1],
                [0, 1, 0]]
    }
    
    static var lMatrix: [[Int]] {
        return [[0, 1, 0],
                [0, 1, 0],
                [0, 1, 1]]
    }
    
    static var jMatrix: [[Int]] {
        return [[0, 0, 1],
                [0, 0, 1],
                [0, 1, 1]]
    }
    
    static var zMatrix: [[Int]] {
        return [[0, 0, 1],
                [0, 1, 1],
                [0, 1, 0]]
    }
    
    static var sMatrix: [[Int]] {
        return [[0, 1, 0],
                [0, 1, 1],
                [0, 0, 1]]
    }
    
    static var allInitialMatrix: [[[Int]]] {
        return [squareMatrix, lineMatrix, tMatrix, lMatrix, jMatrix, zMatrix, sMatrix]
//        return [lineMatrix]
        
    }
}
