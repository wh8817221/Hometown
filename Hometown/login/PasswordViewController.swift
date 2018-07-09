//
//  PasswordViewController.swift
//  chapiaotong
//
//  Created by 王浩 on 2018/5/28.
//  Copyright © 2018年 王浩. All rights reserved.

import UIKit

import PKHUD
import Alamofire
import zxcvbn_ios

class PasswordViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    enum PasswordMode {
        case forget
        case register
    }
    var mode: PasswordMode = .forget
    fileprivate var zxcvbn = DBZxcvbn()
    @IBOutlet weak var tableView: UITableView!
    fileprivate var strength1: PasswordStrengthView!
    fileprivate var strength2: PasswordStrengthView!
    
    var phoneNumber: String?
    fileprivate var newPassword: String?
    fileprivate var againPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch mode {
        case .forget:
            title = BXLocalizedString("忘记密码", comment: "")
        default:
            title = BXLocalizedString("立即注册", comment: "")
        }

        self.tableView.backgroundColor = kLineColor
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.bounces = false
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 100)
        let btn1 = ScaleButton(type: .custom)
        btn1.setTitle(BXLocalizedString("确定", comment: ""), for: .normal)
        btn1.backgroundColor = kThemeColor
        btn1.setTitleColor(kWhiteColor, for: .normal)
        btn1.titleLabel?.font = kFont14
        footerView.addSubview(btn1)
        btn1.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        btn1.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
        tableView.tableFooterView = footerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIApplication
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    //MARK:- 确定
    @objc fileprivate func confirmAction(_ sender: UIButton) {
        switch mode {
        case .forget:
            self.forgetAction()
        default:
            self.registerAction()
        }
    }
    
    //MARK:- 忘记密码确定
    fileprivate func forgetAction() {
        self.view.endEditing(true)
        guard let newP = self.newPassword, !newP.isEmpty else {
            showHideTextHUD(BXLocalizedString("请输入新密码", comment: ""))
            return
        }

        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let d1 = ["verify_id": 1]
//        d1["password"] = newP
        
        let d2 = RequestHelper.resetPassword(d1).generate()
        Alamofire.request(d2.url, method: .post, parameters: d2.params, encoding: JSONEncoding.default, headers: nil)
            .responseObjectMapper {(response: DataResponse<Result<ObjectNull>>) -> Void in
                switch response.result {
                case .success(let result):
                    if result.code == 0 {
                        PKHUD.sharedHUD.hide(afterDelay: 0.25)
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.processResponseError(result.code, msg: result.msg, error: result.error)
                    }
                case .failure(_):
                    self.processNetworkError()
                }
        }
    }
    
    //MARK:- 修改密码确定
    fileprivate func registerAction() {
        self.view.endEditing(true)
        guard let phone = self.phoneNumber, !phone.isEmpty else {
            showHideTextHUD(BXLocalizedString("请输入手机号", comment: ""))
            return
        }
        
        guard let newP = self.newPassword, !newP.isEmpty else {
            showHideTextHUD(BXLocalizedString("请输入密码", comment: ""))
            return
        }
        
        guard let againP = self.againPassword, !againP.isEmpty else {
            showHideTextHUD(BXLocalizedString("请再次输入密码", comment: ""))
            return
        }
        
        if newP != againP {
            showHideTextHUD(BXLocalizedString("两次密码不一致", comment: ""))
            return
        }
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        var d1 = UserManager.sharedInstance.getUserOpenID()
        d1["phone_number"] = self.phoneNumber
        d1["new_password"] = self.newPassword
        let d2 = RequestHelper.userRegister(d1).generate()
        
        Alamofire.request(d2.url, method: .post, parameters: d2.params, encoding: JSONEncoding.default, headers: nil)
            .responseObjectMapper {(response: DataResponse<Result<ObjectNull>>) -> Void in
                switch response.result {
                case .success(let result):
                    if result.code == 0 {
                        PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                        PKHUD.sharedHUD.hide(afterDelay: 0.25)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.processResponseError(result.code, msg: result.msg, error: result.error)
                    }
                case .failure(_):
                    self.processNetworkError()
                }
        }
    }
    
    // MARK: - Action
    @objc func changedAction(_ sender: UITextField) {
        if let cell = sender.parentViewOfType(UITableViewCell.self) {
            let pw4 = cell.viewWithTag(4) as! PasswordStrengthView
            if let text = sender.text {
                if text.isEmpty {
                    pw4.score = 0
                } else {
                    let result = zxcvbn.passwordStrength(text)
                    pw4.score = Int((result?.score)!==4 ? (result?.score)! : (result?.score)!+1);
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case .register:
            return 3
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell", for: indexPath)
        let lbl1 = cell.viewWithTag(1) as! UILabel
        let tf2 = cell.viewWithTag(2) as! UITextField
        let line3 = cell.viewWithTag(3)
        let pw4 = cell.viewWithTag(4) as! PasswordStrengthView
        
        lbl1.textColor = kTextColor1
        lbl1.font = kFont12
        
        tf2.font = kFont12
        tf2.delegate = self
        tf2.clearButtonMode = .whileEditing
        tf2.addTarget(self, action: #selector(changedAction(_:)), for: .editingChanged)
        line3?.backgroundColor = kLineColor

        switch indexPath.row {
        case 0:
            lbl1.text = BXLocalizedString("手机号", comment: "")
            tf2.placeholder = BXLocalizedString("请输入手机号", comment: "")
            tf2.text = self.phoneNumber ?? ""
            tf2.isSecureTextEntry = false
            pw4.isHidden = true
        case 1:
            switch mode {
            case .register:
                lbl1.text = BXLocalizedString("新密码", comment: "")
                tf2.placeholder = BXLocalizedString("请输入新密码", comment: "")
                tf2.isSecureTextEntry = true
                strength1 = pw4
            default:
                lbl1.text = BXLocalizedString("验证码", comment: "")
                tf2.placeholder = BXLocalizedString("请输入验证码", comment: "")
                tf2.isSecureTextEntry = false
                pw4.isHidden = true
            }
            
        default:
            lbl1.text = BXLocalizedString("再次输入", comment: "")
            tf2.placeholder = BXLocalizedString("请再次输入新密码", comment: "")
            tf2.isSecureTextEntry = true
            strength2 = pw4
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let cell = textField.parentViewOfType(UITableViewCell.self), let ip = tableView.indexPath(for: cell) {
            switch ip.row {
            case 0:
                strength2.isHidden = true
            case 1:
                switch mode {
                case .forget:
                    strength2.isHidden = true
                case .register:
                    strength2.isHidden = false
                }
                
            case 2:
                strength2.isHidden = false
            default:
                break
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cell = textField.parentViewOfType(UITableViewCell.self), let ip = self.tableView.indexPath(for: cell) {
            switch (ip.section, ip.row) {
            case (0, 0):
                self.phoneNumber = textField.text ?? ""
            case (0, 1):
                switch self.mode {
                case .register:
                    self.newPassword = textField.text ?? ""
                default:
                    break
                }
            case (0, 2):
                self.againPassword = textField.text ?? ""
            default:
                break
            }
        }
        
        strength1.isHidden = true
        strength2.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
}



