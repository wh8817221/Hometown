//
//  CommonAlertView.swift
//  baoxiao
//
//  Created by ruanyu on 15/12/14.
//  Copyright © 2015年 schope. All rights reserved.
//

import UIKit

enum TextFieldAlertType {
    case changeCompanyName
    case createCompany
    case bindCompany
    case changeRealname
    case changeEmail
    case addProject
    case addSubject
    case changeDepartName
    case addDepartment
    case changeAccount_number
    case changeAccount_bank

    func generate() -> (title:String, message:String?, placeholder:String, cancel:String, confirm:String) {
        switch self {
        case .changeCompanyName:
            return ("修改企业名称", nil, "企业名称", "取消", "确定")
        case .createCompany:
            return ("创建企业", "请输入要创建的企业名称", "企业名称", "取消", "确定")
        case .bindCompany:
            return ("加入企业", "请输入企业的绑定码", "绑定码", "取消", "确定")
        case .changeRealname:
            return ("修改姓名", nil, "姓名", "取消", "确定")
        case .changeEmail:
            return ("修改邮箱", nil, "邮箱", "取消", "确定")
        case .addProject:
            return ("新项目", "请为此项目输入名称", "项目名称", "取消", "确定")
        case .addSubject:
            return ("新类别", "请为此类别输入名称", "类别名称", "取消", "确定")
        case .changeDepartName:
            return ("修改部门名称", nil, "部门名称", "取消", "确定")
        case .addDepartment:
            return ("新增部门名称", nil, "部门名称", "取消", "确定")
        case .changeAccount_number:
            return ("修改银行账号", nil, "银行账号", "取消", "确定")
        case .changeAccount_bank:
            return ("修改开户银行", nil, "开户银行", "取消", "确定")

        }
    }
}

enum NormalAlertType {
    case updateApp
    case permissionCamera
    case permissionPhoto
    case permissionApns
    case updateClient
    case otherQrCode(String)
    case noQrCode
    case logout
    case logoutInvalid(String)
    
    func generate() -> (title:String?, message:String?, cancel:String?, confirm:String?, other:String?) {
        switch self {
        case .updateApp:
            return ("版本更新", "应用商店有新版本了!", "取消", "前往更新", nil)
        case .permissionCamera:
            return ("未获得授权", "请在\"设置-隐私-相机\"中打开", "取消", "设置", nil)
        case .permissionPhoto:
            return ("未获得授权", "请在\"设置-隐私-照片\"中打开", "取消", "设置", nil)
        case .permissionApns:
            return ("未获得授权", "请在\"设置-隐私-通知\"中打开", "取消", "设置", nil)
        case .updateClient:
            return ("提示", "请升级客户端", "取消", "确定", nil)
        case .otherQrCode(let text):
            return (nil, text, "关闭", "拷贝", nil)
        case .noQrCode:
            return ("提示", "未发现二维码", nil, "确定", nil)
        case .logout:
            return ("提示", "是否确认退出登录", "取消", "确定", nil)
        case .logoutInvalid(let text):
            return ("提示", text, "取消", "确定", nil)
        }
    }
}

enum NoContentType {
    case dataNull
    case other
}

enum ContentType {
    case unLogin
}

