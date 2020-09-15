//
//  EMMessage+.swift
//  Pods-WZIM_Example
//
//  Created by qiuqixiang on 2020/8/14.
//

import Foundation
import HyphenateLite

// MARK - 环信消息遵循协议
extension EMMessage: WZIMMessageProtocol {
        
    /// 消息状态
    public func wzStatus() -> WZIMMessageStatus {
        return WZIMMessageStatus.init(rawValue: Int(status.rawValue)) ?? .sucess
    }
    
    /// 是否已读
    public func wzIsReaded() -> Bool{
        return isRead
    }
    
    /// 是否删除消息
    public func wzRemove() -> Bool {
        return false
    }
    
    /// 发送者
    public func wzSender() -> String {
        return from
    }
    
    /// 消息id
    public func wzMessageId() -> String {
        return messageId
    }
    
    /// 时间戳
    public func wzTimestamp() -> Date {
        
        let interval:TimeInterval = TimeInterval.init(timestamp)
        return Date(timeIntervalSince1970: interval)
    }
    
    /// 获取当前消息的会话
    public func wzGetConversation() -> WZIMConversationProcotol {

        var conversationType = EMConversationTypeChat
        switch chatType {
        case EMChatTypeGroupChat:
            conversationType = EMConversationTypeGroupChat
        case EMChatTypeChatRoom:
            conversationType = EMConversationTypeChatRoom
        default: break
        }
        let conv: EMConversation = EMClient.shared().chatManager.getConversation(conversationId, type: conversationType, createIfNotExist: false)
        return conv
    }
    
    /// 将消息导入本地
    public func wzConvertToImportedMsg() {
        
    }
    
    /// 设置消息发送方: 需要先将消息到导入到本地，调用 convertToImportedMsg 方法
    public func wzSetSender(sender: String) {
        
    }

    /// 是否自己
    public func wzLoaction() -> WZMessageLocation {
        
        switch direction {
        case EMMessageDirectionSend:
            return .right
        case EMMessageDirectionReceive:
            return .lelft
        default:
            return .center
        }
    }
    
    public var wzCustomInt: Int {
        get {
            let custom = ext["wzCustomInt"] as? Int
            return custom ?? 0
        }
        set {
            ext["wzCustomInt"] = newValue
            EMClient.shared().chatManager.update(self, completion: nil)
        }
    }
    
    public var wzCustomData: Data? {
        get {
            let custom = ext["wzCustomData"] as? Data
            return custom 
        }
        set {
            ext["wzCustomData"] = newValue
            EMClient.shared().chatManager.update(self, completion: nil)
        }
    }
    public func wzCurrentElem() -> WZMessageElem? {
        return nil
    }
    
    public func uploadElem(elem: WZMessageElem) {
        
    }
}
