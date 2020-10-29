//
//  WZIMTextTableViewCell.swift
//  Pods-WZIMUI_Example
//
//  Created by qiuqixiang on 2020/8/20.
//

import UIKit
import SnapKit

// MARK - 文字UI
public class WZIMTextTableViewCell: WZIMBaseTableViewCell {

    private lazy var contentLabel: UITextView = {
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textContainer.lineFragmentPadding = 0
        $0.isEditable = false
        $0.dataDetectorTypes = .link
        $0.backgroundColor = UIColor.clear
        $0.delegate = self
        return $0
    }(UITextView())
    
    /// 自动布局使用
    private lazy var label: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        $0.isUserInteractionEnabled = true
        $0.isHidden = true
        return $0
    }(UILabel())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(label)
        bubbleImageView.addSubview(contentLabel)
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        
        let maxWidth = WZIMConfig.maxWidth
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualTo(-15)
            make.width.lessThanOrEqualTo(maxWidth)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualTo(-15)
        }
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
     
        switch model.currentElem {
        case let .text(elem):
            setText(text: elem.getText())
        case let .hibox(elem):
            setText(text: elem.text)
        default:
            break
        }
    }
    
    func setText(text: String)  {
        let color = getTextColor()
        let mPara = NSMutableParagraphStyle()
        mPara.lineSpacing = 4
        
        label.attributedText = NSMutableAttributedString(string: text,
                                                         attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                                                                      NSAttributedString.Key.foregroundColor: UIColor.clear,
                                                                      NSAttributedString.Key.paragraphStyle : mPara])
        contentLabel.attributedText = NSMutableAttributedString(string: text,
                                                                           attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                                                                                        NSAttributedString.Key.foregroundColor: color,
                                                                                        NSAttributedString.Key.paragraphStyle : mPara])
    }
}

/// MARK - UITextViewDelegate
extension WZIMTextTableViewCell: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                      in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            return true
        }
}
