//
//  V2TIMManager+.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/19.
//

import ImSDK
import Foundation

/// 添加前缀
public extension String {
    
    /// 添加前缀
    var imPrefix: String {
        
        if self.contains("wzly_") {
            return self
        }
        return "wzly_\(self)"
    }
    
    /// 去除前缀
    var imDelPrefix: String{
        if self.contains("wzly_") {
            return self.replacingOccurrences(of: "wzly_", with: "")
        }
        return self
    }
}

// MARK - 管理器遵循协议
extension V2TIMManager: WZIMManagerProcotol {
    
    public func loginStatus() -> WZIMLoginStatus {
        return WZIMLoginStatus.init(rawValue: getLoginStatus().rawValue) ?? .logOut
    }
    
    public func revokeMessage(msg: WZMessageProtocol, sucess: SucessHandler, fail: FailHandler) {
        revokeMessage((msg as! V2TIMMessage)) {
            sucess?()
        } fail: { (code, msg) in
            fail?(Int(code), msg ?? "")
        }
    }
    
    
    public func setReadMessage(receiverId: String, type: WZIMConversationType) {
        
        if type == .c2c {
            markC2CMessage(asRead: receiverId.imPrefix) {
                
            } fail: { (code, msg) in
                
            }
            return
        }
        markGroupMessage(asRead: receiverId.imPrefix) {
            
        } fail: { (code, msg) in
            
        }
    }
    
    public func sendC2CMessage(receiverId: String, message: WZMessageProtocol, progress: ProgressHandler, sucess: SucessHandler, fail: FailHandler) -> String {
        let msg = (message as! V2TIMMessage)
        return send(msg, receiver: receiverId.imPrefix, groupID: nil, priority: .PRIORITY_DEFAULT, onlineUserOnly: false, offlinePushInfo: nil) { (progre) in
            progress?(CGFloat(progre))
        } succ: {
            sucess?()
        } fail: { (code, msg) in
            fail?(Int(code), msg ?? "")
        }
    }
    
    public func sendGruopMessage(receiverId: String, message: WZMessageProtocol, progress: ProgressHandler, sucess: SucessHandler, fail: FailHandler) -> String {
        let msg = (message as! V2TIMMessage)
        return send(msg, receiver: nil, groupID: receiverId.imPrefix, priority: .PRIORITY_DEFAULT, onlineUserOnly: false, offlinePushInfo: nil) { (progre) in
            progress?(CGFloat(progre))
        } succ: {
            sucess?()
        } fail: { (code, msg) in
            fail?(Int(code), msg ?? "")
        }
    }
    
    public func getC2CMessages(receiverId: String, cont: Int, last: WZMessageProtocol?, sucess: MessageListHandler, fail: FailHandler) {
        
        getC2CHistoryMessageList(receiverId.imPrefix, count: Int32(cont), lastMsg: (last as? V2TIMMessage)) { (list) in
            let arr = list?.sorted { (obj0, obj1) -> Bool in
                return  obj0.timeTamp.compare(obj1.timeTamp) == .orderedAscending
            }
            sucess?(arr ?? [])
        } fail: { (code, msg) in
            fail?(Int(code), msg ?? "")
        }
    }
    
    public func getGroupMessages(receiverId: String, cont: Int, last: WZMessageProtocol?, sucess: MessageListHandler, fail: FailHandler) {
        getGroupHistoryMessageList(receiverId.imPrefix, count: Int32(cont), lastMsg: (last as? V2TIMMessage)) { (list) in
            let arr = list?.sorted { (obj0, obj1) -> Bool in
                return  obj0.timeTamp.compare(obj1.timeTamp) == .orderedAscending
            }
            sucess?(arr ?? [])
        } fail: { (code, msg) in
            fail?(Int(code), msg ?? "")
        }
    }
    
    public func setUserProfile(receiverId: String, data: Data) {
        let aFilePath = WZIMToolAppearance.getUserInfoPath(userId: receiverId.imPrefix)
        try? data.write(to: URL(fileURLWithPath: aFilePath))
    }
    
    public func getUserProfile(receiverId: String) -> Data? {
        
        let aFilePath = WZIMToolAppearance.getUserInfoPath(userId: receiverId.imPrefix)
        return FileManager.default.contents(atPath: aFilePath)
    }
    
    public func setConversationTop(receiverId: String, isTop: Bool) {
        UserDefaults.standard.set(isTop, forKey: "com.wzly.im.conversation.\(String(describing: getLoginUser())).\(receiverId.imPrefix).isTop")
    }
    
