//
//  ViewController.swift
//  YetAnother2048
//
//  Created by 宋 奎熹 on 2018/8/6.
//  Copyright © 2018 宋 奎熹. All rights reserved.
//

import UIKit

enum ActionDirection: Int {
    case left   = 0
    case up     = 1
    case down   = 2
    case right  = 3
}

class ViewController: UIViewController {
    
    @IBOutlet weak var boardView: UIView?
    @IBOutlet weak var scoreLabel: UILabel?
    
    var board = Board()
    
    var labelMatrix: [[UILabel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let upSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        upSwipeGesture.direction = .up
        self.view.addGestureRecognizer(upSwipeGesture)
        let downSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        downSwipeGesture.direction = .down
        self.view.addGestureRecognizer(downSwipeGesture)
        let leftSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        leftSwipeGesture.direction = .left
        self.view.addGestureRecognizer(leftSwipeGesture)
        let rightSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            board.left()
        case .right:
            board.right()
        case .up:
            board.up()
        case .down:
            board.down()
        default:
            break
        }
        setLabels()
        setScore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let boardView = self.boardView {
            let width = (UIScreen.main.bounds.size.width - 20) / CGFloat(Board.size)
            for i in 0..<Board.size {
                var tempLabels: [UILabel] = []
                for j in 0..<Board.size {
                    let label: UILabel = UILabel(frame: CGRect(x: 5 + CGFloat(j) * width,
                                                               y: 5 + CGFloat(i) * width,
                                                               width: width - 10,
                                                               height: width - 10))
                    label.tag = i * Board.size + j
                    label.textAlignment = .center
                    label.font = UIFont(name: "Futura", size: 40.0)
                    label.adjustsFontSizeToFitWidth = true
                    label.layer.cornerRadius = 5
                    label.layer.masksToBounds = true
                    label.backgroundColor = UIColor.lightGray
                    tempLabels.append(label)
                    boardView.addSubview(label)
                }
                labelMatrix.append(tempLabels)
            }
        }
        setLabels()
    }
    
    private func setLabels() {
        for i in 0..<Board.size {
            for j in 0..<Board.size {
                let val = board.tileMatrix[i][j]
                let label = labelMatrix[i][j]
                if val > 0 {
                    label.text = "\(val)"
                    label.backgroundColor = UIColor(red: 1.0 - (15.0 * log2(CGFloat(val))) / 255.0,
                                                    green: 1.0 - (15.0 * log2(CGFloat(val))) / 255.0,
                                                    blue: 1.0 - (15.0 * log2(CGFloat(val))) / 255.0,
                                                    alpha: 1.0)
                } else {
                    label.text = ""
                    label.backgroundColor = UIColor.clear
                }
            }
        }
    }
    
    private func setScore() {
        scoreLabel?.text = "\(board.score)"
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        switch ActionDirection(rawValue: sender.tag)! {
        case .left:
            board.left()
        case .up:
            board.up()
        case .down:
            board.down()
        case .right:
            board.right()
        }
        setLabels()
        setScore()
        if board.checkIsLose() {
            let alert = UIAlertController(title: "You Lose", message: "Final score: \(board.score)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                self.reset(nil)
            }))
            alert.addAction(UIAlertAction(title: "Give up", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func reset(_ sender: Any?) {
        board.reset()
        setLabels()
        setScore()
    }
    
}

