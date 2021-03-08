//
//  WZMessageAppointmentNameAuthCell.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/23.
//

import UIKit

// MARK - 约会实名认证cell
public class WZMessageAppointmentNameAuthCell: WZIMBaseTableViewCell {

    /// 代理
    weak var delegate: WZMessageAppointmentNameAuthCellDelegate?
    
    private lazy var titleLabel: UILabel = {
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0x272A2D")
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.text = "开启约会实名认证邀请"
        return $0
    }(UILabel())
    
    /// 中间图片
    private lazy var centerImageView: UIImageView = {
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xE4E4E4")
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    /// 线
    private lazy var lineView: UIView = {
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xF3F4F5")
        return $0
    }(UIView())
    
    /// 认证图片
    private lazy var lelftImageView: UIImageView = {
        $0.image = UIImage(named: "Cell.bundle/ic_chat_certification")
        return $0
    }(UIImageView())
    
    private lazy var bottomLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0xA8A9AA")
        $0.text = "我主良缘实名认证"
        return $0
    }(UILabel())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(titleLabel)
        bubbleImageView.addSubview(centerImageView)
        bubbleImageView.addSubview(lineView)
        bubbleImageView.addSubview(lelftImageView)
        bubbleImageView.addSubview(bottomLabel)
        bubbleImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bubbleImageViewAction)))
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalToSuperview().offset(15)
        }
        centerImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(200)
            make.height.equalTo(90)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(centerImageView.snp.bottom).offset(15)
            make.height.equalTo(0.5)
        }
        lelftImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(lineView.snp.bottom).offset(11)
            make.width.equalTo(11)
            make.height.equalTo(11)
            make.bottom.equalToSuperview().offset(-11)
        }
        bottomLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lelftImageView.snp.right).offset(5)
            make.centerY.equalTo(lelftImageView.snp.centerY)
        }
    }
    
    @objc private func bubbleImageViewAction(tap: UITapGestureRecognizer){
        delegate?.disectAppointmentNameAuthCell(cell: self)
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        
        if model.loaction == .right {
            bubbleImageView.image = UIImage(named: "Cell.bundle/ic_chat_windowtwowhite")?.wzStretchableImage()
        }
        delegate = cDelegate as? WZMessageAppointmentNameAuthCellDelegate
        if case let .dateAuthInvite(elem) = message.currentElem {
            titleLabel.text = elem.text
            bottomLabel.text = elem.title
            pDelegate.baseTableViewCell(cell: self, imageView: centerImageView, url: elem.img, placeholder: nil)
        }
    }
}

// MARK - WZMessageAppointmentNameAuthCellDelegate
public protocol WZMessageAppointmentNameAuthCellDelegate: class {
    
    /// 事件点击
    func disectAppointmentNameAuthCell(cell: WZMessageAppointmentNameAuthCell)
}
