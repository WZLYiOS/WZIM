//
//  V2TIMConversation+.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/19.
//

import ImSDK
import Foundation

// MARK - 会话协议
extension V2TIMConversation: WZConversationProcotol {
    public var conversationType: WZIMConversationType {
        switch type {
        case .C2C:
            return .c2c
        default:
            return .group
        }
    }
    
    public var conversationId: String {
        return conversationID
    }
    
    public var receiverId: String {
        switch type {
        case .C2C:
            return userID.imDelPrefix
        default:
            return groupID.imDelPrefix
        }
    }
    
    public var unReadCount: Int {
        return Int(unreadCount)
    }
    
    public var lastMsg: WZMessageProtocol? {
        return lastMessage
    }
    
    public var draft: String? {
        return draftText
    }
    
    public var draftTime: Date? {
        return draftTimestamp as Date? 
    }
}
