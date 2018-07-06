//
//  ScanViewController.swift
//  baoxiao
//
//  Created by ruanyu on 15/12/13.
//  Copyright © 2015年 schope. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

import pop
import PKHUD
import Alamofire

enum ScanType {
    case invoice
    case `default`
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var callback: ObjectCallback?
    var ocrCallback: ObjectCallback?
    var successback: ObjectCallback?
    var manualCallback: ObjectCallback?
    fileprivate let scanWidth: CGFloat = 240.0, scanHeight: CGFloat = 240.0
    fileprivate let btnWidth: CGFloat = 100.0, btnHeight: CGFloat = 60.0
    fileprivate var loadOnce = false
    fileprivate var autoScan = true
    fileprivate var scanRect = CGRect.zero
    fileprivate var soundID: SystemSoundID = 0
    fileprivate var lineView: UIImageView!
    
    fileprivate var output: AVCaptureMetadataOutput!
    fileprivate var session: AVCaptureSession!
    fileprivate var preview: AVCaptureVideoPreviewLayer!
    // permission
    fileprivate var _cameraPermission = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = BXLocalizedString("扫描二维码", comment: "")
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied {
            // permission
            _cameraPermission = false
            
            showNormalAlert(.permissionCamera, cancelHandler:nil, confirmHandler: { () -> Void in
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            })
            return
        }
        
        autoScan = true
        scanRect = CGRect(x: (view.frame.width-scanWidth)/2, y: (view.frame.height-scanHeight)/2, width: scanWidth, height: scanHeight)
        
        // scanner
        do {
            
            let device = AVCaptureDevice.default(for: AVMediaType.video)
            let input = try AVCaptureDeviceInput(device: device!)
            output = AVCaptureMetadataOutput()
            session = AVCaptureSession()
            //连接输入输出
            if session.canAddInput(input) {
                session.addInput(input)
            }
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            

            session.sessionPreset = AVCaptureSession.Preset.high
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//            output.metadataObjectTypes = output.availableMetadataObjectTypes
            
            preview = AVCaptureVideoPreviewLayer(session: session)
            preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
            preview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            view.layer.insertSublayer(preview, at: 0)
            
            //持续对焦
            if (device?.isFocusModeSupported(.continuousAutoFocus))!{
                try  input.device.lockForConfiguration()
                input.device.focusMode = .continuousAutoFocus
                input.device.unlockForConfiguration()
            }
        }
        catch let error as NSError {
            showHideTextHUD(error.localizedDescription)
            return
        }
        
        // mask
        let maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = kBlackAlphaColor
        view.addSubview(maskView)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = maskView.layer.bounds
        
        let maskPath = CGMutablePath()
        maskPath.addRect(maskView.bounds)
        maskPath.addRect(scanRect)
        
        maskLayer.path = maskPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskView.layer.mask = maskLayer
        
        // views
        let label = UILabel(frame: CGRect(x: scanRect.minX, y: scanRect.maxY+10, width: scanWidth, height: 40))
        let lightBtn = UIButton(frame: CGRect(x: (screenWidth-40)/2, y: label.frame.maxY+5, width: 35, height: 35))
        
        label.text = BXLocalizedString("将二维码放入框内，即可自动扫描", comment: "")
//        let bottomView = UIView(frame: CGRect(x: 0, y: screenHeight-60, width: screenWidth, height: 60))
//        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        view.addSubview(bottomView)
//
//        let ocrBtn = UIButton(frame: CGRect(x:  0, y: 0, width: screenWidth/2, height: btnHeight))
//        ocrBtn.contentHorizontalAlignment = .center
//        ocrBtn.backgroundColor = .clear
//        ocrBtn.titleLabel?.font = kFont14
//        ocrBtn.setTitle(BXLocalizedString("拍照录入", comment: ""), for: UIControlState())
//        ocrBtn.setTitleColor(.white, for: UIControlState())
//        ocrBtn.addTarget(self, action: #selector(ocrInput(_:)), for: .touchUpInside)
//
//        let manualBtn = UIButton(frame: CGRect(x:  screenWidth/2, y: 0, width: screenWidth/2, height: btnHeight))
//        manualBtn.contentHorizontalAlignment = .center
//        manualBtn.backgroundColor = .clear
//        manualBtn.titleLabel?.font = kFont14
//        manualBtn.setTitle(BXLocalizedString("手动查验", comment: ""), for: UIControlState())
//        manualBtn.setTitleColor(.white, for: UIControlState())
//        manualBtn.addTarget(self, action: #selector(manualInput(_:)), for: .touchUpInside)
//
//        let line = UIView(frame: CGRect(x:  screenWidth/2, y: 10, width: 1, height: btnHeight-20))
//        line.backgroundColor = kWhiteColor
//
//        bottomView.addSubview(manualBtn)
//        bottomView.addSubview(ocrBtn)
//        bottomView.addSubview(line)

