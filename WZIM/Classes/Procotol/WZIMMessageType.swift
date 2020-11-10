//
//  WZIMMessageType.swift
//  WZIMUIKit_Example
//
//  Created by qiuqixiang on 2020/4/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

// MARK - SDK 登录状态
public enum WZIMLoginStatus: Int {
    case logIned = 1  // 已登录
    case loginIng = 2 // 登录中
    case logOut = 3   // 无登录
}

// MARK - 消息状态
public enum WZIMMessageStatus: Int {
    case pending = 0  // 未开始发送
    case sending = 1  // 发送中
    case sucess = 2   // 成功
    case fail = 3     // 失败
    case deleted = 4  // 消息被删除
    case stored = 5   // 导入到本地的消息
    case revoked = 6  // 被撤销的消息
}

// MARK - 会话类型
public enum WZIMConversationType: Int {
    case c2c = 1      // C2C 类型
    case group = 2    // 群聊 类型
}
 
/// MARK - 消息位置
public enum WZMessageLocation: Int {
    case lelft = 0     // 居左
    case right = 1     // 居右
    case center = 2    // 居中
}

/// MARK - 枚举默认值
public protocol WZIMDefaultEnumCodable: RawRepresentable, Codable {
    
    static var defaultCase: Self { get }
}


public extension WZIMDefaultEnumCodable where Self.RawValue: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        self = Self.init(rawValue: rawValue) ?? Self.defaultCase
    }
}
