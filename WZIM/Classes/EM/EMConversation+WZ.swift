//
//  EMConversation+.swift
//  Pods-WZIM_Example
//
//  Created by qiuqixiang on 2020/8/14.
//

import Foundation
import HyphenateLite

// MARK - 环信会话遵循协议
extension EMConversation: WZIMConversationProcotol {
    
    public var userProfile: Data? {
        get {
             let aFilePath = WZIMToolAppearance.getUserInfoPath(userId: conversationId)
             return FileManager.default.contents(atPath: aFilePath)
        }
        set {
            let aFilePath = WZIMToolAppearance.getUserInfoPath(userId: conversationId)
            try? newValue?.write(to: URL(fileURLWithPath: aFilePath))
        }
    }
    
    /// 是否置顶
    public var isTop: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "com.wzly.im.conversation.\(wzReceiverId()).isTop")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "com.wzly.im.conversation.\(wzReceiverId()).isTop")
        }
    }
    
    /// 获取最后一条消息
    public func wzLastMessage() -> WZIMMessageProtocol? {
        return self.latestMessage
    }
    
    /// 会话类型
    public func wzConversationType() -> WZIMConversationType {
        switch type {
        case EMConversationTypeChat:
            return .c2c
        case EMConversationTypeGroupChat, EMConversationTypeChatRoom:
            return .group
        default:
            return .system
        }
    }
    
    /// 获取会话 ID
    public func wzReceiverId() -> String {
        return self.conversationId
    }
    
    public func wzReadMessage(message: WZIMMessageProtocol?) {
        self.markMessageAsRead(withId: message?.wzMessageId(), error: nil)
    }
    
    public func wzGetUnReadMessageNum() -> Int {
        return Int(self.unreadMessagesCount)
    }
    
    public func wzSendMessage(message: WZIMMessageProtocol, sucess: sucess, fail: fail) {
        EMClient.shared()?.chatManager.send((message as! EMMessage), progress: { (float) in
            
        }, completion: { (mess, err) in
        
            if err ==  nil {
                sucess?()
            }else{
                fail?(Int(err!.code.rawValue), err!.description)
            }
        })
    }
    
    public func wzGetMessage(cont: Int, last: WZIMMessageProtocol?, sucess: getMsgSucess, fail: fail) {
        
        loadMessagesStart(fromId: last?.wzMessageId() ?? "", count: Int32(cont), searchDirection: EMMessageSearchDirection(rawValue: 0)) { (list, err) in
            if err == nil {
                
            }
        }
    }
    
    public func wzSaveMessage(message: WZIMMessageProtocol, sender: String, isRead: Bool) {
        
    }
    
    public func wzGetTextMessage(text: String) -> WZIMMessageProtocol {
        return EMMessage()
    }
    
    public func wzGetGifMenssage(gif git: WZIMFaceCustomModel, name: String) -> WZIMMessageProtocol {
        return EMMessage()
    }
    
    public func wzGetDTEmojiMessage(emojiCode: String, emojiName: String) -> WZIMMessageProtocol {
        return EMMessage()
    }
    
    public func wzGetVoiceMessage(path: String, duration: Int) -> WZIMMessageProtocol {
        return EMMessage()
    }
    
   public func wzCreateCustom(type: WZMessageCustomType, data: Data) -> WZIMMessageProtocol {
       return EMMessage()
   }
    
    public func wzCreateImageMessage(elem: WZIMImageCustomElem) -> WZIMMessageProtocol {
        return EMMessage()
    }
    public func wzCreateTimeMessage(date: Date) -> WZIMMessageProtocol {
        return EMMessage()
    }
}
