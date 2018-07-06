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
    
}
