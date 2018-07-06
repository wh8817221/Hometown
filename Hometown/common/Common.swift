//
//  Common.swift
//  chapiaotong
//
//  Created by 王浩 on 2018/5/3.
//  Copyright © 2018年 王浩. All rights reserved.
//

import UIKit
import DynamicColor
import PKHUD

let null = NSNull()
let colon = "："
let space = " "

// callback
typealias DictionaryCallback = (_ value: [String:Any]) -> Void
typealias ObjectCallback = (_ value: Any) -> Void

//屏幕的高
let screenHeight:CGFloat = UIScreen.main.bounds.height
let screenWidth:CGFloat = UIScreen.main.bounds.width

//适配iPhoneX
var IS_IPHONE_X: Bool {
    return UIScreen.instancesRespond(to: #selector(getter: UIDynamicItem.bounds)) ? CGSize(width: 375, height: 812).equalTo(UIScreen.main.bounds.size) : false
}

let navHeight:CGFloat = IS_IPHONE_X ? 24 : 0
let tabHeight:CGFloat = IS_IPHONE_X ? 34 : 0

//MARK:-主题颜色
let kThemeColor = UIColor(hexString: "#4eb6fd")
let kTintedColor = kThemeColor.tinted(amount: 0.14)

let kCircleColor = UIColor(hexString: "#aaaaaa")
let kClearColor = UIColor.clear
let kPinkColor = UIColor(hexString: "#fde2e5")
let kDeepPinkColor = UIColor(hexString: "#fc6d6d")
let kWhiteColor = UIColor(hexString: "#FFFFFF")
let kPurpleColor = UIColor(hexString: "#a567e4")
let kTripColor = UIColor(hexString: "#24dddb")
let kRedColor = UIColor(hexString: "#f75e5e")
let kGreenColor = UIColor(hexString: "#44db5e")
let kOrangeColor = UIColor(hexString: "#ffad10")
let kBlueColor = UIColor(hexString: "#4eb6fd")

let kBlackAlphaColor = UIColor(white: 0, alpha: 0.625)
let kLineColor = UIColor(hexString: "#efeff4")
let kTextColor1 = UIColor(hexString: "#333333")
let kTextColor2 = UIColor(hexString: "#808080")
let kTextColor3 = UIColor(hexString: "#a0a0a0")

//MARK:- font (不用动态字体)
let kFont20 = UIFont.systemFont(ofSize: 20)
let kFont17  = UIFont.systemFont(ofSize: 17)
let kFont16  = UIFont.systemFont(ofSize: 16)
let kFont15  = UIFont.systemFont(ofSize: 15)
let kFont14  = UIFont.systemFont(ofSize: 14)
let kFont13  = UIFont.systemFont(ofSize: 13)
let kFont12  = UIFont.systemFont(ofSize: 12)
let kFont11  = UIFont.systemFont(ofSize: 11)
let kFont10  = UIFont.systemFont(ofSize: 10)

func isValidEmail(_ email: String) -> Bool {
    // http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    let emailRegex = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: email)
}


func isValidMobile(_ mobile: String) -> Bool {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,178
     * 联通：130,131,132,155,156,185,186,176
     * 电信：133,153,180,181,189,177
     * 170
     */
    //    let mobileRegex = "^1(3[0-9]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$"
    //    let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
    //    return mobileTest.evaluateWithObject(mobile)
    return mobile.count == 11
}

func showHideTextHUD(_ text: String?) {
    PKHUD.sharedHUD.contentView = PKHUDTextView(text: text)
    if !PKHUD.sharedHUD.isVisible {
        PKHUD.sharedHUD.show()
    }
    PKHUD.sharedHUD.hide(afterDelay: 1)
}

func showSuccessHUD() {
    PKHUD.sharedHUD.contentView = PKHUDSuccessView()
    if !PKHUD.sharedHUD.isVisible {
        PKHUD.sharedHUD.show()
    }
    PKHUD.sharedHUD.hide(afterDelay: 0.25)
}

func showHideErrorHUD() {

    PKHUD.sharedHUD.contentView = PKHUDErrorView(title: BXLocalizedString("", comment: ""), subtitle: "请检查您的网络")
    if !PKHUD.sharedHUD.isVisible {
        PKHUD.sharedHUD.show()
    }
    PKHUD.sharedHUD.hide(afterDelay: 0.25)
}

//MARK:-初始化控制器
func getStoryboardInstantiateViewController(identifier: String) -> UIViewController? {
    let vc = UIViewController.dd_instanceFromStoryboard(withIdentifier: identifier)
    return vc
}

//MARK:-延迟执行
func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

//本地化语言
func BXLocalizedString(_ key: String, comment: String) -> String {
    let string = NSLocalizedString(key, comment: comment)
    let path = Bundle.main.path(forResource: "en", ofType: "lproj")
    let language = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode)! as! String
    
    if let str = UserDefaults.standard.value(forKey: "kChangeLanguage") as? String {
        if str == "en" {
            return (Bundle(path: path!)?.localizedString(forKey: key, value: "", table: nil)) ?? key
        } else {
            return key
        }
    } else {
        if language == "zh"{
            return string
        } else {
            return (Bundle(path: path!)?.localizedString(forKey: key, value: "", table: nil)) ?? key
        }
        
    }
}

