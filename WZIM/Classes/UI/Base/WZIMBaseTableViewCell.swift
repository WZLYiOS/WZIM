//
//  WZIMBaseTableViewCell.swift
//  Pods-WZIM_Example
//
//  Created by qiuqixiang on 2020/8/24.
//

import UIKit
import SnapKit

// AMRK - 基础cell
open class WZIMBaseTableViewCell: UITableViewCell {

    /// 代理
    public weak var pDelegate: WZIMTableViewCellPublicDelegate!
    
    /// 消息
    public var message: WZMessageProtocol!
    
    /// 头像
    public lazy var avatarImageView: UIImageView = {
        $0.layer.cornerRadius = WZIMConfig.avatarSize.height/2
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.gray
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarImageViewAction)))
        return $0
    }(UIImageView())
    
    /// 气泡
    public lazy var bubbleImageView: UIImageView = {
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    /// 底部内容视图，针对多个elem
    public lazy var bottomStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        return $0
    }(UIStackView())
    
    /// 发送失败
    public lazy var sendFailButton: UIButton = {
        $0.isHidden = true
        $0.setImage(UIImage(named: "Cell.bundle/ic_talk_fail"), for: .normal)
        $0.addTarget(self, action: #selector(sendFailButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    /// 未读已读
    public lazy var readButton: UIButton = {
        $0.setTitle("未读", for: .normal)
        $0.setTitle("已读", for: .selected)
        $0.setTitleColor(WZIMToolAppearance.hexadecimal(rgb: "0x4C48D3"), for: .normal)
        $0.setTitleColor(WZIMToolAppearance.hexadecimal(rgb: "0x7C7C7C"), for: .selected)
        $0.isUserInteractionEnabled = false
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return $0
    }(UIButton())
    
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
        contentView.addSubview(bottomStackView)
        contentView.addSubview(sendFailButton)
        contentView.addSubview(readButton)
    }

    open func configViewLocation() {
        bottomStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalTo(bubbleImageView.snp.bottom)
            make.bottom.lessThanOrEqualToSuperview().offset(-WZIMConfig.bubbleEdge.bottom).priority(.low)
        }
        readButton.snp.makeConstraints { (make) in
            make.right.equalTo(bubbleImageView.snp.left).offset(-10)
            make.bottom.equalTo(bubbleImageView.snp.bottom)
        }
        
        sendFailButton.snp.makeConstraints { (make) in
            make.right.equalTo(bubbleImageView.snp.left).offset(-10)
            make.bottom.equalTo(bubbleImageView.snp.bottom)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
    
    /// 更新数据
    open func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {

        message = model
        /// 设置头像
        pDelegate.baseTableViewCell(cell: self, set: avatarImageView)
        uploadConstraints(type: model.loaction)
    }
    
    /// 更新位置
    open func uploadConstraints(type: WZMessageLocation) {
        switch type {
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
            bubbleImageView.image = WZIMConfig.lelftBubbleImage
            sendFailButton.isHidden = true
            readButton.isHidden = true
            avatarImageView.isHidden = false
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
            
            bubbleImageView.image = WZIMConfig.rightBubbleImage
           
            let state = message.sendStatus
            sendFailButton.isHidden =  state == .fail ? false : true
            readButton.isHidden = !sendFailButton.isHidden
            readButton.isSelected = message.isReaded
            avatarImageView.isHidden = false
        case .center:
            bubbleImageView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(WZIMConfig.avatarEdge.top)
            }
            bubbleImageView.image = nil
            sendFailButton.isHidden = true
            readButton.isHidden = true
            avatarImageView.isHidden = true
        }
    }
    
    /// 获取文字颜色
    open func getTextColor() -> UIColor {
        return  message.loaction == .right ? WZIMConfig.rightTextColor : WZIMConfig.lelftTextColor
    }
}

///   MARK - 扩展事件
extension WZIMBaseTableViewCell {
    
    @objc private  func sendFailButtonAction(btn: UIButton) {
        pDelegate.baseTableViewCell(cell: self, resend: btn)
    }
    
    @objc private func avatarImageViewAction(tap: UITapGestureRecognizer) {
        pDelegate.baseTableViewCell(cell: self, tap: tap.view! as! UIImageView)
    }
}

// MARK - 图片九宫格
public extension UIImage {
    
    /// 九宫格
    var wzIMResizableImage: UIImage {
        let widthFloat = floor(self.size.width/2)
        let heightFloat = floor(self.size.height/2)
        return self.resizableImage(withCapInsets: UIEdgeInsets(top: heightFloat, left: widthFloat, bottom: heightFloat, right: widthFloat))
    }
    
    /// 特定的
    func wzStretchableImage(marn: CGFloat = 5) -> UIImage? {
        let lelft = Int(floor(self.size.width/2))
        let top = Int(floor(self.size.height/2+marn))
       return self.stretchableImage(withLeftCapWidth: lelft, topCapHeight: top)
    }
}
