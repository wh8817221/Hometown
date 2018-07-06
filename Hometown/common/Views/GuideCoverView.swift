//
//  GuideCoverView.swift
//  chapiaotong
//
//  Created by 王浩 on 2018/5/31.
//  Copyright © 2018年 王浩. All rights reserved.
//

import UIKit
import SnapKit

enum TipMode {
    case home_scan([String])
    case home_manual([String])
    case company([String])
    case nomal
}

class GuideCoverView: UIView {
    var callback: ObjectCallback?

    fileprivate var tipMode = TipMode.nomal
    fileprivate var index: Int = 0
    fileprivate lazy var bgView: UIControl = {
        let control = UIControl()
        //背景透明,子控件不透明
        control.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        control.addTarget(self, action: #selector(myKnowBtn(_:)), for: .touchUpInside)
        return control
    }()
    
    fileprivate lazy var bottomBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    fileprivate var positionView: UIView!
    
    init(frame: CGRect, positionView: UIView, tipMode: TipMode) {
        super.init(frame: frame)
        self.tipMode = tipMode
        self.positionView = positionView
        self.coverlayoutSubviews(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func coverlayoutSubviews(_ frame: CGRect) {
        //创建灰色背景
        bgView.frame = frame
        self.addSubview(bgView)
        addCoverSubviews(frame)
    }
    
    fileprivate func addCoverSubviews(_ frame: CGRect) {
        bgView.addSubview(bottomBtn)
        bgView.addSubview(imageView)
        
        switch tipMode {
        case .home_scan(let images):
            imageView.image = UIImage(named:images[index])
            imageView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.centerY.equalTo(self.snp.centerY).offset(-20)
            }
            
            bottomBtn.setImage(UIImage(named:"home_next"), for: .normal)
            bottomBtn.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.bottom.equalTo(self.snp.bottom).offset(-40)
            }
        case .home_manual(let images):
            imageView.image = UIImage(named:images[index])
            imageView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.centerY.equalTo(self.snp.centerY).offset(-20)
            }
            
            bottomBtn.setImage(UIImage(named:"home_next"), for: .normal)
            bottomBtn.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.bottom.equalTo(self.snp.bottom).offset(-40)
            }
        case .company(let images):
            
            let image = UIImage(named:images[index])
            imageView.image = image
            if let tableView = self.positionView as? UITableView {
                let rectIntbV = tableView.rectForRow(at: IndexPath(row: 1, section: 1))
                let rectInspV = tableView.convert(rectIntbV, to: tableView.superview)
                imageView.frame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
                let midY = rectInspV.midY-((image?.size.height)! - rectInspV.height)/2
                imageView.center = CGPoint(x: rectInspV.midX, y: midY)
            }

            bottomBtn.setImage(UIImage(named:"home_know"), for: .normal)
            bottomBtn.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.bottom.equalTo(self.snp.bottom).offset(-40)
            }
        default:
            break
        }
        

        bottomBtn.addTarget(self, action: #selector(myKnowBtn(_:)), for: .touchUpInside)
    }
    
    //MARK:-对外提供一个调用的方法
    func showView() {
        let tabVC = UIApplication.shared.keyWindow?.rootViewController
        tabVC?.view.addSubview(self)
    }
    //我知道了
    @objc func myKnowBtn(_ sender:UIButton){
        self.index+=1

        switch tipMode {
        case .home_scan(let images):
            if index <= (images.count-1) {
                imageView.image = UIImage(named:images[index])
                imageView.snp.updateConstraints { (make) in
                    make.centerX.equalTo(self)
                    make.centerY.equalTo(self.snp.centerY).offset(positionView.frame.height/2+10)
                }
                bottomBtn.setImage(UIImage(named:"home_lijitiyan"), for: .normal)
            } else {
                self.dismissContactView()
            }
        case .home_manual(let images):
            if index <= (images.count-1) {
                imageView.image = UIImage(named:images[index])
                imageView.snp.updateConstraints { (make) in
                    make.centerX.equalTo(self)
                    make.centerY.equalTo(self.snp.centerY).offset(caculatePosition())
                }
                bottomBtn.setImage(UIImage(named:"home_lijitiyan"), for: .normal)
            } else {
                self.dismissContactView()
            }
        case .company(let images):
            if index > (images.count-1) {
                self.dismissContactView()
            } else {
                let image = UIImage(named:images[index])
                imageView.image = image
                if let tableView = self.positionView as? UITableView {
                    let rectIntbV = tableView.rectForRow(at: IndexPath(row: 2, section: 1))
                    let rectInspV = tableView.convert(rectIntbV, to: tableView.superview)
                    imageView.frame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
                    let midY = rectInspV.midY-((image?.size.height)! - rectInspV.height)/2
                    imageView.center = CGPoint(x: rectInspV.midX, y: midY)
                }
                
            }
        default:
            self.dismissContactView()
        }
    }
    
    fileprivate func caculatePosition() -> CGFloat {
        if DeviceInfo.IS_4_7_INCHES(){
            return 80
        } else if DeviceInfo.IS_5_5_INCHES() {
            return 55
        } else {
            return 30
        }
    }
 
    //手势退出界面
    func dismissContactView(_ tapGesture: UITapGestureRecognizer){
        self.dismissContactView()
    }
    
    func dismissContactView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { (finished) in
            self.removeFromSuperview()
        })
    }
}