        lightBtn.setImage(UIImage(named: "light_icon"), for: .normal)
        lightBtn.setImage(UIImage(named: "smlr_sd_p"), for: .selected)
        lightBtn.addTarget(self, action: #selector(lightButtonClick(_:)), for: .touchUpInside)
        view.addSubview(lightBtn)
        
        label.textAlignment = .center
        label.font = kFont13
        label.textColor = .white
        label.numberOfLines = 0
        view.addSubview(label)
        
        let border = UIImageView(frame: scanRect)
        border.image = UIImage(named: "scan_box")
        view.addSubview(border)
        
        lineView = UIImageView(frame: CGRect(x: scanRect.minX, y: scanRect.minY+40, width: scanWidth, height: 6))
        lineView.image = UIImage(named: "scan_line")
        view.addSubview(lineView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: BXLocalizedString("取消", comment: ""), style: .plain, target: self, action: #selector(cancelAction(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: BXLocalizedString("相册", comment: ""), style: .plain, target: self, action: #selector(albumAction(_:)))
    
        // sound
        let path = Bundle.main.path(forResource: "qrcode", ofType:"wav")
        let url = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
//        // sound
//        if let path = Bundle.main.path(forResource: "qrcode", ofType:"wav") {
//            let url = URL(fileURLWithPath: path)
//            AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
//        }
//        AudioServicesPlaySystemSound(soundID) //播放声音
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) //静音模式下震动
        
    }

    // MARK: - ocr识别录入
    @objc func ocrInput(_ sender: UIButton!) {
        dismiss(animated: false) { () -> Void in
            self.ocrCallback?(true)
        }
    }
    
    // MARK: - 手动查验
    @objc func manualInput(_ sender: UIButton!) {
        dismiss(animated: false) { () -> Void in
            self.manualCallback?(true)
        }
    }

    @objc func lightButtonClick(_ sender: UIButton) {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if device == nil {
            sender.isEnabled = false
            return
        }
        if device?.torchMode == AVCaptureDevice.TorchMode.off{
            do {
                try device?.lockForConfiguration()
            } catch {
                return
            }
            device?.torchMode = .on
            device?.unlockForConfiguration()
            sender.isSelected = true
        }else {
            do {
                try device?.lockForConfiguration()
            } catch {
                return
            }
            device?.torchMode = .off
            device?.unlockForConfiguration()
            sender.isSelected = false
        }
    }
    
    deinit {
        AudioServicesDisposeSystemSoundID(soundID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //导航透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //去掉导航栏底部的黑线
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // umeng
//        self.umengEnterPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopScanning()
        
        //显示
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        // umeng
//        self.umengExitPage()
        
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // permission
        if _cameraPermission == false { return }
        
        if !loadOnce {
            loadOnce = true

            let metaRect = preview.metadataOutputRectConverted(fromLayerRect: scanRect)
            output.rectOfInterest = metaRect
        }
        
        if autoScan {
            startScanning()
        }
    }
    
    // MARK: - UIApplication
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Action
    @objc func cancelAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func albumAction(_ sender: AnyObject) {
        if PHPhotoLibrary.authorizationStatus() == .denied {
            showNormalAlert(.permissionPhoto, cancelHandler:nil, confirmHandler: { () -> Void in
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            })
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    // MARK: - Scan
    func startScanning() {
        session.startRunning()
        
        let a = POPBasicAnimation(propertyNamed: kPOPViewCenter)
        a?.fromValue = NSValue(cgPoint: CGPoint(x: view.frame.width/2, y: scanRect.origin.y))
        a?.toValue = NSValue(cgPoint: CGPoint(x: view.frame.width/2, y: scanRect.origin.y + scanHeight))
        a?.duration = 2
        a?.repeatForever = true
        lineView.pop_add(a, forKey: "repeat")
    }
    
    func stopScanning() {
        session.stopRunning()
        
        lineView.pop_removeAllAnimations()
    }
    
    func detectedQR(_ value: String?) {
        autoScan = true
        if let scanned = value {
            receiptQR(scanned)
        } else {
            showNormalAlert(.noQrCode, cancelHandler: nil, confirmHandler: { () -> Void in
                    self.startScanning()
            })
        }
    }

    //扫描发票
    func receiptQR(_ value: String) {
        self.dismiss(animated: false) { () -> Void in
            self.successback?(value)
        }
        
//        let scanVC = getStoryboardInstantiateViewController(identifier:  "scanTip") as! ScanTipViewController
//        weak var weakSelf = self
//        scanVC.content = value
//        //扫描成功过的回调
//        scanVC.successback = successback
//        scanVC.successback = {(value: Any) in
//            weakSelf?.dismiss(animated: false) { () -> Void in
//                weakSelf?.successback?(value)
//            }
//        }
//        //拍照录入的回调
//        scanVC.callback = callback
//        scanVC.callback = {(value: Any) -> Void in
//            weakSelf?.dismiss(animated: false) { () -> Void in
//                weakSelf?.ocrCallback?(true)
//            }
//        }
//        scanVC.isSuccess = true
//        let nav = UINavigationController(rootViewController: scanVC)
//        self.present(nav, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

            let ciimage = CIImage(cgImage: image.cgImage!)
            let features = detector?.features(in: ciimage) ?? []
            
            var scanned: String?
            if features.count > 0 {
                for f in features {
                    if let qf = f as? CIQRCodeFeature {
                        scanned = qf.messageString
                        break
                    }
                }
            }
            
            autoScan = false
            dismiss(animated: true, completion: { () -> Void in
                self.detectedQR(scanned)
            })
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            if let obj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                stopScanning()
                AudioServicesPlaySystemSound(soundID)
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) //静音模式下震动
                receiptQR(obj.stringValue!)
            }
        }
    }
    
}
