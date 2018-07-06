//
//  HelpViewController.swift
//  baoxiao
//
//  Created by ruanyu on 15/12/9.
//  Copyright © 2015年 schope. All rights reserved.
//

import UIKit
import WebKit

import PKHUD

enum WebContentType {
    case information(String)
    case invite(String)
    case `default`
}

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var type: WebContentType = .default
    var url: String?
    fileprivate var progressView: UIProgressView!
    fileprivate var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(topLayoutGuide.snp.bottom)
        }
        
        progressView = UIProgressView()
        progressView.trackTintColor = UIColor.clear
        progressView.progressTintColor = kOrangeColor
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(topLayoutGuide.snp.bottom)
        }
        
        switch type {
        case .information(let urlString):
            title = BXLocalizedString("资讯", comment: "")
            url = urlString
            
        case .invite(let urlString):
            title = BXLocalizedString("邀请好友", comment: "")
            url = urlString
        case .default:
            break
        }
        
        if let requestUrl = url {
            webView.load(URLRequest(url: URL(string: requestUrl)!))
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // swipe back ---->
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // swipe back ---->
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // swipe back ---->
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        // swipe back ---->

        super.viewWillDisappear(animated)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }
    
    // MARK: - UIApplication
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if let newValue = change?[NSKeyValueChangeKey.newKey] as? Float {
                progressView.isHidden = newValue == 1
                progressView.setProgress(newValue, animated: true)
            }
        }
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showHideTextHUD(error.localizedDescription)
    }
}


