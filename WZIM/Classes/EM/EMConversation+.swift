//
//  EMConversation+.swift
//  Pods-WZIM_Example
//
//  Created by qiuqixiang on 2020/8/14.
//

import Foundation
import HyphenateLite

// MARK - 环信会话对象
extension EMConversation: WZConversationProcotol {
        
    public var conversationType: WZIMConversationType {
        return .c2c
    }
    
    public var receiverId: String {
        return self.conversationId
    }
    
    public var unReadCount: Int {
        return Int(self.unreadMessagesCount)
    }
    
    public var lastMsg: WZMessageProtocol? {
        return latestMessage ?? nil
    }
    
    public var draft: String? {
        return nil
    }
    
    public var draftTime: Date? {
        return nil
    }
}
