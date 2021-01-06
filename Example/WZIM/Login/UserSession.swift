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
    
    public lazy var emManager: WZEMClientManager = {
        return $0
    }(WZEMClientManager(appkey: "7799520#wzly", apnsCertName: "APNS_Development", delegate: self))
    
    
    func logIn() {
        UserLoginApi.logIn(username: "18150960091", password: "123456")
        .request()
        .mapModel(UserAppPlatformConfig.self, isDebug: true)
        .subscribe(onNext: { (result) in
            self.tokenConfig = result
            
            self.emManager.emLogin(userId: result.userId, password: "wzlycodebytangyouyou")
            self.logIn(identifier: "wzly_\(result.userId )", userSig: result.userSig, sucess: {
                
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

/// MARK - 代理
extension UserSession: WZEMClientManagerDelegate {
    
    public func eMClientManager(manager: WZEMClientManager, conversations: [WZConversationProcotol]) {
        
    }
    
    public func eMClientManager(manager: WZEMClientManager, receive newMessage: [WZMessageProtocol]) {
        
    }
    
    public func eMClientManager(manager: WZEMClientManager, didRead: [WZMessageProtocol]) {
        
    }
}
