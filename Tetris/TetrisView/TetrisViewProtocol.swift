//
//  TetrisViewProtocol.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 6/18/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation
import UIKit

protocol TetrisViewProtocol: class {
    var finalCompletionCalled: Bool { get set }

    init(centerPoint: CGPoint, coloring: Bool, size: CGFloat, distance: CGFloat)
    
    func move(in gameView: GameView, speed: Speed, to side: Side, completion: ((TetrisView) -> Void)?)
    func rotate(left: Bool)
    func moveDidEnd(to side: Side)
}
