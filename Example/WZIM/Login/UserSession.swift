//
//  UserSession.swift
//  WZIM_Example
//
//  Created by qiuqixiang on 2020/9/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import WZIM
public class UserSession: NSObject {
    
    /// 单利
    static let shared = UserSession()
    
    /// 登录token
    var tokenConfig: UserAppPlatformConfig?
    
    /// 腾讯云IM
    lazy var wzTim: WZTIMManager = {
        return $0
    }(WZTIMManager.init(appId: 1400073229))
    
    func logIn() {
        UserLoginApi.logIn(username: "18150960090", password: "123456")
        .request()
        .mapModel(UserAppPlatformConfig.self, isDebug: true)
        .subscribe(onNext: { (result) in
            self.tokenConfig = result
            
            self.wzTim.logIn(identifier: "wzly_\(result.userId )", userSig: result.userSig, sucess: {
                self.wzTim.setUserConfig(cDelegate: self)
            }) { (code, msg) in
                
            }
        }, onError: { (error) in
            debugPrint(error.localizedDescription)
        }).disposed(by:rx.disposeBag)
    }
    
    
}

extension UserSession {
    @objc static let ImLoginSucessNotification = Notification.Name(rawValue: "com.wzly.new.im.login.notification")
}
