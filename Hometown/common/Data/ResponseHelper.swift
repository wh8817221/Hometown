//
//  ResponseHelper.swift
//  baoxiao
//
//  Created by ruanyu on 15/12/24.
//  Copyright © 2015年 schope. All rights reserved.
//

import ObjectMapper

// MARK: - Generic
class ResultT<T>: Mappable {
    var code: Int = 9999
    var msg: String = BXLocalizedString("网络不给力", comment: "")
    var data: T?
    var error: AnyObject?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        msg <- map["msg"]
        data <- map["data"]
        error <- map["error"]
    }
}

class Result<T: Mappable>: Mappable {
    var code: Int = 9999
    var msg: String = BXLocalizedString("网络不给力", comment: "")
    var data: T?
    var error: AnyObject?
    var reSubmitTip: String?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        code <- map["code"]
        msg <- map["msg"]
        data <- map["data"]
        error <- map["error"]
        reSubmitTip <- map["data"]
    }
}

class ResultArray<T: Mappable>: Mappable {
    var code: Int = 9999
    var msg: String = BXLocalizedString("网络不给力", comment: "")
    var data: [T]?
    var error: AnyObject?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        msg <- map["msg"]
        data <- map["data"]
        error <- map["error"]
    }
}

class ObjectNull: Mappable {
    
    required init?( map: Map){
        
    }

    func mapping( map: Map) {
    }
}

class ObjectTabNumber: Mappable {
    var company: Int?
    var individual: Int?
    var todo: Int?
   
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        company <- map["company"]
        individual <- map["individual"]
        todo <- map["todo"]
    }
}

class ObjectAttachment: NSObject, NSCoding, Mappable {
    var id: Int?
    var create_time: String?
    var thumb_path: String?
    var image_path: String?
    var image_data: UIImage?
    
    var name: String?
    var type: String?
    var is_web_upload: Bool = false
    var date: String?
    
    required init?(map: Map){

    }
    
    init(name: String, path: String) {
        self.name = name
        self.image_path = path
    }
    
    init(image: UIImage) {
        self.image_data = image
        self.date = Date().stringFromFormat(string: "yyyy-MM-dd HH:mm:ss")
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        create_time <- map["create_time"]
        thumb_path <- map["thumb_path"]
        image_path <- map["attachment_path"]

        name <- map["name"]
        type <- map["type"]
        is_web_upload <- map["is_web_upload"]
        date <- map["date"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        if let name = aDecoder.decodeObject(forKey: "name") as? String { self.name = name }
        if let date = aDecoder.decodeObject(forKey: "date") as? String { self.date = date }
        if let path = aDecoder.decodeObject(forKey: "path") as? String { self.image_path = path }
        if let data = aDecoder.decodeObject(forKey: "image") as? Data {
            self.image_data = UIImage(data: data)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        if let id = id { aCoder.encodeCInt(Int32(id), forKey: "id") }
        if let name = name { aCoder.encode(name, forKey: "name") }
        if let date = date { aCoder.encode(date, forKey: "date") }
        if let path = image_path { aCoder.encode(path, forKey: "path") }
        if let image = image_data {
            aCoder.encode(UIImageJPEGRepresentation(image, 0.7), forKey: "image")
        }
    }
}

class ObjectAction: Mappable {
    var id: Int?
    var name: String?
    var intent: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        intent <- map["intent"]
    }
    
    init(name: String, intent: String) {
        self.name = name
        self.intent = intent
    }
    
    init(id: Int, name: String, intent: String) {
        self.id = id
        self.name = name
        self.intent = intent
    }
}

//MARK:-ObjectReceiptDetail
class ObjectReceiptDetail: NSObject, Mappable {
    
    var id: Int?
    /**发票title*/
    var title: String?
    /**发票种类*/
    var fpzl: String?
    /**发票代码*/
    var fpdm: String?
    /**发票号码*/
    var fphm: String?
    /**校验码*/
    var jym: String?
    /**开票日期*/
    var kprq: String?
    /**供方名称*/
    var gfmc: String?
    /**销方名称*/
    var xfmc: String?
    /**税额*/
    var se: String?
    /**发票影像*/
    var file_path: String?
    /**金额*/
    var je: String?
    /**销方地址电话*/
    var xfdzdh: String?
    /**供方地址电话*/
    var gfdzdh: String?
    /**供方识别号*/
    var gfsbh: String?
    /**销方纳税人识别号*/
    var xfsbh: String?
    /**销方银行账号*/
    var xfyhzh: String?
    /**供方银行账号*/
    var gfyhzh: String?
    
