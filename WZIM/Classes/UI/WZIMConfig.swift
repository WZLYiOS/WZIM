//
//  WZIMConfig.swift
//  Pods-WZIMProtocol_Example
//
//  Created by qiuqixiang on 2020/8/12.
//

import Foundation

// MARK - 基础配置
@objc public class WZIMConfig: NSObject {
    
    /// 左侧会话框
    @objc public static var lelftBubbleImage: UIImage? = nil
    
    /// 右侧侧会话框
    @objc public static var rightBubbleImage: UIImage? = nil
    
    /// 头像位置
    @objc public static var avatarSize: CGSize = CGSize(width: 50, height: 50)
    
    /// 头部位置
    @objc public static var avatarEdge: UIEdgeInsets = UIEdgeInsets(top: 17, left: 15, bottom: 0, right: 10)
    
    /// 消息框边距
    @objc public static var bubbleEdge: UIEdgeInsets = UIEdgeInsets(top: 21, left: 10, bottom: 3, right: 10)
    
    /// 字体大小
    @objc public static var timeFont = UIFont.systemFont(ofSize: 12)
    
    /// 时间颜色
    @objc public static var timeColor: UIColor = UIColor(red: 165/255.0, green: 164/255.0, blue: 170/255.0, alpha: 1)
    
    /// 长按菜单
    @objc public static var menuItems: [String] = []
}

