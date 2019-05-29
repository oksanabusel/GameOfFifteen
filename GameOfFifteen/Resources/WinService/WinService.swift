//
//  WinService.swift
//  GameOfFifteen
//
//  Created by Cat on 5/28/19.
//  Copyright © 2019 Oksana. All rights reserved.
//

import UIKit

class WinService {
    class func isCorrectSubviewsPosition(containerView: UIView) -> Bool {
        var xConstraint: CGFloat = 0
        var yConstraint: CGFloat = 0
        var counter = 1
        
        for i in 1...15 {
            if containerView.viewWithTag(i)?.frame.origin.x != xConstraint || containerView.viewWithTag(i)?.frame.origin.y != yConstraint {
                return false
            } else if i == 15 {
                return true
            }
            
            counter += 1
            xConstraint += 75
            
            if counter == 5 {
                counter = 1
                xConstraint  = 0
                yConstraint += 75
            }
        }
        return true
    }
    
}