    //机动车
    /**厂牌型号*/
    var cpxh: String?
    /**车辆类型*/
    var cllx: String?
    /**车辆识别代号/车架号码*/
    var cjhm: String?
    /**不含税价*/
    var cjfy: String?
    /**产地*/
    var cd: String?
    /**电话*/
    var dh: String?
    /**吨位*/
    var dw: String?
    /**地址*/
    var dz: String?
    /**发动机号*/
    var fdjhm: String?
    /**购买方名称*/
    var ghdw: String?
    /**合格证号*/
    var hgzs: String?
    /**进口证明书号*/
    var jkzmsh: String?
    /**机器编号*/
    var jqbh: String?
    /**价税合计*/
    var jshj: String?
    /**开户银行*/
    var khyh: String?
    /**销方纳税人识别号*/
    var nsrsbh: String?
    /**身份证号码/组织机构代码*/
    var sfzhm: String?
    /**商检单号*/
    var sjdh: String?
    /**机器编码*/
    var skph: String?
    /**主管税务机关代码*/
    var swjg_dm: String?
    /**主管税务机关名称*/
    var swjg_mc: String?
    /**完税凭证号码*/
    var wspzhm: String?
    /**限乘人数*/
    var xcrs: String?
    /**销货单位名称*/
    var xhdwmc: String?
    /**作废标志*/
    var zfbz: String?
    /**账号*/
    var zh: String?
    /**增值税税额*/
    var zzsse: String?
    /**增值税税率或征收率*/
    var zzssl: String?
    /**查验日期*/
    var create_time: String?
    
    //    var details: [ObjectDetails]?
    
    required init?(map: Map){
        
    }
    
    override init() {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        skph <- map["skph"]
        
        title <- map["title"]
        fpzl <- map["fpzl"]
        fpdm <- map["fpdm"]
        fphm <- map["fphm"]
        kprq <- map["kprq"]
        jym <- map["jym"]
        gfmc <- map["gfmc"]
        
        xfmc <- map["xfmc"]
        jshj <- map["jshj"]
        se <- map["se"]
        je <- map["je"]
        file_path <- map["file_path"]
        xfdzdh <- map["xfdzdh"]
        gfdzdh <- map["gfdzdh"]
        xfsbh <- map["xfsbh"]
        gfsbh <- map["gfsbh"]
        xfyhzh <- map["xfyhzh"]
        gfyhzh <- map["gfyhzh"]
//        details <- map["details"]
        //发动机
        cpxh <- map["cpxh"]
        cllx <- map["cllx"]
        cjhm <- map["cjhm"]
        cjfy <- map["cjfy"]
        cd <- map["cd"]
        dh <- map["dh"]
        dw <- map["dw"]
        dz <- map["dz"]
        fdjhm <- map["fdjhm"]
        ghdw <- map["ghdw"]
        hgzs <- map["hgzs"]
        jkzmsh <- map["jkzmsh"]
        jqbh <- map["jqbh"]
        jshj <- map["jshj"]
        khyh <- map["khyh"]
        nsrsbh <- map["nsrsbh"]
        sfzhm <- map["sfzhm"]
        sjdh <- map["sjdh"]
        skph <- map["skph"]
        swjg_dm <- map["swjg_dm"]
        swjg_mc <- map["swjg_mc"]
        wspzhm <- map["wspzhm"]
        xcrs <- map["xcrs"]
        xhdwmc <- map["xhdwmc"]
        
        zfbz <- map["zfbz"]
        zh <- map["zh"]
        zzsse <- map["zzsse"]
        zzssl <- map["zzssl"]
        create_time <- map["create_time"]
        
    }
}
//MARK:-ObjecReceiptDetail
class ObjectDetails: Mappable {

    /**货物名称*/
    var hwmc: String?
    /**税后金额*/
    var je: String?
    /**税率*/
    var slv: String?
    /**税额*/
    var se: String?
    /**单价*/
    var dj: String?
    /**数量*/
    var sl: String?
    /**单位*/
    var dw: String?
    /**规格型号*/
    var ggxh: String?
    
    /**车牌号*/
    var cph: String?
    /**类型*/
    var lx: String?
    /**通行日期起*/
    var txrqq: String?
    /**通行日期止*/
    var txrqz: String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        
        hwmc <- map["hwmc"]
        je <- map["je"]
        slv <- map["slv"]
        se <- map["se"]
        
        dj <- map["dj"]
        sl <- map["sl"]
        dw <- map["dw"]
        ggxh <- map["ggxh"]
        
        cph <- map["cph"]
        lx <- map["lx"]
        txrqq <- map["txrqq"]
        txrqz <- map["txrqz"]
    }
}

