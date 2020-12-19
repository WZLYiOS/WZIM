//
//  EMClient+.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/11/4.
//

import Foundation
import HyphenateLite

/// MARK - 环信实体
public class WZEMClientManager: NSObject {
    
    /// 代理
    public weak var delegate: WZEMClientManagerDelegate?
    
    /// 设备token
    public var deviceToken: Data?
    
    /// 初始化
    public init(appkey: String, apnsCertName: String, delegate: WZEMClientManagerDelegate) {
        super.init()
        self.delegate = delegate
        let options = EMOptions(appkey: appkey)
        options?.apnsCertName = apnsCertName
        options?.isAutoLogin = false
        EMClient.shared()!.initializeSDK(with: options)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    /// 进入后台
    @objc public func didEnterBackground(notification: Notification) {
        
        guard let application = notification.object else {
            return
        }
        EMClient.shared()?.applicationDidEnterBackground(application)
    }
    
    /// 进入前台
    @objc public func willEnterForeground(notification: Notification) {
        guard let application = notification.object else {
            return
        }
        EMClient.shared()?.applicationWillEnterForeground(application)
    }
    
    /// 环信登录
    public func emLogin(userId: String, password: String) {

        EMClient.shared()?.login(withUsername: userId, password: password,completion: { [weak self](code, error) in
            guard let self = self else { return }
            EMClient.shared()?.chatManager.add(self, delegateQueue: nil)
            EMClient.shared()?.registerPushKitToken(self.deviceToken, completion: nil)
            if self.deviceToken != nil {
                EMClient.shared()?.registerPushKitToken(self.deviceToken, completion: nil)
            }
        })
    }
    
    /// 退出登录
    public func emLogout() {
        EMClient.shared()?.chatManager.remove(self)
        EMClient.shared()?.logout(true, completion: nil)
    }
    
    /// 当前登录用户
    public func currentUserId() -> String {
        return EMClient.shared()?.currentUsername ?? ""
    }
    
    /// 获取会话
    public func getConversation(receiveId: String, type: EMConversationType = EMConversationTypeChat) -> EMConversation {
        return EMClient.shared().chatManager.getConversation(receiveId, type: type, createIfNotExist: true)
    }
    
    /// 设置已读
    public func markAllMessagesAsRead(receiveId: String) {
        getConversation(receiveId: receiveId).markAllMessages(asRead: nil)
    }
    
    /// 获取历史消息
    public func loadMessagesStartFromId(receiveId: String, messageId: String, count: Int, sucess: ((_ list: [WZMessageProtocol]) -> Void)?, fail:((_ error: Error) -> Void)?){
        let conversation = getConversation(receiveId: receiveId)
        conversation.loadMessagesStart(fromId: messageId, count: Int32(count), searchDirection: EMMessageSearchDirectionUp) { (convers, error) in
            if let xerr = error {
                fail?(NSError.init(domain: xerr.errorDescription, code: Int(xerr.code.rawValue), userInfo: nil))
            }else{
                sucess?(convers as? [WZMessageProtocol] ?? [])
            }
        }
    }
    
    /// 发送消息
    public func sendMessage( message: WZMessageProtocol, aProgressBlock: ((_ progress: Int) -> Void)?, aCompletionBlock:((_ result: WZMessageProtocol, _ error: Error?) -> Void)?){
        EMClient.shared()?.chatManager.send(message as? EMMessage, progress: { (pros) in
            aProgressBlock?(Int(pros))
        }, completion: { (msg, emErr) in
            if emErr == nil {
                aCompletionBlock?(message, nil)
            }else{
                aCompletionBlock?(message, NSError.init(domain: emErr!.errorDescription, code: Int(emErr!.code.rawValue)))
            }
        })
    }
}

/// MARK - EMChatManagerDelegate
extension WZEMClientManager: EMChatManagerDelegate {
    
    public func messagesDidReceive(_ aMessages: [Any]!) {
        guard let arr = aMessages as? [EMMessage] else {
            return
        }
        delegate?.eMClientManager(manager: self, receive: arr)
    }
    
    public func conversationListDidUpdate(_ aConversationList: [Any]!) {
        
        guard let arr = aConversationList as? [EMConversation] else {
            return
        }
        delegate?.eMClientManager(manager: self, conversations: arr)
    }
    
    public func messagesDidRead(_ aMessages: [Any]!) {
        guard let arr = aMessages as? [EMMessage] else {
            return
        }
        delegate?.eMClientManager(manager: self, didRead: arr)
    }
}

/// MARK - 代理
public protocol WZEMClientManagerDelegate: class {
    
    /// 收到新的消息
    func eMClientManager(manager: WZEMClientManager, receive newMessage: [WZMessageProtocol])
    
    /// 收到已读类型
    func eMClientManager(manager: WZEMClientManager, didRead: [WZMessageProtocol])
    
    /// 更新会话
    func eMClientManager(manager: WZEMClientManager, conversations: [WZConversationProcotol])
}

/// MARK - 消息构建
extension WZEMClientManager {
    
    /// 文本消息
    public func createTextMessage(receiveId: String, text: String) -> EMMessage {
        let body = EMTextMessageBody(text: text)
        let message = EMMessage(conversationID: receiveId, from: currentUserId(), to: receiveId, body: body, ext: [:])
        message?.chatType = EMChatTypeChat
        return message!
    }
    
    /// 语音消息
    public func createVoiceMessage(receiveId: String, localPath: String, duration: Int) -> EMMessage {
        let body = EMVoiceMessageBody(localPath: localPath, displayName: "audio")
        body?.duration = Int32(duration)
        let message = EMMessage(conversationID: receiveId, from: currentUserId(), to: receiveId, body: body, ext: [:])
        message?.chatType = EMChatTypeChat
        return message!
    }
    
    /// 图片消息
    public func createImageMessage(receiveId: String, image: UIImage) -> EMMessage {
        let data = image.jpegData(compressionQuality: 1)
        let body = EMImageMessageBody.init(data: data, thumbnailData: data)
        let message = EMMessage(conversationID: receiveId, from: currentUserId(), to: receiveId, body: body, ext: [:])
        message?.chatType = EMChatTypeChat
        return message!
    }
}
 
