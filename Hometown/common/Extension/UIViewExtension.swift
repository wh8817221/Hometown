//
//  UIViewExtension.swift
//  baoxiao
//
//  Created by 王浩 on 2018/4/3.
//  Copyright © 2018年 schope. All rights reserved.
//

import UIKit

extension UIView {
    func parentViewOfType<T>(_ type: T.Type) -> T? {
        var currentView = self
        while currentView.superview != nil {
            if currentView is T {
                return currentView as? T
            }
            currentView = currentView.superview!
        }
        return nil
    }
    
    enum CircleType {
        case dot
        case number
    }
    
    func drawCircle(color: UIColor ,type: CircleType, number: String?) {
        var valueWidthStep: CGFloat = 0
        var number = number
        if number != nil {
            if Int(number!)! > 99 {
                valueWidthStep = 6
                number = "99+"
            } else {
                valueWidthStep = 0
            }
        }
        //移除以前的layer层,否则会重复创建
        self.layer.sublayers?.removeAll()
        let margin: CGFloat = 2.0
        let layer1 = CALayer()
        layer1.frame = CGRect(x: 0, y: 0, width: self.bounds.width+valueWidthStep, height: self.bounds.height)
        layer1.backgroundColor = color.changeBackgroundColorToAlpha(alpha: 0.3).cgColor
        layer1.cornerRadius = self.bounds.height/2
        layer1.masksToBounds = true
        
        let layer2 = CALayer()
        layer2.frame = CGRect(x: margin, y: margin, width: self.bounds.width-2*margin+valueWidthStep, height: self.bounds.height-2*margin)
        layer2.backgroundColor = color.cgColor
        layer2.cornerRadius = (self.bounds.height-2*margin)/2
        layer2.masksToBounds = true
        
        self.layer.addSublayer(layer1)
        self.layer.addSublayer(layer2)
        
        if type == .number {
            let lbl = UILabel(frame: layer2.frame)
            lbl.text = number ?? ""
            lbl.textAlignment = .center
            lbl.font = kFont11
            lbl.textColor = kWhiteColor
            self.addSubview(lbl)
        }
    }
    
    //MARK:-view 加阴影边框
    func setShadow(offset: CGFloat, shadowColor: UIColor = UIColor.gray) {
        self.layer.shadowOpacity = 0.5  // 阴影透明度
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowRadius = 4.0 // 阴影扩散的范围控制
        self.layer.shadowOffset  = CGSize(width: offset, height: offset) // 阴影的范围
    }
    
    //MARK:-单边阴影
    enum ShadowPosition {
        case top
        case bottom
        case left
        case right
    }
    func singleShadow(position: ShadowPosition) {
        //这三个属性要设置
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6  // 阴影透明度
        self.layer.shadowOffset  = CGSize(width: 0, height: 4)
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        let offset: CGFloat = 2
        //路径阴影
        let path = UIBezierPath.init()
        switch position {
        case .top:
            path.move(to: CGPoint(x: 0, y: 0))
            //添加直线
            path.addLine(to: CGPoint(x: 0, y: -offset))
            path.addLine(to: CGPoint(x: width, y: -offset))
            path.addLine(to: CGPoint(x: width, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
        case .bottom:
            path.move(to: CGPoint(x: 0, y: height))
            //添加直线
            path.addLine(to: CGPoint(x: 0, y: offset+height))
            path.addLine(to: CGPoint(x: width, y: offset+height))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
        case .left:
            path.move(to: CGPoint(x: 0, y: 0))
            //添加直线
            path.addLine(to: CGPoint(x: -offset, y: 0))
            path.addLine(to: CGPoint(x: -offset, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        case .right:
            path.move(to: CGPoint(x: width, y: 0))
            //添加直线
            path.addLine(to: CGPoint(x: width+offset, y: 0))
            path.addLine(to: CGPoint(x: width+offset, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: width, y: 0))
        }
        //设置阴影路径
        self.layer.shadowPath = path.cgPath
    }
    
    
}
//圆角
extension UIView {
   
    func radiusView(_ radius: CGFloat){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func roundView(){
        radiusView(frame.height / 2)
    }
    
    
    func roundCorner(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
}
//MARK: 动画
extension UIView {
    enum AnimationSubtype: String {
        case fade = "kCATransitionFade"
        case moveIn = "kCATransitionMoveIn"
        case push = "kCATransitionPush"
        case reveal = "kCATransitionReveal"
        case fromRight = "kCATransitionFromRight"
        case fromLeft = "kCATransitionFromLeft"
        case fromTop = "kCATransitionFromTop"
        case fromBottom = "kCATransitionFromBottom"
    }
    
    enum AnimationType: String {
        case fade = "fade"                   //淡入淡出
        case push = "push"                     //推挤
        case reveal = "reveal"                   //揭开
        case moveIn = "moveIn"                     //覆盖
        case cube =  "cube"                     //立方体
        case suckEffect = "suckEffect"                 //吮吸
        case oglFlip = "oglFlip"                    //翻转
        case rippleEffect = "rippleEffect"               //波纹
        case pageCurl = "pageCurl"                  //翻页
        case pageUnCurl = "pageUnCurl"                //反翻页
        case cameraIrisHollowOpen = "cameraIrisHollowOpen"       //开镜头
        case cameraIrisHollowClose = "cameraIrisHollowClose"     //关镜头
        case curlDown = "curlDown"                   //下翻页
        case curlUp = "curlUp"                    //上翻页
        case flipFromLeft = "flipFromLeft"              //左翻转
        case flipFromRight = "flipFromRight"             //右翻转
    }
    /**
     *  动画效果实现
     *
     *  @param type    动画的类型 在开头的枚举中有列举,比如 CurlDown//下翻页,CurlUp//上翻页
     ,FlipFromLeft//左翻转,FlipFromRight//右翻转 等...
     *  @param subtype 动画执行的起始位置,上下左右
     *  @param view    哪个view执行的动画
     */
    func transition(type: AnimationType, subtype: AnimationSubtype?) {
        let animation = CATransition()
        animation.duration = 0.7
        animation.type = type.rawValue
        if subtype != nil {
            animation.subtype = subtype?.rawValue
        }
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.layer.add(animation, forKey: "animation")
    }

}
