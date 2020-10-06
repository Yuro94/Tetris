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
    
    public var matricsData: [[Int]] {
        return tetrisItem.matrics.matricsData
    }
    
    public var matrics: Matrics {
        return tetrisItem.matrics
    }
    
    public var finalCompletionCalled: Bool = false
    
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
        let countOfElements = CGFloat(currentTetrisItem.matrics.matricsData.count)
        
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
    }
    
    private func createTetrisView(for tetrisItem: TetrisItem) {
        let matrics = tetrisItem.matrics.matricsData
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

    func rotate(side: Side) {
        let clockWise: Bool = (side == .left) ? false : true
        tetrisItem.matrics.rotate(clockWise: clockWise, by: 1)
       
        setupTetrisItemsAgain()
    }
    
    public func setupTetrisItemsAgain() {
        reset()
        createTetrisView(for: tetrisItem)
    }
    
    private func reset() {
        for item in allTetrisItems {
            item.removeFromSuperview()
        }
    }
}
