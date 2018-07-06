//
//  UILabelExtension.swift
//  baoxiao
//
//  Created by 王浩 on 2018/4/3.
//  Copyright © 2018年 schope. All rights reserved.
//

import UIKit
import pop
extension UILabel {
    //MARK:-金额pop
    func popTotalLabel(_ total: String, animated: Bool=true) {
        if animated {
            self.pop_removeAllAnimations()
            let a1 = POPBasicAnimation()
            a1.property = POPAnimatableProperty.property(withName: "count", initializer: { (prop) in
                prop?.readBlock = { (object, values) -> Void in
                    if let lbl = object as? UILabel {
                        values?[0] = CGFloat((lbl.description as NSString).doubleValue)
                    }
                }
                
                prop?.writeBlock = { (object, values) -> Void in
                    if let lbl = object as? UILabel {
                        lbl.text = String(format: "%.2f", (values?[0])!).formatCurrency()
                    }
                }
                
                prop?.threshold = 0.01
            }) as! POPAnimatableProperty!
            
            a1.duration = 1
            a1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            a1.fromValue = 0.0
            a1.toValue = Float(total)
            a1.completionBlock = { (animation, finish) -> Void in
                self.text = total.formatCurrency()
            }
            
            self.pop_add(a1, forKey: "counting")
        } else {
            self.text = total.formatCurrency()
        }
    }
}
