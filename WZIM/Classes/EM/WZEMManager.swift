//
//  WZEMManager.swift
//  Pods-WZIM_Example
//
//  Created by qiuqixiang on 2020/8/13.
//

import Foundation
import HyphenateLite

// MARK - 环信管理器
class WZEMManager: NSObject {
    
    /// 代理
    private weak var delegate: WZEMManagerDelegate?
    
    /// 初始化SDK
    init(appkey: String) {
        EMClient.shared()?.initializeSDK(with: EMOptions.init(appkey: appkey))
    }
    
    func setUserConfig(cDelegate: WZEMManagerDelegate) {
        delegate = cDelegate
        EMClient.shared()?.chatManager.add(self, delegateQueue: nil)
    }
    
    /// 登录
    func logIn(identifier: String, userSig: String, sucess: (() -> Void)?, failBlock: ((_ code: Int, _ err: String) -> Void)?) {
        
        EMClient.shared()?.login(withUsername: identifier, password: userSig, completion: { (msg, err) in
            if err == nil {
                sucess?()
            }else{
                failBlock?(Int(err!.code.rawValue), err!.description)
            }
        })
    }
    
    /// 退出
    func logout(sucess: (() -> Void)?, failBlock: ((_ code: Int, _ err: String) -> Void)?) {
        EMClient.shared()?.logout(true, completion: { (err) in
            if err == nil {
                sucess?()
            }else{
                failBlock?(Int(err!.code.rawValue), err!.description)
            }
        })
    }
}

// MARK - EMChatManagerDelegate
extension WZEMManager: EMChatManagerDelegate {
    
    func conversationListDidUpdate(_ aConversationList: [Any]!) {
        delegate?.conversationListDidUpdate(manager: self, aConversationList: aConversationList as? [EMConversation] ?? [])
    }
    
    func messagesDidReceive(_ aMessages: [Any]!) {
        delegate?.messagesDidReceive(manager: self, aMessages: aMessages as! [EMMessage])
    }
    
    func cmdMessagesDidReceive(_ aCmdMessages: [Any]!) {
        delegate?.cmdMessagesDidReceive(manager: self, aCmdMessages: aCmdMessages as! [EMMessage])
    }
    
    func messagesDidRead(_ aMessages: [Any]!) {
        delegate?.messagesDidRead(manager: self, aMessages: aMessages as! [EMMessage])
    }
    
    func groupMessageDidRead(_ aMessage: EMMessage!, groupAcks aGroupAcks: [Any]!) {
        delegate?.groupMessageDidRead(manager: self, aMessage: aMessage, groupAcks: aGroupAcks as! [EMGroupMessageAck])
    }
    
    func groupMessageAckHasChanged() {
        delegate?.groupMessageAckHasChanged()
    }
    
    func messagesDidDeliver(_ aMessages: [Any]!) {
        delegate?.messagesDidDeliver(manager: self, aMessages: aMessages as! [EMMessage])
    }
    
    func messagesDidRecall(_ aMessages: [Any]!) {
        delegate?.messagesDidRecall(manager: self, aMessages: aMessages as! [EMMessage])
    }
    
    func messageStatusDidChange(_ aMessage: EMMessage!, error aError: EMError!) {
        delegate?.messageStatusDidChange(manager: self, aMessage: aMessage, error: aError)
    }
    
    func messageAttachmentStatusDidChange(_ aMessage: EMMessage!, error aError: EMError!) {
        delegate?.messageAttachmentStatusDidChange(manager: self, aMessage: aMessage, error: aError)
    }
}
