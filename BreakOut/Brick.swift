//
//  Brick.swift
//  BreakOut
//
//  Created by SESP Walkup on 7/28/16.
//  Copyright © 2016 Teddy Chen. All rights reserved.
//

import UIKit

class Brick: UIView {
    
    var originalColor = UIColor.blackColor()
    
    init(frame: CGRect, originalColor: UIColor) {
        super.init(frame: frame)
        self.commonInit(originalColor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(originalColor: UIColor) {
        self.originalColor = originalColor
    }
    
}
