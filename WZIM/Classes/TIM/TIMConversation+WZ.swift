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
    
    public var userProfile: Data? {
        get {
             let aFilePath = WZIMToolAppearance.getUserInfoPath(userId: getReceiver())
             return FileManager.default.contents(atPath: aFilePath)
        }
        set {
            let aFilePath = WZIMToolAppearance.getUserInfoPath(userId: getReceiver())
            try? newValue?.write(to: URL(fileURLWithPath: aFilePath))
        }
    }
    
    /// 是否置顶
    public var isTop: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "com.wzly.im.conversation.isTop")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "com.wzly.im.conversation.isTop")
        }
    }
    
    
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
    
    public func wzSaveMessage(message: WZIMMessageProtocol, sender: String, isRead: Bool) {
        save((message as! TIMMessage), sender: sender, isReaded: isRead)
    }
    
    public func wzGetTextMessage(text: String) -> WZIMMessageProtocol {
        let elem = TIMTextElem()
        elem.text = text
        
        let message = TIMMessage()
        message.add(elem)
        return message
    }
    
    public func wzGetGifMenssage(git: WZIMFaceCustomModel, name: String) -> WZIMMessageProtocol {
        
        let model = WZIMFaceCustomMarkModel()
        model.expressionData = git
        model.messageType = .gif
        model.name = name
        
        let elem = TIMFaceElem()
        elem.data = try? JSONEncoder().encode(model)
        
        let message = TIMMessage()
        message.add(elem)
        return message
    }
    
    public func wzGetDTEmojiMessage(emojiCode: String, emojiName: String) -> WZIMMessageProtocol {
        
        let face = WZIMFaceCustomModel()
        face.code = emojiCode
        
        let model = WZIMFaceCustomMarkModel()
        model.expressionData = face
        model.messageType = .face
        model.name = emojiName
        
        let elem = TIMFaceElem()
        elem.data = try? JSONEncoder().encode(model)
        
        let message = TIMMessage()
        message.add(elem)
        return message
    }
    
    public func wzGetVoiceMessage(path: String, duration: Int) -> WZIMMessageProtocol {
        let elem = TIMSoundElem()
        elem.path = path
        elem.second = Int32(duration)
        
        let message = TIMMessage()
        message.add(elem)
        return message
    }
    

    /// 创建自定义消息
    public func wzCreateCustom(type: WZMessageCustomType, data: Data) -> WZIMMessageProtocol {
        
        let custom = WZIMCustomElem(type: type, msg: String(data: data, encoding: String.Encoding.utf8)!)
        
        let tElem = TIMCustomElem()
        tElem.data = try? JSONEncoder().encode(custom)
        
        let message = TIMMessage()
        message.add(tElem)
        return message
    }
}

