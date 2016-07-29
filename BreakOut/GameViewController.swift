//
//  GameViewController.swift
//  BreakOut
//
//  Created by SESP Walkup on 7/28/16.
//  Copyright © 2016 Teddy Chen. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var dynamicAnimator = UIDynamicAnimator()
    var collisionBehavior = UICollisionBehavior()
    var paddle = UIView()
    var ball = UIView()
    var lives = 3
    var allObjects = [UIDynamicItem]()
    var bricks = [UIView]()
    var brickColors = [UIColor.redColor(), UIColor.orangeColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.purpleColor()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        createRowOfAdjacentBricks(20, yValue: 20, amount: 10, color: UIColor.redColor(), startIndexForLoop: 0, brickMargin: 2.0)
        createRowOfAdjacentBricks(20, yValue: 42, amount: 4, color: UIColor.orangeColor(), startIndexForLoop: 10, brickMargin: 2.0)
        
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
        let pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
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
    }
    
    func createRowOfAdjacentBricks(height: CGFloat, yValue: CGFloat, amount: Int, color: UIColor, startIndexForLoop: Int, brickMargin: CGFloat) {
        let width = (view.frame.width - CGFloat(amount + 1) * brickMargin ) / CGFloat(amount)
        var xValue = CGFloat(0.0) + brickMargin
        for brickNumber in startIndexForLoop..<amount + startIndexForLoop {
            bricks.append(UIView(frame: CGRectMake(xValue, yValue, width, height)))
            bricks[brickNumber].backgroundColor = color
            //bricks[brickNumber].layer.borderColor = UIColor.blackColor().CGColor
            //bricks[brickNumber].layer.borderWidth = 2.0
            view.addSubview(bricks[brickNumber])
            xValue += (width + brickMargin)
        }
    }
    
    @IBAction func dragPaddle(sender: UIPanGestureRecognizer) {
        let panGesture = sender.locationInView(view)
        paddle.center.x = panGesture.x
        dynamicAnimator.updateItemUsingCurrentState(paddle)
    }
}
