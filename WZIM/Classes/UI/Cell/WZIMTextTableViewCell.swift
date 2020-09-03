//
//  WZIMTextTableViewCell.swift
//  Pods-WZIMUI_Example
//
//  Created by qiuqixiang on 2020/8/20.
//

import UIKit

// MARK - 文字UI
public class WZIMTextTableViewCell: WZIMBaseTableViewCell {

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
        
        let maxWidth = WZIMConfig.maxWidth
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
            let color = model.wzLoaction() == .right ? UIColor.white : WZIMToolAppearance.hexadecimal(rgb: 0x3C3C3C)
            let mPara = NSMutableParagraphStyle()
            mPara.lineSpacing = 4
            let text = NSMutableAttributedString(string: elem.getText(),
                                                 attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
                                                              NSAttributedString.Key.foregroundColor: color,
                                                              NSAttributedString.Key.paragraphStyle : mPara])
            contentLabel.attributedText = text
        }
    }
}

// MARK - 文字内容协议
public protocol  WZIMTextProtocol {
    
    /// 文字消息
    func getText() -> String
}
