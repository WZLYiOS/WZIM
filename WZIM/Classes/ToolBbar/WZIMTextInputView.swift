//
//  WZIMTextInputView.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/24.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit
import SnapKit

// MARK - IM输入框
public class WZIMTextInputView: UIView {

    /// 代理
    public weak var delegate: WZIMTextInputViewDelegate?
    
    /// 输入框
    public lazy var textInput: WZIMChatTextView = {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0x31345C")
        $0.placeHolderFont = $0.font
        $0.placeHolderTextColor = WZIMToolAppearance.hexadecimal(rgb: "0xA5A4AA")
        $0.returnKeyType = .send
        $0.backgroundColor = UIColor.clear
        $0.placeHolderLabel.text = "请输入聊天内容"
        $0.placeHolderLabel.font = $0.font
        $0.placeHolderLabel.textColor = WZIMToolAppearance.hexadecimal(rgb: "0xA5A4AA")
        $0.delegate = self
        return $0
    }(WZIMChatTextView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xF8F8F8")
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        configView()
        configViewLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        self.addSubview(textInput)
    }
    func configViewLocation() {
        textInput.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.right.equalToSuperview().offset(-5)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    /// 是否隐藏
    public func chandge(isHidden: Bool, isOpenKeyBor: Bool =  true) {
        self.isHidden = isHidden
        var height = textInput.getHeight()
        if isHidden {
            height = 35
            textInput.resignFirstResponder()
        } else {
            if isOpenKeyBor {
                textInput.becomeFirstResponder()
            }else{
                textInput.resignFirstResponder()
            }
        }
        
        self.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    
    func clearTextInput() {
        let textView = textInput
        textView.text = ""
        textViewChangeHeight(textView: textView, animated: true)
    }
}

/// MARK - WZIMTextInputViewDelegate
public protocol WZIMTextInputViewDelegate: class {
    
    /// 内容输入
    func textViewDidChange(view: WZIMTextInputView, animated: Bool)
    
    /// 内容返回
    func textViewDidReturn(view: WZIMTextInputView)
}

/// MARK - YYTextViewDelegate
extension WZIMTextInputView: UITextViewDelegate {
    
    /// 动态修改textView 高度
    func textViewChangeHeight(textView: UITextView, animated: Bool) {
        let height = textView.getHeight()
         self.snp.updateConstraints { (make) in
             make.height.equalTo(height)
         }
        self.delegate?.textViewDidChange(view: self, animated: animated)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        textViewChangeHeight(textView: textView, animated: false)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" && textView.text.count>0{
            delegate?.textViewDidReturn(view: self)
            clearTextInput()
            return false
        }
        return true
    }
}
