//
//  Notification+IM.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/10/9.
//

import Foundation

// MARK - IM 订阅名称
public extension Notification.Name {

    /// Im通知
    struct wzIMTask {
        
        /// 会话添加
        public static let conversationAdd = Notification.Name("com.wzly.im.conversation.add")
        
        /// 会话修改
        public static let conversationChange = Notification.Name("com.wzly.im.conversation.changed")
        
        /// 信令消息
        public static func signaling(inviteId: String) -> Notification.Name {
            return Notification.Name("com.wzly.im.message.signaling.\(inviteId)")
        }
        
        /// IM 各种消息 订阅名称
        public static func getMessage(notif: WZMessageNotification) -> Notification.Name {
            
            let name = "com.wzly.im.message.\(notif)."
            switch notif {
            case .notice:
                return Notification.Name(rawValue: name)
            case .revoked:
                return Notification.Name(rawValue: name)
            case let .msg(userId), let .readReceipt(userId):
                return Notification.Name(rawValue: name+userId)
            }
        }
    }
}

/// MARK - 通知
public enum WZMessageNotification {
    case notice                       // 透传消息
    case msg(String)                  // 新消息
    case revoked                      // 撤回消息
    case readReceipt(String)          // 消息已读
}

/// MARK - 通知
public extension WZMessageProtocol {
    
    /// 订阅名称
    var postName: Notification.Name {
        switch currentElem {
        case .notice:
            return Notification.Name.wzIMTask.getMessage(notif: .notice)
        default:
            return Notification.Name.wzIMTask.getMessage(notif: .msg(receiverId))
        }
    }
    
    /// 订阅实体内容
    var postData: Any? {
        switch currentElem {
        case let .notice(elem):
            return elem
        default:
            return self
        }
    }
}
