//
//  UserSession+IM.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/20.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import WZIM
import ImSDK
import HyphenateLite
import Foundation

// MARK - TIM
extension UserSession {
    
    /// IM管理器
    var imManager: WZIMManagerProcotol {
        return V2TIMManager.sharedInstance()
    }
    
   /// 初始化SDK
    public func initTIMSDk(appId: Int32) {
          let config = V2TIMSDKConfig()
        config.logLevel = .LOG_NONE
        V2TIMManager.sharedInstance()?.initSDK(appId, config: config, listener: self)
      }
   

      /// 获取会话列表
      public func getConversationList() -> [TIMConversation] {
          return TIMManager.sharedInstance()!.getConversationList()
      }
    
      
      /// 登录
     public func logIn(identifier: String, userSig: String, sucess: (() -> Void)?, failBlock: ((_ code: Int, _ err: String) -> Void)?) {
        V2TIMManager.sharedInstance()?.login(identifier, userSig: userSig, succ: {
            sucess?()
            V2TIMManager.sharedInstance()?.setConversationListener(self)
            NotificationCenter.default.post(name: UserSession.ImLoginSucessNotification, object: nil)
        }, fail: { (code, msg) in
            failBlock?(Int(code), String(msg ?? ""))
        })
      }
      
      /// 退出
      public func logout(sucess: (() -> Void)?, failBlock: ((_ code: Int, _ err: String) -> Void)?) {
        V2TIMManager.sharedInstance()?.logout({
            sucess?()
        }, fail: { (code, msg) in
            failBlock?(Int(code), String(msg ?? ""))
        })
      }
}

/// MARK - V2TIMSDKListener
extension UserSession: V2TIMSDKListener {
    
}

/// MARK - V2TIMSimpleMsgListener
extension UserSession: V2TIMSimpleMsgListener {
    
}

/// V2TIMConversationListener
extension UserSession: V2TIMConversationListener {
    public func onSyncServerStart() {
        
    }
    
    public func onSyncServerFinish() {
        
    }
    
    public func onSyncServerFailed() {
        
    }
    
    public func onNewConversation(_ conversationList: [V2TIMConversation]!) {
        
    }
    
    public func onConversationChanged(_ conversationList: [V2TIMConversation]!) {
        
    }
}









