//
//  UserManager.swift
//  baoxiao
//
//  Created by ruanyu on 15/12/9.
//  Copyright © 2015年 schope. All rights reserved.
//

import KeychainAccess

class UserManager {
    static let sharedInstance = UserManager()
    
    fileprivate var keychain: Keychain!
    
    fileprivate var _open_id: String
    fileprivate var _username: String

    fileprivate var _phone_number: String
    init() {
        keychain =  Keychain()
        
        _open_id = keychain["cpt_openid"] ?? ""
        _username = keychain["cpt_username"] ?? ""
        _phone_number = keychain["cpt_phone_number"] ?? ""

    }
    
    var openId: String {
        get {
            return _open_id
        }
        set {
            _open_id = newValue
            keychain["cpt_openid"] = newValue
        }
    }
    
    var username: String {
        get {
            return _username
        }
        set {
            _username = newValue
            keychain["cpt_username"] = newValue
        }
    }
    
    var phoneNumber: String {
        get {
            return _phone_number
        }
        set {
            _phone_number = newValue
            keychain["cpt_phone_number"] = newValue
        }
    }
    
    func reset() {
        _open_id = ""
        _username = ""
        keychain["cpt_openid"] = nil
        keychain["cpt_username"] = nil
        
        _phone_number = ""
        keychain["cpt_phone_number"] = nil
    }
    
    func setUser(_ id: String, telephone: String) {
        _open_id = id
        keychain["cpt_openid"] = id
        _phone_number = telephone
        keychain["cpt_phone_number"] = telephone
    }
    
    func getUserOpenID() -> [String: Any] {
        var uc = [String: String]()
        if !openId.isEmpty {
            uc["open_id"] = openId
        }
        return uc
    }
}