//MARK:-判断字符串是否存在
func stringIsEmpty(_ string: String?)->Bool{
    if string==nil || string == "" {
        return true
    }else {
        return false
    }
}
//MARK:-计算字体大小
func calculateTextSize(text: String, font: UIFont) -> CGSize {
    let str = NSString(string: text)
    let size = str.size(withAttributes: [NSAttributedStringKey.font: font])
    return size
}

//MARK:-调整textFildLeftView 和文字的间距
func textFildLeftViewMargin(imageName: String) -> UIImageView {
    let image = UIImage(named: imageName)
    let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: (image?.size.width)!+8, height: (image?.size.height)!+8))
    imageV.image = image
    imageV.contentMode = .center
    return imageV
}

//MARK:-格式化金额
func formatCurrencyAmount(_ formatAmount: String, formatColor: UIColor = kTextColor1, title: String , font: UIFont, isShowColon: Bool = true) -> NSAttributedString {
    var amount = ""
    amount = formatAmount.formatCurrency(true)
    let t = BXLocalizedString(title, comment: "")

    var range = (t+"：\(amount)" as NSString).range(of: amount)
    var attrStr = NSMutableAttributedString(string: t+"：\(amount)")
    if isShowColon {
        range = (t+"：\(amount)" as NSString).range(of: amount)
        attrStr = NSMutableAttributedString(string: t+"：\(amount)")
    } else {
        range = (t+"\(amount)" as NSString).range(of: amount)
        attrStr = NSMutableAttributedString(string: t+"\(amount)")
    }
    
    attrStr.addAttribute(NSAttributedStringKey.foregroundColor, value: formatColor, range: range)
    attrStr.addAttribute(NSAttributedStringKey.font, value: font, range: range)
    return attrStr
}

//MARK:-格式化文字
func formatCurrencyText(allText: String, formatText: String, formatTextColor: UIColor, formatTextFont: UIFont) -> NSAttributedString {
    let text = BXLocalizedString(formatText, comment: "")
    let range = (allText as NSString).range(of: text)
    let attrStr = NSMutableAttributedString(string: allText)

    attrStr.addAttribute(NSAttributedStringKey.foregroundColor, value: formatTextColor, range: range)
    attrStr.addAttribute(NSAttributedStringKey.font, value: formatTextFont, range: range)
    return attrStr
}

//MARK:-格式日期
func dateFromFormat(date: String?) -> Date {
    var date = date
    func formatString(date: String) -> String {
        var characters = [Character]()
        for c in date {
            characters.append(c)
        }
        characters.insert("-", at: 4)
        characters.insert("-", at: 7)
        let str = String(characters)
        return str
    }
    
    if date != nil && date != "" {
        if !(date?.contains("-"))! {
            date = formatString(date: date!)
        }
    }
    
    let dateFormat = DateFormatter()
    dateFormat.locale = Locale.current
    dateFormat.dateFormat = "yyyy-MM-dd"
    let d = dateFormat.date(from: date ?? "")
    return d ?? Date()
}


// MARK: - extension
extension Date {
    func stringFromFormat(string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = string
        let date = dateFormatter.string(from: self)
        return date
    }
}
extension Array {
    func objectsAtIndexes(_ indexes: [Int]) -> [Element] {
        let elements: [Element] = indexes.map{ (idx) in
            if idx < self.count {
                return self[idx]
            }
            return nil
            }.flatMap{ $0 }
        return elements
    }
}

extension Dictionary {
    mutating func merge<K, V>(_ dictionaries: Dictionary<K, V>...) {
        for dict in dictionaries {
            for (key, value) in dict {
                self.updateValue(value as! Value, forKey: key as! Key)
            }
        }
    }
}


