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
    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var gameModel = GameModel()
    var labelMatrix: [[UILabel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let upSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        upSwipeGesture.direction = .up
        view.addGestureRecognizer(upSwipeGesture)
        let downSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        downSwipeGesture.direction = .down
        view.addGestureRecognizer(downSwipeGesture)
        let leftSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)
        let rightSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        
        if let model = GameHelper.shared.loadGame() {
            let alert = UIAlertController(title: "Unfinished game", message: "There is an unfinished game, do you want to continue?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Never mind", style: .cancel))
            alert.addAction(UIAlertAction(title: "Go on", style: .default, handler: { _ in
                DispatchQueue.main.async { [weak self] in
                    self?.gameModel = model
                    self?.setModel()
                }
            }))
            present(alert, animated: true)
        }
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            gameModel.left()
        case .right:
            gameModel.right()
        case .up:
            gameModel.up()
        case .down:
            gameModel.down()
        default:
            break
        }
        setModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let width = (UIScreen.main.bounds.size.width - 20) / CGFloat(GameModel.size)
        for i in 0..<GameModel.size {
            var tempLabels: [UILabel] = []
            for j in 0..<GameModel.size {
                let label: UILabel = UILabel(frame: CGRect(x: 5 + CGFloat(j) * width,
                                                           y: 5 + CGFloat(i) * width,
                                                           width: width - 10,
                                                           height: width - 10))
                label.tag = i * GameModel.size + j
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
        setModel()
    }
    
    private func setModel() {
        for i in 0..<GameModel.size {
            for j in 0..<GameModel.size {
                let val = gameModel.tileMatrix[i][j]
                let label = labelMatrix[i][j]
                if val > 0 {
                    label.text = "\(val)"
                    label.backgroundColor = UIColor(red: 1.0 - (15.0 * log2(CGFloat(val))) / 255.0,
                                                    green: 1.0 - (15.0 * log2(CGFloat(val))) / 255.0,
                                                    blue: 1.0 - (15.0 * log2(CGFloat(val))) / 255.0,
                                                    alpha: 1.0)
                } else {
                    label.text = ""
                    label.backgroundColor = .clear
                }
            }
        }
        scoreLabel.text = "\(gameModel.score)"
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        switch ActionDirection(rawValue: sender.tag)! {
        case .left:
            gameModel.left()
        case .up:
            gameModel.up()
        case .down:
            gameModel.down()
        case .right:
            gameModel.right()
        }
        setModel()
        if gameModel.checkIsLose() {
            GameHelper.shared.setNoGameSaved()
            let alert = UIAlertController(title: "You lose", message: "Final score: \(gameModel.score)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [weak self] _ in
                self?.reset(nil)
            }))
            alert.addAction(UIAlertAction(title: "Give up", style: .cancel))
            present(alert, animated: true)
        }
    }

    @IBAction func reset(_ sender: Any?) {
        gameModel = GameModel()
        gameModel.reset()
        setModel()
        GameHelper.shared.setNoGameSaved()
    }
    
}
