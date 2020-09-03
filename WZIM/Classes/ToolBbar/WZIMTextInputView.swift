//
//  WZIMTextInputView.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/24.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit

// MARK - IM输入框
public class WZIMTextInputView: UIView {

    /// 输入框
    public lazy var textInput: WZIMChatTextView = {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: 0x31345C)
        $0.placeHolderFont = $0.font
        $0.placeHolderTextColor = WZIMToolAppearance.hexadecimal(rgb: 0xA5A4AA)
        $0.returnKeyType = .send
        $0.backgroundColor = UIColor.clear
        $0.placeHolderLabel.text = "请输入聊天内容"
        $0.placeHolderLabel.font = $0.font
        $0.placeHolderLabel.textColor = WZIMToolAppearance.hexadecimal(rgb: 0xA5A4AA)
        return $0
    }(WZIMChatTextView())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: 0xF8F8F8)
        self.layer.cornerRadius = 17.5
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
            make.height.equalTo(35)
        }
    }
    
    /// 是否隐藏
    func chandge(isHidden: Bool, isOpenKeyBor: Bool =  true) {
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
        textInput.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
}

// MARK - 空键盘
class WZIMkeyboardView: UIView {
    
    private lazy var bgView: UIView = {
        return $0
    }(UIView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
        configViewLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        self.addSubview(bgView)
    }
    func configViewLocation() {
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    func changge(height: CGFloat) {
        self.isHidden = height == 0 ? true : false
        bgView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        
    }
}


