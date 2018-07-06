//
//  StringExtension.swift
//  baoxiao
//
//  Created by 王浩 on 2018/4/3.
//  Copyright © 2018年 schope. All rights reserved.
//

import UIKit

//MARK:-extension String
extension String {
    
    func formatCurrency(_ useFormat: Bool=true) -> String {
        let styler = NumberFormatter()
        styler.locale = Locale(identifier: "zh-Hans_CN")
        styler.numberStyle = .decimal
        
        let converter = NumberFormatter()
        converter.locale = Locale(identifier: "zh-Hans_CN")
        converter.numberStyle = .currency
        converter.currencyCode = "CNY"
        converter.currencySymbol = "¥"
        
        if useFormat {
            if let number = styler.number(from: self), let currancy = converter.string(from: number) {
                return currancy
            } else {
                return "￥0.00"
            }
        } else {
            return "¥\(self)"
        }
    }
    
    // 格式德文输入
    func formatDe() -> String {
        if self.contains(",") {
            return self.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
        } else {
            return self
        }
    }
    
    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace:String {
        let whitespace = CharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String {
        let whitespace = CharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce:String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(_ num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
    
    /*
     *将德文中的","转文"."
     */
    var replacingCommas:String {
        return self.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
    }
    
    /*
     *将德文中的","转文"."
     */
    func isValidUrl() -> Bool {
        if self.contains("http://") || self.contains("https://") {
            return true
        } else {
            return false
        }
    }
    //汉字转拼音
    func transformToPinYin()->String{
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return  string.replacingOccurrences(of: " ", with: "").capitalized
    }
    //字符串截取
    func textSubstring(startIndex: Int, length: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: startIndex)
        let endIndex = self.index(startIndex, offsetBy: length)
        let subvalues = self[startIndex..<endIndex]
        return String(subvalues)
    }
}
