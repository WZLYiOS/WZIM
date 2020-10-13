//
//  WZIMChatTextView.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/26.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit

// MARK - IM输入框
open class WZIMChatTextView: UITextView {
    
    /// 默认展示文字，默认为nil
    public var placeHolder: String = ""
    
    /// 默认显示文字颜色，默认为
    public var placeHolderTextColor: UIColor? = nil
    
    /// 默认文字字体大小
    public var placeHolderFont: UIFont? = nil
    
    /// 提示文字
    public lazy var placeHolderLabel: UILabel = {
        $0.textColor = UIColor.gray
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.text = "请输入"
        return $0
    }(UILabel())

    open override var text: String! {
        willSet {
            self.setNeedsDisplay()
            self.placeHolderLabel.isHidden = text.count > 0 ? true : false
        }
    }
    open override var attributedText: NSAttributedString! {
        willSet {
            self.setNeedsDisplay()
        }
    }
    
    open override var font: UIFont? {
        willSet {
            self.setNeedsDisplay()
        }
    }
    open override var textAlignment: NSTextAlignment {
        willSet {
            self.setNeedsDisplay()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        placeHolderLabel.frame = CGRect(x: 5, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        config()
        self.addSubview(placeHolderLabel)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.placeHolderLabel.isHidden = text.count > 0 ? true : false
    }
    
    func config() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.isExclusiveTouch = true
        self.returnKeyType = .send
        self.enablesReturnKeyAutomatically = true
        NotificationCenter.default.addObserver( self, selector: #selector(didReceiveTextDidChangeNotification), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver( self, selector: #selector(didReceiveTextDidBeginEditinNotification), name: UITextView.textDidBeginEditingNotification, object: self)
    }
    

    @objc func didReceiveTextDidChangeNotification(notification: Notification) {
        self.setNeedsDisplay()
        
        guard let textView = notification.object as? UITextView else {
            return
        }
        placeHolderLabel.isHidden = textView.text.count > 0 ? true : false
        let view = textView.subviews.first! as UIView
        
        if (view.frame.size.height < textView.frame.size.height) {
            let center = CGPoint(x: textView.frame.size.width * 0.5, y: textView.frame.size.height * 0.5)
            view.center = center;
        } else {
            view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        }
    }
    @objc func didReceiveTextDidBeginEditinNotification(notification: Notification) {
        guard let textView = notification.object as? UITextView else {
            return
        }
        let view = textView.subviews.first! as UIView
        if (view.frame.size.height < textView.frame.size.height) {
            let center = CGPoint(x: textView.frame.size.width * 0.5, y: textView.frame.size.height * 0.5)
            view.center = center;
        }
    }
    
    /// 获取文字内容
    func placeholderTextAttributes() -> [NSAttributedString.Key : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = self.textAlignment
        return [NSAttributedString.Key.paragraphStyle : paragraphStyle,
                NSAttributedString.Key.font: placeHolderFont ?? UIFont.systemFontSize , NSAttributedString.Key.foregroundColor: placeHolderTextColor ?? UIColor.black]
    }
}
// MARK - 扩展
public extension UITextView {
    
    func getHeight(maxFloat: CGFloat = 110, miniFloat: CGFloat = 35) -> CGFloat {
        
        let height = ceil(self.contentSize.height)
        switch height {
        case 0...miniFloat:
             return miniFloat
        case (miniFloat+1)...maxFloat:
            return height
        default:
            return maxFloat
        }
    }
}
