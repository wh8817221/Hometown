//
//  NotifcationCenterExt.swift

import UIKit

extension NotificationCenter {
	
	class func post(name: NotificationName, object: Any? = nil , userInfo: [AnyHashable : Any]? = nil) {
		
		NotificationCenter.default.post(name: .customName(name: name),
		                                object: object,
		                                userInfo: userInfo)
		
	}

	class func post(name: Notification.Name, object: Any? = nil , userInfo: [AnyHashable : Any]? = nil) {

		NotificationCenter.default.post(name: name,
										object: object,
										userInfo: userInfo)
	}

	class func addObserver(observer: Any, selector: Selector, name: NotificationName, object: Any? = nil) {

		NotificationCenter.default.addObserver(observer,
											   selector: selector,
											   name: .customName(name: name),
											   object: object)
		
	}

	class func addObserver(observer: Any, selector: Selector, name: Notification.Name, object: Any? = nil) {

		NotificationCenter.default.addObserver(observer,
											   selector: selector,
											   name: name,
											   object: object)

	}
    
    class func removeObserver(observer: Any, name: NotificationName, object: Any? = nil) {
        NotificationCenter.default.removeObserver(observer,
                                                  name: .customName(name: name),
                                                  object: object)
    }
    
    class func removeObserver(observer: Any, name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.removeObserver(observer,
                                                  name: name,
                                                  object: object)
    }
}

extension NSNotification.Name {

	static func customName(name: NotificationName) -> NSNotification.Name {
    
		return NSNotification.Name(name.rawValue)
	}

}

enum NotificationName: String {
	// 刷新列表
    case kReloadFolderList
    case kReloadInvioceAddTo
    case kReloadCompanyCard
    case kReloadHomeCard
}

