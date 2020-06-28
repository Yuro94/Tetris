//
//  Matrics.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 6/1/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation

class Matrics {
    public var matricsData: [[Int]] = []
    
    public var count: Int = 0
    
    init(_ matrics: [[Int]]) {
        self.matricsData = matrics
        self.count = matrics.count
    }
    
    public func rotate(clockWise: Bool = true, by: Int = 1) {
        var result: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: matricsData.count), count: matricsData.count)
        var changedResult: [[Int]] = matricsData
        
        for _ in 0..<by {
            for i in 0..<changedResult.count {
                for j in 0..<changedResult.count {
                    result[i][j] = clockWise ? changedResult[changedResult.count - 1 - j][i] : changedResult[j][changedResult.count - 1 - i]
                }
            }
            changedResult = result
        }
        
        matricsData = moveDownMatrixIfPossible(matrics: changedResult)
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
        var changedMatrix = matricsData
        for i in 0..<matricsData.count {
            for j in 0..<matricsData[i].count {
                if left {
                    if matricsData[i][0] != 0 {
                        return false
                    }
                    if j == matricsData.count - 1 {
                        changedMatrix[i][j] = matricsData[i][0]
                    } else {
                        changedMatrix[i][j] = matricsData[i][j + 1]
                    }
                } else {
                    if matricsData[i][matricsData.count - 1] != 0 {
                        return false
                    }
                    if j == 0 {
                        changedMatrix[i][j] = matricsData[i][matricsData.count - 1]
                    } else {
                        changedMatrix[i][j] = matricsData[i][j - 1]
                    }
                }
            }
        }
        
        matricsData = changedMatrix
        return true
    }
    
    public func existMatchesLines(to lines: [Int]) {
        var changedMatricsData = matricsData
        
        var incrementCount = 0
        var cachedMatricsData = matricsData
        var sortedLines = lines
        sortedLines.sort(by: >)
        for line in sortedLines {
            for i in 0...(line + incrementCount){
                for j in 0..<matricsData[i].count {
                    if i <= incrementCount {
                        changedMatricsData[i][j] = 0
                    } else {
                        changedMatricsData[i][j] = cachedMatricsData[i - 1][j]
                    }
                }
            }
            cachedMatricsData = changedMatricsData
            incrementCount += 1
        }
        
        matricsData = changedMatricsData
    }
    
}

extension Matrics: CustomStringConvertible {
    public var description: String {
        return "\(matricsData)"
    }
}
