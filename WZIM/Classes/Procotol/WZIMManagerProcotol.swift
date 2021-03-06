//
//  WZIMManagerProcotol.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/19.
//

import Foundation

// MARK - IM管理器协议
public protocol WZIMManagerProcotol {
    
    /// 成功
    typealias SucessHandler = (()-> Void)?
    
    /// 功能回调有返回消息数组
    typealias MessageListHandler = ((_ list: [WZMessageProtocol])-> Void)?
    
    /// 失败
    typealias FailHandler = ((_ code: Int, _ msg: String)-> Void)?
    
    /// 文件上传进度（当发送消息中包含图片、语音、视频、文件等富媒体消息时才有效）。
    typealias ProgressHandler = ((_ progress: CGFloat)-> Void)?
        
    /// 获取会话列表
    typealias ConversationListHandler = ((_ list: [WZConversationProcotol], _ nextPage: Int, _ isFinished: Bool)-> Void)?
    
    /// 发送单聊消息
    /// - Parameters:
    ///   - receiverId: 用户id | 群id
    ///   - type: 会话类型
    ///   - message: 消息
    ///   - sucess: 成功
    ///   - fail: 失败
    ///   - 返回msgId
    @discardableResult
    func sendC2CMessage(receiverId: String, message: WZMessageProtocol, pushInfo: WZIMOfflinePushInfoProtocol?, progress: ProgressHandler, sucess: SucessHandler, fail: FailHandler) -> String
    
    /// 发送群聊消息
    /// - Parameters:
    ///   - receiverId: 用户id | 群id
    ///   - message: 消息
    ///   - sucess: 成功
    ///   - fail: 失败
    ///   - 返回msgId
    @discardableResult
    func sendGruopMessage(receiverId: String, message: WZMessageProtocol, progress: ProgressHandler, sucess: SucessHandler, fail: FailHandler) -> String
    
    
    /// 从服务端获取单聊历史消息
    /// - Parameters:
    ///   - receiverId: 用户id
    ///   - cont: 数量
    ///   - last: 最后一条消息
    ///   - sucess: 成功
    ///   - fail: 失败
    func getC2CMessages(receiverId: String, cont: Int, last: WZMessageProtocol?, sucess: MessageListHandler, fail: FailHandler)
    
    /// 从服务端获取群里历史消息
    /// - Parameters:
    ///   - receiverId: 用户id
    ///   - cont: 数量
    ///   - last: 最后一条消息
    ///   - sucess: 成功
    ///   - fail: 失败
    func getGroupMessages(receiverId: String, cont: Int, last: WZMessageProtocol?, sucess: MessageListHandler, fail: FailHandler)
    
    /// 消息撤回
    /// - Parameters:
    ///   - msg: 撤回的消息
    ///   - sucess: 成功
    ///   - fail: 失败
    func revokeMessage(msg: WZMessageProtocol, sucess: SucessHandler, fail: FailHandler)
    
    /// 设置消息已读
    /// - Parameters:
    ///   - receiverId: 用户id
    ///   - type: 会话列席
    func setReadMessage(receiverId: String, type: WZIMConversationType)
    
    /// 获取普通消息
    /// - Parameter text: 消息
    func wzCreateTextMessage(text: String) -> WZMessageProtocol
    
    /// gif 消息
    /// - Parameters:
    ///   - gif: gif
    ///   - name: gifName
    func wzCreateGifMenssage(gif: WZIMFaceCustomModel, name: String) -> WZMessageProtocol
    
    /// 表情消息
    /// - Parameters:
    ///   - emojiCode: code
    ///   - emojiName: name
    func wzCreateDTEmojiMessage(emojiCode: String, emojiName: String) -> WZMessageProtocol
    
    /// 语音消息
    /// - Parameters:
    ///   - path: 路径
    ///   - duration: 时长
    func wzCreateVoiceMessage(path: String, duration: Int) -> WZMessageProtocol
        
    /// 创建自定义消息
    /// - Parameters:
    ///   - type: 类型
    ///   - data: data
    func wzCreateCustom(type: WZMessageCustomType, data: Data) -> WZMessageProtocol
    
    /// 图片消息
    /// - Parameter path: 路径
    func wzCreateImageMessage(image: UIImage) -> WZMessageProtocol
    
    /// 时间消息
    /// - Parameter date: 时间
    func wzCreateTimeMessage(date: Date) -> WZMessageProtocol
    
    /// 创建文件消息
    /// - Parameters:
    ///   - size: 大小
    ///   - name: 文件名
    ///   - path: 路径
    func wzCreateFileMessage(name: String, path: String) -> WZMessageProtocol
    
    /// 设置用户资料
    /// - Parameters:
    ///   - receiverId: 被设置的用户
    ///   - data: data
    func setUserProfile(receiverId: String, data: Data)
    
    /// 获取用户资料
    /// - Parameter receiverId: 用户id
    func getUserProfile(receiverId: String) -> Data?
    
    /// 设置会话置顶
    /// - Parameters:
    ///   - receiverId: 用户id
    ///   - isTop: 置顶
    func setConversationTop(receiverId: String, isTop: Bool)
    
    /// 会话是否置顶
    /// - Parameter receiverId: 用户id
    func getConversationTop(receiverId: String) -> Bool

