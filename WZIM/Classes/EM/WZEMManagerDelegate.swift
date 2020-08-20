//
//  WZEMManagerDelegate.swift
//  Pods-WZIM_Example
//
//  Created by qiuqixiang on 2020/8/14.
//

import Foundation
import HyphenateLite

// MARK - 环信消息代理
protocol WZEMManagerDelegate: class {
    
    /// 会话列表发生变化
    /// - Parameters:
    ///   - manager: 管理器
    ///   - aConversationList: 会话list
   func conversationListDidUpdate(manager: WZEMManager, aConversationList: [WZIMConversationProcotol])
    
    /// 收到消息
    /// - Parameters:
    ///   - manager: 管理器
    ///   - aMessages: 消息
   func messagesDidReceive(manager: WZEMManager, aMessages: [WZIMMessageProtocol])
    
    /// 收到Cmd消息
    /// - Parameters:
    ///   - manager: 管理器
    ///   - aCmdMessages: 消息
   func cmdMessagesDidReceive(manager: WZEMManager, aCmdMessages: [WZIMMessageProtocol])
    
    /// 收到已读回执
    /// - Parameters:
    ///   - manager: 管理器
    ///   - aMessages: 已读消息
   func messagesDidRead(manager: WZEMManager, aMessages: [WZIMMessageProtocol])
    
    /// 收到群消息已读回执
    /// - Parameters:
    ///   - manager: 管理器
    ///   - aMessage: 消息
    ///   - aGroupAcks: Acknowledged message list<EMGroupMessageAck>
   func groupMessageDidRead(manager: WZEMManager, aMessage: WZIMMessageProtocol, groupAcks aGroupAcks: [EMGroupMessageAck])
    
    /// 所有群已读消息发生变化
   func groupMessageAckHasChanged() 
    
    /// 收到消息送达回执
    /// - Parameters:
    ///   - manager: 管理器
    ///   - aMessages: 消息
   func messagesDidDeliver(manager: WZEMManager, aMessages: [WZIMMessageProtocol])
    
    /// 收到消息撤回
    /// - Parameters:
    ///   - manager: 管理器
    ///   - aMessages: 消息
   func messagesDidRecall(manager: WZEMManager, aMessages: [WZIMMessageProtocol])
    
    /// 消息状态发生变化
    /// - Parameters:
    ///   - manager: 管理器
    ///   - aMessage: 消息
    ///   - aError: 错误码
   func messageStatusDidChange(manager: WZEMManager, aMessage: WZIMMessageProtocol, error aError: EMError)
    
    ///  消息附件状态发生改变
    /// - Parameters:
    ///   - manager: 管理器
    ///   - aMessage: 消息
    ///   - aError: 错误码
   func messageAttachmentStatusDidChange(manager: WZEMManager, aMessage: WZIMMessageProtocol, error aError: EMError)
}
