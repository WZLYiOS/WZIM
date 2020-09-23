//
//  WZConversationProcotol.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/19.
//

import Foundation

/// 会话协议
public protocol WZConversationProcotol {
    
    /// 会话类型
    var conversationType: WZIMConversationType { get }
    
    /// 会话唯一 ID，如果是 C2C 单聊，组成方式为 c2c_userID，如果是群聊，组成方式为 group_groupID
    var conversationId: String { get }
    
    /// 会话类型为 C2C 单聊， 会话类型为群聊
    var receiverId: String { get }
    
    /// 会话未读消息数量,直播群（AVChatRoom）不支持未读计数，默认为 0
    var unReadCount: Int { get }
    
    /// 会话最后一条消息，可以通过 lastMessage -> timestamp 对会话做排序，timestamp 越大，会话越靠前
    var lastMsg: WZMessageProtocol? { get }
    
    /// 草稿信息，设置草稿信息请调用 setConversationDraft() 接口
    var draft: String? { get }
    
    /// 草稿编辑时间，草稿设置的时候自动生成
    var draftTime: Date? { get }
}

// MARK - 消息监听
public protocol WZConversationDelegate: class {
    
    /// 同步服务器会话开始，SDK 会在登录成功或者断网重连后自动同步服务器会话，您可以监听这个事件做一些 UI 进度展示操作。
    func onSyncServerStart()
    
    /// 同步服务器会话完成，如果会话有变更，会通过 onNewConversation | onConversationChanged 回调告知客户
    func onSyncServerFinish()
    
    /// 同步服务器会话失败
    func onSyncServerFailed()
    
    /// 有新的会话（比如收到一个新同事发来的单聊消息、或者被拉入了一个新的群组中），可以根据会话的 lastMessage -> timestamp 重新对会话列表做排序。
    func onNewConversation(conversationList: [WZConversationProcotol])
    
    /// 某些会话的关键信息发生变化（未读计数发生变化、最后一条消息被更新等等），可以根据会话的 lastMessage -> timestamp 重新对会话列表做排序。
    func onConversationChanged(conversationList: [WZConversationProcotol])
}