// MARK: - User
class ObjectLogin: Mappable {
    var open_id: String?
    var realname: String?
    var is_bind: Bool = false
    var telephone: String?
    //忘记密码验证
    var verify_id: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        open_id <- map["open_id"]
        realname <- map["realname"]
        is_bind <- map["is_bind"]
        telephone <- map["telephone"]
        verify_id <- map["verify_id"]
    }
}

class ObjectOption: Mappable {
    var id: Int?
    var name: String?
    var object: String?
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        object <- map["object"]
    }
}

class ObjectWechatAuth: Mappable {
    /*
     access_token    接口调用凭证
     expires_in    access_token接口调用凭证超时时间，单位（秒）
     refresh_token    用户刷新access_token
     openid    授权用户唯一标识
     scope    用户授权的作用域，使用逗号（,）分隔
     unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
     */
    var access_token: String?
    var expires_in: String?
    var openid: String?
    var scope: String?
    var unionid: String?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        access_token <- map["access_token"]
        expires_in <- map["expires_in"]
        openid <- map["openid"]
        scope <- map["scope"]
        unionid <- map["unionid"]
    }
}

class ObjectWechatUser: Mappable {

    var headimgurl: String?
    var nickname: String?
    var openid: String?
    var sex: Int?
    var unionid: String?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        headimgurl <- map["headimgurl"]
        nickname <- map["nickname"]
        openid <- map["openid"]
        sex <- map["sex"]
        unionid <- map["unionid"]
    }
}

class ObjectCompanyCard: Mappable {
    var id: Int?
    var account_bank: String?
    var account_number: String?
    var address: String?
    var company_name: String?
    var company_phone: String?
    var headimgurl: String?
    var name: String?
    var tax_number: String?
    var quota: Int?
    var subscribe: Bool = false

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        account_bank <- map["account_bank"]
        account_number <- map["account_number"]
        address <- map["address"]
        company_name <- map["company_name"]
        company_phone <- map["company_phone"]
        headimgurl <- map["headimgurl"]
        name <- map["name"]
        tax_number <- map["tax_number"]
        quota <- map["quota"]
        subscribe <- map["subscribe"]
        
    }
}

class ObjectInformation: Mappable {
    var count: Int?
    var page: Int?
    var informations: [ObjectNew]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        page <- map["page"]
        informations <- map["information"]
    }
}

class ObjectNew: Mappable {
    var id: Int?
    var create_time: String?
    var creator: String?
    var is_read: Bool = false
    var text: String?
    var title: String?
    var url: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        create_time <- map["create_time"]
        creator <- map["creator"]
        is_read <- map["is_read"]
        text <- map["text"]
        title <- map["title"]
        url <- map["url"]
    }
}

class ObjectReceipt: Mappable {
    var invoice: ObjectReceiptDetail?
    var invoice_detail: [ObjectDetails]?
    var message: String?
    var same_company: Bool = false
    var same_tax: Bool = false
    var status_code: String?
    var reason: String?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        invoice <- map["invoice"]
        invoice_detail <- map["invoice_detail"]
        message <- map["message"]
        same_company <- map["same_company"]
        same_tax <- map["same_tax"]
        status_code <- map["status_code"]
        reason <- map["reason"]
    }
}

class ObjectReceiptList: Mappable {
    var invocie_list: [ObjectReceipt]?
    var count: Int?
    var page: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        invocie_list <- map["invocie_list"]
        count <- map["count"]
        page <- map["page"]
    }
}

class ObjectQuotaLog: Mappable {
    class ObjectLog: Mappable {
        var create_time: String?
        var is_out_date: Bool = false
        var name: String?
        var quota_expire: String?
        var tel: String?
        required init?(map: Map){
            
        }
        
        func mapping(map: Map) {
            create_time <- map["create_time"]
            is_out_date <- map["is_out_date"]
            name <- map["name"]
            quota_expire <- map["quota_expire"]
            tel <- map["tel"]
        }
    }
    
    class ObjectCommon: Mappable {
        var create_time: String?
        var is_bind: Bool = false
        required init?(map: Map){
            
        }
        
        func mapping(map: Map) {
            create_time <- map["create_time"]
            is_bind <- map["is_bind"]
        }
    }
    
    var logs: [ObjectLog]?
    var month: ObjectCommon?
    var user: ObjectCommon?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        logs <- map["logs"]
        month <- map["month"]
        user <- map["user"]
    }
}

class ObjectMessage: Mappable {
    var create_time: String?
    var content: String?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        create_time <- map["create_time"]
        content <- map["content"]
    }
}
class ObjectAppCount: Mappable {
    var home_count: Int?
    var msg_count: Int?
    var news_count: Int?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        home_count <- map["home_count"]
        msg_count <- map["msg_count"]
        news_count <- map["news_count"]
    }
}
