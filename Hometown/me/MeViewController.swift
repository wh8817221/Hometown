//
//  MeViewController.swift
//  Hometown
//
//  Created by 王浩 on 2018/7/6.
//  Copyright © 2018年 haoge. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = BXLocalizedString("个人", comment: "")
        
        logoutButton.setTitle(BXLocalizedString("退出登录", comment: ""), for: .normal)
        logoutButton.setTitleColor(kWhiteColor, for: .normal)
        logoutButton.titleLabel?.font = kFont16
        logoutButton.backgroundColor = kThemeColor
        logoutButton.addTarget(self, action: #selector(logoutAction(_:)), for: .touchUpInside)
    }

    @objc fileprivate func logoutAction(_ sender: UIButton) {
        UserManager.sharedInstance.openId = ""
        let root = getStoryboardInstantiateViewController(identifier: "loginNav")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.changeRootViewController(root!, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
