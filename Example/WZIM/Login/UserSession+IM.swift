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
    
   /// 初始化SDK
    public func initTIMSDk(appId: Int32) {
          let config = TIMSdkConfig()
          config.sdkAppId = appId
          config.disableLogPrint = true
          config.connListener = self
          TIMManager.sharedInstance()?.initSdk(config)
      }
   
      /// 设置监听等
      public func setUserConfig() {
          let userConfig = TIMUserConfig()
          userConfig.disableAutoReport = true
          userConfig.enableReadReceipt = true
          userConfig.userStatusListener = self
          userConfig.refreshListener = self
          userConfig.messageReceiptListener = self
          userConfig.groupEventListener = self
          TIMManager.sharedInstance()?.setUserConfig(userConfig)
          TIMManager.sharedInstance()?.add(self)
      }
      
      /// 获取会话列表
      public func getConversationList() -> [TIMConversation] {
          return TIMManager.sharedInstance()!.getConversationList()
      }
    
    func getConversation(type: WZIMConversationType ,userId: String) -> WZIMConversationProcotol {
        return TIMManager.sharedInstance()!.getConversation(TIMConversationType.init(rawValue: type.rawValue)!, receiver: userId)
    }
      
      /// 登录
     public func logIn(identifier: String, userSig: String, sucess: (() -> Void)?, failBlock: ((_ code: Int, _ err: String) -> Void)?) {
          let param = TIMLoginParam()
          param.identifier = identifier
          param.userSig = userSig
          param.appidAt3rd = param.identifier
          
          TIMManager.sharedInstance()?.login(param, succ: {
              sucess?()
          }, fail: { (code, msg) in
              failBlock?(Int(code), String(msg ?? ""))
          })
      }
      
      /// 退出
      public func logout(sucess: (() -> Void)?, failBlock: ((_ code: Int, _ err: String) -> Void)?) {
          TIMManager.sharedInstance()?.logout({
              sucess?()
          }, fail: { (code, msg) in
              failBlock?(Int(code), String(msg ?? ""))
          })
      }
      
      /// 加入群
      public func joinGroup(groupId: String, msg: String,sucess: (() -> Void)?, failBlock: ((_ code: Int, _ err: String) -> Void)?) {
          TIMGroupManager.sharedInstance()?.joinGroup(groupId, msg: msg, succ: {
              sucess?()
          }, fail: { (code, msg) in
              failBlock?(Int(code), msg ?? "")
          })
      }
      
      /// 退出群
      public func quitGroup(groupId: String, sucess: (() -> Void)?, failBlock: ((_ code: Int, _ err: String) -> Void)?) {
          TIMGroupManager.sharedInstance()?.quitGroup(groupId, succ: {
              TIMManager.sharedInstance()?.remove(self)
              sucess?()
          }, fail: { (code, msg) in
              failBlock?(Int(code), msg ?? "")
          })
      }
   
}

// MARK - TIMConnListener
extension UserSession: TIMConnListener {
    
    public func onConnSucc() {
        
    }
    
    public func onConnFailed(_ code: Int32, err: String!) {
        
    }
    
    public func onDisconnect(_ code: Int32, err: String!) {
        
    }
    
    public func onConnecting() {
        
    }
}

// MARK - TIMUserStatusListener
extension UserSession: TIMUserStatusListener {
    
    public func onForceOffline() {
        
    }
    
    public func onReConnFailed(_ code: Int32, err: String!) {
        
    }
    
    public func onUserSigExpired() {
        
    }
}

// MARK - TIMRefreshListener
extension UserSession: TIMRefreshListener {
    
    public func onRefresh() {
        NotificationCenter.default.post(name: UserSession.ImLoginSucessNotification, object: nil)
    }
    
    public func onRefreshConversations(_ conversations: [TIMConversation]!) {
        NotificationCenter.default.post(name: UserSession.ImLoginSucessNotification, object: nil)
    }
}

// MARK - TIMMessageReceiptListener
extension UserSession: TIMMessageReceiptListener {
    
    public func onRecvMessageReceipts(_ receipts: [Any]!) {
        
    }
}

// MARK - TIMGroupEventListener
extension UserSession: TIMGroupEventListener {
    
    public func onGroupTipsEvent(_ elem: TIMGroupTipsElem!) {
        
    }
}

// MARK - TIMMessageListener
extension UserSession: TIMMessageListener {
    
    public func onNewMessage(_ msgs: [Any]!) {
        
    }
}





