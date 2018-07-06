//
//  BarButtonItem.swift
//  baoxiao
//
//  Created by 王浩 on 2017/10/30.
//  Copyright © 2017年 schope. All rights reserved.

import UIKit

class BarButtonItem: UIControl {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    convenience init(imageName: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        
        let template = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: template)
        imageView.tintColor = .white
        imageView.center = center
        imageView.tag = 1
        self.addSubview(imageView)
        
        let x = center.x + 6
        let y = center.y - 12
        let dot = UIView(frame: CGRect(x: x, y: y, width: 12, height: 12))
        
        dot.drawCircle(color: kOrangeColor,type: .dot, number: nil)
        dot.tag = 2
        self.addSubview(dot)
    
        addTarget(self, action: #selector(downAction), for: .touchDown)
        addTarget(self, action: #selector(upAction), for: [.touchUpInside, .touchUpOutside, .touchCancel])

    }
    
    // MARK: - Action
    @objc func downAction() {
        let iv = viewWithTag(1) as! UIImageView
        iv.tintColor = UIColor(white: 1, alpha: 0.5)
    }
    
    @objc func upAction() {
        let iv = viewWithTag(1) as! UIImageView
        iv.tintColor = .white
    }
    
    // MARK: - Private
    func showDot(count: Int) {
        let v2 = viewWithTag(2)!
        v2.isHidden = count == 0
    }
}
