//
//  TIMConversation+.swift
//  SweepTreasure
//
//  Created by qiuqixiang on 2020/7/13.
//  Copyright © 2020 划宝. All rights reserved.
//

import ImSDK
import wz
import Foundation



// MARK - 消息扩展
extension TIMConversation: WZIMConversationProcotol, UITableViewCellIdentifierProtocol {
    
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
    
    public func getCellIdentifier() -> UITableViewCell.Type {
        return MessageListTableViewCell.self
    }
    
    public func wzReadMessage(message: WZIMMessageProtocol?) {
        let mess = (message as? TIMMessage) ?? nil
        setRead(mess, succ: {
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
        let mess = (last as? TIMMessage) ?? nil
        getMessage(Int32(cont), last: mess, succ: { (list) in
            let arr = list as? [WZIMMessageProtocol]
            sucess?(arr?.reversed() ?? [])
        }) { (code, msg) in
            fail?(Int(code), msg ?? "")
        }
    }
    
    public func wzGetUserInfo(forceUpdate: Bool, comple: @escaping(WZIMUserInfoProtocol) -> Void) {
        
        if let info = TIMFriendshipManager.sharedInstance()?.queryUserProfile(getReceiver()) {
            comple(info)
            if forceUpdate == false {
                return
            }
        }
        
        TIMFriendshipManager.sharedInstance()?.getUsersProfile([getReceiver()], forceUpdate: forceUpdate, succ: { (list) in
            
            if let xx = list?.first {
                comple(xx)
            }
        }, fail: { (code, msg) in
        })
    }
}

// MARK - 获取用户资料
extension TIMUserProfile: WZIMUserInfoProtocol {
    public func wzGetUserName() -> String {
        return nickname
    }
    
    public func wzGetAvatar() -> String {
        return faceURL
    }
}

