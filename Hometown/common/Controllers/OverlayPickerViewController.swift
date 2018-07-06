//
//  OverlayPickerViewController.swift
//  baoxiao
//
//  Created by ruanyu on 15/12/31.
//  Copyright © 2015年 schope. All rights reserved.
//

import UIKit

enum OverlayPickerType {
    case normal
    case date
}

enum SelectPickerType: Int {
    case project = 0  
    case subject = 1
    case invoice = 2
    case other = 3
}
class OverlayPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate ,UISearchBarDelegate{
    var popType: OverlayPickerType = .normal
    var selectType: SelectPickerType = .other
    var callback: ObjectCallback?
    //增加项目/类别
    var addCallback: ObjectCallback?
    
    var optionTitle: String?
    
    var string:String?
    
    // AnyObject: ObjectOption ObjectSubject ObjectProject
    var selectedIndex = 0
    var optionItems: [Any]! {
        didSet {
            filteredItems = optionItems
        }
    }
    var selectedDate: Date!
    
    var filteredItems = [Any]()
    
    fileprivate lazy var normalPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true
        return picker
    }()
    fileprivate var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = .white
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .date
        picker.minimumDate = Date(timeIntervalSince1970: TimeInterval.init())
        picker.locale = Locale(identifier: "zh-Hans_CN")
        return picker
    }()

    //MARK:懒加载UISearchBar
    fileprivate var searchBar: UISearchBar = {
          let search = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenWidth * 3/5, height: 44))
          search.placeholder = BXLocalizedString("点击快速搜索", comment: "")
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let toolbar = UIToolbar()
        let cancel = UIBarButtonItem(title: BXLocalizedString("取消", comment: ""), style: .plain, target: self, action: #selector(cancelAction(_:)))
//        let add = UIBarButtonItem(title: BXLocalizedString("新增", comment: ""), style: .plain, target: self, action: #selector(addAction(_:)))
        let confirm = UIBarButtonItem(title: BXLocalizedString("确定", comment: ""), style: .plain, target: self, action: #selector(confirmAction(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //textField
        let textView = UIBarButtonItem(customView: searchBar)
        searchBar.delegate = self
        if let searchField = searchBar.value(forKey: "_searchField") as? UITextField {
            searchField.font = kFont16
            searchField.textColor = kTextColor2
        }
        let label = UILabel()
        label.text = optionTitle
        label.textColor = kTextColor1
        label.font = kFont16
        label.sizeToFit()
        let tilte = UIBarButtonItem(customView: label)
        
        switch self.popType {
        case .normal:
            searchBar.frame = CGRect(x: 0, y: 0, width: screenWidth * 4/5, height: 44)
            toolbar.setItems([textView, space, confirm], animated: false)
        case .date:
            toolbar.setItems([cancel, space, tilte, space, confirm], animated: false)
        }

        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(toolbar)
        
        NSLayoutConstraint(item: toolbar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toolbar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toolbar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toolbar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44).isActive = true
        
        // picker
        switch popType {
        case .normal:
            view.addSubview(normalPicker)
            normalPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
            
            NSLayoutConstraint(item: normalPicker, attribute: .top, relatedBy: .equal, toItem: toolbar, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: normalPicker, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: normalPicker, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: normalPicker, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
            
        case .date:
            view.addSubview(datePicker)
            datePicker.date = selectedDate
            
            NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal, toItem: toolbar, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: datePicker, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: datePicker, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: datePicker, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册通知监听键盘的出现和消失
        NotificationCenter.default.addObserver(self, selector: #selector(OverlayPickerViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OverlayPickerViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // umeng
//        self.umengEnterPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // umeng
//        self.umengExitPage()
        
        super.viewWillDisappear(animated)
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UIApplication
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Action
    @objc func cancelAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Action
    @objc func addAction(_ sender: AnyObject) {
        dismiss(animated: true) { () -> Void in
            switch self.selectType {
            case .other:
                break
            default:
                self.addCallback?(self.selectType.rawValue)
            }
        }
    }
    
    @objc func confirmAction(_ sender: AnyObject) {
        dismiss(animated: true) { () -> Void in
            switch self.popType {
            case .normal:
                let index = self.normalPicker.selectedRow(inComponent: 0)
                if self.filteredItems.count == 0 {
                 return
                }
                
                self.callback?(self.filteredItems[index])
                
            case .date:
                let date = self.datePicker.date
                self.callback?(date)
            }
        }
    }
    
    // MARK: - UIPickerViewDataSource, UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filteredItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = filteredItems[row]
        
//        if item is ObjectOption {
//            return (item as! ObjectOption).name
//        } else if item is ObjectSubject {
//            return (item as! ObjectSubject).name
//        } else if item is ObjectProject {
//            return (item as! ObjectProject).name
//        } else if item is ObjectCustomOption {
//            return (item as! ObjectCustomOption).name
//        } else if item is ObjectIncomeTax {
//            let _tax = item as! ObjectIncomeTax
//            return (_tax.spmc ?? "") + "(\(_tax.rate ?? ""))"
//        } else if item is ObjectCurrency {
//            let _currency = item as! ObjectCurrency
//            return (_currency.name ?? "") + "\(_currency.rate ?? "")"
//        }else if item is ObjectLanguage {
//            let _language = item as! ObjectLanguage
//            return (_language.name ?? "")
//        } else {
//            return BXLocalizedString((item as! String), comment: "")
//        }
        return BXLocalizedString((item as! String), comment: "")
    }
    
    //MARK:-UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.filteredItems = self.optionItems
        }else {
           self.filteredItems = []
            
//            if let options = self.optionItems as? [ObjectOption] {
//                self.filteredItems = options.filter({(ObjectOption) -> Bool in
//                    return charactSearch(ObjectOption.name ?? "", searchText: searchText)
//                })
//            }
            
            if let items = self.optionItems as? [String] {
                self.filteredItems = items.filter({(Object) -> Bool in
                    return charactSearch(Object , searchText: searchText)
                })
            }
            
        }
        self.normalPicker.reloadAllComponents()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.filteredItems = self.optionItems
        self.normalPicker.reloadAllComponents()
    }
    
    func charactSearch(_ characts: String,searchText: String)->Bool{
        return characts.lowercased().contains(searchText.lowercased())
    }
    
    //MARK:键盘的隐藏显示
    @objc func keyboardWillShow(_ notification: Notification){
         let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
         let height = keyboardFrame?.size.height

         var viewFrame = view.frame
         viewFrame.origin.y =  (screenHeight - viewFrame.size.height) - height!
         view.frame = viewFrame

    }
    @objc func keyboardWillHide(_ notification: Notification){
        var viewFrame = view.frame
        viewFrame.origin.y = screenHeight - viewFrame.size.height
        view.frame = viewFrame
    }

}

