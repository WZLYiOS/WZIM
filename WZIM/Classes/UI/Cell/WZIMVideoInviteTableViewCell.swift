//
//  WZIMVideoInviteTableViewCell.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/3.
//

import UIKit
import SnapKit

// MARK - 视频邀请
public class WZIMVideoInviteTableViewCell: WZIMBaseTableViewCell {

    /// 数据
    public var markModel: WZVideoTalkInviteElem!
    
    /// 代理
    weak var delegete: WZIMVideoInviteTableViewCellDeleagte?
    
    /// 顶部文案
    private lazy var topLabel: UILabel = {
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0x3C3C3C")
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var lelftButton: UIButton = {
        $0.setTitle("不同意", for: .normal)
        $0.setTitleColor(WZIMToolAppearance.hexadecimal(rgb: "0xFB4E38"), for: .normal)
        $0.setTitleColor(WZIMToolAppearance.hexadecimal(rgb: "0xCCCCCC"), for: .selected)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 0.5
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.tag = 0
        $0.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        return $0
    }(UIButton(type: .custom))
    
    private lazy var rightButton: UIButton = {
        $0.setTitle("同意", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.tag = 1
        $0.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        return $0
    }(UIButton(type: .custom))
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(topLabel)
        bubbleImageView.addSubview(lelftButton)
        bubbleImageView.addSubview(rightButton)
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        topLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(21)
            make.right.equalToSuperview().offset(-21)
            make.top.equalToSuperview().offset(15)
        }
        
        lelftButton.snp.makeConstraints { (make) in
            make.leading.equalTo(21)
            make.top.equalTo(topLabel.snp.bottom).offset(20)
            make.width.equalTo(88)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-15)
        }
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(lelftButton.snp.centerY)
            make.left.equalTo(lelftButton.snp.right).offset(10)
            make.width.equalTo(88)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-43)
        }
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        delegete = cDelegate as? WZIMVideoInviteTableViewCellDeleagte
        if case let .videoTalkInvite(elem) = message.currentElem {
            markModel = elem
            let text = NSMutableAttributedString(string: "专属顾问向你发起了视频申请，是否同意？")
            text.wzSetLineSpacing(value: 3)
            topLabel.attributedText = text
        }else{
            
        }
        if model.customData == nil {
            lelftButton.isSelected = false
            lelftButton.isUserInteractionEnabled = true
            lelftButton.layer.borderColor = WZIMToolAppearance.hexadecimal(rgb: "0xFB4E38").cgColor
            rightButton.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xFB4E38")
            rightButton.isSelected = false
            rightButton.isUserInteractionEnabled = true
            return
        }
        lelftButton.isSelected = true
        lelftButton.isUserInteractionEnabled = false
        lelftButton.layer.borderColor = WZIMToolAppearance.hexadecimal(rgb: "0xD4D4D4").cgColor
        rightButton.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xD4D4D4")
        rightButton.isSelected = true
        rightButton.isUserInteractionEnabled = false
        
    }
    
    @objc private func tapAction(btn: UIButton){
        delegete?.videoInviteTableViewCell(cell: self, isAgree: btn.tag == 0 ? false : true)
    }
}

// MARK - WZIMVideoInviteTableViewCellDeleagte
protocol WZIMVideoInviteTableViewCellDeleagte: class {
    
    /// 是否同意
    func videoInviteTableViewCell(cell: WZIMVideoInviteTableViewCell, isAgree: Bool)
}

/// MARK - 自己发的视频邀请
public class WZIMVideoInviteSelfTableViewCell: WZIMBaseTableViewCell {
    /// 顶部文案
    private lazy var topLabel: UILabel = {
        $0.textColor = WZIMConfig.rightTextColor
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(topLabel)
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        topLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(21)
            make.right.equalToSuperview().offset(-21)
            make.top.equalToSuperview().offset(15)
            make.width.lessThanOrEqualTo(WZIMConfig.maxWidth)
            make.bottom.lessThanOrEqualToSuperview().offset(-15).priority(.low)
        }
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        topLabel.text = "发起视频通话"
    }
}
