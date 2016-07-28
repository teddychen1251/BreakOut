//
//  GameViewController.swift
//  BreakOut
//
//  Created by SESP Walkup on 7/28/16.
//  Copyright © 2016 Teddy Chen. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var dynamicAnimator = UIDynamicAnimator()
    var collisionBehavior = UICollisionBehavior()
    var paddle = UIView()
    var ball = UIView()
    var brick = UIView()
    var lives = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dragPaddle(sender: UIPanGestureRecognizer) {
    }
}
