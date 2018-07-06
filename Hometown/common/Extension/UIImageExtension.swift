//
//  UIImageExtension.swift
//  baoxiao
//
//  Created by 王浩 on 2018/4/3.
//  Copyright © 2018年 schope. All rights reserved.
//

import UIKit

//MARK:-extension UIImage
extension UIImage {
    convenience init? (fromView view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        self.init(cgImage: (UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext();
    }
    
    func resize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized!
    }
    
    func base64(_ compression: CGFloat) -> String {
        return UIImageJPEGRepresentation(self, compression)!.base64EncodedString(options: .lineLength64Characters)
    }
    
    //修改图片的颜色
    func imageWithTintColor(tintColor: UIColor) -> UIImage {
        return self.imageWithTintColor(tintColor: tintColor, blendMode: .destinationIn)
    }
    
    func imageWithGradientTintColor(tintColor: UIColor) -> UIImage {
        return self.imageWithTintColor(tintColor: tintColor, blendMode: .overlay)
    }
    
    fileprivate func imageWithTintColor(tintColor: UIColor, blendMode: CGBlendMode) -> UIImage {
        //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        tintColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIRectFill(bounds)
        
        //Draw the tinted image in context
        self.draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        if blendMode != .destinationIn {
            self.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        }
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
}
