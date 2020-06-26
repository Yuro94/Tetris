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
    
    private var matrics: [[Int]]!
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
    
    
    private func createContentViewWithMultipleItemViews(for matrics: [[Int]]) {
        for i in 0..<matrics.count {
            for j in 0..<matrics[i].count {
                let xPosition = CGFloat(j) * itemSize
                let yPosition = CGFloat(i) * itemSize
                let matricsItemFrame = CGRect(x: xPosition, y: yPosition, width: itemSize, height: itemSize)
                let matricsItemView = UIView(frame: matricsItemFrame)
                
                
                let redColor: CGFloat = CGFloat(i * 2 + j * 1 + 10) / CGFloat(255)
                let greenColor: CGFloat = CGFloat(i * 3 + j * 2 + 20) / CGFloat(255)
                let blueColor: CGFloat = CGFloat(i * 1 + j * 2 + 15) / CGFloat(255)
                
                matricsItemView.backgroundColor = UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1)
                contentView.addSubview(matricsItemView)
                matricsItemViews.append(matricsItemView)
            }
        }
    }
    
    private func setupContentView() {
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: columnsCount * itemSize, height: rowsCount * itemSize))
        contentView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        addSubview(contentView)
        createContentViewWithMultipleItemViews(for: gameMatrics.matrics)
    }
    
    private func setupMatrics() {
        matrics = [[Int]].init(repeating: [Int].init(repeating: 0, count: Int(columnsCount)), count: Int(rowsCount))
        gameMatrics = Matrics(matrics)
    }
    
    private func markGameMatrics(for tetrisView: TetrisView) {
        for busyCoordinates in currentIJCompositions {
            let iCordinate = busyCoordinates[0]
            let jCordinate = busyCoordinates[1]
            var position = iCordinate * gameMatrics.matrics[iCordinate].count + jCordinate
            
            matricsItemViews[position].backgroundColor = (tetrisView.itemColor != nil) ? tetrisView.itemColor! : UIColor.red
        }
    }
    
    private func setupTetrisItem() {
        if tetrisView != nil {
            lastTetrisView = tetrisView
            
            markGameMatrics(for: lastTetrisView!)
            lastTetrisView!.removeFromSuperview()
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
    
    func moveDown(speed: Speed) {
        tetrisView.move(in: self, speed: speed, to: .down) { view in
            if view.finalCompletionCalled {
                return
            }
            
            self.tetrisView.finalCompletionCalled = true
            if self.superview != nil {
                self.setupTetrisItem()
            }
        }
    }
    
    func moveDidEnd(to side: Side) {
        tetrisView.moveDidEnd(to: side)
    }
    
    func rotate(left: Bool) {
        tetrisView.rotate(left: left)
    }
    
    func move(to side: Side, speed: Speed) {
        if side == .down {
            if speed == .fast {
                 tetrisView.moveDownOneStep = false
            }
            moveDown(speed: speed)
        } else {
            tetrisView.oneTapWork = true
            tetrisView.move(in: self, speed: speed, to: side, completion: nil)
        }
    }
    
    private func removeMatchesItems() {
        let matchesLines: [Int] = checkTetrisState()
        guard matchesLines.count > 0 else {
            return
        }
    }
    
    private func checkTetrisState() -> [Int] {
        var lines: [Int] = []
        let matrics = gameMatrics.matrics
        
        for i in 0..<matrics.count {
            var busyLine: [Int] = []
            for j in 0..<matrics[i].count {
                if matrics[i][j] == 1 {
                    busyLine.append(1)
                }
            }
            
            if busyLine.count == matrics[i].count {
                lines.append(i)
            }
        }
        return lines
        
    }
    
}
