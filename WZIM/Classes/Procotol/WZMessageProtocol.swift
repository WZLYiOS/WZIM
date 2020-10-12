//
//  WZMessageProtocol.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/19.
//

import Foundation

// MARK - 消息协议
public protocol WZMessageProtocol {
    
    /// 消息 ID（消息创建的时候为 nil，消息发送的时候会生成）
    var messageId: String { get }
    
    /// 消息时间
    var timeTamp: Date { get }
    
    /// 消息发送者
    var senderId: String { get }
    
    /// 会话类型为 C2C 单聊， 会话类型为群聊
    var receiverId: String { get }
    
    /// 消息位置
    var loaction: WZMessageLocation { get }
    
    /// 设置音频已读 0:未读 1 已读
    var customInt: Int {set get}
    
    /// 自定义数据
    var customData: Data? {set  get}
    
    /// 消息发送状态
    var sendStatus: WZIMMessageStatus { get }
    
    /// 是否已读
    var isReaded: Bool { get }
    
    /// 当前数据
    var currentElem: WZMessageElem { get }
}

// MARK - C2C 已读回执
public protocol WZMessageReceiptProtocol {
    
    /// 消息接收对象
    var userId: String { get }
    
    /// 已读回执时间，这个时间戳之前的消息都可以认为对方已读
    var time: Int { get }
}





