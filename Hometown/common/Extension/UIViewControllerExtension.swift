//
//  UIViewControllerExtension.swift
//  baoxiao
//
//  Created by 王浩 on 2018/4/16.
//  Copyright © 2018年 schope. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire

extension UIViewController {
//     MARK: - processResponseError
    func processResponseError(_ code: Int, msg: String?, error: Any?) {
        
        if code == RequestHelper.errorUpdateForce {
            PKHUD.sharedHUD.hide(afterDelay: 0.25)
            self.showNormalAlert(.updateClient, cancelHandler: nil, confirmHandler: { () -> Void in
                let url: URL! = URL(string: "itms-apps://itunes.apple.com/app/id931370041")
                UIApplication.shared.openURL(url)
            })
        } else if code == RequestHelper.errorWechatExpire {
            PKHUD.sharedHUD.hide(afterDelay: 0.25)
            let nav = getStoryboardInstantiateViewController(identifier: "loginNav")
            self.present(nav!, animated: true, completion: nil)
        } else if code == RequestHelper.errorLoginFailed {
            PKHUD.sharedHUD.hide(afterDelay: 0.25)
            showNormalAlert(.logoutInvalid(msg ?? "登录失效,请重新登录"), cancelHandler: nil, confirmHandler: {
                let nav = getStoryboardInstantiateViewController(identifier: "loginNav")
                self.present(nav!, animated: true, completion: nil)
            })
        } else {
            showHideTextHUD(msg)
        }
    }

    func processNetworkError() {
        showHideErrorHUD()
    }
}

