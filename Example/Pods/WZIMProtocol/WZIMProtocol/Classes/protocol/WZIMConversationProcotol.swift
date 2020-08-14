//
//  WZIMConversationProcotol.swift
//  WZIMUIKit_Example
//
//  Created by qiuqixiang on 2020/4/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

// MARK - 消息会话
public protocol WZIMConversationProcotol {
    
    /// 成功
    typealias sucess = (()-> Void)?
    
    /// 功能回调有返回消息数组
    typealias getMsgSucess = ((_ list: [WZIMMessageProtocol])-> Void)?
    
    /// 失败
    typealias fail = ((_ code: Int, _ msg: String)-> Void)?
    
    /// 获取最后一条消息
    func wzLastMessage() -> WZIMMessageProtocol?
    
    /// 会话类型
    func wzConversationType() -> WZIMConversationType
    
    /// 获取会话 ID
    func wzReceiverId() -> String
    
    /// 设置最后一条消息为nil
    func wzReadMessage(message: WZIMMessageProtocol?)
    
    /// 获取未读数量
    func wzGetUnReadMessageNum() -> Int
    
    /// 发送消息
    func wzSendMessage(message: WZIMMessageProtocol, sucess: sucess, fail: fail)
    
    /// 从服务端获取消息
    func wzGetMessage(cont: Int, last: WZIMMessageProtocol?, sucess: getMsgSucess, fail: fail)
}
