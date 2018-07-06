//
//  BottombarView.swift
//  baoxiao
//
//  Created by mini on 16/10/11.
//  Copyright © 2016年 schope. All rights reserved.
//

import UIKit

class BottombarView: UIView {
    fileprivate var margin: CGFloat = 20.0
    fileprivate var line = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    //MARK:-自定义构造函数
    init(frame: CGRect, titles:[String], target:AnyObject?,selectors:[Selector], intents:[String]){
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = kWhiteColor
        
        // line
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = kLineColor
        self.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.left.right.equalTo(self)
            make.height.equalTo(1)
        }
        
        addBottomBar(titles,target: target, selectors: selectors, intents: intents)
    }
    
    // MARK: - Private
    fileprivate func addBottomBar(_ titles:[String], target:AnyObject?,selectors:[Selector], intents:[String]) {
        func styleForAction(_ button: UIButton, title: String, intent: String) {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(title, for: UIControlState())
            button.titleLabel?.font = kFont15
            switch intent {
            case "save", "confirm":
                button.backgroundColor = kThemeColor
                button.setTitleColor(kWhiteColor, for: UIControlState())
            case "reset":
                button.setTitleColor(kTextColor1, for: UIControlState())
                button.backgroundColor = kWhiteColor
            case "delete":
                button.layer.borderColor = kRedColor.cgColor
                button.layer.borderWidth = 1
                button.setTitleColor(kRedColor, for: UIControlState())
            default:
                button.setTitleColor(kThemeColor, for: UIControlState())
            }
        }
        
        // buttons
        switch titles.count {
        case 1:
            let btn1 = UIButton()
            btn1.tag = 1
            styleForAction(btn1, title: titles[0], intent: intents[0])
            btn1.addTarget(target, action: selectors[0], for: .touchUpInside)
            self.addSubview(btn1)
            
            btn1.snp.makeConstraints({ (make) in
                
                make.centerY.equalTo(self.snp.centerY)
                make.left.equalTo(self.snp.left).offset(margin)
                make.right.equalTo(self.snp.right).offset(-margin)
                make.height.equalTo(35)
            })
        case 2:
            let btn1 = UIButton()
            btn1.tag = 1
            styleForAction(btn1, title: titles[0], intent: intents[0])
            btn1.addTarget(target, action: selectors[0], for: .touchUpInside)
            self.addSubview(btn1)
            
            let line1 = UIView()
            line1.backgroundColor = kLineColor
            self.addSubview(line1)
            
            let btn2 = UIButton()
            btn2.tag = 2
            styleForAction(btn2, title: titles[1],intent: intents[1])
            btn2.addTarget(target, action: selectors[1], for: .touchUpInside)
            self.addSubview(btn2)
            
            btn1.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.snp.centerY)
                make.leading.equalTo(self.snp.leading).offset(margin)
                make.height.equalTo(35)
            })
            
            btn2.snp.makeConstraints({ (make) in
                make.leading.equalTo(btn1.snp.trailing).offset(margin)
                make.trailing.equalTo(self.snp.trailing).offset(-margin)
                make.centerY.equalTo(self.snp.centerY)
                make.height.equalTo(35)
                make.width.equalTo(btn1.snp.width)
            })
            
            line1.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self.snp.centerX)
                make.centerY.equalTo(self.snp.centerY)
                make.width.equalTo(1)
                make.top.equalTo(btn1.snp.top)
                make.bottom.equalTo(btn1.snp.bottom)
            })
            
        case 3:
            let btn1 = UIButton()
            btn1.tag = 1
            styleForAction(btn1, title: titles[0], intent: intents[0])
            btn1.addTarget(target, action: selectors[0], for: .touchUpInside)
            self.addSubview(btn1)
            
            let line1 = UIView()
            line1.backgroundColor = kLineColor
            self.addSubview(line1)
            
            let btn2 = UIButton()
            btn2.tag = 2
            styleForAction(btn2, title: titles[1], intent: intents[1])
            btn2.addTarget(target, action: selectors[1], for: .touchUpInside)
            self.addSubview(btn2)
            
            let line2 = UIView()
            line2.backgroundColor = kLineColor
            self.addSubview(line2)
            
            let btn3 = UIButton()
            btn3.tag = 3
            styleForAction(btn3, title: titles[2], intent: intents[2])
            btn3.addTarget(target, action:selectors[2], for: .touchUpInside)
            self.addSubview(btn3)
            
            
            btn1.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.snp.centerY)
                make.leading.equalTo(self.snp.leading).offset(margin)
                make.height.equalTo(35)
            })
            
            btn2.snp.makeConstraints({ (make) in
                make.leading.equalTo(btn1.snp.trailing).offset(margin)
                make.centerY.equalTo(self.snp.centerY)
                make.height.equalTo(35)
                make.width.equalTo(btn1.snp.width)
            })
            
            btn3.snp.makeConstraints({ (make) in
                make.leading.equalTo(btn2.snp.trailing).offset(margin)
                make.trailing.equalTo(self.snp.trailing).offset(-margin)
                make.centerY.equalTo(self.snp.centerY)
                make.height.equalTo(35)
                make.width.equalTo(btn1.snp.width)
            })
            
            line1.snp.makeConstraints({ (make) in
                make.leading.equalTo(btn1.snp.trailing).offset(10)
                make.width.equalTo(1)
                make.top.equalTo(btn1.snp.top)
                make.bottom.equalTo(btn1.snp.bottom)
            })
            
            line2.snp.makeConstraints({ (make) in
                make.leading.equalTo(btn2.snp.trailing).offset(10)
                make.width.equalTo(1)
                make.top.equalTo(btn2.snp.top)
                make.bottom.equalTo(btn2.snp.bottom)
            })
        case 4:
            let btn1 = UIButton()
            btn1.tag = 1
            styleForAction(btn1, title: titles[0], intent: intents[0])
            btn1.addTarget(target, action: selectors[0], for: .touchUpInside)
            self.addSubview(btn1)
            
            let line1 = UIView()
            line1.backgroundColor = kLineColor
            self.addSubview(line1)
            
            let btn2 = UIButton()
            btn2.tag = 2
            styleForAction(btn2, title: titles[1], intent: intents[1])
            btn2.addTarget(target, action: selectors[1], for: .touchUpInside)
            self.addSubview(btn2)
            
            let line2 = UIView()
            line2.backgroundColor = kLineColor
            self.addSubview(line2)
            
            let btn3 = UIButton()
            btn3.tag = 3
            styleForAction(btn3, title: titles[2], intent: intents[2])
            btn3.addTarget(target, action:selectors[2], for: .touchUpInside)
            self.addSubview(btn3)
            
            let line3 = UIView()
            line3.backgroundColor = kLineColor
            self.addSubview(line3)
            
            let btn4 = UIButton()
            btn4.tag = 4
            styleForAction(btn4, title: titles[3], intent: intents[3])
            btn4.addTarget(target, action:selectors[3], for: .touchUpInside)
            self.addSubview(btn4)
            
            btn1.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.snp.centerY)
                make.leading.equalTo(self.snp.leading).offset(margin)
                make.height.equalTo(35)
            })
            
            btn2.snp.makeConstraints({ (make) in
                make.leading.equalTo(btn1.snp.trailing).offset(margin)
                make.centerY.equalTo(self.snp.centerY)
                make.height.equalTo(35)
                make.width.equalTo(btn1.snp.width)
            })
            
            btn3.snp.makeConstraints({ (make) in
                make.leading.equalTo(btn2.snp.trailing).offset(margin)
//                make.trailing.equalTo(self.snp.trailing).offset(-margin)
                make.centerY.equalTo(self.snp.centerY)
                make.height.equalTo(35)
                make.width.equalTo(btn1.snp.width)
            })
            
            btn4.snp.makeConstraints({ (make) in
                make.leading.equalTo(btn3.snp.trailing).offset(margin)
                make.trailing.equalTo(self.snp.trailing).offset(-margin)
                make.centerY.equalTo(self.snp.centerY)
                make.height.equalTo(35)
                make.width.equalTo(btn1.snp.width)
            })
            
            line1.snp.makeConstraints({ (make) in
                make.leading.equalTo(btn1.snp.trailing).offset(10)
                make.width.equalTo(1)
                make.top.equalTo(btn1.snp.top)
                make.bottom.equalTo(btn1.snp.bottom)
            })
            
            line2.snp.makeConstraints({ (make) in
                make.leading.equalTo(btn2.snp.trailing).offset(10)
                make.width.equalTo(1)
                make.top.equalTo(btn2.snp.top)
                make.bottom.equalTo(btn2.snp.bottom)
            })
            
            line3.snp.makeConstraints({ (make) in
                make.leading.equalTo(btn3.snp.trailing).offset(10)
                make.width.equalTo(1)
                make.top.equalTo(btn3.snp.top)
                make.bottom.equalTo(btn3.snp.bottom)
            })
        default:
            return
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