extension UIViewController {
    // MARK: - TextFieldAlert
    func showTextFieldAlert(_ type: TextFieldAlertType, value: String?, confirmHandler: @escaping (String) -> Void) {
        
        let (title, message, placeholder, cancel, confirm) = type.generate()
        let alert = UIAlertController(title: BXLocalizedString(title, comment: ""), message: BXLocalizedString(message ?? "", comment: ""), preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: BXLocalizedString(cancel, comment: ""), style: .cancel) { (_) -> Void in
            
        }
        action1.setValue(kTextColor2, forKey: "_titleTextColor")
        let action2 = UIAlertAction(title: BXLocalizedString(confirm, comment: ""), style: .default) { (_) -> Void in
            let newValue = alert.textFields![0].text
            delay(0.1, closure: { 
                confirmHandler(newValue!)
            })
        }
        
        // disable confirm
        if value == nil { action2.isEnabled = false }
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = BXLocalizedString(placeholder, comment: "")
            textField.text = value

            if type == .bindCompany {
                textField.autocapitalizationType = .allCharacters
                textField.keyboardType = .asciiCapable
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                switch type {
                case .bindCompany:
                    action2.isEnabled = textField.text?.count == 6
                    
                case .changeEmail:
                    action2.isEnabled = isValidEmail(textField.text ?? "")
                    
                default:
                    action2.isEnabled = textField.text != ""
                }
            }
        })
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        // patch 6plus
        if DeviceInfo.IS_5_5_INCHES() {
            alert.view.setNeedsLayout()
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TextFieldAlert+scan
    func showTextFieldAlertPlusScan(_ type: TextFieldAlertType, value: String?, confirmHandler: @escaping (String) -> Void, otherHandler:@escaping ()->Void) {
        
        let (title, message, placeholder, cancel, confirm) = type.generate()
        let alert = UIAlertController(title: BXLocalizedString(title, comment: ""), message: BXLocalizedString(message ?? "", comment: ""), preferredStyle: .alert)
        let action1 = UIAlertAction(title: BXLocalizedString(cancel, comment: ""), style: .cancel) { (_) -> Void in
            
        }
        action1.setValue(kTextColor2, forKey: "_titleTextColor")
        let action2 = UIAlertAction(title: BXLocalizedString(confirm, comment: ""), style: .default) { (_) -> Void in
            let newValue = alert.textFields![0].text
            delay(0.1, closure: {
                confirmHandler(newValue!)
            })
        }
        
        let action3 = UIAlertAction(title: BXLocalizedString("扫描二维码绑定", comment: ""), style: .default) { (_) -> Void in
            delay(0.1, closure: { () -> () in
                otherHandler()
            })
        }
        
        // disable confirm
        if value == nil { action2.isEnabled = false }
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = BXLocalizedString(placeholder, comment: "")
            textField.text = value
            
            if type == .bindCompany {
                textField.autocapitalizationType = .allCharacters
                textField.keyboardType = .asciiCapable
            }
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                switch type {
                case .bindCompany:
                    action2.isEnabled = textField.text?.count == 6
                    
                case .changeEmail:
                    action2.isEnabled = isValidEmail(textField.text ?? "")
                    
                default:
                    action2.isEnabled = textField.text != ""
                }
            }
        })
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        // patch 6plus
        if DeviceInfo.IS_5_5_INCHES() {
            alert.view.setNeedsLayout()
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - NormalAlert
    func showNormalAlert(_ type: NormalAlertType, cancelHandler: (() -> Void)?, confirmHandler: (() -> Void)?) {
        let (title, message, cancel, confirm, _) = type.generate()
        
        let alert = UIAlertController(title: BXLocalizedString(title ?? "", comment: ""), message: BXLocalizedString(message ?? "", comment: ""), preferredStyle: .alert)
        
        if let c = cancel {
            let action1 = UIAlertAction(title: BXLocalizedString(c, comment: ""), style: .cancel) { (_) -> Void in
                if let handler = cancelHandler {
                    delay(0.1, closure: { () -> () in handler() })
                }
            }
//            switch type {
//            case .taxShare:
//                action1.setValue(kThemeColor, forKey: "_titleTextColor")
//            case .autoConfirm:
//                action1.setValue(kRedColor, forKey: "_titleTextColor")
//            default:
//
//            }
//            action1.setValue(kTextColor2, forKey: "_titleTextColor")
            alert.addAction(action1)
        }
        
        if let c = confirm {
            let action2 = UIAlertAction(title: BXLocalizedString(c, comment: ""), style: .default) { (_) -> Void in
                if let handler = confirmHandler {
                    delay(0.1, closure: { () -> () in handler() })
                }
            }
            alert.addAction(action2)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Cover
    fileprivate struct AssociatedKeys {
        static var NoContentCover = "NoContentCover"
    }
    
    var coverView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.NoContentCover) as? UIView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.NoContentCover, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func showNoContentCover(_ view: UIView, type: NoContentType, inset: UIEdgeInsets = UIEdgeInsets.zero, color: UIColor = kLineColor) {
        if self.coverView == nil {
            self.coverView = Bundle.main.loadNibNamed("NoContentCover", owner: self, options: nil)?.first as? UIView
        }
        self.coverView?.backgroundColor = color
        
        let iv1 = self.coverView!.viewWithTag(1) as! UIImageView
        let lbl2 = self.coverView!.viewWithTag(2) as! UILabel
        let lbl3 = self.coverView!.viewWithTag(3) as! UILabel
        
        lbl2.textColor = kTextColor3
        lbl2.font = kFont13
        lbl3.textColor = kTextColor3
        lbl3.font = kFont13
 
        switch type {
        case .dataNull:
            iv1.image = UIImage(named: "page_null")
            lbl2.text = BXLocalizedString("暂无数据", comment: "")
            lbl3.text = nil
        default:
            break
            
        }
        
        var frame = view.bounds
        frame.origin.x += inset.left
        frame.origin.y += inset.top
        frame.size.width -= inset.left + inset.right
        frame.size.height -= inset.top + inset.bottom
        self.coverView!.frame = frame
        view.addSubview(self.coverView!)
    }
    
    func showLoginCover(_ view: UIView, type: ContentType, inset: UIEdgeInsets = UIEdgeInsets.zero, color: UIColor = kLineColor, parentVC: UIViewController) {
        if self.coverView == nil {
            var frame = view.bounds
            frame.origin.x += inset.left
            frame.origin.y += inset.top
            frame.size.width -= inset.left + inset.right
            frame.size.height -= inset.top + inset.bottom
            self.coverView = UnLoginCover(frame: frame, parentVC: parentVC)
            view.addSubview(self.coverView!)
        }
        self.coverView?.backgroundColor = color
        
    }
    
    func hideNoContentCover(_ view: UIView) {
        if let cover = self.coverView {
            cover.removeFromSuperview()
        }
    }
    
    
}
