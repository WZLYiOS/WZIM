//
//  WZConversationProcotol.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/19.
//

import Foundation

/// 会话协议
public protocol WZConversationProcotol {
    
    /// 会话类型
    var conversationType: WZIMConversationType { get }
    
    /// 会话类型为 C2C 单聊， 会话类型为群聊
    var receiverId: String { get }
    
    /// 会话未读消息数量,直播群（AVChatRoom）不支持未读计数，默认为 0
    var unReadCount: Int { get }
    
    /// 会话最后一条消息，可以通过 lastMessage -> timestamp 对会话做排序，timestamp 越大，会话越靠前
    var lastMsg: WZMessageProtocol? { get }
    
    /// 草稿信息，设置草稿信息请调用 setConversationDraft() 接口
    var draft: String? { get }
    
    /// 草稿编辑时间，草稿设置的时候自动生成
    var draftTime: Date? { get }
}

/// 扩展
public extension WZConversationProcotol {
    
    /// 会话id
    var conversationId: String {
        return receiverId
    }
}

