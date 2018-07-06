//
//  LoginViewController.swift
//  Hometown
//
//  Created by 王浩 on 2018/7/6.
//  Copyright © 2018年 haoge. All rights reserved.
//

import UIKit

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
        nameLabel.text = "家宝"
        nameLabel.textColor = UIColor.purple
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        
        phoneLabel.text = "手机号"
        phoneLabel.textColor = UIColor.black
        phoneLabel.font = UIFont.systemFont(ofSize: 14)
        phoneTF.placeholder = "请输入手机号"
        phoneTF.textColor = UIColor.purple
        phoneTF.keyboardType = .numberPad
        phoneTF.delegate = self
        
        line1.backgroundColor = UIColor.gray
        line2.backgroundColor = UIColor.gray
        
        passwordLabel.text = "密码"
        passwordLabel.textColor = UIColor.black
        passwordLabel.font = UIFont.systemFont(ofSize: 14)
        passwordTF.placeholder = "请输入密码"
        passwordTF.textColor = UIColor.purple
        passwordTF.keyboardType = .numberPad
        passwordTF.delegate = self
        
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loginButton.backgroundColor = UIColor.purple
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
        print("登录")
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
