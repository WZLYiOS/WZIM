//
//  TIMMessage+.swift
//  SweepTreasure
//
//  Created by qiuqixiang on 2020/7/13.
//  Copyright © 2020 划宝. All rights reserved.
//

import Foundation
import ImSDK

// MARK - 消息协议实现
extension TIMMessage: WZIMMessageProtocol {
    
    /// 消息状态
    public func wzStatus() -> WZIMMessageStatus {
        return WZIMMessageStatus.init(rawValue: status().rawValue) ?? .sucess
    }
    
    /// 是否已读
    public func wzIsReaded() -> Bool{
        return isReaded()
    }
    
    /// 是否删除消息
    public func wzRemove() -> Bool {
        return remove()
    }
    
    /// 发送者
    public func wzSender() -> String {
        return sender()
    }
    
    /// 消息id
    public func wzMessageId() -> String {
        return msgId()
    }
    
    /// 时间戳
    public func wzTimestamp() -> Date {
        return timestamp()
    }
    
    /// 获取当前消息的会话
    public func wzGetConversation() -> WZIMConversationProcotol {
        return getConversation()
    }
    
    /// 将消息导入本地
    public func wzConvertToImportedMsg() {
        convertToImportedMsg()
    }
    
    /// 设置消息发送方: 需要先将消息到导入到本地，调用 convertToImportedMsg 方法
    public func wzSetSender(sender: String) {
        setSender(sender)
    }

    /// 是否自己
    public func wzLoaction() -> WZMessageLocation {
        return isSelf() ? .right : .lelft
    }
    
    /// 会话列表最后一条消息内容
    public func wzListContent() -> NSMutableAttributedString {
        
        /// 判断消息类型，并获取对应的解析data
        let elem = wzGetElem()
        var text: String = ""
        
        switch elem {
        case let .text(model):
            text = model.text
        case .video:
            text = "[视频]"
        case let .chatTips(elem):
            if case let .greet(elem2) = elem.msg.data {
                text = elem2.tips
            }
        default:
            text = "未知消息，请更新版本"
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.yy_color = ColorAppearance.hexadecimal(rgb: 0xA5A4AA)
        attributedString.yy_font = FontAppearance.font(size: 13)
        
        return attributedString
    }
}
