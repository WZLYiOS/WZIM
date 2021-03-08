//
//  WZIMActivityTableViewCell.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/3.
//

import UIKit
import SnapKit

// MARK - 分享活动
public class WZIMActivityTableViewCell: WZIMBaseTableViewCell {
    
    /// 代理
    weak var delegate: WZIMActivityTableViewCellDelegate?
    
    /// 数据源
    public  var dataModel: WZIMShareCustomElem!
    
    private lazy var shareImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var titleLabel: UILabel = {
        $0.numberOfLines = 2
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0x2c2c2c")
        $0.font = UIFont.boldSystemFont(ofSize: 13)
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private lazy var timeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0x999999")
        return $0
    }(UILabel())
    
    public override func configView() {
        super.configView()
        bubbleImageView.addSubview(shareImageView)
        bubbleImageView.addSubview(titleLabel)
        bubbleImageView.addSubview(timeLabel)
        bubbleImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
      
    public override func configViewLocation() {
        super.configViewLocation()
        shareImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-21)
            make.centerY.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(55)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalToSuperview().offset(15)
            make.right.equalTo(shareImageView.snp.left).offset(-15)
            make.width.equalTo(WZIMConfig.maxWidth-15-15-55-21)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.bottom.equalToSuperview().offset(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
      
      public override func reload(model: WZMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, cDelegate: cDelegate)
        delegate = cDelegate as? WZIMActivityTableViewCellDelegate
        if case let .share(elem) = model.currentElem {
            if model.loaction == .right {
                bubbleImageView.image = UIImage(named: "Cell.bundle/ic_chat_windowtwowhite")?.wzStretchableImage()
            }
            dataModel = elem
            pDelegate.baseTableViewCell(cell: self, imageView: shareImageView, url: elem.content.img, placeholder: nil)
            timeLabel.text = elem.content.beginTime + "" + elem.content.city
            
            let mPara = NSMutableParagraphStyle()
            mPara.lineSpacing = 3
            titleLabel.attributedText = NSMutableAttributedString(string: elem.content.title,
                                                 attributes: [NSAttributedString.Key.paragraphStyle : mPara])
            titleLabel.lineBreakMode = .byTruncatingTail
        }
      }
    
    @objc private func tapAction(){
        delegate?.tapActivityTableViewCell(cell: self)
    }
}

// MARK - WZIMActivityTableViewCellDelegate
public protocol WZIMActivityTableViewCellDelegate: class {
    
    /// 事件点击
    func tapActivityTableViewCell(cell: WZIMActivityTableViewCell)
}
