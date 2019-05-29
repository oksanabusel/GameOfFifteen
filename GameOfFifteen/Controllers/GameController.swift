//
//  ViewController.swift
//  GameOfFifteen
//
//  Created by Cat on 5/28/19.
//  Copyright © 2019 Oksana. All rights reserved.
//

import UIKit

class GameController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popupYConstraint: NSLayoutConstraint!
    
    private var puzzleArray:       [UIView] = []
    private let puzzleWidth:        Int     = 75
    private let puzzleHeight:       Int     = 75
    private let containerViewWidth: CGFloat = 300
    
    struct Segues {
        static let winControllerSegue = "winControllerSegue"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        self.createArrayOfViews()
    }
    
    @discardableResult
    func createArrayOfViews() -> Array<UIView> {
        var viewsArray: [UIView] = []
        
        for i in 1...15 {
            let view = UIView()
            view.tag = i
            viewsArray.append(view)
        }
        return createGamePuzzle(inputArray: viewsArray)
    }
    
    func createGamePuzzle(inputArray: Array<UIView>) -> Array<UIView> {
        self.containerView.subviews.forEach({$0.removeFromSuperview()})
        let resultArray = inputArray.shuffled()

        var xConstraint: CGFloat = containerView.bounds.minX
        var yConstraint: CGFloat = containerView.bounds.minY
        
        var counter = 0
        
        for i in 1...15 {
            let numberOfItem = i - 1
            let view = resultArray[numberOfItem]
            
            view.frame = CGRect(x: Int(xConstraint),
                                y: Int(yConstraint),
                            width: puzzleWidth,
                           height: puzzleHeight)
            
            let tag = view.tag
            self.containerView.addSubview(view)
            
            let image       = UIImage(named: String(tag))
            let imageView   = UIImageView(image: image)
            imageView.frame = CGRect(x: 0,
                                     y: 0,
                                 width: puzzleWidth,
                                height: puzzleHeight)
            
            self.containerView.viewWithTag(tag)?.addSubview(imageView)
            
            counter     += 1
            xConstraint += 75
            
            if counter == 4 {
                counter = 0
                xConstraint = 0
                yConstraint += 75
            }
        }
        return addGesture(inputArray: resultArray)
    }
    
    func addGesture(inputArray: Array<UIView>) -> Array<UIView> {
        for item in inputArray {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            let swipeLeft  = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            let swipeUp    = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            let swipeDown  = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            swipeLeft.direction  = UISwipeGestureRecognizer.Direction.left
            swipeDown.direction  = UISwipeGestureRecognizer.Direction.down
            swipeUp.direction    = UISwipeGestureRecognizer.Direction.up
            
            item.addGestureRecognizer(swipeRight)
            item.addGestureRecognizer(swipeLeft)
            item.addGestureRecognizer(swipeUp)
            item.addGestureRecognizer(swipeDown)
        }
        puzzleArray = inputArray
        return inputArray
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizer.Direction.right:
                if swipeGesture.view?.frame.maxX != containerViewWidth {
                    var isPossibleToMovePuzzle = true
                    for i in puzzleArray {
                        if i.frame.origin.y == swipeGesture.view?.frame.origin.y {
                            if i.frame.origin.x == (swipeGesture.view?.frame.origin.x)! + CGFloat(puzzleWidth) {
                                isPossibleToMovePuzzle = false
                            }
                        }
                    }
                    
                    if isPossibleToMovePuzzle {
                        swipeGesture.view?.frame.origin.x += CGFloat(puzzleWidth)
                        
                        if WinService.isCorrectSubviewsPosition(containerView: containerView) {
                            performSegue(withIdentifier: "winControllerSegue", sender: self)
                        }
                    }

                }
                
            case UISwipeGestureRecognizer.Direction.down:
                if swipeGesture.view?.frame.maxY != containerViewWidth {
                    var isPossibleToMovePuzzle = true
                    for i in puzzleArray {
                        if i.frame.origin.x == swipeGesture.view?.frame.origin.x {
                            if i.frame.origin.y == (swipeGesture.view?.frame.origin.y)! + CGFloat(puzzleHeight) {
                                isPossibleToMovePuzzle = false
                            }
                        }
                    }
                    
                    if isPossibleToMovePuzzle {
                        swipeGesture.view?.frame.origin.y += CGFloat(puzzleWidth)
                       
                        if WinService.isCorrectSubviewsPosition(containerView: containerView) {
                            performSegue(withIdentifier: "winControllerSegue", sender: self)
                        }
                    }
                }
                
            case UISwipeGestureRecognizer.Direction.left:
                if swipeGesture.view?.frame.minX != 0 {
                    var isPossibleToMovePuzzle = true
                    for i in puzzleArray {
                        if i.frame.origin.y == swipeGesture.view?.frame.origin.y {
                            if i.frame.origin.x == (swipeGesture.view?.frame.origin.x)! - CGFloat(puzzleWidth) {
                                isPossibleToMovePuzzle = false
                            }
                        }
                    }
                    
                    if isPossibleToMovePuzzle {
                        swipeGesture.view?.frame.origin.x -= CGFloat(puzzleWidth)
                        
                        if WinService.isCorrectSubviewsPosition(containerView: containerView) {
                            performSegue(withIdentifier: "winControllerSegue", sender: self)
                        }
                    }
                }
                
            case UISwipeGestureRecognizer.Direction.up:
                if swipeGesture.view?.frame.minY != 0 {
                    var isPossibleToMovePuzzle = true
                    for i in puzzleArray {
                        if i.frame.origin.x == swipeGesture.view?.frame.origin.x {
                            if i.frame.origin.y == ((swipeGesture.view?.frame.origin.y)!) - CGFloat(puzzleHeight) {
                                isPossibleToMovePuzzle = false
                            }
                        }
                    }
                    
                    if isPossibleToMovePuzzle {
                        swipeGesture.view?.frame.origin.y -= CGFloat(puzzleHeight)
                       
                        if WinService.isCorrectSubviewsPosition(containerView: containerView) {
                            performSegue(withIdentifier: "winControllerSegue", sender: self)
                        }
                    }
                }
            default:
                break
            }
        }
    }
    
}
