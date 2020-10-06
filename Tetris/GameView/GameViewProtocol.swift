//
//  GameViewProtocol.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 6/18/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation
import UIKit

protocol GameViewProtocol: class {
    init(tetrisItemSize: CGFloat, frame: CGRect)
    
    func setup(tetrisItemSize: CGFloat)
    func move(to side: Side, speed: Speed)
    func moveDidEnd(to side: Side)
    func moveFastStart(to side: Side)
    func rotate(side: Side)
}
