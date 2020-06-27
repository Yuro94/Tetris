//
//  TetrisItem.swift
//  TetrisItem
//
//  Created by Yurik Mnatsakanyan on 6/1/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation
import UIKit

class TetrisItem {
    public var matrics: Matrics
    public var color: UIColor
    
    public init(matrics: Matrics, color: UIColor = TetrisColor.gray.value ) {
        self.matrics = matrics
        self.matrics.matricsData = matrics.moveDownMatrixIfPossible(matrics: matrics.matricsData)
//        self.matrics.matrics = matrics.moveUpMatrics(matrics: matrics.matrics)
        self.color = color
    }
    
}
