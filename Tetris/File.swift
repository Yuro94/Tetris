//
//  File.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 6/8/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation
import UIKit

class Queen {
    var row: Int = 1
    var column: Int = 1
    var positions: [[Int]] = [[]]
    
    init() {}
}

extension Queen: CustomStringConvertible {
    public var description: String {
        return "Row -- \(row), Column --- \(column)"
    }
}

class Chees {
    var cheesCount: Int = 8
    var queens: [Queen] = []
    var chees: [[Int]] = [[]]
    
    init(cheesCount: Int) {
        setupInitialValues()
    }
    
    private func setupInitialValues() {
        queens = [Queen].init(repeating: Queen(), count: cheesCount)
        chees = [[Int]].init(repeating: [Int].init(repeating: 0, count: cheesCount), count: cheesCount)
        setup(in: chees)
    }
    
    private func setup(in matrics: [[Int]]) {
        for i in 0..<matrics.count {
            for j in 0..<matrics.count {
                setupQueensPlaces(row: i, column: j)
            }
        }
        print(queens)
    }
    
    private func setupQueensPlaces(row: Int, column: Int) {
        for queen in queens {
            if queen.row == row {
                return
            }
            
            if queen.column == column {
                return
            }
            
            if !queen.positions.contains([row, column]) {
                queen.positions = findPositions(row: row, column: column, allCount: cheesCount)
                print(queen.positions)
                queen.row = row
                queen.column = column
            }
        }
    }
    
    private func findPositions(row: Int, column: Int, allCount: Int) -> [[Int]] {
        var positions: [[Int]] = [[]]
        
        var currentRow = row
        var currentColumn = column
        
        while currentRow >= 0 && currentColumn >= 0 {
            positions.append([currentRow, currentColumn])
            currentRow -= 1
            currentColumn -= 1
        }
        
        currentRow = row
        currentColumn = column
        
        while currentRow >= 0 && currentColumn <= allCount {
            positions.append([currentRow, currentColumn])
            currentRow -= 1
            currentColumn += 1
        }
        
        currentRow = row
        currentColumn = column
        
        while currentRow <= allCount && currentColumn >= 0 {
            positions.append([currentRow, currentColumn])
            currentRow += 1
            currentColumn -= 1
        }
        
        currentRow = row
        currentColumn = column
        
        while currentRow <= allCount && currentColumn <= allCount {
            positions.append([currentRow, currentColumn])
            currentRow += 1
            currentColumn += 1
        }
        
        return positions
    }
    
    
}
