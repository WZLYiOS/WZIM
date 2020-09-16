//
//  WZIMVoiceTableViewCell.swift
//  Pods-WZIMUI_Example
//
//  Created by qiuqixiang on 2020/8/20.
//

import UIKit
import SnapKit

// MARK - 推荐卡片
public class WZIMRecommendCardTableViewCell: WZIMBaseTableViewCell {

    /// 头像
    private lazy var lelftImageView: UIImageView = {
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: 0xD1CFCF)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    /// 姓名
    private lazy var nameLabel: UILabel = {
        $0.font =  UIFont.boldSystemFont(ofSize: 15)
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: 0x3C3C3C)
        return $0
    }(UILabel())
    
    /// 信息
    private lazy var infoLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: 0xAAAAAA)
        return $0
    }(UILabel())
    
    /// 线
    private lazy var lineLabel: UILabel = {
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: 0xF0F0F0)
        return $0
    }(UILabel())
    
    /// 提示文字
    private lazy var timeLabel: UILabel = {
        $0.text = "本名片10分钟内有效"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: 0xBBBBBB)
        return $0
    }(UILabel())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(lelftImageView)
        bubbleImageView.addSubview(nameLabel)
        bubbleImageView.addSubview(infoLabel)
        bubbleImageView.addSubview(lineLabel)
        bubbleImageView.addSubview(timeLabel)
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        lelftImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(21)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lelftImageView.snp.right).offset(10)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(15)
            make.width.equalTo(160)
            make.right.equalToSuperview().offset(-10)
        }
        infoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lelftImageView.snp.right).offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(9)
        }
        lineLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(lelftImageView.snp.bottom).offset(12)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(21)
            make.top.equalTo(lineLabel.snp.bottom).offset(10)
            make.height.equalTo(12)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    public override func reload(model: WZIMMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        if model.wzLoaction() == .right {
            bubbleImageView.image = UIImage(named: "Cell.bundle/ic_talk_inputbox_style4")?.wzStretchableImage()
        }
        
        nameLabel.text = "潘先生"
        infoLabel.text = "福建福州-26岁"
    }
}
