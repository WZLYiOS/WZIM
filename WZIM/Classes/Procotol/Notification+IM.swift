//
//  Notification+IM.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/10/9.
//

import Foundation

// MARK - IM 订阅名称
public extension Notification {
    
    /// IM 各种消息 订阅名称
    static func getImNotificationName(notif: WZMessageNotification) -> Notification.Name {
        
        let name = "com.wzly.im.message.\(notif)."
        switch notif {
        case let .notice(type):
            return Notification.Name(rawValue: name+"\(type.rawValue)")
        case .revoked:
            return Notification.Name(rawValue: name)
        case let .msg(userId), let .readReceipt(userId):
            return Notification.Name(rawValue: name+userId)
        }
    }
}

/// MARK - 通知
public enum WZMessageNotification {
    case notice(WZMessageNoticeType)  // 透传消息
    case msg(String)                  // 新消息
    case revoked                      // 撤回消息
    case readReceipt(String)          // 消息已读
}
