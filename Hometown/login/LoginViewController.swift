//
//  LoginViewController.swift
//  Hometown
//
//  Created by 王浩 on 2018/7/6.
//  Copyright © 2018年 haoge. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.image = UIImage(named:"icon")
        iconImageView.radiusView(iconImageView.frame.height/2)
        nameLabel.text = "家乡帮"
        nameLabel.textColor = kThemeColor
        nameLabel.font = kFont16.bold(size: 16)
        
        phoneLabel.text = "手机号"
        phoneLabel.textColor = kThemeColor
        phoneLabel.font = kFont14
        
        phoneTF.setPlaceholder(placeholder: "请输入手机号", color: kLineColor, font: kFont16)
        phoneTF.tintColor = kThemeColor
        phoneTF.textColor = kThemeColor
        phoneTF.font = kFont16
        phoneTF.delegate = self
        phoneTF.clearButtonMode = .whileEditing
        phoneTF.keyboardType = .numberPad
        phoneTF.returnKeyType = .next
        phoneTF.text = "18101377455"
        
        line1.backgroundColor = kLineColor
        line2.backgroundColor = kLineColor
        
        passwordLabel.text = "密码"
        passwordLabel.textColor = kThemeColor
        passwordLabel.font = kFont14
        
        passwordTF.setPlaceholder(placeholder: "请输入密码", color: kLineColor, font: kFont16)
        passwordTF.tintColor = kThemeColor
        passwordTF.textColor = kThemeColor
        passwordTF.font = kFont16
        passwordTF.delegate = self
        passwordTF.leftViewMode = .always
        passwordTF.isSecureTextEntry = true
        passwordTF.returnKeyType = .go
        passwordTF.text = "1"
        
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(kWhiteColor, for: .normal)
        loginButton.titleLabel?.font = kFont16
        loginButton.backgroundColor = kThemeColor
        loginButton.addTarget(self, action: #selector(loginAction(_ :)), for: .touchUpInside)
        
        
        //注册通知监听键盘的出现和消失
        NotificationCenter.default.addObserver(self, selector: #selector(OverlayPickerViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OverlayPickerViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        view.addGestureRecognizer(tapGR)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //导航透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //去掉导航栏底部的黑线
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //注册通知监听键盘的出现和消失
        NotificationCenter.default.addObserver(self, selector: #selector(OverlayPickerViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OverlayPickerViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //显示
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Action
    @objc func tapAction(_ sender: UITapGestureRecognizer!) {
        if phoneTF.isFirstResponder { phoneTF.resignFirstResponder() }
        if passwordTF.isFirstResponder { passwordTF.resignFirstResponder() }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func loginAction(_ sender: UIButton) {
        if phoneTF.isFirstResponder {phoneTF.resignFirstResponder()}
        if passwordTF.isFirstResponder {passwordTF.resignFirstResponder()}
        
        guard let telephone = phoneTF.text, !telephone.isEmpty else {
            showHideTextHUD(BXLocalizedString("请输入手机号", comment: ""))
            return
        }
        
        if let _ = Int64(telephone) {
            if !isValidMobile(telephone) {
                showHideTextHUD(BXLocalizedString("请输入正确手机号", comment: ""))
                return
            }
        }
        
        guard let password = passwordTF.text, !password.isEmpty else {
            showHideTextHUD(BXLocalizedString("请输入密码", comment: ""))
            return
        }
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let d1 = ["telephone": telephone, "password": password]
        let d2 = RequestHelper.userLogin(d1).generate()
        Alamofire.request(d2.url, method: .post, parameters: d2.params, encoding: JSONEncoding.default, headers: nil)
            .responseObjectMapper {(response: DataResponse<Result<ObjectLogin>>) -> Void in
                switch response.result {
                case .success(let result):
                    if result.code == 0 {
                        PKHUD.sharedHUD.hide(afterDelay: 0.25)

                        // clear pwd
                        self.passwordTF.text = nil
                        if let data = result.data, let open_id = data.open_id {
                            // kaychain user
                            UserManager.sharedInstance.setUser(open_id, telephone: data.telephone ?? "")
                           
                            let root = getStoryboardInstantiateViewController(identifier: "Main") as! MainViewController
                            let delegate = UIApplication.shared.delegate as! AppDelegate
                            delegate.changeRootViewController(root, animated: true)
                        }
                        
                    } else {
                        
                        self.processResponseError(result.code, msg: result.msg, error: result.error)
                    }
                case .failure(_):
                    self.processNetworkError()
                }
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneTF {
            phoneTF.text = textField.text ?? ""
        } else if textField == passwordTF {
            passwordTF.text = textField.text ?? ""
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === phoneTF {
            passwordTF.becomeFirstResponder()
            return false
            
        } else {
            passwordTF.resignFirstResponder()
            self.loginAction(self.loginButton)
            return true
        }
    }
    
    //MARK:键盘的隐藏显示
    @objc func keyboardWillShow(_ notification: Notification){
        let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let height = keyboardFrame?.size.height
        
        var viewFrame = view.frame
        viewFrame.origin.y =  (screenHeight - viewFrame.size.height) - height! + 100
        view.frame = viewFrame
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        var viewFrame = view.frame
        viewFrame.origin.y = screenHeight - viewFrame.size.height
        view.frame = viewFrame
    }
    
    deinit {
        NotificationCenter.removeObserver(observer: self, name: NSNotification.Name.UIKeyboardWillShow)
        NotificationCenter.removeObserver(observer: self, name: NSNotification.Name.UIKeyboardWillHide)
    }
    
}
