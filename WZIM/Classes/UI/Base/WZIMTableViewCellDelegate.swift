//
//  WZIMTableViewCellDelegate.swift
//  Pods-WZIMProtocol_Example
//
//  Created by qiuqixiang on 2020/8/11.
//

import Foundation

// MARK - 代理
public protocol WZIMTableViewCellDelegate: class {
    
}

// MARK - 撤回等
public protocol WZIMTableViewCellPublicDelegate: class {
    
    /// 头像点击
    /// - Parameters:
    ///   - WZIMTableViewCell: cell
    ///   - avatarImageView: 被点击view
    func baseTableViewCell(cell: WZIMBaseTableViewCell, tap avatarImageView: UIImageView)
 
    /// 长按菜单
    /// - Parameters:
    ///   - cell: cell
    ///   - menuTitle: 点击item
    func baseTableViewCell(cell: WZIMBaseTableViewCell, menuTitle: String)
    
    /// 设置头像
    /// - Parameters:
    ///   - cell: cell
    ///   - avatar: 头像
    func baseTableViewCell(cell: WZIMBaseTableViewCell, set avatar: UIImageView)
    
    /// 消息重发
    /// - Parameters:
    ///   - cell: cell
    ///   - btn: 重发按钮
    func baseTableViewCell(cell: WZIMBaseTableViewCell, resend btn: UIButton)
}
