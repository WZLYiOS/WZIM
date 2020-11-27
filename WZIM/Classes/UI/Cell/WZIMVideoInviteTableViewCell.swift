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
    public var markModel: WZSignalingElem!
    
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
        
        guard case let .signaling(elem) = message.currentElem else {
            return
        }
        
        markModel = elem
        let text = NSMutableAttributedString(string: "专属顾问向你发起了视频申请，是否同意？")
        text.wzSetLineSpacing(value: 3)
        topLabel.attributedText = text
        
        if model.customInt == 0 {
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
public protocol WZIMVideoInviteTableViewCellDeleagte: class {
    
    /// 是否同意
    func videoInviteTableViewCell(cell: WZIMVideoInviteTableViewCell, isAgree: Bool)
}

/// MARK - 自己发的视频邀请
public class WZIMVideoInviteSelfTableViewCell: WZIMBaseTableViewCell {
    
    /// 代理
    public weak var delegate: WZIMVideoInviteSelfTableViewCellDeleagte?
    
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
            make.leading.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualTo(-15)
            make.width.lessThanOrEqualTo(WZIMConfig.maxWidth)
        }
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        guard case let .signaling(elem) = message.currentElem else {
            return
        }
        self.delegate = cDelegate as? WZIMVideoInviteSelfTableViewCellDeleagte
        
        let namorImage = model.loaction == .lelft ? UIImage(named: "Cell.bundle/ic_talk_dialog_video") : UIImage(named: "Cell.bundle/ic_talk_inputbox_voice02")
        
        let image = delegate?.VideoInviteSelfCell(cell: self) ?? namorImage
        
        sendFailButton.isHidden = true
        readButton.isHidden = true
        topLabel.textColor = getTextColor()
        let text = NSMutableAttributedString(string: elem.getText(isSelf: message.loaction == .lelft ? false : true))
        text.wzSetLineSpacing(value: 3)
        
        if model.loaction == .lelft {
            text.insert(NSAttributedString(string: " "), at: 0)
            text.insert(text.wzGetAttachment(image: image, y: -3), at: 0)
        }else{
            text.append(NSAttributedString(string: " "))
            text.append(text.wzGetAttachment(image: image, y: -2))
        }
        topLabel.attributedText = text
    }
}

/// MARK - WZIMVideoInviteSelfTableViewCellDeleagte
public protocol WZIMVideoInviteSelfTableViewCellDeleagte: WZIMTableViewCellDelegate {
    
    /// 获取图片
    func VideoInviteSelfCell(cell: WZIMVideoInviteSelfTableViewCell) -> UIImage?
}
