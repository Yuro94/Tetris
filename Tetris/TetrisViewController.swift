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
    
    private var tapGesture: UITapGestureRecognizer!
    private var panGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGameView()
        addGestures()
    }
    
    private func setupGameView() {
        gameView = GameView(tetrisItemSize: 10, frame: CGRect(x: 100, y: 50, width: 240, height: 320))
        
        if let gameViewUI = gameView as? GameView {
            view.addSubview(gameViewUI)
        }
    }
    
    private func addGestures() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_ :)))
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        if gesture.location(in: view).x <= view.frame.size.width / 2 {
            gameView.move(to: .left, speed: .slow)
        } else {
            gameView.move(to: .right, speed: .slow)
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let velocityX = gesture.velocity(in: view).x
        let velocityY = gesture.velocity(in: view).y
        
        if velocityX > velocityY || (-1) * velocityX > velocityY {
            if velocityX < 0 {
                swipe(gesture, to: .left)
            } else if velocityX > 0 {
                swipe(gesture, to: .right)
            }
        } else if velocityY > 0 {
            swipe(gesture, to: .down)
        }
    }
    
    private func swipe(_ gesture: UIPanGestureRecognizer, to side: Side) {
        switch gesture.state {
        case .began:
            gameView.move(to: side, speed: .fast)
        case .ended:
            gameView.moveDidEnd(to: side)
        default:
            break
        }
    }
        
    private func reset() {
        if let gameViewUI = gameView as? UIView {
            gameViewUI.removeFromSuperview()
            gameView = nil
        }
    }
    
    @IBAction func newGame() {
        reset()
        setupGameView()
    }
    
    @IBAction func rotate(_ sender: UIButton) {
        let rotateToLeft: Bool = (sender.tag == 1) ? true : false
        gameView.rotate(left: rotateToLeft)
        
    }
    
    @IBAction func move(_ sender: UIButton) {
        
    }
}
