//
//  WZMessageRemindTableViewCell.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/23.
//

import UIKit

/// 提示消息
public class WZMessageRemindTableViewCell: WZIMBaseTableViewCell {

    /// 代理
    weak var delegate: WZMessageRemindTableViewCellDelegate?
    
    /// 内容
    public lazy var contentLabel: UILabel = {
        $0.backgroundColor = UIColor.clear
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.numberOfLines = 0
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contentLabelAction)))
        return $0
    }(UILabel())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(contentLabel)
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
    
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualTo(-15)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.size.width-70)
        }
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        uploadConstraints(type: .center)
        bubbleImageView.layer.cornerRadius = 5
        bubbleImageView.layer.masksToBounds = true
        bubbleImageView.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xCCCDCE")
        delegate = cDelegate as? WZMessageRemindTableViewCellDelegate
        
        switch message.currentElem {
        case let .dateServiceHnSetRecCon(elem):
            let text = NSMutableAttributedString(string: elem.text)
            let range = (text.string as NSString).range(of: elem.label)
            text.wzSetUnderline(style: .patternDashDot, color: WZIMToolAppearance.hexadecimal(rgb: "0x5A68A1"), range: range)
            text.wzSetLineSpacing(value: 3)
            text.wzSetColor(value: WZIMToolAppearance.hexadecimal(rgb: "0x5A68A1"), range: range)
            contentLabel.attributedText = text
        case let .sms(elem):
            let text = NSMutableAttributedString(string: elem.remindMsg)
            let range: NSRange = (text.string as NSString).range(of: elem.label)
            text.wzSetLineSpacing(value: 3)
            text.wzSetColor(value: WZIMToolAppearance.hexadecimal(rgb: "#\(elem.color)"), range: range)
            contentLabel.attributedText = text
        default: break
        }
        delegate?.remindTableViewCell?(custom: self)
    }
    
    /// 获取点击的label
    private func getLabel() -> String {
        return ""
    }
    
    /// 点击事件
    @objc private func contentLabelAction(tap: UITapGestureRecognizer){
        delegate?.remindTableViewCell(cell: self, diselect: getLabel())
    }
}

// MARK - WZMessageRemindTableViewCellDelegate
@objc public protocol WZMessageRemindTableViewCellDelegate: class {
    
    /// 文字点击
    /// - Parameters:
    ///   - cell: cell
    ///   - label: 点击的内容
    func remindTableViewCell(cell: WZMessageRemindTableViewCell, diselect label: String)
    
    /// 自定义cell颜色等
    /// - Parameter cell: cell
    @objc optional func remindTableViewCell(custom cell: WZMessageRemindTableViewCell)
}
