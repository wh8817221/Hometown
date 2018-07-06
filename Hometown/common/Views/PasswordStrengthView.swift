//
//  PasswordStrengthView.swift
//  baoxiao
//
//  Created by ruanyu on 15/12/9.
//  Copyright © 2015年 schope. All rights reserved.
//

import Foundation
import UIKit

import pop

class PasswordStrengthView: UIView {
    
    var _score = 0
    var _filledView: UIView!
    let kPartition0Color = kLineColor
    let kPartition1Color = UIColor(hexString: "#FF7777")
    let kPartition2Color = UIColor(hexString: "#FFCD77")
    let kPartition3Color = UIColor(hexString: "#EEFB5C")
    let kPartition4Color = UIColor(hexString: "#6CE092")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        
        _filledView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: frame.height))
        _filledView.backgroundColor = UIColor.red
        self.addSubview(_filledView)
    }
    
    var score:Int {
        get{
            return _score
        }
        set {
            if _score == newValue {
                return
            }
            
            _score = newValue
            animateFilledView(_score)
        }
    }
    
    func animateFilledView(_ score: Int) {
        let rect: CGRect
        let color: UIColor
        
        switch _score {
        case 0:
            rect = CGRect(x: 0, y: 0, width: 0, height: frame.height)
            color = kPartition0Color
            
        case 1:
            rect = CGRect(x: 0, y: 0, width: frame.width/4, height: frame.height)
            color = kPartition1Color
            
        case 2:
            rect = CGRect(x: 0, y: 0, width: frame.width/2, height: frame.height)
            color = kPartition2Color
            
        case 3:
            rect = CGRect(x: 0, y: 0, width: frame.width*0.75, height: frame.height)
            color = kPartition3Color
            
        case 4:
            rect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            color = kPartition4Color
            
        default:
            rect = CGRect(x: 0, y: 0, width: 0, height: 0)
            color = kPartition0Color
        }
        
        // animation
        _filledView.pop_removeAllAnimations()
        
        let a1 = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        a1?.toValue = NSValue(cgRect: rect)
        a1?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        _filledView.pop_add(a1, forKey: "frame")
        
        let a2 = POPBasicAnimation(propertyNamed: kPOPViewBackgroundColor)
        a2?.toValue = color
        _filledView.pop_add(a2, forKey: "color")
    }
}
