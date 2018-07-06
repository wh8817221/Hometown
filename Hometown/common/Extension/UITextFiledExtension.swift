//
//  UITextFiledExtension.swift
//  chapiaotong
//
//  Created by 王浩 on 2018/5/28.
//  Copyright © 2018年 王浩. All rights reserved.
//

import UIKit

extension UITextField {
    func setPlaceholder(placeholder: String, color: UIColor, font: UIFont) {
        let placeholserAttributes = [NSAttributedStringKey.foregroundColor : color,NSAttributedStringKey.font: font]
        self.attributedPlaceholder = NSAttributedString(string: BXLocalizedString(placeholder, comment: ""),attributes: placeholserAttributes)
    }
}
