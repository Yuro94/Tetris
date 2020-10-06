//
//  TetrisViewController.swift
//  Tetris
//
//  Created by Yurik Mnatsakanyan on 5/30/20.
//  Copyright © 2020 Yurik Mnatsakanyan. All rights reserved.
//

import UIKit

class TetrisViewController: UIViewController {
        
    private var gameView: GameViewProtocol!
    
    private var gameView1: GameViewProtocol!
    private var gameView2: GameViewProtocol!
    
    private var tapGesture: UITapGestureRecognizer!
    private var panGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGameView()
        addGestures()
    }
    
    private func setupGameView() {
        let xCordinate: CGFloat = 16
        let width: CGFloat = view.frame.width - 2 * xCordinate
        gameView = GameView(tetrisItemSize: 10, frame: CGRect(x: xCordinate, y: 80, width: width, height: width))

        if let gameViewUI = gameView as? GameView {
            view.addSubview(gameViewUI)
        }

//        gameView1 = GameView(tetrisItemSize: 10, frame: CGRect(x: 10, y: 80, width: 190, height: 300))
//        gameView2 = GameView(tetrisItemSize: 10, frame: CGRect(x: 210, y: 80, width: 190, height: 300))
        
//        if let gameViewUI1 = gameView1 as? GameView, let gameViewUI2 = gameView2 as? GameView {
//            view.addSubview(gameViewUI1)
//            view.addSubview(gameViewUI2)
//        }
    }
    
    private func addGestures() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_ :)))
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        if gesture.location(in: view).x <= view.frame.size.width / 2 {
            gameView.moveFastStart(to: .left)// must removed this code or change function name
            gameView.move(to: .left, speed: .slow)
            
//            gameView1.moveFastStart(to: .left)
//            gameView1.move(to: .left, speed: .slow)
//
//            gameView2.moveFastStart(to: .left)
//            gameView2.move(to: .left, speed: .slow)
        } else {
            gameView.moveFastStart(to: .right)// must removed this code or change function name
            gameView.move(to: .right, speed: .slow)
            
//            gameView1.moveFastStart(to: .right)
//            gameView1.move(to: .right, speed: .slow)
//
//            gameView2.moveFastStart(to: .right)
//            gameView2.move(to: .right, speed: .slow)
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let velocityX = gesture.velocity(in: view).x
        let velocityY = gesture.velocity(in: view).y
        
        if abs(velocityX) > velocityY {
            let toSide: Side = (velocityX < 0) ? .left : .right
            swipe(gesture, to: toSide)
        } else if velocityY > 0 {
            swipe(gesture, to: .down)
        }
    }
    
    private func swipe(_ gesture: UIPanGestureRecognizer, to side: Side) {
        switch gesture.state {
        case .began:
            gameView.moveFastStart(to: side)
            gameView.move(to: side, speed: .fast)
            
//            gameView1.moveFastStart(to: side)
//            gameView1.move(to: side, speed: .fast)
//
//            gameView2.moveFastStart(to: side)
//            gameView2.move(to: side, speed: .fast)
        case .ended:
            gameView.moveDidEnd(to: side)
            
//            gameView1.moveDidEnd(to: side)
//            gameView2.moveDidEnd(to: side)
        default:
            break
        }
    }
        
    private func reset() {
        if let gameViewUI = gameView as? UIView {
            gameViewUI.removeFromSuperview()
            gameView = nil
        }
        
//        if let gameViewUI1 = gameView1 as? UIView, let gameViewUI2 = gameView2 as? UIView {
//            gameViewUI1.removeFromSuperview()
//            gameViewUI2.removeFromSuperview()
//            gameView1 = nil
//            gameView2 = nil
//        }
    }
    
    @IBAction func newGame() {
        reset()
        setupGameView()
    }
    
    @IBAction func rotate(_ sender: UIButton) {
        let rotateToLeft: Side = (sender.tag == 1) ? .left : .right
        gameView.rotate(side: rotateToLeft)
        
//        gameView1.rotate(left: rotateToLeft)
//        gameView2.rotate(left: rotateToLeft)
        
    }
    
    @IBAction func move(_ sender: UIButton) {
        
    }
}
