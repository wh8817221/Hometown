//
//  RequestHelper.swift
//  baoxiao
//
//  Created by ruanyu on 15/12/9.
//  Copyright © 2015年 schope. All rights reserved.
//

import KeychainAccess
import Alamofire
import ObjectMapper
import PKHUD

extension DataRequest {
    // ObjectMapper
    public static func ObjectMapperSerializer<T: Mappable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else { return .failure(error!) }
            let result = DataRequest.serializeResponseJSON(options: .allowFragments, response: response, data: data, error: error)
            
            print(result.value as Any)

            if let parsedObject = Mapper<T>().map(JSONObject: result.value) {
                return .success(parsedObject)
            }
            return .failure(result.error!)
        }
    }
    
    @discardableResult
    public func responseObjectMapper<T: Mappable>(_ completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(responseSerializer: DataRequest.ObjectMapperSerializer(), completionHandler: completionHandler)
    }
}


enum RequestHelper {
    static let baseURL = "http:192.168.1.244:8000"
    static let apiVerion = 0
    
    static let errorUpdateForce = 40011
    //微信更新
    static let errorWechatExpire = 40012
    //登录失效
    static let errorLoginFailed = 40004
    // user
    case userLogin([String: Any])
    case userRegister([String: Any])
    case userLogout([String: Any])
    case userToken([String: Any])
    case userGet(([String: Any]))
    case userEdit(([String: Any]))
    
    case newsGet(([String: Any]))
    case newsEditStatus(([String: Any]))
    case invoiceCheck(([String: Any]))
    case invoiceSave(([String: Any]))
    case invoiceList(([String: Any]))
    case invoiceGetquotalog(([String: Any]))
    case messageList(([String: Any]))
    case mobilewxLogin(([String: Any]))
    case bindphone(([String: Any]))
    case checkphone(([String: Any]))
    case resetPassword(([String: Any]))
    case changePassword(([String: Any]))
    case getCode(([String: Any]))
    case verifyCode(([String: Any]))
    case homepageCounts(([String: Any]))

    fileprivate func extend(_ params: [String: Any]) -> [String: Any] {
        var extendParams = params
        
        extendParams["os_type"] = 1
        extendParams["version"] = RequestHelper.apiVerion
        extendParams["timestamp"] = Int(Date().timeIntervalSince1970)
        return extendParams
    }
    
    func generate() -> (url:String, params:Dictionary<String, Any>) {
        var url:String = RequestHelper.baseURL
        var params = [String: Any]()
        switch self {
        case .userLogin(let tmp):
            url += "/api/user/phone/login"
            params = tmp
        case .userRegister(let tmp):
            url += "/api/user/phone/register"
            params = tmp
            
        case .userLogout(let tmp):
            url += "/api/user/logout"
            params = tmp
            
        case .userToken(let tmp):
            url += "/api/user/token"
            params = tmp
            
        case .userGet(let tmp):
            url += "/api/user/app/get"
            params = tmp
        case .userEdit(let tmp):
            url += "/api/user/edit"
            params = tmp
        case .newsGet(let tmp):
            url += "/api/news/get/list"
            params = tmp
        case .newsEditStatus(let tmp):
            url += "/api/news/edit/status"
            params = tmp
        case .invoiceCheck(let tmp):
            url += "/api/invoice/check"
            params = tmp
        case .invoiceSave(let tmp):
            url += "/api/invoice/save"
            params = tmp
        case .invoiceList(let tmp):
            url += "/api/invoice/app/list"
            params = tmp
        case .invoiceGetquotalog(let tmp):
            url += "/api/user/getquotalog"
            params = tmp
        case .messageList(let tmp):
            url += "/api/news/message/list"
            params = tmp
        case .mobilewxLogin(let tmp):
            url += "/api/user/mobilewx/login"
            params = tmp
        case .bindphone(let tmp):
            url += "/api/user/bindphone"
            params = tmp
        case .checkphone(let tmp):
            url += "/api/user/checkphone"
            params = tmp
        case .resetPassword(let tmp):
            url += "/api/user/reset/password"
            params = tmp
        case .changePassword(let tmp):
            url += "/api/user/change/password"
            params = tmp
        case .getCode(let tmp):
            url += "/api/user/get/code"
            params = tmp
        case .verifyCode(let tmp):
            url += "/api/user/verify/code"
            params = tmp
        case .homepageCounts(let tmp):
            url += "/api/news/homepage/counts"
            params = tmp
            
        }
        
        return (url, extend(params))
    }
}

