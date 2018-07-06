//
//  ScaleButton.swift
//  baoxiao
//
//  Created by ruanyu on 15/12/15.
//  Copyright © 2015年 schope. All rights reserved.
//

import UIKit

import pop

class ScaleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.addTarget(self, action: #selector(scaleToSmall), for: [.touchDown, .touchDragEnter])
        self.addTarget(self, action: #selector(scaleAnimation), for: .touchUpInside)
        self.addTarget(self, action: #selector(scaleToDefault), for: .touchDragExit)
    }
    
    @objc func scaleToSmall() {
        let a = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        a?.toValue = NSValue(cgSize: CGSize(width: 0.9, height: 0.9))
        layer.pop_add(a, forKey: "small")
    }
    
    @objc func scaleAnimation() {
        let a = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        a?.velocity = NSValue(cgSize: CGSize(width:3, height: 3))
        a?.toValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        a?.springBounciness = 18
        layer.pop_add(a, forKey: "spring")
    }
    
    @objc func scaleToDefault() {
        let a = POPBasicAnimation(propertyNamed: kPOPLayerScaleXY)
        a?.toValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        layer.pop_add(a, forKey: "default")
    }
}

