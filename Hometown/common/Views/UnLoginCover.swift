//
//  UnLoginCover.swift
//  chapiaotong
//
//  Created by 王浩 on 2018/5/25.
//  Copyright © 2018年 王浩. All rights reserved.

import UIKit

class UnLoginCover: UIView {
    
    weak var parentVC: UIViewController?
    var contentView: UIView!
    var topView: UIView!
    var textL1: UILabel!
    var textL2: UILabel!
    
    var wechatBtn: UIButton!
    var phoneBtn: UIButton!
    
    var textL3: UILabel!
    
    init(frame: CGRect, parentVC: UIViewController) {
        super.init(frame: frame)
        self.parentVC = parentVC
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUI() {
        contentView = UIView()
        contentView.backgroundColor = kClearColor
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        
        topView = UIView()
        topView.backgroundColor = kWhiteColor
        contentView.addSubview(topView)
        
        topView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        textL3 = UILabel()
        textL3.textColor = kTextColor2
        textL3.font = kFont12
        textL3.textAlignment = .center
        textL3.attributedText = formatCurrencyText(allText: "首次登录+20次免费查验额度", formatText: "+20", formatTextColor: kOrangeColor, formatTextFont: kFont12)
        contentView.addSubview(textL3)
        textL3.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.left.right.equalTo(topView)
        }
        
        textL1 = UILabel()
        textL1.text = BXLocalizedString("暂未登录", comment: "")
        textL1.textColor = kTextColor2
        textL1.font = kFont17
        textL1.textAlignment = .center
        topView.addSubview(textL1)

        
        textL2 = UILabel()
        textL2.text = "登录后可查看数据"
        textL2.textColor = kTextColor2
        textL2.font = kFont12
        textL2.textAlignment = .center
        topView.addSubview(textL2)

        textL1.snp.makeConstraints { (make) in
            make.top.equalTo(44)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        textL2.snp.makeConstraints { (make) in
            make.top.equalTo(textL1.snp.bottom).offset(4)
            make.left.right.equalTo(textL1)
        }
        
        wechatBtn = ScaleButton(type: .custom)
        wechatBtn.tag = 1
        wechatBtn.setTitleColor(kWhiteColor, for: .normal)
        wechatBtn.backgroundColor = kThemeColor
        wechatBtn.layer.cornerRadius = 22
        wechatBtn.layer.masksToBounds = true
        wechatBtn.changeImagePosition(positon: .left, imageName: "wechat_login", title: "微信一键登录", titleFont: kFont17)
        topView.addSubview(wechatBtn)
        
        phoneBtn = UIButton(type: .custom)
        phoneBtn.tag = 2
        phoneBtn.setTitle(BXLocalizedString("手机号登录", comment: ""), for: .normal)
        phoneBtn.setTitleColor(kThemeColor, for: .normal)
        phoneBtn.titleLabel?.font = kFont17
        topView.addSubview(phoneBtn)
        
        wechatBtn.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(44)
            make.centerX.equalTo(topView.snp.centerX)
            make.top.equalTo(textL2.snp.bottom).offset(30)
        }
        
        phoneBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(wechatBtn)
            make.centerX.equalTo(topView.snp.centerX)
            make.top.equalTo(wechatBtn.snp.bottom).offset(20)
            make.bottom.equalTo(topView.snp.bottom).offset(-44)
        }
        
        wechatBtn.addTarget(self, action: #selector(addAction(_ :)), for: .touchUpInside)
        phoneBtn.addTarget(self, action: #selector(addAction(_ :)), for: .touchUpInside)
        
//        wechatBtn.isHidden = !WXApi.isWXAppInstalled()
        
    }
    
    @objc fileprivate func addAction(_ sender: UIButton) {
//        if sender.tag == 1 {
//            if WXApi.isWXAppInstalled() {
//                let req = SendAuthReq()
//                req.scope = "snsapi_userinfo"
//                req.openID = WX_APPID
//                req.state = "wechat_sdk_chapiaotong"
//                WXApi.send(req)
//            }
//        } else {
            let nav = getStoryboardInstantiateViewController(identifier: "loginNav")
            parentVC?.present(nav!, animated: true, completion: nil)
//        }
    }
}


