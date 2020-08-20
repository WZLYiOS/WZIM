//
//  WZIMTableViewCell.swift
//  SweepTreasure
//
//  Created by qiuqixiang on 2020/7/13.
//  Copyright © 2020 划宝. All rights reserved.
//

import UIKit
import SnapKit

// MARK - 气泡cell
open class WZIMTableViewCell: UITableViewCell {

    /// 代理
    private weak var pDelegate: WZIMTableViewCellPublicDelegate!
    
    /// 消息
    public var message: WZIMMessageProtocol!
    
    /// 头像
    public lazy var avatarImageView: UIImageView = {
        $0.layer.cornerRadius = WZIMConfig.avatarSize.height/2
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.gray
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    /// 气泡
    public lazy var bubbleImageView: UIImageView = {
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    /// 发送中和发送失败等
    public lazy var stateStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.red
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 0
        return $0
    }(UIStackView())
    
    
    /// 底部内容视图，针对多个elem
    private lazy var bottomStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.red
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        return $0
    }(UIStackView())
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        configView()
        configViewLocation()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configView() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(bubbleImageView)
        contentView.addSubview(stateStackView)
        contentView.addSubview(bottomStackView)
    }

    open func configViewLocation() {
        bottomStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalTo(bubbleImageView.snp.bottom)
            make.bottom.lessThanOrEqualToSuperview().priority(.low)
        }
    }
    
    /// 更新数据
    open func reload(model: WZIMMessageProtocol, publicDelegate: WZIMTableViewCellPublicDelegate, cDelegate: WZIMTableViewCellDelegate) {
        
        pDelegate = publicDelegate
        message = model
    
        switch model.wzLoaction() {
        case .lelft:
            
            avatarImageView.snp.remakeConstraints { (make) in
                make.leading.equalTo(WZIMConfig.avatarEdge.left)
                make.width.equalTo(WZIMConfig.avatarSize.width)
                make.height.equalTo(WZIMConfig.avatarSize.height)
                make.top.equalToSuperview().offset(WZIMConfig.avatarEdge.top)
            }
            
            bubbleImageView.snp.remakeConstraints { (make) in
                make.left.equalTo(avatarImageView.snp.right).offset(WZIMConfig.bubbleEdge.left)
                make.top.equalToSuperview().offset(WZIMConfig.avatarEdge.top)
            }
            bubbleImageView.image = WZIMConfig.lelftBubbleImage?.wzIMResizableImage
            stateStackView.isHidden = true
        case .right:
            avatarImageView.snp.remakeConstraints { (make) in
                make.right.equalToSuperview().offset(-WZIMConfig.avatarEdge.right)
                make.width.equalTo(WZIMConfig.avatarSize.width)
                make.height.equalTo(WZIMConfig.avatarSize.height)
                make.top.equalToSuperview().offset(WZIMConfig.avatarEdge.top)
            }
            bubbleImageView.snp.remakeConstraints { (make) in
                make.right.equalTo(avatarImageView.snp.left).offset(-WZIMConfig.bubbleEdge.right)
                make.top.equalToSuperview().offset(WZIMConfig.avatarEdge.top)
            }
            bubbleImageView.image = WZIMConfig.rightBubbleImage?.wzIMResizableImage
            
            stateStackView.snp.remakeConstraints { (make) in
                make.right.equalTo(bubbleImageView.snp.left)
                make.centerY.equalTo(bubbleImageView.snp.centerY)
            }
            stateStackView.isHidden = false
        case .center:
            bubbleImageView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(WZIMConfig.avatarEdge.top)
            }
            bubbleImageView.image = nil
            stateStackView.isHidden = true
        }

        /// 设置头像
        pDelegate.WZIMTableViewCell(cell: self, set: avatarImageView)
    }
    
    
}

// MARK - 图片九宫格
extension UIImage {
    
    var wzIMResizableImage: UIImage {
        let widthFloat = floor(self.size.width/2)
        let heightFloat = floor(self.size.height/2)
        return self.resizableImage(withCapInsets: UIEdgeInsets(top: heightFloat, left: widthFloat, bottom: heightFloat, right: widthFloat))
    }
}