    /// 获取当前登录的
    func wzGetLoginUser() -> String
    
    /// 消息列表
    /// - Parameters:
    ///   - nextSeq: 分页拉取游标，第一次默认取传 0，后续分页拉传上一次分页拉取回调里的 nextSeq
    ///   - count: 分页拉取的个数，一次分页拉取不宜太多，会影响拉取的速度，建议每次拉取 100 个会话
    ///   - comple: 完成
    func wzGetConversationList(nextSeq: Int, count: Int, comple: ConversationListHandler, fail: FailHandler)
    
    /// 删除会话
    /// - Parameter conversationId: 会话id
    func wzDeleteConversation(conversationId: String)
    
    /// 发送邀请
    /// - Parameters:
    ///   - userId: 被邀请用户
    ///   - data: 自定义内容
    ///   - timeOut: 过期时间
    ///   - sucess: 成功
    ///   - fail: 失败
    @discardableResult
    func inviteC2C(userId: String, onlineUserOnly: Bool, data: String, timeOut: Int, pushInfo: WZIMOfflinePushInfoProtocol?, sucess: SucessHandler, fail: FailHandler) -> String
    
    /// 邀请群成员
    /// - Parameters:
    ///   - groupId: 群id
    ///   - userIds: 用户s
    ///   - data: 自定义内容
    ///   - timeOut: 过期时间
    ///   - sucess: 成功
    ///   - fail: 失败
    @discardableResult
    func inviteGroup(groupId: String, onlineUserOnly: Bool, userIds: [String],data: String, timeOut: Int, sucess: SucessHandler, fail: FailHandler) -> String
    
    /// 取消邀请
    /// - Parameters:
    ///   - inviteId: 邀请id
    ///   - data: 自定义内容
    ///   - sucess: 成功
    ///   - fail: 失败
    func cancel(inviteId: String, data: String, sucess: SucessHandler, fail: FailHandler)
    
    /// 接受邀请
    /// - Parameters:
    ///   - inviteId: 邀请id
    ///   - data: 自定义内容
    ///   - sucess: 成功
    ///   - fail: 失败
    func accept(inviteId: String, data: String, sucess: SucessHandler, fail: FailHandler)
    
    /// 拒绝邀请
    /// - Parameters:
    ///   - inviteId: 邀请id
    ///   - data: 自定义内容
    ///   - sucess: 成功
    ///   - fail: 失败
    func reject(inviteId: String, data: String, sucess: SucessHandler, fail: FailHandler)
    
    /// 获取SDK 登录状态
    func loginStatus() -> WZIMLoginStatus
    
    ///  向C2C消息列表中添加一条消息
    ///  该接口主要用于满足向C2C聊天会话中插入一些提示性消息的需求，比如“您已成功发送消息”，这类消息有展示
    ///  在聊天消息去的需求，但并没有发送给对方的必要。
    ///  所以 insertC2CMessageToLocalStorage()相当于一个被禁用了网络发送能力的 sendMessage() 接口。
    /// - Parameters:
    ///   - message: 消息
    ///   - to: 对象
    ///   - sender: 发送方
    ///   - sucess: 成功
    ///   - fail: 失败
    @discardableResult func insertC2CMessageToLocalStorage(message: WZMessageProtocol, to: String, sender: String, sucess: SucessHandler, fail: FailHandler) -> String
    
    ///  向群消息列表中添加一条消息
    ///  该接口主要用于满足向C2C聊天会话中插入一些提示性消息的需求，比如“您已成功发送消息”，这类消息有展示
    ///  在聊天消息去的需求，但并没有发送给对方的必要。
    ///  所以 insertC2CMessageToLocalStorage()相当于一个被禁用了网络发送能力的 sendMessage() 接口。
    /// - Parameters:
    ///   - message: 消息
    ///   - to: 对象
    ///   - sender: 发送方
    ///   - sucess: 成功
    ///   - fail: 失败
    @discardableResult func insertGroupMessageToLocalStorage(message: WZMessageProtocol, groupID: String, sender: String, sucess: SucessHandler, fail: FailHandler) -> String
    
    /// 时间和置顶排序
    @discardableResult func sorted(list: [WZConversationProcotol]) -> [WZConversationProcotol]
}

// MARK - 上传进度
public protocol WZIMUploadProgressListener: class {
    
    /// 上传进度
    func WZIMManager(manger: WZIMManagerProcotol, uploadProgress message: WZMessageProtocol)
}


/// 扩展方法
extension WZIMManagerProcotol {
    
    /// 置顶排序一下
    public func sorted(list: [WZConversationProcotol]) -> [WZConversationProcotol] {
        var arr = list.sorted { (obj0, obj1) -> Bool in
            guard let obj0Time = obj0.lastMsg?.timeTamp, let obj1Time = obj1.lastMsg?.timeTamp else {
                return false
            }
            return  obj0Time.compare(obj1Time) == .orderedDescending
        }
        arr.removeAll(where: {$0.receiverId == "admin"})
        return arr.sorted(by: { (obj0, obj1) -> Bool in
            let top0 = self.getConversationTop(receiverId: obj0.receiverId) ? 1 : 0
            let top1 = self.getConversationTop(receiverId: obj1.receiverId) ? 1 : 0
            return top0 > top1
        })
    }
}
