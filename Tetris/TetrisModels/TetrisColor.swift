//
//  TetrisColor.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 6/2/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation
import UIKit

enum TetrisColor: Int, CaseIterable {
    case red = 0, green, blue, orange, gray
    
    static func randomColor() -> UIColor {
        let randomIndex = Int.random(in: 0..<self.allCases.count)
        let tetrisColor = TetrisColor(rawValue: randomIndex)
        let currentColor = tetrisColor != nil ? tetrisColor!.value : self.green.value
        return currentColor
    }
    
}

extension TetrisColor {
    var value: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        case .orange:
            return UIColor.orange
        case .green:
            return UIColor.green
        case .gray:
            return UIColor.gray
        }
    }
}
