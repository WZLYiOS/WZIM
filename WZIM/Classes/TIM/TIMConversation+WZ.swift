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
    
    public func wzGetImageMessage(url: String, name: String, image: UIImage) -> WZIMMessageProtocol {
        
        let elem = WZIMImageCustomElem()
        elem.fileName = name
        elem.width = image.size.width
        elem.heigth = image.size.height
        elem.length = CGFloat(image.pngData()!.count/1024)
        elem.url = url
        
        let data = try? JSONEncoder().encode(elem)
        let customElem = WZIMCustomElem(type: .img, msg: String(data: data!, encoding: String.Encoding.utf8)!)

        let xx = TIMCustomElem()
        xx.data = try? JSONEncoder().encode(customElem)
        
        let message = TIMMessage()
        message.add(xx)
        return message
    }
}

