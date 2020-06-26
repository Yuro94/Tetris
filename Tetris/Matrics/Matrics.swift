//
//  Matrics.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 6/1/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation

class Matrics {
    public var matrics: [[Int]] = []
    
    public var count: Int = 0
    
    init(_ matrics: [[Int]]) {
        self.matrics = matrics
        self.count = matrics.count
    }
    
    public func rotate(clockWise: Bool = true, by: Int = 1) {
        var result: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: matrics.count), count: matrics.count)
        var changedResult: [[Int]] = matrics
        
        for _ in 0..<by {
            for i in 0..<changedResult.count {
                for j in 0..<changedResult.count {
                    result[i][j] = clockWise ? changedResult[changedResult.count - 1 - j][i] : changedResult[j][changedResult.count - 1 - i]
                }
            }
            changedResult = result
        }
        
        matrics = moveDownMatrixIfPossible(matrics: changedResult)
    }

    public func moveDownMatrixIfPossible(matrics: [[Int]]) -> [[Int]] {
        var allNullLines = 0
        var nullElementsCount = 0
        var changedMatrics: [[Int]] = matrics
        var cachedMatrics = matrics
        
            for i in (1..<matrics.count).reversed() {
            nullElementsCount = 0
            for j in 0..<matrics[i].count {
                if i == (matrics.count - 1) {
                    if matrics[i][j] != 0 {
                        return matrics
                    }
                }
                if matrics[i][j] == 0 {
                    nullElementsCount += 1
                }
            }
            if nullElementsCount == matrics.count {
                allNullLines += 1
            }
        }
        
        for _ in 0..<allNullLines {
            for i in 0..<matrics.count {
                for j in 0..<matrics.count {
                    if i == 0 {
                        changedMatrics[i][j] = cachedMatrics[cachedMatrics.count - 1][j]
                    } else {
                        changedMatrics[i][j] = cachedMatrics[i - 1][j]
                    }
                }
            }
            cachedMatrics = changedMatrics
        }
        return changedMatrics
    }
    
    public func mustMoveMatrics(left: Bool) -> Bool {
        var changedMatrix = matrics
        for i in 0..<matrics.count {
            for j in 0..<matrics[i].count {
                if left {
                    if matrics[i][0] != 0 {
                        return false
                    }
                    if j == matrics.count - 1 {
                        changedMatrix[i][j] = matrics[i][0]
                    } else {
                        changedMatrix[i][j] = matrics[i][j + 1]
                    }
                } else {
                    if matrics[i][matrics.count - 1] != 0 {
                        return false
                    }
                    if j == 0 {
                        changedMatrix[i][j] = matrics[i][matrics.count - 1]
                    } else {
                        changedMatrix[i][j] = matrics[i][j - 1]
                    }
                }
            }
        }
        
        matrics = changedMatrix
        return true
    }
    
}

extension Matrics: CustomStringConvertible {
    public var description: String {
        return "\(matrics)"
    }
}
