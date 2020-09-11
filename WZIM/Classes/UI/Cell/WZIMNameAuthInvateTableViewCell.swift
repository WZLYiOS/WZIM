//
//  WZIMNameAuthInvateTableViewCell.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/10.
//

import UIKit
import SnapKit

// MARK - 实名认证邀请
public class WZIMNameAuthInvateTableViewCell: WZIMBaseTableViewCell {

    /// 代理
    weak var delegate: WZIMNameAuthInvateTableViewCellDelegate?
    
    /// 数据
    var dataMarkModel: WZIMnameAuthInviteCustomElem!
    
    private lazy var titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: 0x999999)
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        return $0
    }(UILabel())
    
    private lazy var subLabel: UILabel = {
        $0.text = "前往认证中心>>"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: 0xFB4D38)
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        return $0
    }(UILabel())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(titleLabel)
        bubbleImageView.addSubview(subLabel)
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(15)
            make.width.lessThanOrEqualTo(WZIMConfig.maxWidth)
        }
        subLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.bottom.lessThanOrEqualTo(-15)
        }
    }
    @objc private func tapAction(tap: UITapGestureRecognizer){
        delegate?.tapNameAuthInvateCell(cell: self)
    }
    
    public override func reload(model: WZIMMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        if case let .nameAuthInvite(elem) = model.wzCurrentElem() {
            delegate = cDelegate as? WZIMNameAuthInvateTableViewCellDelegate
            dataMarkModel = elem
            let color = model.wzLoaction() == .right ? WZIMConfig.rightTextColor : WZIMConfig.lelftTextColor
            let text = NSMutableAttributedString(string: elem.content)
            text.wzSetColor(value: color)
            text.wzSetLineSpacing(value: 4)
            titleLabel.attributedText = text
        }
    }
}

// MARK - 代理
protocol WZIMNameAuthInvateTableViewCellDelegate: class {
    
    /// 点击事件
    func tapNameAuthInvateCell(cell: WZIMNameAuthInvateTableViewCell)
}
