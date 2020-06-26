//
//  RandomTetrisGenerator.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 6/2/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation

class RandomTetrisGenerator {
    private var tetris: TetrisItem!
    
    func getTetrisItem(coloring: Bool = false) -> TetrisItem {
        let rotationCount = generateRandomNumber(from: 0, to: 3)
        let matrics = Matrics(generateRandomTetris())
        matrics.rotate(by: rotationCount)
        tetris = coloring ? TetrisItem(matrics: matrics, color: TetrisColor.randomColor()) : TetrisItem(matrics: matrics)
        
        return tetris
    }
    
    private func generateRandomNumber(from: Int, to: Int) -> Int {
        return Int.random(in: from...to)
    }
    
    private func generateRandomTetris() -> [[Int]] {
        let allTetrisItems: [[[Int]]] = TetrisType.allInitialMatrix
        
        let randomIndex = generateRandomNumber(from: 0, to: allTetrisItems.count - 1)
        
        return allTetrisItems[randomIndex]
    }
    
}
