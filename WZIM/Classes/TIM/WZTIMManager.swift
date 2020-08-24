//
//  WZTIMManager.swift
//  Pods-WZIM_Example
//
//  Created by qiuqixiang on 2020/8/13.
//

import ImSDK
import Foundation

// MARK - 腾讯管理器
open class WZTIMManager: NSObject {
    
    /// 代理
    private weak var delegate: WZTIMManagerDelegate?
    
    /// 初始化SDK
    public init(appId: Int32) {
        super.init()
        let config = TIMSdkConfig()
        config.sdkAppId = appId
        config.disableLogPrint = true
        config.connListener = self
        TIMManager.sharedInstance()?.initSdk(config)
    }
 
    /// 设置监听等
    public func setUserConfig(cDelegate: WZTIMManagerDelegate) {
        delegate = cDelegate
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
extension WZTIMManager: TIMConnListener {
    
    public func onConnSucc() {
        delegate?.onConnSucc(manager: self)
    }
    
    public func onConnFailed(_ code: Int32, err: String!) {
        delegate?.onConnFailed(manager: self, code: code, err: err)
    }
    
    public func onDisconnect(_ code: Int32, err: String!) {
        delegate?.onDisconnect(manager: self, code: code, err: err)
    }
    
    public func onConnecting() {
        delegate?.onConnecting(manager: self)
    }
}

// MARK - TIMUserStatusListener
extension WZTIMManager: TIMUserStatusListener {
    
    public func onForceOffline() {
        delegate?.onForceOffline(manager: self)
    }
    
    public func onReConnFailed(_ code: Int32, err: String!) {
        delegate?.onReConnFailed(manager: self, code: code, err: err)
    }
    
    public func onUserSigExpired() {
        delegate?.onUserSigExpired(manager: self)
    }
}

// MARK - TIMRefreshListener
extension WZTIMManager: TIMRefreshListener {
    
    public func onRefresh() {
        delegate?.onRefresh(manager: self)
    }
    
    public func onRefreshConversations(_ conversations: [TIMConversation]!) {
        delegate?.onRefreshConversations(manager: self, conversations: conversations)
    }
}

// MARK - TIMMessageReceiptListener
extension WZTIMManager: TIMMessageReceiptListener {
    
    public func onRecvMessageReceipts(_ receipts: [Any]!) {
        delegate?.onRecvMessageReceipts(manager: self, receipts: receipts as? [TIMMessageReceipt] ?? [] )
    }
}

// MARK - TIMGroupEventListener
extension WZTIMManager: TIMGroupEventListener {
    
    public func onGroupTipsEvent(_ elem: TIMGroupTipsElem!) {
        delegate?.onGroupTipsEvent(manager: self, elem: elem)
    }
}

// MARK - TIMMessageListener
extension WZTIMManager: TIMMessageListener {
    
    public func onNewMessage(_ msgs: [Any]!) {
        delegate?.onNewMessage(manager: self, msgs: msgs as? [TIMMessage] ?? [])
    }
}
