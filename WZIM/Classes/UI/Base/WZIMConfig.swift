//
//  WZIMConfig.swift
//  Pods-WZIMProtocol_Example
//
//  Created by qiuqixiang on 2020/8/12.
//

import Foundation

// MARK - 基础配置
public struct WZIMConfig {
    
    /// 左侧会话框
    public static var lelftBubbleImage: UIImage? = UIImage(named: "Cell.bundle/ic_chat_windowone")?.wzStretchableImage()
    
    /// 右侧侧会话框
    public static var rightBubbleImage: UIImage? = UIImage(named: "Cell.bundle/ic_chat_windowtwo")?.wzStretchableImage()
    
    /// 右侧白底
    public static var rightWhiteBubbleImage: UIImage? = UIImage(named: "Cell.bundle/ic_chat_windowtwowhite")?.wzStretchableImage()
    
    /// 头像位置
    public static var avatarSize: CGSize = CGSize(width: 50, height: 50)
    
    /// 头部位置
    public static var avatarEdge: UIEdgeInsets = UIEdgeInsets(top: 17, left: 15, bottom: 0, right: 10)
    
    /// 消息框边距
    public static var bubbleEdge: UIEdgeInsets = UIEdgeInsets(top: 21, left: 10, bottom: 3, right: 10)
    
    /// 最大宽度
    public static var maxWidth = UIScreen.main.bounds.size.width - WZIMConfig.avatarEdge.left - WZIMConfig.avatarSize.width - WZIMConfig.bubbleEdge.left - 80
    
    /// 文字左边颜色
    public static var lelftTextColor: UIColor = WZIMToolAppearance.hexadecimal(rgb: "0x3C3C3C")
    
    /// 右边颜色
    public static var rightTextColor: UIColor = UIColor.white
}

// MARK - 富文本修改
public extension NSMutableAttributedString {
    
    /// 设置文字
    func wzSetFont(value: UIFont) {
        wzSetAttribute(key: NSAttributedString.Key.font, value: value, range: NSRange(location: 0, length: self.length))
    }
    
    /// 设置间距
    func wzSetLineSpacing(value: Int) {
        let mPara = NSMutableParagraphStyle()
        mPara.lineSpacing = CGFloat(value)
        wzSetAttribute(key: NSAttributedString.Key.paragraphStyle, value: mPara, range: NSRange(location: 0, length: self.length))
    }
    
    /// 设置颜色
    func wzSetColor(value: UIColor, range: NSRange? = nil) {

        if range != nil {
            wzSetAttribute(key: NSAttributedString.Key.foregroundColor, value: value, range: range!)
            return
        }
        wzSetAttribute(key: NSAttributedString.Key.foregroundColor, value: value, range:  NSRange(location: 0, length: self.length))
    }
    
    /// 设置下划线
    func wzSetUnderline(style: NSUnderlineStyle = .single, color: UIColor? = nil, range: NSRange) {
        if self.length < range.location + range.length {
            return
        }
        let attrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        self.addAttributes(attrs, range: range)
        
        if let tempColor = color {
            let attr2 = [NSAttributedString.Key.underlineColor: tempColor]
            self.addAttributes(attr2, range: range)
        }
    }
    
    /// 添加key
    func wzSetAttribute(key: NSAttributedString.Key, value: Any, range: NSRange) {
        self.addAttribute(key, value: value, range: range)
    }
    
    /// 富文本图片
    func wzGetAttachment(image: UIImage?, x: CGFloat = 0, y: CGFloat = 0) -> NSAttributedString {
        let attch = NSTextAttachment()
        attch.bounds = CGRect(x: x, y: y, width: image?.size.width ?? 0, height: image?.size.height ?? 0)
        attch.image = image
        let attachment = NSAttributedString(attachment: attch)
        return attachment
    }
}

/// MARK - cell
public extension WZMessageProtocol {
    /// cell 标识
    func getNomarCellId() -> WZIMBaseTableViewCell.Type {
        
        switch currentElem {
        case .img:
            return WZIMPictureTableViewCell.self
        case .text:
            return WZIMTextTableViewCell.self
        case .sound:
            return WZIMVoiceTableViewCell.self
        case .nameAuthInvite:
            return WZIMNameAuthInvateTableViewCell.self
        case .time:
            return WZIMTimeTableViewCell.self
        case .dateAuthInvite, .dateService:
            return WZIMMakingCourseTableViewCell.self
        case .card:
            return WZIMRecommendCardTableViewCell.self
        case .signaling:
            return WZIMVideoInviteSelfTableViewCell.self
        case .share:
            return WZIMActivityTableViewCell.self
        case .file:
            return WZIMFileTableViewCell.self
        default:
            return WZIMUnknownTableViewCell.self
        }
    }
}
