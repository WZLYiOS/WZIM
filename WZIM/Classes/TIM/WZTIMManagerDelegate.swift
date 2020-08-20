//
//  WZTIMManagerDelegate.swift
//  Pods-WZIM_Example
//
//  Created by qiuqixiang on 2020/8/14.
//

import ImSDK
import Foundation

// MARK - 腾讯SDK代理回调
public protocol WZTIMManagerDelegate: class {
    
    /// 网络连接成功
    /// - Parameter manager: 管理器
    func onConnSucc(manager: WZTIMManager)
    
    /// 网络连接失败
    /// - Parameters:
    ///   - manager: 管理器
    ///   - code: 错误码
    ///   - err: 错误信息
    func onConnFailed(manager: WZTIMManager, code: Int32, err: String)
    
    /// 网络连接断开（断线只是通知用户，不需要重新登录，重连以后会自动上线）
    /// - Parameters:
    ///   - manager: 管理器
    ///   - code: 错误码
    ///   - err: 错误信息
    func onDisconnect(manager: WZTIMManager, code: Int32, err: String)
    
    /// 连接中
    /// - Parameter manager: 管理器
    func onConnecting(manager: WZTIMManager)
    
    /// 踢下线通知
    /// - Parameter manager: 管理器
    func onForceOffline(manager: WZTIMManager)
    
    /// 断线重连失败
    /// - Parameters:
    ///   - code: 错误码
    ///   - err: 错误描述
    func onReConnFailed(manager: WZTIMManager, code: Int32, err: String) 
    
    /// 用户登录的userSig过期（用户需要重新获取userSig后登录）
    /// - Parameter manager: 管理器
    func onUserSigExpired(manager: WZTIMManager)
    
    /// 刷新会话
    /// - Parameter manager: 管理器
    func onRefresh(manager: WZTIMManager)
    
    /// 刷新部分会话
    /// - Parameters:
    ///   - manager: 管理器
    ///   - conversations: 会话数组
    func onRefreshConversations(manager: WZTIMManager, conversations: [TIMConversation])
    
    /// 收到了已读回执
    /// - Parameters:
    ///   - manager: 管理器
    ///   - receipts: 已读列表
    func onRecvMessageReceipts(manager: WZTIMManager, receipts: [TIMMessageReceipt])
    
    /// 群tips回调
    /// - Parameters:
    ///   - manager: 管理器
    ///   - elem: elem
    func onGroupTipsEvent(manager: WZTIMManager, elem: TIMGroupTipsElem)
    
    /// 新消息回调通知
    /// - Parameters:
    ///   - manager: 管理器
    ///   - msgs: 消息
    func onNewMessage(manager: WZTIMManager, msgs: [TIMMessage])
}
