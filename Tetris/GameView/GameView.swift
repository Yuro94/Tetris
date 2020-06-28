//
//  GameView.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 6/8/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import Foundation
import UIKit

class GameView: UIView, GameViewProtocol {
    
    private var itemSize: CGFloat = 10
    
    private var columnsCount: CGFloat {
        self.frame.width / itemSize
    }
    private var rowsCount: CGFloat {
        self.frame.height / itemSize
    }
    
    private var tetrisView: TetrisView!
    
    public var gameMatrics: Matrics!
    public var contentView: UIView!
    
    private var lastTetrisView: TetrisView?
    private var matricsItemViews: [UIView] = []
    public var currentIJCompositions: [[Int]] = []
    
    public var oneTapWork = true
    public var moveDownOneStep = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSetup()
    }
    
    required init(tetrisItemSize: CGFloat, frame: CGRect) {
        super.init(frame: frame)
        
        setup(tetrisItemSize: tetrisItemSize)
        initialSetup()
    }
    
    private func initialSetup() {
        setupMatrics()
        setupContentView()
        setupTetrisItem()
    }
    
    public func setup(tetrisItemSize: CGFloat) {
        itemSize = tetrisItemSize
    }
    
    private func createAddedTetrisView(in coordinate: [[Int]]) {
        
    }
    
    private func createContentViewWithMultipleItemViews(for cordinates: [[Int]]) {
        for i in 0..<cordinates.count {
                let xPosition = CGFloat(cordinates[i][1]) * itemSize
                let yPosition = CGFloat(cordinates[i][0]) * itemSize
                let matricsItemFrame = CGRect(x: xPosition, y: yPosition, width: itemSize, height: itemSize)
                let matricsItemView = UIView(frame: matricsItemFrame)
             
                matricsItemView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                matricsItemView.tag = cordinates[i][0]
                contentView.addSubview(matricsItemView)
                matricsItemViews.append(matricsItemView)
        }
    }
    
    private func setupContentView() {
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: columnsCount * itemSize, height: rowsCount * itemSize))
        contentView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        addSubview(contentView)
    }
    
    private func setupTetrisItem() {
        if tetrisView != nil {
            moveDownOneStep = true
            oneTapWork = true
//            markGameMatrics()
            tetrisView.removeFromSuperview()
        }
        
        let distance: CGFloat = 0
        var xPoint: CGFloat = 0
        
        var delta: CGFloat = 0
        let diff = center.x / 2 - itemSize
        
        while (Int(diff + delta) % Int(itemSize)) != 0 {
            delta -= 1
        }
        
        xPoint = diff + delta
        
        tetrisView = TetrisView(centerPoint: CGPoint(x: xPoint, y: 0), coloring: true, size: itemSize, distance: distance)
        
        var yPoint: CGFloat {
            return -tetrisView.height
        }
        tetrisView.frame.origin.y = yPoint
        contentView.addSubview(tetrisView)
        move(to: .down, speed: .slow)
    }
    
    func moveDidEnd(to side: Side) {
        switch side {
        case .down:
            moveDownOneStep = true
        case .left, .right:
            oneTapWork = false
        }
    }
    
    func rotate(left: Bool) {
        tetrisView.rotate(left: left)
    }
    
    private func removeMatchesItems() {
        let filledLines: [Int] = getFilledLines()
        guard filledLines.count > 0 else {
            return
        }
        print("Matrix View count --- \(matricsItemViews.count)")
        gameMatrics.existMatchesLines(to: filledLines.reversed())
        var removedViews: [UIView] = []
        
        for line in filledLines {
            for view in matricsItemViews {
                if view.tag == line {
                    removedViews.append(view)
                    view.removeFromSuperview()
                } else {
                    if view.frame.origin.y <= CGFloat(line) * itemSize {
                        view.frame.origin.y += itemSize
                    }
                }
            }
        }
        
        matricsItemViews.removeAll { (view) -> Bool in
            removedViews.contains(view)
        }
        
        print("Matrix View count after remove --- \(matricsItemViews.count)")
        
        for view in matricsItemViews {
            var incrementCount = 0
            for line in filledLines {
                if view.tag < line {
                    incrementCount += 1
                }
            }
            view.tag += incrementCount
        }
    }
    
    private func getFilledLines() -> [Int] {
        var lines: [Int] = []
        let matricsData = gameMatrics.matricsData
        
        for i in 0..<matricsData.count {
            var busyLine: [Int] = []
            for j in 0..<matricsData[i].count {
                if matricsData[i][j] == 1 {
                    busyLine.append(1)
                }
            }
            
            if busyLine.count == matricsData[i].count {
                lines.append(i)
            }
        }
        return lines
    }
    
    // Moved functions
    private func setupMatrics() {
        let matricsData = [[Int]].init(repeating: [Int].init(repeating: 0, count: Int(columnsCount)), count: Int(rowsCount))
        gameMatrics = Matrics(matricsData)
    }
    
