//
//  WZIMMessageReceipt.swift
//  Pods-WZIMProtocol_Example
//
//  Created by qiuqixiang on 2020/8/14.
//

import Foundation

// MARK - 已读协议
protocol WZIMMessageReceipt {
    
    /// 已读回执对应的会话（目前只支持 C2C 会话）
    func wzConversation() -> WZIMConversationProcotol
    
    /// 收到已读回执时，这个时间戳之前的消息都已读
    func wzGetTimestamp() -> time_t
}
