//
//  MainViewController.swift
//  chapiaotong
//
//  Created by 王浩 on 2018/5/22.
//  Copyright © 2018年 王浩. All rights reserved.

import UIKit
import AVFoundation
import Photos
import Alamofire
import PKHUD
/*
 使用extension通过valueForKey("view"), 添加UILabel在_UIBadgeView图层下
 showBadge(0, style: .Dot, value: 0)
 showBadge(1, style: .Number, value: 123)
 */

private let BadgeDotHeight: CGFloat = 12
private let BadgeValueHeight: CGFloat = 18
private let BadgeValueWidthStep: CGFloat = 6
private let BadgeCenterOffset = CGPoint(x: 14, y: -14)

enum BadgeStyle {
    case dot
    case number
}

class MainViewController: UITabBarController {
    
    fileprivate var badges = [Int: UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in tabBar.items! {
            item.title = BXLocalizedString(item.title!, comment: "")
        }
        
    }
    
    // MARK: - UIApplication
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Notification -> ReactiveCocoa
    //    func reloadTodoCount(_ sender: AnyObject!) {
    //        if let company_id = Int(UserManager.sharedInstance.compId) {
    //            let todo = TodoManager.sharedInstance.todo[company_id] ?? 0
    //            if todo > 0 {
    //                showBadge(1, style: .number, value: todo)
    //            } else {
    //                hideBadge(1)
    //            }
    //        }
    //    }
    
    // MARK: - Public
    func showBadge(_ index: Int, style: BadgeStyle, value: Int) {
        if index < 0 || index >= tabBar.items!.count {
            return
        }
        
        func initBadge(_ badge: UILabel, style: BadgeStyle, value: Int) {
            switch style {
            case .dot:
                badge.frame = CGRect(x: 0, y: 0, width: BadgeDotHeight, height: BadgeDotHeight)
                badge.drawCircle(color: kOrangeColor,type: .dot, number: nil)
                badge.isHidden = false
                
            case .number:
                badge.isHidden = false
                
                if value > 99 {
                    badge.frame = CGRect(x: 0, y: 0, width: BadgeValueHeight + BadgeValueWidthStep*2, height: BadgeValueHeight)
                    
                } else if value > 9 {
                    badge.frame = CGRect(x: 0, y: 0, width: BadgeValueHeight + BadgeValueWidthStep, height: BadgeValueHeight)
                    
                } else if value > 0 {
                    badge.frame = CGRect(x: 0, y: 0, width: BadgeValueHeight, height: BadgeValueHeight)
                    
                } else {
                    badge.isHidden = true
                }
                badge.drawCircle(color: kOrangeColor,type: .number, number: "\(value)")
            }
        }
        
        var badge = badges[index]
        if badge == nil {
            badge = UILabel()
            tabBar.addSubview(badge!)
            badges[index] = badge!
        }
        initBadge(badge!, style: style, value: value)
        
        let width: CGFloat = tabBar.frame.width / CGFloat(tabBar.items!.count)
        let x = width/2 + width*CGFloat(index) + BadgeCenterOffset.x
        let y = tabBar.frame.height/2 + BadgeCenterOffset.y-tabHeight/2
        badge!.center = CGPoint(x: x, y: y)
    }
    
    func hideBadge(_ index: Int) {
        let badge = badges[index]
        badge?.isHidden = true
    }
    
   
    deinit {
        // Notification -> ReactiveCocoa
        NotificationCenter.removeObserver(observer: self, name: .kReloadInvioceAddTo)
    }
}
