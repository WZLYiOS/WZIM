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

// MARK - IM
extension UserSession: WZTIMManagerDelegate {
    
    func getConversation(type: WZIMConversationType ,userId: String) -> WZIMConversationProcotol {
        return TIMManager.sharedInstance()!.getConversation(TIMConversationType.init(rawValue: type.rawValue)!, receiver: userId)
    }
    
    public func onConnSucc(manager: WZTIMManager) {
        
    }
    
    public func onConnFailed(manager: WZTIMManager, code: Int32, err: String) {
        
    }
    
    public func onDisconnect(manager: WZTIMManager, code: Int32, err: String) {
        
    }
    
    public func onConnecting(manager: WZTIMManager) {
        
    }
    
    public func onForceOffline(manager: WZTIMManager) {
        
    }
    
    public func onReConnFailed(manager: WZTIMManager, code: Int32, err: String) {
        
    }
    
    public func onUserSigExpired(manager: WZTIMManager) {
        
    }
    
    public func onRefresh(manager: WZTIMManager) {
        NotificationCenter.default.post(name: UserSession.ImLoginSucessNotification, object: nil)
    }
    
    public func onRefreshConversations(manager: WZTIMManager, conversations: [TIMConversation]) {
        NotificationCenter.default.post(name: UserSession.ImLoginSucessNotification, object: nil)
    }
    
    public func onRecvMessageReceipts(manager: WZTIMManager, receipts: [TIMMessageReceipt]) {
     
    }
    
    public func onGroupTipsEvent(manager: WZTIMManager, elem: TIMGroupTipsElem) {
        
    }
    
    public func onNewMessage(manager: WZTIMManager, msgs: [TIMMessage]) {
        
    }
}

// MARK - 环信
extension UserSession: WZEMManagerDelegate {
    
    public func conversationListDidUpdate(manager: WZEMManager, aConversationList: [WZIMConversationProcotol]) {
        
    }
    
    public func messagesDidReceive(manager: WZEMManager, aMessages: [WZIMMessageProtocol]) {
        
    }
    
    public func cmdMessagesDidReceive(manager: WZEMManager, aCmdMessages: [WZIMMessageProtocol]) {
        
    }
    
    public func messagesDidRead(manager: WZEMManager, aMessages: [WZIMMessageProtocol]) {
        
    }
    
    public func groupMessageDidRead(manager: WZEMManager, aMessage: WZIMMessageProtocol, groupAcks aGroupAcks: [EMGroupMessageAck]) {
        
    }
    
    public func groupMessageAckHasChanged() {
        
    }
    
    public func messagesDidDeliver(manager: WZEMManager, aMessages: [WZIMMessageProtocol]) {
        
    }
    
    public func messagesDidRecall(manager: WZEMManager, aMessages: [WZIMMessageProtocol]) {
        
    }
    
    public func messageStatusDidChange(manager: WZEMManager, aMessage: WZIMMessageProtocol, error aError: EMError) {
        
    }
    
    public func messageAttachmentStatusDidChange(manager: WZEMManager, aMessage: WZIMMessageProtocol, error aError: EMError) {
        
    }
}
