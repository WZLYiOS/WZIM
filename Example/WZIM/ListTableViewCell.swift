//
//  ListTableViewCell.swift
//  WZIM_Example
//
//  Created by qiuqixiang on 2020/9/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import SnapKit
import WZIM

class ListTableViewCell: UITableViewCell {

    private lazy var nameLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        return $0
    }(UILabel())
    
    private lazy var avatarImageView: UIImageView = {
        $0.backgroundColor = UIColor.gray
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "ToolBbar.bundle/ic_talk_keyboard")
        return $0
    }(UIImageView())
    
    private lazy var timeLabel: UILabel = {
        $0.font = UIFont.boldSystemFont(ofSize: 13)
        return $0
    }(UILabel())
    
    private lazy var contentLabel: UILabel = {
        return $0
    }(UILabel())
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configView()
        configViewLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
    }
    func configViewLocation() {
        avatarImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(22)
            make.top.equalToSuperview().offset(13)
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualToSuperview().offset(-13).priority(.low)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(15)
            make.top.equalToSuperview().offset(19)
            make.height.equalTo(15)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
        }
    }
    
    func reload(model: WZConversationProcotol) {
        nameLabel.text = model.receiverId
//        contentLabel.text = model.wzLastMessage()?.wzMessageId()
        timeLabel.text = model.lastMsg?.timeTamp.wzImDate
    }
}

