//
//  GameViewController.swift
//  BreakOut
//
//  Created by SESP Walkup on 7/28/16.
//  Copyright © 2016 Teddy Chen. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    var dynamicAnimator = UIDynamicAnimator()
    var pushBehavior = UIPushBehavior()
    var collisionBehavior = UICollisionBehavior()
    var paddle = UIView()
    var ball = UIView()
    var lives = 3
    var allObjects = [UIDynamicItem]()
    var bricks = [Brick]()
    var brickColors = [UIColor.redColor(), UIColor.orangeColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.purpleColor()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetButton.hidden = true
        
        // Ball
        ball = UIView(frame: CGRectMake(view.center.x, view.center.y, 20, 20))
        ball.backgroundColor = UIColor.brownColor()
        ball.layer.cornerRadius = 10
        ball.clipsToBounds = true
        view.addSubview(ball)
        
        // Paddle
        paddle = UIView(frame: CGRectMake(view.center.x, view.center.y * 1.7, 80, 20))
        paddle.backgroundColor = UIColor.whiteColor()
        view.addSubview(paddle)
        
        // Bricks
//        createRowOfAdjacentBricks(20, yValue: 20, amount: 10, color: UIColor.redColor(), startIndexForLoop: 0, brickMargin: 2.0)
//        createRowOfAdjacentBricks(7, yValue: 42, amount: 6, color: UIColor.orangeColor(), startIndexForLoop: 10, brickMargin: 5.0)
//        createRowOfAdjacentBricks(50, yValue: 50, amount: 14, color: UIColor.yellowColor(), startIndexForLoop: 16, brickMargin: 7.0)
//        createRowOfAdjacentBricks(10, yValue: 102, amount: 8, color: UIColor.greenColor(), startIndexForLoop: 30, brickMargin: 2.5)
//        createRowOfAdjacentBricks(20, yValue: 115, amount: 10, color: UIColor.blueColor(), startIndexForLoop: 38, brickMargin: 2.0)
//        createRowOfAdjacentBricks(30, yValue: 150, amount: 4, color: UIColor.purpleColor(), startIndexForLoop: 48, brickMargin: 15.0)
        createStartingBricks()
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        // Ball dynamics
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0
        ballDynamicBehavior.resistance = 0
        ballDynamicBehavior.elasticity = 1.0
        ballDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        
        // Paddle dynamics
        let paddleDynamicBehavior = UIDynamicItemBehavior(items: [paddle])
        paddleDynamicBehavior.resistance = 100
        paddleDynamicBehavior.density = 10000
        paddleDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(paddleDynamicBehavior)
        
        //Brick dynamics
        let brickDynamicBehavior = UIDynamicItemBehavior(items: bricks)
        brickDynamicBehavior.density = 10000
        brickDynamicBehavior.resistance = 100
        brickDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(brickDynamicBehavior)
        
        for brick in bricks {
            allObjects.append(brick)
        }
        
        // Push ball
        pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        pushBehavior.pushDirection = CGVectorMake(0.2, 1.0)
        pushBehavior.magnitude = 0.25
        dynamicAnimator.addBehavior(pushBehavior)
        
        allObjects.append(paddle)
        allObjects.append(ball)
        
        // Collision behaviors
        collisionBehavior = UICollisionBehavior(items: allObjects)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
        
        livesLabel.text = "Lives: \(lives)"
    }
    
    func createRowOfAdjacentBricks(height: CGFloat, yValue: CGFloat, amount: Int, color: UIColor, startIndexForLoop: Int, brickMargin: CGFloat) {
        let width = (view.frame.width - CGFloat(amount + 1) * brickMargin ) / CGFloat(amount)
        var xValue = CGFloat(0.0) + brickMargin
        for brickNumber in startIndexForLoop..<amount + startIndexForLoop {
            bricks.append(Brick(frame: CGRectMake(xValue, yValue, width, height), originalColor: color))
            bricks[brickNumber].backgroundColor = color
            view.addSubview(bricks[brickNumber])
            xValue += (width + brickMargin)
        }
    }
    
    func createStartingBricks() {
        var yValue = CGFloat(20)
        var prevAmount = 0
        for color in brickColors {
            let amount = Int(arc4random_uniform(20)) + 1
            let height = CGFloat(arc4random_uniform(80)) + 1
            createRowOfAdjacentBricks(height, yValue: yValue, amount: amount, color: color, startIndexForLoop: prevAmount, brickMargin: CGFloat(drand48() + 0.2) * 10.0)
            prevAmount += amount
            yValue += (height + CGFloat(drand48() + 0.1) * 5.0)
        }

        
    }
    
    func checkForWin() -> Bool {
        for brick in bricks {
            if brick.hidden == false {
                return false
            }
        }
        return true
    }
    
    // Reset helper funcs
    
//    func ballAdder(ball: UIView) {
//        view.addSubview(ball)
//        ball.center = view.center
//        collisionBehavior.addItem(ball)
//        dynamicAnimator.updateItemUsingCurrentState(ball)
//        dynamicAnimator.addBehavior(pushBehavior)
//    }
//    
//    func brickAdder(brick: Brick) {
//        if brick.hidden == true {
//            brick.hidden = false
//            view.addSubview(brick)
//            collisionBehavior.addItem(brick)
//            dynamicAnimator.updateItemUsingCurrentState(brick)
//        }
//    }
//    
//    func reset() {
//        ballAdder(ball)
//        for brick in bricks {
//            brick.backgroundColor = brick.originalColor
//            brickAdder(brick)
//        }
//        lives = 3
//        livesLabel.text = "Lives: \(lives)"
//    }
    func reset() {
        UIApplication.sharedApplication().keyWindow?.rootViewController = storyboard!.instantiateViewControllerWithIdentifier("GameView")
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if item.isEqual(ball) && p.y > paddle.center.y {
            lives -= 1
            if lives > 0 {
                livesLabel.text = "Lives: \(lives)"
                ball.center = view.center
                dynamicAnimator.updateItemUsingCurrentState(ball)
            } else {
                livesLabel.text = "You lose"
                ball.removeFromSuperview()
                collisionBehavior.removeItem(ball)
                dynamicAnimator.updateItemUsingCurrentState(ball)
                resetButton.hidden = false
            }
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        for brick in bricks {
            if (item1.isEqual(ball) && item2.isEqual(brick)) || (item2.isEqual(ball) && item1.isEqual(brick)) {
                if brick.backgroundColor != UIColor.purpleColor() {
                    brick.backgroundColor = brickColors[brickColors.indexOf(brick.backgroundColor!)! + 1]
                } else {
                    brick.hidden = true
                    brick.removeFromSuperview()
                    collisionBehavior.removeItem(brick)
                    dynamicAnimator.updateItemUsingCurrentState(brick)
                }
            }
        }
        if checkForWin() {
            ball.removeFromSuperview()
            collisionBehavior.removeItem(ball)
            dynamicAnimator.updateItemUsingCurrentState(ball)
            livesLabel.text = "You win!"
            resetButton.hidden = false
        }
    }
    
    @IBAction func dragPaddle(sender: UIPanGestureRecognizer) {
        let panGesture = sender.locationInView(view)
        paddle.center.x = panGesture.x
        dynamicAnimator.updateItemUsingCurrentState(paddle)
    }
    
    @IBAction func onTappedResetButton(sender: UIButton) {
        reset()
        resetButton.hidden = true
    }
}
