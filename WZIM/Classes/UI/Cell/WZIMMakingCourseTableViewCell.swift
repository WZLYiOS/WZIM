//
//  WZIMMakingCourseTableViewCell.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/3.
//

import UIKit
import SnapKit

// MARK - 红娘课程 | 线上视频约会服务 | 开启约会实名认证邀请
public class WZIMMakingCourseTableViewCell: WZIMBaseTableViewCell {

    /// 代理
    weak var delegate: WZIMMakingCourseTableViewCellDelegate?
    
    /// 顶部文案
    private lazy var topLabel: UILabel = {
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0x3C3C3C")
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    /// 图
    private lazy var picImageView: UIImageView = {
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xE4E4E4")
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    /// 线
    private lazy var lineLabel: UILabel = {
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xF0F0F0")
        return $0
    }(UILabel())
    
    /// 红娘课程： Cell.bundle/ic_chat_course
    /// 线上视频约会服务 :
    /// 开启约会实名认证邀请
    private lazy var lelftImageView: UIImageView = {
        return $0
    }(UIImageView())
    
    private lazy var titleLbale: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0xBCBCBC")
        return $0
    }(UILabel())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(topLabel)
        bubbleImageView.addSubview(picImageView)
        bubbleImageView.addSubview(lineLabel)
        bubbleImageView.addSubview(lelftImageView)
        bubbleImageView.addSubview(titleLbale)
        bubbleImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bubbleImageViewAction)))
    }
    
    public override func configViewLocation() {
        super.configViewLocation()
        topLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(21)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(15)
        }
        picImageView.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.leading.equalTo(21)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(209)
            make.height.equalTo(90)
        }
        lineLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalTo(picImageView.snp.bottom).offset(13)
            make.height.equalTo(0.5)
        }
        lelftImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.top.equalTo(lineLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        titleLbale.snp.makeConstraints { (make) in
            make.centerY.equalTo(lelftImageView.snp.centerY)
            make.left.equalTo(lelftImageView.snp.right).offset(5)
        }
    }
    
    public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        self.delegate = cDelegate as? WZIMMakingCourseTableViewCellDelegate
        if model.loaction == .right {
            bubbleImageView.image = UIImage(named: "Cell.bundle/ic_chat_windowtwowhite")?.wzStretchableImage()
        }
        switch message.currentElem {
        case let .dateAuthInvite(elem):
            topLabel.text = elem.text.count == 0 ? "开启约会实名认证邀请" : elem.text
            lelftImageView.image = UIImage(named: "Cell.bundle/ic_chat_certification")
            titleLbale.text = elem.title.count == 0 ? "我主良缘实名认证" : elem.title
            pDelegate.baseTableViewCell(cell: self, imageView: picImageView, url: elem.img, placeholder: UIImage(named: "Cell.bundle/chat_name_auth_pic"))
        case let .dateService(elem):
            topLabel.text =  elem.text.count == 0 ? "线上视频约会服务" : elem.text
            lelftImageView.image = UIImage(named: "Cell.bundle/ic_chat_video")
            titleLbale.text = elem.title.count == 0 ? "我主良缘线上视频约会服务" : elem.title
            pDelegate.baseTableViewCell(cell: self, imageView: picImageView, url: elem.img, placeholder: UIImage(named: "Cell.bundle/chat_service_pic"))
        default: break
        }
    }
    
    /// 点击
    @objc private func bubbleImageViewAction(tap: UITapGestureRecognizer) {
        delegate?.courseTableViewCell(tap: self)
    }
}

/// MARK - WZIMMakingCourseTableViewCellDelegate
public protocol WZIMMakingCourseTableViewCellDelegate: WZIMTableViewCellDelegate {
    
    /// 事件点击
    func courseTableViewCell(tap cell: WZIMMakingCourseTableViewCell)
}
