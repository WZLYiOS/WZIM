//
//  WZIMTableViewCellDelegate.swift
//  Pods-WZIMProtocol_Example
//
//  Created by qiuqixiang on 2020/8/11.
//

import Foundation

// MARK - 代理
@objc public protocol WZIMTableViewCellDelegate: class {
    
}

// MARK - 撤回等
@objc public protocol WZIMTableViewCellPublicDelegate: class {
    
    /// 头像点击
    /// - Parameters:
    ///   - WZIMTableViewCell: cell
    ///   - avatarImageView: 被点击view
    @objc func WZIMTableViewCell(cell: WZIMTableViewCell, tap avatarImageView: UIImageView)
 
    /// 长按菜单
    /// - Parameters:
    ///   - cell: cell
    ///   - menuTitle: 点击item
    @objc func WZIMTableViewCell(cell: WZIMTableViewCell, menuTitle: String)
    
    /// 设置头像
    /// - Parameters:
    ///   - cell: cell
    ///   - avatar: 头像
    @objc func WZIMTableViewCell(cell: WZIMTableViewCell, set avatar: UIImageView)
}
