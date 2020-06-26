//
//  TetrisView.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 6/5/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation
import UIKit

class TetrisView: UIView, TetrisViewProtocol {
    private var tetrisItem: TetrisItem!
    private var withMultipleColor: Bool = true
    private var tetrisItemSize: CGFloat = 40
    private var distanceBetwenItems: CGFloat = 0.5
    private var contentView: UIView!
    private let itemsBorderWidth: CGFloat = 0
    private var itemsCount: Int = 0
    private var allTetrisItems: [UIView] = []
    
    public var finalCompletionCalled: Bool = false
    
    public var oneTapWork = true
    public var moveDownOneStep = true
    
    public var additionalBordersSize: CGFloat {
        return CGFloat(itemsCount) * itemsBorderWidth
    }
    
    public var itemsCounts: CGFloat {
        return CGFloat(itemsCount)
    }
    
    public var height: CGFloat = 0
    public var itemColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContentView()
        getRandomTetrisItem(with: RandomTetrisGenerator().getTetrisItem(coloring: withMultipleColor))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupContentView()
        getRandomTetrisItem(with: RandomTetrisGenerator().getTetrisItem(coloring: withMultipleColor))
    }
    
    required public init(centerPoint: CGPoint, coloring: Bool, size: CGFloat, distance: CGFloat) {
        let currentTetrisItem = RandomTetrisGenerator().getTetrisItem(coloring: withMultipleColor)
        let countOfElements = CGFloat(currentTetrisItem.matrics.matrics.count)
        
        super.init(frame: CGRect(x: centerPoint.x, y: centerPoint.y, width: size * countOfElements, height: size * countOfElements))
        
        set(size: size, distance: distance, withMultipleColor: coloring)
        setupContentView()
        getRandomTetrisItem(with: currentTetrisItem)
    }
    
    private func setupContentView() {
        contentView = UIView(frame: bounds)
        addSubview(contentView)
    }
    
    private func getRandomTetrisItem(with item: TetrisItem) {
        tetrisItem = item
        createTetrisView(for: tetrisItem)
    }
    
    private func findeTetrisItemHeight(for matrics: [[Int]]) {
        var currentHeiht = 0
        var nulLines = 0
        var nulLinesOver = true
        
        for i in 0..<matrics.count {
            currentHeiht = 0
            for j in 0..<matrics[i].count {
                if nulLinesOver {
                    if matrics[i][j] == 0 {
                        currentHeiht += 1
                    } else {
                        nulLinesOver = false
                    }
                }
            }
            
            if currentHeiht == matrics[i].count {
                nulLines += 1
            }
        }
        height = CGFloat(nulLines) * tetrisItemSize
        print(nulLines)
    }
    
    private func createTetrisView(for tetrisItem: TetrisItem) {
        let matrics = tetrisItem.matrics.matrics
        findeTetrisItemHeight(for: matrics)
        itemColor = tetrisItem.color
        for i in 0..<matrics.count {
            for j in 0..<matrics[i].count {
                if matrics[i][j] != 0 {
                    let xPosition = CGFloat(j) * (tetrisItemSize + distanceBetwenItems)
                    let yPosition = CGFloat(i) * (tetrisItemSize + distanceBetwenItems)
                    let tetrisFrame = CGRect(x: xPosition, y: yPosition, width: tetrisItemSize, height: tetrisItemSize)
                    
                    setupTetrisView(frame: tetrisFrame)
                }
            }
        }
    }
    
    private func setupTetrisView(frame: CGRect) {
        let itemView = UIView(frame: frame)
        itemView.backgroundColor = tetrisItem.color
        itemView.layer.borderColor = UIColor.green.cgColor
        itemView.layer.borderWidth = itemsBorderWidth
        itemsCount += 1
        allTetrisItems.append(itemView)
        contentView.addSubview(itemView)
    }
    
    public func set(size: CGFloat, distance: CGFloat, withMultipleColor: Bool) {
        tetrisItemSize = size
        distanceBetwenItems = distance
        self.withMultipleColor = withMultipleColor
    }
    
    // MARK: -- Protocol methods
    func move(in gameView: GameView, speed: Speed, to side: Side, completion: ((TetrisView) -> Void)?) {
        switch side {
        case .down:
            moveDown(in: gameView, speed: speed, completion: completion!)
        case .left, .right:
            moveHorizontal(to: side, in: gameView, speed: speed)
        }
    }
    
    func moveDidEnd(to side: Side) {
        switch side {
        case .down:
            moveDownOneStep = true
        case .left, .right:
            oneTapWork = false
        }
    }
    
    private func moveDown(in gameView: GameView, speed: Speed, completion: @escaping(TetrisView) -> Void) {
        if finalCompletionCalled {
            return
        }
        if !isPlaceSafe(for: .down, cordinates: getAllBusyCordinates(in: gameView), in: gameView) {
            changeGameMatrics(with: getAllBusyCordinates(in: gameView), in: gameView)
            completion(self)
            return
        }
        
        let animTime: TimeInterval = moveDownOneStep ? 1 : 0.01
        moveDown(animTime: animTime) {
            self.moveDown(in: gameView, speed: speed , completion: completion)
        }
    }
    
    private func moveDown(animTime: TimeInterval, completion: @escaping () -> Void) {
        self.layer.removeAllAnimations()
        UIView.animate(withDuration: animTime, animations: {
            self.center = CGPoint(x: self.center.x, y: self.center.y + self.tetrisItemSize)
        }) { finished in
            if finished {
                completion()
            }
        }
    }
    
    private func canMoveDown(in gameView: GameView) -> Bool {
        return frame.origin.y + frame.size.height < gameView.frame.size.height
    }
    
    private func getAllBusyCordinates(in gameView: GameView) -> [[Int]] {
        let tetrisMatrics = tetrisItem.matrics.matrics
        var busyCordinates: [[Int]] = []
        
        for i in 0..<tetrisMatrics.count {
            for j in 0..<tetrisMatrics[i].count {
                if tetrisMatrics[i][j] == 1 {
                    let jCordinate = Int(frame.origin.x / tetrisItemSize) + j
                    let iCordinate = Int(frame.origin.y / tetrisItemSize) + i
                    busyCordinates.append([iCordinate, jCordinate])
                }
            }
        }
        return busyCordinates
    }
    
    private func changeGameMatrics(with cordinates: [[Int]], in gameView: GameView) {
        let gameMatrics = gameView.gameMatrics
        gameView.currentIJCompositions = []
        for i in 0..<cordinates.count {
            var addedMatrics: [Int] = []
            for j in cordinates[i] {
                addedMatrics.append(j)
            }
            gameMatrics?.matrics[addedMatrics[0]][addedMatrics[1]] = 1
            
            gameView.currentIJCompositions.append([addedMatrics[0], addedMatrics[1]])
        }
    }
    
    private func isPlaceSafe(for side: Side, cordinates: [[Int]], in gameView: GameView) -> Bool {
        
        if frame.origin.y + frame.size.height >= gameView.frame.size.height {
            return false
        }
        
        let gameMatrics = gameView.gameMatrics
        var boolValue = true
        
        for i in 0..<cordinates.count {
            var addedMatrics: [Int] = []
            for j in cordinates[i] {
                addedMatrics.append(j)
            }
            
            var iCordinate = addedMatrics[0]
            var jCordinate = addedMatrics[1]
            
            switch side {
            case .down:
                iCordinate = addedMatrics[0] + 1
                jCordinate = addedMatrics[1]
            case .left:
                iCordinate = addedMatrics[0]
                if addedMatrics[1] - 1 >= 0 {
                    jCordinate = addedMatrics[1] - 1
                }
            case .right:
                iCordinate = addedMatrics[0]
                if addedMatrics[1] + 1 < gameMatrics!.matrics[0].count {
                    jCordinate = addedMatrics[1] + 1
                }
            }
            
            guard iCordinate >= 0, jCordinate >= 0 else {
                return true
            }
            
            if gameMatrics?.matrics[iCordinate][jCordinate] == 0 {
                boolValue = true
            } else {
                return false
            }
        }
        return boolValue
    }
    
    private func changeMatricsPosition(to side: Side, in gameView: GameView) -> Bool {
        var toSide: Bool = true
        switch side {
        case .left:
            toSide = true
        case .right:
            toSide = false
        default:
            break
        }
        
        if isPlaceSafe(for: side, cordinates: getAllBusyCordinates(in: gameView), in: gameView) {
            if tetrisItem.matrics.mustMoveMatrics(left: toSide) {
                setupTetrisItemsAgain()
                return true
            }
        }
        
        return false
    }
    
    private func moveHorizontal(to side: Side, in gameView: GameView, speed: Speed) {
        if changeMatricsPosition(to: side, in: gameView) {
            if speed == .slow {
                return
            }
        }
        
        if !isPlaceSafe(for: side, cordinates: getAllBusyCordinates(in: gameView), in: gameView) || !canMove(to: side, in: gameView) || !oneTapWork {
            return
        }
        
        move(to: side, speed: speed) {
            self.moveHorizontal(to: side, in: gameView, speed: speed)
        }
    }
    
    private func move(to side: Side, speed: Speed, completion: @escaping () -> Void) {
        let xPosition: CGFloat = (side == .left) ? center.x - tetrisItemSize : center.x + tetrisItemSize
        
        let animTime: TimeInterval = (speed == .slow) ? 0.1 : 0
        
        UIView.animate(withDuration: animTime, animations: {
            self.center = CGPoint(x: xPosition, y: self.center.y)
        }) { (_) in
            if speed == .fast  {
                completion()
            }
        }
    }
    
    private func canMove(to side: Side, in gameView: GameView) -> Bool {
        switch side {
        case .left:
            return frame.origin.x > 0
        case .right:
            return frame.origin.x + frame.size.width < gameView.contentView.frame.size.width
        default:
            break
        }
        return false
    }
    
    func rotate(left: Bool) {
        if left {
            tetrisItem.matrics.rotate(clockWise: false, by: 1)
        } else {
            tetrisItem.matrics.rotate(clockWise: true, by: 1)
        }
        setupTetrisItemsAgain()
    }
    
    private func setupTetrisItemsAgain() {
        reset()
        createTetrisView(for: tetrisItem)
    }
    
    private func reset() {
        for item in allTetrisItems {
            item.removeFromSuperview()
        }
    }
}
