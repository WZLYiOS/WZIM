//
//  WZIMTextTableViewCell.swift
//  Pods-WZIMUI_Example
//
//  Created by qiuqixiang on 2020/8/20.
//

import UIKit

// MARK - 文字UI
public class WZIMTextTableViewCell: WZIMChatTableViewCell {

    private lazy var contentLabel: UILabel = {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        return $0
    }(UILabel())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(contentLabel)
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        
        let maxWidth = UIScreen.main.bounds.size.width - WZIMConfig.avatarEdge.left - WZIMConfig.avatarSize.width - WZIMConfig.bubbleEdge.left - 65
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualTo(-15)
            make.width.lessThanOrEqualTo(maxWidth)
        }
    }
    
    public override func reload(model: WZIMMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
     
        if case let .text(elem) = model.wzCurrentElem() {
            contentLabel.textColor = model.wzLoaction() == .right ? UIColor.white : WZIMToolAppearance.hexadecimal(rgb: 0x3C3C3C)
            let text = NSMutableAttributedString(string: elem.getText())
            
//            let mPara = NSMutableParagraphStyle()
//            mPara.lineSpacing = 4
//            text.setAttribute(name: NSAttributedString.Key.paragraphStyle, value: mPara, range: NSRange(location: 0, length: text.string.count))
//            
//            text.color =
//            text.font = UIFont.boldSystemFont(ofSize: 15)
//            text.lineSpacing = 4
            contentLabel.attributedText = text
        }
    }
}

// MARK - 文字内容协议
public protocol  WZIMTextProtocol {
    
    /// 文字消息
    func getText() -> String
}