//    private func markGameMatrics() {
//        for busyCoordinates in 0..<currentIJCompositions.count {
////            let iCordinate = currentIJCompositions[busyCoordinates][0]
////            let jCordinate = currentIJCompositions[busyCoordinates][1]
////            let position = iCordinate * gameMatrics.matricsData[iCordinate].count + jCordinate
//
////            matricsItemViews[position].backgroundColor = (tetrisView.itemColor != nil) ? tetrisView.itemColor! : UIColor.red
////            matricsItemViews[busyCoordinates].backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
//        }
//    }
    
    private func isPlaceSafe(for side: Side, cordinates: [[Int]]) -> Bool {
        if side == .down {
            if tetrisView.frame.origin.y + tetrisView.frame.size.height >= frame.size.height {
                return false
            }
        }
        
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
                if addedMatrics[1] + 1 < gameMatrics!.matricsData[0].count {
                    jCordinate = addedMatrics[1] + 1
                }
            }
            
            guard iCordinate >= 0, jCordinate >= 0 else {
                return true
            }
            
            if gameMatrics?.matricsData[iCordinate][jCordinate] == 0 {
                boolValue = true
            } else {
                return false
            }
        }
        return boolValue
    }
    
    private func changeMatricsPosition(to side: Side) -> Bool {
        var toSide: Bool = true
        switch side {
        case .left:
            toSide = true
        case .right:
            toSide = false
        default:
            break
        }
        
        if isPlaceSafe(for: side, cordinates: getAllBusyCordinates()) {
            if tetrisView.matrics.mustMoveMatrics(left: toSide) {
                tetrisView.setupTetrisItemsAgain()
                return true
            }
        }
        
        return false
    }
    
    private func canMove(to side: Side) -> Bool {
        switch side {
        case .left:
            return tetrisView.frame.origin.x > 0
        case .right:
            return tetrisView.frame.origin.x + tetrisView.frame.size.width < contentView.frame.size.width
        default:
            break
        }
        return false
    }
    
    private func getAllBusyCordinates() -> [[Int]] {
        let tetrisMatrics = tetrisView.matricsData
        var busyCordinates: [[Int]] = []
        
        for i in 0..<tetrisMatrics.count {
            for j in 0..<tetrisMatrics[i].count {
                if tetrisMatrics[i][j] == 1 {
                    let jCordinate = Int(tetrisView.frame.origin.x / itemSize) + j
                    let iCordinate = Int(tetrisView.frame.origin.y / itemSize) + i
                    busyCordinates.append([iCordinate, jCordinate])
                }
            }
        }
        return busyCordinates
    }
    
    private func changeGameMatrics(with cordinates: [[Int]]) {
        currentIJCompositions = cordinates
        for i in 0..<cordinates.count {
            var addedMatrics: [Int] = []
            for j in cordinates[i] {
                addedMatrics.append(j)
            }
            gameMatrics?.matricsData[addedMatrics[0]][addedMatrics[1]] = 1
        }
    }
    
    // MARK: -- Move actions
    
    func move(to side: Side, speed: Speed) {
        switch side {
        case .down:
            if speed == .fast {
                moveDownOneStep = false
            }
            moveDown(speed: speed) {
                self.removeMatchesItems()
                if self.superview != nil {
                    self.setupTetrisItem()
                }
            }
        case .left, .right:
            oneTapWork = true
            moveHorizontal(to: side, speed: speed)
        }
    }
    
    private func moveDown(speed: Speed, completion: @escaping() -> Void) {
        if !isPlaceSafe(for: .down, cordinates: getAllBusyCordinates()) {
            changeGameMatrics(with: getAllBusyCordinates())
            createContentViewWithMultipleItemViews(for: getAllBusyCordinates())
            completion()
            return
        }
        
        let animTime: TimeInterval = moveDownOneStep ? 1 : 0.01
        moveDownOneStep(animTime: animTime) {
            self.moveDown(speed: speed , completion: completion)
        }
    }
    
    private func moveDownOneStep(animTime: TimeInterval, completion: @escaping () -> Void) {
        self.tetrisView.layer.removeAllAnimations()
        UIView.animate(withDuration: animTime, animations: {
            self.tetrisView.center = CGPoint(x: self.tetrisView.center.x, y: self.tetrisView.center.y + self.itemSize)
        }) { finished in
            if finished {
                completion()
            }
        }
    }
    
    private func moveHorizontal(to side: Side, speed: Speed) {
        if changeMatricsPosition(to: side) {
            if speed == .slow {
                return
            }
        }
        
        if !isPlaceSafe(for: side, cordinates: getAllBusyCordinates()) || !canMove(to: side) || !oneTapWork {
            return
        }
        
        moveHorizontal(to: side, speed: speed) {
            self.moveHorizontal(to: side, speed: speed)
        }
    }
    
    private func moveHorizontal(to side: Side, speed: Speed, completion: @escaping () -> Void) {
        let xPosition: CGFloat = (side == .left) ? tetrisView.center.x - itemSize : tetrisView.center.x + itemSize
        
        let animTime: TimeInterval = (speed == .slow) ? 0.1 : 0
        UIView.animate(withDuration: animTime, animations: {
            self.tetrisView.center = CGPoint(x: xPosition, y: self.tetrisView.center.y)
        }) { (_) in
            if speed == .fast  {
                completion()
            }
        }
    }
}
