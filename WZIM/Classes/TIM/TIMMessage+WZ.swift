//
//  TIMMessage+.swift
//  SweepTreasure
//
//  Created by qiuqixiang on 2020/7/13.
//  Copyright © 2020 划宝. All rights reserved.
//

import ImSDK
import Foundation
import CleanJSON

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
    
    public var wzCustomInt: Int {
        get {
            return Int(self.customInt())
        }
        set {
            self.setCustomInt(Int32(newValue))
        }
    }
    
    public var wzCustomData: Data? {
        get {
            return customData()
        }
        set {
            setCustomData(newValue)
        }
    }
    public func wzCurrentElem() -> WZMessageElem? {
        let elem = getElem(0)
        return elem?.getElem()
    }
}