    public func getConversationTop(receiverId: String) -> Bool {
        return UserDefaults.standard.bool(forKey: "com.wzly.im.conversation.\(String(describing: getLoginUser())).\(receiverId.imPrefix).isTop")
    }
    
    public func wzCreateTextMessage(text: String) -> WZMessageProtocol {
        return createTextMessage(text)
    }
    
    public func wzCreateGifMenssage(gif: WZIMFaceCustomModel, name: String) -> WZMessageProtocol {
        let model = WZIMFaceCustomMarkModel()
        model.expressionData = gif
        model.messageType = .gif
        model.name = name
        return createFaceMessage(1, data: try? JSONEncoder().encode(model))
    }
    
    public func wzCreateDTEmojiMessage(emojiCode: String, emojiName: String) -> WZMessageProtocol {
        let face = WZIMFaceCustomModel()
        face.code = emojiCode
        
        let model = WZIMFaceCustomMarkModel()
        model.expressionData = face
        model.messageType = .face
        model.name = emojiName
        return createFaceMessage(1, data: try? JSONEncoder().encode(model))
    }
    
    public func wzCreateVoiceMessage(path: String, duration: Int) -> WZMessageProtocol {
        return createSoundMessage(path, duration: Int32(duration))
    }
    
    public func wzCreateCustom(type: WZMessageCustomType, data: Data) -> WZMessageProtocol {
    
        return createCustomMessage(WZIMCustomElem.getData(type: type, msgData: data))
    }
    
    public func wzCreateImageMessage(path: String) -> WZMessageProtocol {
        return createImageMessage(path)
    }
    
    public func wzCreateTimeMessage(date: Date) -> WZMessageProtocol {
        let elem = WZIMTimeCustomElem(time: "\((date as  NSDate).timeIntervalSince1970)")
        return wzCreateCustom(type: .time, data: try! JSONEncoder().encode(elem))
    }
    
    /// 获取当前登录的
    public  func wzGetLoginUser() -> String {
        return getLoginUser()
    }
    
    public func wzGetConversationList(nextSeq: Int, count: Int, comple: ConversationListHandler, fail: FailHandler) {
        self.getConversationList(UInt64(nextSeq), count: Int32(count)) { (lists, page, isFinish) in
        
            let arr = lists?.sorted(by: { (obj0, obj1) -> Bool in
                let top0 = self.getConversationTop(receiverId: obj0.receiverId) ? 1 : 0
                let top1 = self.getConversationTop(receiverId: obj0.receiverId) ? 1 : 0
                return top0 > top1
            })
            comple?(arr ?? [], Int(page), isFinish)
        } fail: { (code, msg) in
            fail?(Int(code), msg ?? "")
        }
    }
    
    public func wzDeleteConversation(conversationId: String) {
        deleteConversation(conversationId, succ: nil, fail: nil)
    }
    
    public func inviteC2C(userId: String, data: String, timeOut: Int, sucess: SucessHandler, fail: FailHandler) -> String {
        return invite(userId.imPrefix, data: data, timeout: Int32(timeOut)) {
            sucess?()
        } fail: { (code, msg) in
            fail?(Int(code),msg ?? "")
        }
    }
    
    public func inviteGroup(groupId: String, userIds: [String], data: String, timeOut: Int, sucess: SucessHandler, fail: FailHandler) -> String {
        return invite(inGroup: groupId.imPrefix, inviteeList: userIds, data: data, timeout: Int32(timeOut)) {
            sucess?()
        } fail: { (code, msg) in
            fail?(Int(code),msg ?? "")
        }
    }
    
    public func cancel(inviteId: String, data: String, sucess: SucessHandler, fail: FailHandler) {
        cancel(inviteId, data: data) {
            sucess?()
        } fail: { (code, msg) in
            fail?(Int(code),msg ?? "")
        }
    }
    
    public func accept(inviteId: String, data: String, sucess: SucessHandler, fail: FailHandler) {
        accept(inviteId, data: data) {
            sucess?()
        } fail: { (code, msg) in
            fail?(Int(code),msg ?? "")
        }
    }
    
    public func reject(inviteId: String, data: String, sucess: SucessHandler, fail: FailHandler) {
        reject(inviteId, data: data) {
            sucess?()
        } fail: { (code, msg) in
            fail?(Int(code),msg ?? "")
        }
    }
}
