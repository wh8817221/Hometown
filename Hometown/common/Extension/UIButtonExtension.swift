//
//  UIButtonExtension.swift
//  baoxiao
//
//  Created by 王浩 on 2018/4/3.
//  Copyright © 2018年 schope. All rights reserved.
//

import UIKit

extension UIButton {
    enum BorderPosition  {
        case top
        case bottom
        case left
        case right
    }
    func addBorderWithColor(positon:BorderPosition,margin: CGFloat = 0, color: UIColor = kLineColor, borderWidth: CGFloat = 1.0) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch positon {
        case .bottom:
            border.frame = CGRect(x: margin, y: self.frame.height - borderWidth, width: self.frame.width-2*margin, height: borderWidth)
        case .top:
            border.frame = CGRect(x: margin, y: 0, width: self.frame.width-2*margin, height: borderWidth)
        case .left:
            border.frame = CGRect(x: 0, y: margin, width: borderWidth, height: self.frame.size.height-2*margin)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - borderWidth, y: margin, width: borderWidth, height: self.frame.size.height-2*margin)
        }
        self.layer.addSublayer(border)
    }
    
    func changeImagePosition(positon:BorderPosition, imageName: String, title: String, titleFont: UIFont) {
        let image = UIImage(named: imageName)
        switch positon {
        case .right:
            self.setImage(image, for: .normal)
            self.setTitle(title, for: .normal)
            self.titleLabel?.font = titleFont
            
            let titleSize = calculateTextSize(text: title, font: titleFont)
            let imageWidth: CGFloat = image?.size.width ?? 0
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth-5, bottom: 0, right: imageWidth)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleSize.width+5, bottom: 0, right: -titleSize.width)
            
        case .top:
            self.setImage(image, for: .normal)
            self.setTitle(title, for: .normal)
            self.titleLabel?.font = titleFont
            let imageWidth: CGFloat = image?.size.width ?? 0
            let imageHieght: CGFloat = image?.size.height ?? 0
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHieght-10, right: 0)
            let titleSize = (title as NSString).size(withAttributes: [NSAttributedStringKey.font : titleFont])
            self.imageEdgeInsets = UIEdgeInsets(top: -titleSize.height-2, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            self.setImage(image, for: .normal)
            self.setTitle(title, for: .normal)
            self.titleLabel?.font = titleFont
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        default:
            break
        }
        
    }
    
}
