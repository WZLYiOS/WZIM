//
//  TIMConversation+.swift
//  SweepTreasure
//
//  Created by qiuqixiang on 2020/7/13.
//  Copyright © 2020 划宝. All rights reserved.
//

import ImSDK
import Foundation

// MARK - 消息扩展
extension TIMConversation: WZIMConversationProcotol {
    
    /// 获取最后一条消息
    public func wzLastMessage() -> WZIMMessageProtocol? {
        return self.getLastMsg()
    }
    
    /// 会话类型
    public func wzConversationType() -> WZIMConversationType {
        return .c2c
    }
    
    /// 获取会话 ID
    public func wzReceiverId() -> String {
        return self.getReceiver()
    }
    
    public func wzReadMessage(message: WZIMMessageProtocol?) {
        
        setRead(message as? TIMMessage, succ: {
        }) { (code, msg) in
        }
    }
    
    public func wzGetUnReadMessageNum() -> Int {
        return Int(getUnReadMessageNum())
    }
    
    public func wzSendMessage(message: WZIMMessageProtocol, sucess: sucess, fail: fail) {
        send((message as! TIMMessage), succ: {
            sucess?()
        }) { (code, msg) in
            fail?(Int(code), msg ?? "")
        }
    }
    
    public func wzGetMessage(cont: Int, last: WZIMMessageProtocol?, sucess: getMsgSucess, fail: fail) {

        getMessage(Int32(cont), last: last as? TIMMessage, succ: { (list) in
            let arr = list as? [WZIMMessageProtocol]
            sucess?(arr?.reversed() ?? [])
        }) { (code, msg) in
            fail?(Int(code), msg ?? "")
        }
    }
}

